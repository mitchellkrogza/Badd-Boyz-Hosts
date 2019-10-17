from datetime import datetime
import os
import shutil
import sys
import tarfile

import pytest

from conda_package_handling import api
import conda_package_handling.tarball

this_dir = os.path.dirname(__file__)
data_dir = os.path.join(this_dir, "data")
test_package_name = "mock-2.0.0-py37_1000"


def test_api_extract_tarball_implicit_path(testing_workdir):
    tarfile = os.path.join(data_dir, test_package_name + '.tar.bz2')
    local_tarfile = os.path.join(testing_workdir, os.path.basename(tarfile))
    shutil.copy2(tarfile, local_tarfile)
    api.extract(local_tarfile)
    assert os.path.isfile(os.path.join(testing_workdir, test_package_name, 'info', 'index.json'))


def test_api_tarball_details(testing_workdir):
    tarfile = os.path.join(data_dir, test_package_name + '.tar.bz2')
    results = api.get_pkg_details(tarfile)
    assert results["size"] == 106576
    assert results["md5"] == "0f9cce120a73803a70abb14bd4d4900b"
    assert results["sha256"] == "34c659b0fdc53d28ae721fd5717446fb8abebb1016794bd61e25937853f4c29c"


def test_api_conda_v2_details(testing_workdir):
    condafile = os.path.join(data_dir, test_package_name + '.conda')
    results = api.get_pkg_details(condafile)
    assert results["size"] == 113421
    assert results["sha256"] == "181ec44eb7b06ebb833eae845bcc466ad96474be1f33ee55cab7ac1b0fdbbfa3"
    assert results["md5"] == "23c226430e35a3bd994db6c36b9ac8ae"


def test_api_extract_tarball_explicit_path(testing_workdir):
    tarfile = os.path.join(data_dir, test_package_name + '.tar.bz2')
    local_tarfile = os.path.join(testing_workdir, os.path.basename(tarfile))
    shutil.copy2(tarfile, local_tarfile)

    api.extract(local_tarfile, 'manual_path')
    assert os.path.isfile(os.path.join(testing_workdir, 'manual_path', 'info', 'index.json'))


def test_api_extract_tarball_with_libarchive_import_error(testing_workdir, mocker):
    try:
        api.libarchive_enabled = False
        conda_package_handling.tarball.libarchive_enabled = False
        tarfile = os.path.join(data_dir, test_package_name + '.tar.bz2')
        local_tarfile = os.path.join(testing_workdir, os.path.basename(tarfile))
        shutil.copy2(tarfile, local_tarfile)
        api.extract(local_tarfile, 'manual_path')
        assert os.path.isfile(os.path.join(testing_workdir, 'manual_path', 'info', 'index.json'))
    finally:
        api.libarchive_enabled = True
        conda_package_handling.tarball.libarchive_enabled = True


def test_api_extract_conda_v2_implicit_path(testing_workdir):
    condafile = os.path.join(data_dir, test_package_name + '.conda')
    local_condafile = os.path.join(testing_workdir, os.path.basename(condafile))
    shutil.copy2(condafile, local_condafile)
    api.extract(local_condafile)
    assert os.path.isfile(os.path.join(testing_workdir, test_package_name, 'info', 'index.json'))


def test_api_extract_conda_v2_explicit_path(testing_workdir):
    tarfile = os.path.join(data_dir, test_package_name + '.conda')
    local_tarfile = os.path.join(testing_workdir, os.path.basename(tarfile))
    shutil.copy2(tarfile, local_tarfile)

    api.extract(tarfile, 'manual_path')
    assert os.path.isfile(os.path.join(testing_workdir, 'manual_path', 'info', 'index.json'))


def test_api_extract_conda_v2_explicit_path_prefix(testing_workdir):
    tarfile = os.path.join(data_dir, test_package_name + '.conda')
    api.extract(tarfile, prefix=os.path.join(testing_workdir, 'folder'))
    assert os.path.isfile(os.path.join(testing_workdir, 'folder', test_package_name, 'info', 'index.json'))

    api.extract(tarfile, dest_dir='steve', prefix=os.path.join(testing_workdir, 'folder'))
    assert os.path.isfile(os.path.join(testing_workdir, 'folder', 'steve', 'info', 'index.json'))

def test_api_extract_dest_dir_and_prefix_both_abs_raises():
    tarfile = os.path.join(data_dir, test_package_name + '.conda')
    with pytest.raises(ValueError):
        api.extract(tarfile, prefix=os.path.dirname(tarfile), dest_dir=os.path.dirname(tarfile))

def test_api_extract_info_conda_v2(testing_workdir):
    condafile = os.path.join(data_dir, test_package_name + '.conda')
    local_condafile = os.path.join(testing_workdir, os.path.basename(condafile))
    shutil.copy2(condafile, local_condafile)
    api.extract(local_condafile, 'manual_path', components='info')
    assert os.path.isfile(os.path.join(testing_workdir, 'manual_path', 'info', 'index.json'))
    assert not os.path.isdir(os.path.join(testing_workdir, 'manual_path', 'lib'))


