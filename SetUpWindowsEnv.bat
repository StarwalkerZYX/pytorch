set "VS150COMNTOOLS=C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build"
set CMAKE_GENERATOR=Visual Studio 15 2017 Win64
set DISTUTILS_USE_SDK=1
REM The following two lines are needed for Python 2.7, but the support for it is very experimental.
set MSSdk=1
set FORCE_PY27_BUILD=1
REM As for CUDA 8, VS2015 Update 3 is also required to build PyTorch. Use the following line.
set "CUDAHOSTCXX=%VS140COMNTOOLS%\..\..\VC\bin\amd64\cl.exe"

call "%VS150COMNTOOLS%\vcvarsall.bat" x64 -vcvars_ver=15

SetUpWindowsEnv.bat