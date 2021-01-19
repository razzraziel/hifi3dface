#!/bin/bash
echo "compiling rasterizer"
TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')
# you might need the following to successfully compile the third-party library
tf_mesh_renderer_path=$(pwd)/third_party/kernels/
#sudo ln -s /usr/local/lib/python3.6/dist-packages/tensorflow/libtensorflow_framework.so.2 /usr/lib/libtensorflow_framework.so
#sudo ldconfig
g++ -std=c++11 \
    -shared $tf_mesh_renderer_path/rasterize_triangles_grad.cc $tf_mesh_renderer_path/rasterize_triangles_op.cc $tf_mesh_renderer_path/rasterize_triangles_impl.cc $tf_mesh_renderer_path/rasterize_triangles_impl.h \
    -o $tf_mesh_renderer_path/rasterize_triangles_kernel.so -fPIC -D_GLIBCXX_USE_CXX11_ABI=0 \
    -I$TF_INC -L$TF_LIB -ltensorflow_framework -O2

if [ "$?" -ne 0 ]; then echo "compile rasterizer failed"; exit 1; fi
