#  tests for pycosat-0.6.3-py37h14c3975_0 (this is a generated file);
print('===== testing package: pycosat-0.6.3-py37h14c3975_0 =====');
print('running run_test.py');
#  --- run_test.py (begin) ---
#!/usr/bin/env python
import pycosat
import test_pycosat

assert test_pycosat.run().wasSuccessful()

assert pycosat.__version__ == '0.6.3'

assert test_pycosat.process_cnf_file('qg3-08.cnf') == 18
assert test_pycosat.process_cnf_file('uf20-098.cnf') == 5

import sudoku
sudoku.test()
#  --- run_test.py (end) ---

print('===== pycosat-0.6.3-py37h14c3975_0 OK =====');
print("import: 'pycosat'")
import pycosat

