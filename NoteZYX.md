python D:/GitHub/pytorch/cmake/../aten/src/ATen/gen.py --source-path D:/GitHub/pytorch/cmake/../aten/src/ATen --install_dir C:/Users/yongxin/CMakeBuilds/9969cb59-a872-3a33-9258-87a9a79efdb5/build/x64-Debug/aten/src/ATen D:/GitHub/pytorch/cmake/../aten/src/ATen/Declarations.cwrap D:/GitHub/pytorch/cmake/../aten/src/THNN/generic/THNN.h D:/GitHub/pytorch/cmake/../aten/src/THCUNN/generic/THCUNN.h D:/GitHub/pytorch/cmake/../aten/src/ATen/nn.yaml D:/GitHub/pytorch/cmake/../aten/src/ATen/native/native_functions.yaml

```
conda create -n pytorchbuild
conda activate pytorchbuild
conda install python=3.5
SetUpWindowsEnv.bat
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


