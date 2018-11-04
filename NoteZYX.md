--source-path D:/GitHub/pytorch/cmake/../aten/src/ATen --install_dir C:/Users/yongxin/CMakeBuilds/9969cb59-a872-3a33-9258-87a9a79efdb5/build/x64-Debug/aten/src/ATen D:/GitHub/pytorch/cmake/../aten/src/ATen/Declarations.cwrap D:/GitHub/pytorch/cmake/../aten/src/THNN/generic/THNN.h D:/GitHub/pytorch/cmake/../aten/src/THCUNN/generic/THCUNN.h D:/GitHub/pytorch/cmake/../aten/src/ATen/nn.yaml D:/GitHub/pytorch/cmake/../aten/src/ATen/native/native_functions.yaml --output-dependencies D:/GitHub/pytorch/build/aten/src/ATen/generated_cpp.txt --install_dir D:/GitHub/pytorch/build/aten/src/ATen

D:\GitHub\pytorch\tools\build_pytorch_libs.bat --use-cuda --use-nnpack --use-qnnpack caffe2 > d:\buildpy.txt

 $env:PATH = $env:PATH + ";C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\amd64\;" + "C:\Program Files\CMake\bin\;"

```
conda create -n pytorchbuild
conda activate pytorchbuild
conda install python=3.5
conda install numpy pyyaml mkl mkl-include setuptools cmake cffi typing
d:\GitHub\pytorch\SetUpWindowsEnv.bat
python setup.py install
```

#Setup.py Build过程
##build_deps
 Build all dependent libraries
```
class build_deps(PytorchCommand):
```
### build_libs
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

