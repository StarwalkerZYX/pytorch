# 安装步骤
在Anaconda Prompt中依次执行下述语句
```
conda create -n pytorchbuild
conda activate pytorchbuild
conda install python=3.5
conda install numpy pyyaml mkl mkl-include setuptools cmake cffi typing
d:\GitHub\pytorch\SetUpWindowsEnv.bat
python setup.py install > d:\pybuild.txt
```

#Git操作
```

```

#To continue
## 1. python setup.py install > d:\pybuild.txt 报错
```
setup.py: tools\build_pytorch_libs.bat --use-cuda --use-nnpack --use-qnnpack caffe2
setup.py: Failed to run 'tools\build_pytorch_libs.bat --use-cuda --use-nnpack --use-qnnpack caffe2'
```
## 2.tools\build_pytorch_libs.bat --use-cuda --use-nnpack --use-qnnpack caffe2 报错

```
(pytorchbuild) d:\GitHub\pytorch\build>cmake .. -G "Visual Studio 15 2017 Win64"                   -DCMAKE_BUILD_TYPE=Release                   -DTORCH_BUILD_VERSION="1.0.0a0+b5efc36"                   -DBUILD_TORCH="ON"                   -DNVTOOLEXT_HOME="C:/Program Files/NVIDIA Corporation/NvToolsExt/"                   -DNO_API=ON                   -DBUILD_SHARED_LIBS="ON"                   -DBUILD_PYTHON=ON                   -DBUILD_BINARY=OFF                   -DBUILD_TEST=ON                   -DINSTALL_TEST=ON                   -DBUILD_CAFFE2_OPS=ON                   -DONNX_NAMESPACE=onnx_torch                   -DUSE_CUDA=1                   -DUSE_DISTRIBUTED=OFF                   -DUSE_NUMPY=                   -DUSE_NNPACK=1                   -DUSE_LEVELDB=OFF                   -DUSE_LMDB=OFF                   -DUSE_OPENCV=OFF                   -DUSE_QNNPACK=1                   -DUSE_FFMPEG=OFF                   -DUSE_GLOG=OFF                   -DUSE_GFLAGS=OFF                   -DUSE_SYSTEM_EIGEN_INSTALL=OFF                   -DCUDNN_INCLUDE_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0\include"                   -DCUDNN_LIB_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0\lib/x64"                   -DCUDNN_LIBRARY="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v8.0\lib/x64\cudnn.lib"                   -DNO_MKLDNN=1                   -DMKLDNN_INCLUDE_DIR=""                   -DMKLDNN_LIB_DIR=""                   -DMKLDNN_LIBRARY=""                   -DATEN_NO_CONTRIB=1                   -DCMAKE_INSTALL_PREFIX="d:/GitHub/pytorch/torch/lib/tmp_install"                   -DCMAKE_C_FLAGS=""                   -DCMAKE_CXX_FLAGS="/EHa "                   -DCMAKE_EXE_LINKER_FLAGS=""                   -DCMAKE_SHARED_LINKER_FLAGS=""                   -DUSE_ROCM=0 

```
## 3. cmake .. 报错

```
-- Configuring incomplete, errors occurred!
See also "D:/GitHub/pytorch/build/CMakeFiles/CMakeOutput.log".
See also "D:/GitHub/pytorch/build/CMakeFiles/CMakeError.log".

(pytorchbuild) d:\GitHub\pytorch\build>msbuild INSTALL.vcxproj /p:Configuration=Release 
用于 .NET Framework 的 Microsoft (R) 生成引擎版本 15.8.169+g1ccb72aefa
版权所有(C) Microsoft Corporation。保留所有权利。

MSBUILD : error MSB1009: 项目文件不存在。
开关:INSTALL.vcxproj
```
## 4. 使用CMake GUI重现和查看CMake过程信息
CMakeGUI在处理 《 D:/GitHub/pytorch/caffe2》目录时报错。
```
Entering             D:/GitHub/pytorch/caffe2
Using direct python
NOTE1111
python D:/GitHub/pytorch/cmake/../aten/src/ATen/gen.py --source-path D:/GitHub/pytorch/cmake/../aten/src/ATen --install_dir D:/GitHub/pytorch/build/aten/src/ATen D:/GitHub/pytorch/cmake/../aten/src/ATen/Declarations.cwrap D:/GitHub/pytorch/cmake/../aten/src/THNN/generic/THNN.h D:/GitHub/pytorch/cmake/../aten/src/THCUNN/generic/THCUNN.h D:/GitHub/pytorch/cmake/../aten/src/ATen/nn.yaml D:/GitHub/pytorch/cmake/../aten/src/ATen/native/native_functions.yaml
0
p
ython: can't open file ' ': [Errno 2] No such file or directory

```