def test_api_transmute_tarball_to_conda_v2(testing_workdir):
    tarfile = os.path.join(data_dir, test_package_name + '.tar.bz2')
    errors = api.transmute(tarfile, '.conda', testing_workdir)
    assert not errors
    assert os.path.isfile(os.path.join(testing_workdir, test_package_name + '.conda'))


def test_api_transmute_conda_v2_to_tarball(testing_workdir):
    condafile = os.path.join(data_dir, test_package_name + '.conda')
    api.transmute(condafile, '.tar.bz2', testing_workdir)
    assert os.path.isfile(os.path.join(testing_workdir, test_package_name + '.tar.bz2'))


def test_warning_when_bundling_no_metadata(testing_workdir):
    pass


@pytest.mark.skipif(sys.platform=="win32", reason="windows and symlinks are not great")
def test_create_package_with_uncommon_conditions_captures_all_content(testing_workdir):
    os.makedirs('src/a_folder')
    os.makedirs('src/empty_folder')
    os.makedirs('src/symlink_stuff')
    with open('src/a_folder/text_file', 'w') as f:
        f.write('weee')
    open('src/empty_file', 'w').close()
    os.link('src/a_folder/text_file', 'src/a_folder/hardlink_to_text_file')
    os.symlink('../a_folder', 'src/symlink_stuff/symlink_to_a')
    os.symlink('../empty_file', 'src/symlink_stuff/symlink_to_empty_file')
    os.symlink('../a_folder/text_file', 'src/symlink_stuff/symlink_to_text_file')

    with tarfile.open('pinkie.tar.bz2', 'w:bz2') as tf:
        tf.add('src/empty_folder', 'empty_folder')
        tf.add('src/empty_file', 'empty_file')
        tf.add('src/a_folder', 'a_folder')
        tf.add('src/a_folder/text_file', 'a_folder/text_file')
        tf.add('src/a_folder/hardlink_to_text_file', 'a_folder/hardlink_to_text_file')
        tf.add('src/symlink_stuff/symlink_to_a', 'symlink_stuff/symlink_to_a')
        tf.add('src/symlink_stuff/symlink_to_empty_file', 'symlink_stuff/symlink_to_empty_file')
        tf.add('src/symlink_stuff/symlink_to_text_file', 'symlink_stuff/symlink_to_text_file')

    cph_created = api.create('src', None, 'thebrain.tar.bz2')

    # test against both archives created manually and those created by cph.  They should be equal in all ways.
    for fn in ('pinkie.tar.bz2', 'thebrain.tar.bz2'):
        api.extract(fn)
        target_dir = fn[:-8]
        flist = [
            'empty_folder',
            'empty_file',
            'a_folder/text_file',
            'a_folder/hardlink_to_text_file',
            'symlink_stuff/symlink_to_a',
            'symlink_stuff/symlink_to_text_file',
            'symlink_stuff/symlink_to_empty_file',
        ]

        # no symlinks on windows
        if sys.platform != 'win32':
            # not directly included but checked symlink
            flist.append('symlink_stuff/symlink_to_a/text_file')

        missing_content = []
        for f in flist:
            path_that_should_be_there = os.path.join(testing_workdir, target_dir, f)
            if not (os.path.exists(path_that_should_be_there) or
                    os.path.lexists(path_that_should_be_there)):
                missing_content.append(f)
        if missing_content:
            print("missing files in output package")
            print(missing_content)
            sys.exit(1)

        # hardlinks should be preserved, but they're currently not with libarchive
        # hardlinked_file = os.path.join(testing_workdir, target_dir, 'a_folder/text_file')
        # stat = os.stat(hardlinked_file)
        # assert stat.st_nlink == 2

        hardlinked_file = os.path.join(testing_workdir, target_dir, 'empty_file')
        stat = os.stat(hardlinked_file)
        if sys.platform != 'win32':
            assert stat.st_nlink == 1


@pytest.mark.skipif(datetime.now() <= datetime(2019, 12, 1), reason="Don't understand why this doesn't behave.  Punt.")
def test_secure_refusal_to_extract_abs_paths(testing_workdir):
    with tarfile.open('pinkie.tar.bz2', 'w:bz2') as tf:
        open('thebrain', 'w').close()
        tf.add(os.path.join(testing_workdir, 'thebrain'), '/naughty/abs_path')

    with pytest.raises(api.InvalidArchiveError):
        api.extract('pinkie.tar.bz2')


def tests_secure_refusal_to_extract_dotdot(testing_workdir):
    with tarfile.open('pinkie.tar.bz2', 'w:bz2') as tf:
        open('thebrain', 'w').close()
        tf.add(os.path.join(testing_workdir, 'thebrain'), '../naughty/abs_path')

    with pytest.raises(api.InvalidArchiveError):
        api.extract('pinkie.tar.bz2')
