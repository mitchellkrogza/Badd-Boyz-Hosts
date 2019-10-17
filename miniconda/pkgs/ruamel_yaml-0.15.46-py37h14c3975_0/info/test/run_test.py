#  tests for ruamel_yaml-0.15.46-py37h14c3975_0 (this is a generated file);
print('===== testing package: ruamel_yaml-0.15.46-py37h14c3975_0 =====');
print('running run_test.py');
#  --- run_test.py (begin) ---
import os
import ruamel_yaml
try:
    import pytest
except ImportError:
    pytest = None

if pytest:
    print('ruamel_yaml.__version__: %s' % ruamel_yaml.__version__)

# version_info is used in the package
# check that it exists and matches __version__
from ruamel_yaml import version_info
ver_string = '.'.join([str(i) for i in version_info])
print(ver_string)
assert ver_string == ruamel_yaml.__version__
#  --- run_test.py (end) ---

print('===== ruamel_yaml-0.15.46-py37h14c3975_0 OK =====');
print("import: 'ruamel_yaml'")
import ruamel_yaml

print("import: 'ruamel_yaml.ext._ruamel_yaml'")
import ruamel_yaml.ext._ruamel_yaml