## 5. 推荐使用VS2017打开PyTorch文件夹，调试CMake文件
修改了codegen.cmake文件，CMake能够完成Configure & Generate
上面的“python D:/GitHub/pytorch/cmake/../aten/src/ATen/gen.py”部分，由于之前在Codegen.cmake中加入了“空格”便于查看，导致了传入给gen.py的参数不正确。删除空格后，python能够正确调用gen.py。
CMake能够完成Configure&Generate。但是编译错误。

## 6. 使用VS2107 Build “d:/GitHub/pytorch/build/Caffe2.sln”

遇到第一个错误：
```
错误	C1083	无法打开包括文件: “Eigen/Core”: No such file or directory (编译源文件 D:\GitHub\pytorch\caffe2\utils\math_cpu.cc)	caffe2	d:\github\pytorch\caffe2\utils\eigen_utils.h	6	
```
发现d:/GitHub/pytorch/third_party/eigen/目录为空

## 7. 调查如何CheckOut Submodule

[参考网页](https://www.cnblogs.com/ligun123/p/4139883.html"参考网页“)
依次执行

``` git
git submodule sync
git submodule update –init
#系统报错
fatal: Needed a single revision
Unable to find current revision in submodule path 'third_party/eigen'
#手工删除 d:\GitHub\pytorch\third_party\eigen\
#再次执行
git submodule update –init
```

## 8. 用VS2017再次Build
第一次Build，pybind_state??？项目有错误。
直接再编译一次，就全部通过了！！！

## 9.pytorch\tools\setup_helpers\generate_code.py: generate_code() 

setup.py注释掉tools\build_pytorch_libs.bat，再次执行。发现上述函数中报错退出。

```
c:\programdata\anaconda3\envs\pytorchbuild\include\pyconfig.h(68): fatal error C1083: Cannot open 
include file: 'io.h': No such file or directory
```

**calling stack**

```
build_extension, build_ext.py:527
build_extension, build_ext.py:199
_build_extensions_serial, build_ext.py:473
build_extensions, build_ext.py:448
build_extensions, setup.py:706
run, build_ext.py:339
run, build_ext.py:78
run, setup.py:651
```
***Note: build_ext.py是系统自带文件。 C:/ProgramData/Anaconda3/envs/pytorchbuild/Lib/distutils/command/build_ext.py ***

## 10.include_dirs 增加路径
setup.py， Line 834:
```python
include_dirs += [
    cwd,
    tmp_install_path + "/include",
    tmp_install_path + "/include/TH",
    tmp_install_path + "/include/THNN",
    tmp_install_path + "/include/ATen",
    third_party_path + "/pybind11/include",
    os.path.join(cwd, "torch", "csrc"),
    "d:/GitHb/build/third_party",
    "d:/GitHub/pytorch/aten/src/THC",
    '"C:/Program Files (x86)/Windows Kits/10/Include/10.0.10240.0/ucrt"',
    '"C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/shared"',
    #'"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.15.26726/include"',
]
```
## 11. 发现用的是VS2105的cl.exe
发现Complile时用的都是VS2015的cl.exe。
相应修改了setup.py中的include path。
卡在了： Cannot open include file: 'THCGeneral.h': No such file or directory
发现应该是没有生成.h文件，只有D:\GitHub\pytorch\aten\src\THC\THCGeneral.h.in
```python
include_dirs += [
    cwd,
    tmp_install_path + "/include",
    tmp_install_path + "/include/TH",
    tmp_install_path + "/include/THNN",
    tmp_install_path + "/include/ATen",
    third_party_path + "/pybind11/include",
    os.path.join(cwd, "torch", "csrc"),
    "d:/GitHb/build/third_party",
    "d:/GitHub/pytorch/aten/src/THC",
    "d:/GitHub/pytorch/aten/src",
    '"C:/Program Files (x86)/Windows Kits/10/Include/10.0.10240.0/ucrt"',
    '"C:/Program Files (x86)/Windows Kits/10/Include/10.0.17134.0/shared"',
    '"C:/Program Files (x86)/Microsoft Visual Studio 14.0/VC/include"',
    #'"C:/Program Files (x86)/Microsoft Visual Studio/2017/Community/VC/Tools/MSVC/14.15.26726/include"',
]
```

# Setup.py Build总体过程



- class:build_deps -》 function:run() -》 code:build_libs(libs)  》》》

- function:build_libs(libs) -》 code: subprocess.call(build_libs_cmd + libs, env=my_env, **kwargs) 》》》

- 实际调用命令： tools\build_pytorch_libs.bat --use-cuda --use-nnpack --use-qnnpack caffe2 》》》

- build_pytorch_libs.bat -》 :build_caffe2 节点 -》 调用CMake 编译caffe2文件夹 》》》

- codegen.cmake -》 Python D:/GitHub/pytorch/cmake/../aten/src/ATen/gen.py

# 1. build_deps
 Build all dependent libraries
```
class build_deps(PytorchCommand):
```
# 2. build_libs
Calls build_pytorch_libs.sh/bat with the correct env variables
```
def build_libs(libs):
```
其中，下述语句出错：
```
    if subprocess.call(build_libs_cmd + libs, env=my_env, **kwargs) != 0:
        print("Failed to run '{}'".format(' '.join(build_libs_cmd + libs)))
        sys.exit(1)
```
输出：
```
Failed to run 'tools\build_pytorch_libs.bat --use-cuda --use-nnpack --use-qnnpack caffe2'
```

toos\build_pytorch_libs.bat被调用了，但是返回错误值。

# 3. tools\build_pytorch_libs.bat

1. 设置一堆系统变量和编译变量
1. 根据批处理输入参数 %1 来决定走哪个路径。
```
if "%1"=="" goto after_loop
if "%1"=="caffe2" (
  call:build_caffe2 %~1
```
1. 调用的是 :build_caffe2 路径。
1. build_caffe2中实际调用Cmake。并且CMake目标目录是上一级目录 .. 。
```
cmake ..                    -DCMAKE_BUILD_TYPE=Release                   -DTORCH_BUILD_VERSION="1.0.0a0+7547e1c"                   -DBUILD_TORCH="ON"                   -DNVTOOLEXT_HOME="C:/Program Files/NVIDIA Corporation/NvToolsExt/"                   -DNO_API=ON                   -DBUILD_SHARED_LIBS="ON"                   -DBUILD_PYTHON=ON                   -DBUILD_BINARY=OFF                   -DBUILD_TEST=ON                   -DINSTALL_TEST=ON                   -DBUILD_CAFFE2_OPS=ON                   -DONNX_NAMESPACE=onnx_torch                   -DUSE_CUDA=1                   -DUSE_DISTRIBUTED=OFF                   -DUSE_NUMPY=                   -DUSE_NNPACK=1                   -DUSE_LEVELDB=OFF                   -DUSE_LMDB=OFF                   -DUSE_OPENCV=OFF                   -DUSE_QNNPACK=1                   -DUSE_FFMPEG=OFF                   -DUSE_GLOG=OFF                   -DUSE_GFLAGS=OFF                   -DUSE_SYSTEM_EIGEN_INSTALL=OFF                   -DCUDNN_INCLUDE_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v9.0\include"                   -DCUDNN_LIB_DIR="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v9.0\lib/x64"                   -DCUDNN_LIBRARY="C:/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v9.0\lib/x64\cudnn.lib"                   -DNO_MKLDNN=1                   -DMKLDNN_INCLUDE_DIR=""                   -DMKLDNN_LIB_DIR=""                   -DMKLDNN_LIBRARY=""                   -DATEN_NO_CONTRIB=1                   -DCMAKE_INSTALL_PREFIX="D:/GitHub/pytorch/torch/lib/tmp_install"                   -DCMAKE_C_FLAGS=""                   -DCMAKE_CXX_FLAGS="/EHa "                   -DCMAKE_EXE_LINKER_FLAGS=""                   -DCMAKE_SHARED_LINKER_FLAGS=""                   -DUSE_ROCM=0 
```
# 4.pytorch/CMakeLists.txt
最顶级CMakeList

##4.1 Line 335 添加子目录

```
# ---[ Main build
  add_subdirectory(c10)
  add_subdirectory(caffe2)
```
##4.2 Line 202

```
# ---[ Dependencies 添加依赖文件
include(cmake/Dependencies.cmake)
```

##4.3 Dependencies 报错
```
CMake Error at cmake/public/cuda.cmake:278 (message):
  CUDA support not available with 32-bit windows.  Did you forget to set
  Win64 in the generator target?
Call Stack (most recent call first):
  cmake/Dependencies.cmake:569 (include)
  CMakeLists.txt:202 (include)
```


-------

##D:\GitHub\pytorch\caffe2\CMakeLists.txt
-   add_subdirectory(../aten aten)
 



#Codegen.cmake
D:\GitHub\pytorch\cmake\Codegen.cmake 调用 Python D:/GitHub/pytorch/cmake/../aten/src/ATen/gen.py 后返回值有问题。
下述语句出错：
```
CMake Error at cmake/Codegen.cmake:163 (message):
```
下面的代码RETURN_VALUE为2，为啥？
```
  EXECUTE_PROCESS(
      COMMAND ${GEN_COMMAND}
        --output-dependencies ${CMAKE_BINARY_DIR}/aten/src/ATen/generated_cpp.txt
        --install_dir ${CMAKE_BINARY_DIR}/aten/src/ATen
      RESULT_VARIABLE RETURN_VALUE
  )
```
#1D:\GitHub\pytorch\CMakeLists.txt 解读
 Main build
- add_subdirectory(c10)
    - 
- add_subdirectory(caffe2)
##D:\GitHub\pytorch\caffe2\CMakeLists.txt
-   add_subdirectory(../aten aten)


#备忘
E:\Anaconda3\envs\pytorchbuild\python.exe D:/GitHub/pytorch/cmake/../aten/src/ATen/gen.py --source-path D:/GitHub/pytorch/cmake/../aten/src/ATen --install_dir D:/GitHub/pytorch/build/aten/src/ATen D:/GitHub/pytorch/cmake/../aten/src/ATen/Declarations.cwrap D:/GitHub/pytorch/cmake/../aten/src/THNN/generic/THNN.h D:/GitHub/pytorch/cmake/../aten/src/THCUNN/generic/THCUNN.h D:/GitHub/pytorch/cmake/../aten/src/ATen/nn.yaml D:/GitHub/pytorch/cmake/../aten/src/ATen/native/native_functions.yaml --output-dependencies D:/GitHub/pytorch/build/aten/src/ATen/generated_cpp.txt --install_dir D:/GitHub/pytorch/build/aten/src/ATen

##setup.py寻找VC编译器设置
envs/pytorchbuild/Lib/distutils/_msvccompiler.py
```python
def _find_vcvarsall(plat_spec):
    try:
        key = winreg.OpenKeyEx(
            winreg.HKEY_LOCAL_MACHINE,
            r"Software\Microsoft\VisualStudio\SxS\VC7",
            access=winreg.KEY_READ | winreg.KEY_WOW64_32KEY
        )
```