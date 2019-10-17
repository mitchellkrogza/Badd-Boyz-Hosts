from errno import ELOOP
import os
import re
import subprocess
import sys
import tarfile
from tempfile import NamedTemporaryFile

try:
    from . import archive_utils
    libarchive_enabled = True
except ImportError:
    libarchive_enabled = False

from . import utils
from .interface import AbstractBaseFormat
from .exceptions import CaseInsensitiveFileSystemError, InvalidArchiveError


def _sort_file_order(prefix, files):
    """Sort by filesize or by binsort, to optimize compression"""
    def order(f):
        # we don't care about empty files so send them back via 100000
        fsize = os.lstat(os.path.join(prefix, f)).st_size or 100000
        # info/* records will be False == 0, others will be 1.
        info_order = int(os.path.dirname(f) != 'info')
        if info_order:
            _, ext = os.path.splitext(f)
            # Strip any .dylib.* and .so.* and rename .dylib to .so
            ext = re.sub(r'(\.dylib|\.so).*$', r'.so', ext)
            if not ext:
                # Files without extensions should be sorted by dirname
                info_order = 1 + hash(os.path.dirname(f)) % (10 ** 8)
            else:
                info_order = 1 + abs(hash(ext)) % (10 ** 8)
        return info_order, fsize

    binsort = os.path.join(sys.prefix, 'bin', 'binsort')
    if os.path.exists(binsort):
        with NamedTemporaryFile(mode='w', suffix='.filelist', delete=False) as fl:
            with utils.tmp_chdir(prefix):
                fl.writelines(map(lambda x: '.' + os.sep + x + '\n', files))
                fl.close()
                cmd = binsort + ' -t 1 -q -d -o 1000 {}'.format(fl.name)
                out, _ = subprocess.Popen(cmd, shell=True,
                                            stdout=subprocess.PIPE).communicate()
                files_list = out.decode('utf-8').strip().split('\n')
                # binsort returns the absolute paths.
                files_list = [f.split(prefix + os.sep, 1)[-1]
                                for f in files_list]
                os.unlink(fl.name)
    else:
        files_list = list(f for f in sorted(files, key=order))
    return files_list


def _create_no_libarchive(fullpath, files):
    with tarfile.open(fullpath, 'w:bz2') as t:
        for f in files:
            t.add(f)


def _create_libarchive(fullpath, files, compression_filter, filter_opts):
    archive_utils.create_archive(fullpath, files, compression_filter, filter_opts)


def create_compressed_tarball(prefix, files, tmpdir, basename,
                              ext, compression_filter, filter_opts=''):
    tmp_path = os.path.join(tmpdir, basename)
    files = _sort_file_order(prefix, files)

    # add files in order of a) in info directory, b) increasing size so
    # we can access small manifest or json files without decompressing
    # possible large binary or data files
    fullpath = tmp_path + ext
    with utils.tmp_chdir(prefix):
        if libarchive_enabled:
            _create_libarchive(fullpath, files, compression_filter, filter_opts)
        else:
            _create_no_libarchive(fullpath, files)
    return fullpath


def _tar_xf(tarball, dir_path):
    if not os.path.isabs(tarball):
        tarball = os.path.join(os.getcwd(), tarball)
    with utils.tmp_chdir(dir_path):
        archive_utils.extract_file(tarball)


def _tar_xf_no_libarchive(tarball_full_path, destination_directory=None):
    if destination_directory is None:
        destination_directory = tarball_full_path[:-8]

    with open(tarball_full_path, 'rb') as fileobj:
        with tarfile.open(fileobj=fileobj) as tar_file:
            for member in tar_file.getmembers():
                if (os.path.isabs(member.name) or not os.path.realpath(
                        member.name).startswith(os.getcwd())):
                    raise InvalidArchiveError(tarball_full_path,
                                              "contains unsafe path: {}".format(member.name))
            try:
                tar_file.extractall(path=destination_directory)
            except IOError as e:
                if e.errno == ELOOP:
                    raise CaseInsensitiveFileSystemError(
                        package_location=tarball_full_path,
                        extract_location=destination_directory,
                        caused_by=e,
                    )
                else:
                    raise InvalidArchiveError(tarball_full_path,
                                              "failed with error: {}" % str(e))

    if sys.platform.startswith('linux') and os.getuid() == 0:
        # When extracting as root, tarfile will by restore ownership
        # of extracted files.  However, we want root to be the owner
        # (our implementation of --no-same-owner).
        for root, dirs, files in os.walk(destination_directory):
            for fn in files:
                p = os.path.join(root, fn)
                os.lchown(p, 0, 0)


class CondaTarBZ2(AbstractBaseFormat):

    @staticmethod
    def extract(fn, dest_dir, **kw):
        if not os.path.isdir(dest_dir):
            os.makedirs(dest_dir)
        if not os.path.isabs(fn):
            fn = os.path.normpath(os.path.join(os.getcwd(), fn))

        if libarchive_enabled:
            _tar_xf(fn, dest_dir)
        else:
            _tar_xf_no_libarchive(fn, dest_dir)

    @staticmethod
    def create(prefix, file_list, out_fn, out_folder=os.getcwd(), **kw):
        if os.path.isabs(out_fn):
            out_folder = os.path.dirname(out_fn)
        out_file = create_compressed_tarball(prefix, file_list, out_folder,
                                             os.path.basename(out_fn).replace('.tar.bz2', ''),
                                             '.tar.bz2', 'bzip2')
        return out_file

    @staticmethod
    def get_pkg_details(in_file):
        stat_result = os.stat(in_file)
        size = stat_result.st_size
        # open the file twice because we need to start from the beginning each time
        with open(in_file, 'rb') as f:
            md5 = utils.md5_checksum(f)
        with open(in_file, 'rb') as f:
            sha256 = utils.sha256_checksum(f)
        return {"size": size, "md5": md5, "sha256": sha256}
