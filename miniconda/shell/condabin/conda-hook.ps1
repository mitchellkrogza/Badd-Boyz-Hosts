$Env:CONDA_EXE = "/home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/miniconda/bin/conda"
$Env:_CE_M = ""
$Env:_CE_CONDA = ""
$Env:_CONDA_ROOT = "/home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/miniconda"
$Env:_CONDA_EXE = "/home/travis/build/mitchellkrogza/Badd-Boyz-Hosts/miniconda/bin/conda"

Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"
Add-CondaEnvironmentToPrompt