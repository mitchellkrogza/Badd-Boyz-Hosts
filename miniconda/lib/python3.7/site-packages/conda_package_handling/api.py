import os as _os
from glob import glob as _glob
import functools as _functools
import tempfile as _tempfile

from six import string_types as _string_types
import tqdm as _tqdm

# expose these two exceptions as part of the API.  Everything else should feed into these.
from .exceptions import ConversionError, InvalidArchiveError  # NOQA
from .tarball import CondaTarBZ2 as _CondaTarBZ2, libarchive_enabled  # NOQA
from .conda_fmt import CondaFormat_v2 as _CondaFormat_v2
from .utils import (TemporaryDirectory as _TemporaryDirectory, rm_rf as _rm_rf,
                    get_executor as _get_executor)

SUPPORTED_EXTENSIONS = {'.tar.bz2': _CondaTarBZ2,
                        '.conda': _CondaFormat_v2}


def _collect_paths(prefix):
    dir_paths, file_paths = [], []
    for dp, dn, filenames in _os.walk(prefix):
        for f in filenames:
            file_paths.append(_os.path.relpath(_os.path.join(dp, f), prefix))
        dir_paths.extend(_os.path.relpath(_os.path.join(dp, _), prefix) for _ in dn)
    file_list = file_paths + [dp for dp in dir_paths
                              if not any(f.startswith(dp) for f in file_paths)]
    return file_list


def get_default_extracted_folder(in_file, abspath=True):
    dirname = None
    for ext in SUPPORTED_EXTENSIONS:
        if in_file.endswith(ext):
            dirname = in_file[:-len(ext)]
    if dirname and not abspath:
        dirname = _os.path.basename(dirname)
    return dirname


def extract(fn, dest_dir=None, components=None, prefix=None):
    if dest_dir:
        if _os.path.isabs(dest_dir) and prefix:
            raise ValueError("dest_dir and prefix both provided as abs paths.  If providing both, "
                            "prefix can be abspath, but dest dir must be relative (relative to "
                            "prefix)")
        if not _os.path.isabs(dest_dir):
            dest_dir = _os.path.normpath(_os.path.join(prefix or _os.getcwd(), dest_dir))
    else:
        dest_dir = _os.path.join(prefix or _os.path.dirname(fn),
                                 get_default_extracted_folder(fn, abspath=False))

    if not _os.path.isdir(dest_dir):
        _os.makedirs(dest_dir)

    for ext in SUPPORTED_EXTENSIONS:
        if fn.endswith(ext):
            SUPPORTED_EXTENSIONS[ext].extract(fn, dest_dir, components=components)
            break
    else:
        raise ValueError("Didn't recognize extension for file '{}'.  Supported extensions are: {}"
                         .format(fn, list(SUPPORTED_EXTENSIONS.keys())))


def create(prefix, file_list, out_fn, out_folder=None, **kw):
    if not out_folder:
        out_folder = _os.getcwd()
    if file_list is None:
        file_list = _collect_paths(prefix)

    elif isinstance(file_list, _string_types):
        try:
            with open(file_list) as f:
                data = f.readlines()
            file_list = [_.strip() for _ in data]
        except:
            raise

    for ext in SUPPORTED_EXTENSIONS:
        if out_fn.endswith(ext):
            try:
                out = SUPPORTED_EXTENSIONS[ext].create(prefix, file_list, out_fn, out_folder, **kw)
            except:
                # don't leave broken files around
                if _os.path.isfile(out):
                    _rm_rf(out)
    return out


def _convert(fn, out_ext, out_folder, **kw):
    basename = get_default_extracted_folder(fn, abspath=False)
    from .validate import validate_converted_files_match
    if not basename:
        print("Input file %s doesn't have a supported extension (%s), skipping it"
                % (fn, SUPPORTED_EXTENSIONS))
        return
    out_fn = _os.path.join(out_folder, basename + out_ext)
    errors = ""
    if not _os.path.lexists(out_fn):
        with _TemporaryDirectory(prefix=out_folder) as tmp:
            try:
                extract(fn, dest_dir=tmp)
                file_list = _collect_paths(tmp)

                create(tmp, file_list, _os.path.basename(out_fn), out_folder=out_folder, **kw)
                _, missing_files, mismatching_sizes = validate_converted_files_match(
                    tmp, _os.path.join(out_folder, fn))
                if missing_files or mismatching_sizes:
                    errors = str(ConversionError(missing_files, mismatching_sizes))
            except Exception as e:
                errors = str(e)
    return fn, out_fn, errors


def transmute(in_file, out_ext, out_folder=None, processes=1, **kw):
    if not out_folder:
        out_folder = _os.path.dirname(in_file) or _os.getcwd()

    flist = set(_glob(in_file))
    if in_file.endswith('.tar.bz2'):
        flist = flist - set(_glob(in_file.replace('.tar.bz2', out_ext)))
    elif in_file.endswith('.conda'):
        flist = flist - set(_glob(in_file.replace('.conda', out_ext)))

    failed_files = {}
    with _tqdm.tqdm(total=len(flist), leave=False) as t:
        with _get_executor(processes) as executor:
            convert_f = _functools.partial(_convert, out_ext=out_ext,
                                          out_folder=out_folder, **kw)
            for fn, out_fn, errors in executor.map(convert_f, flist):
                t.set_description("Converted: %s" % fn)
                t.update()
                if errors:
                    failed_files[fn] = errors
                    _rm_rf(out_fn)
    return failed_files


def verify_conversion(glob_pattern, target_dir, reference_ext,
                      tmpdir_root=_tempfile.gettempdir(), processes=None):
    from .validate import validate_converted_files_match
    if not glob_pattern.endswith(reference_ext):
        glob_pattern = glob_pattern + reference_ext
    file_sets_by_ext = {ext: _glob(_os.path.join(target_dir, glob_pattern + ext))
                        for ext in SUPPORTED_EXTENSIONS}
    matches = {path.replace(ext, "") for ext, path in file_sets_by_ext[reference_ext]}
    for ext, paths in file_sets_by_ext.items():
        if ext == reference_ext:
            continue
        matches &= {path.replace(ext, "") for ext, path in paths}
    other_exts = set(SUPPORTED_EXTENSIONS) - {reference_ext, }

    errors = {}
    with _tqdm.tqdm(total=(len(matches) * len(SUPPORTED_EXTENSIONS) - 1), leave=False) as t:
        with _Executor(max_workers=processes) as executor:
            for other_ext in other_exts:
                verify_fn = lambda fn: validate_converted_files_match(ref_ext=reference_ext,
                                                                      subject=fn + other_ext)
                for fn, missing, mismatching in executor.map(verify_fn, matches):
                    t.set_description("Validating %s" % fn)
                    t.update()
                    if missing or mismatching:
                        errors[fn] = str(ConversionError(missing, mismatching))
    return errors


def get_pkg_details(in_file):
    """For the new pkg format, we return the size and hashes of the inner pkg part of the file"""
    for ext in SUPPORTED_EXTENSIONS:
        if in_file.endswith(ext):
            details = SUPPORTED_EXTENSIONS[ext].get_pkg_details(in_file)
            break
    else:
        raise ValueError("Don't know what to do with file {}".format(in_file))
    return details
