#!/usr/bin/env bash

START=$(date +%s)
echo $START

CWD=$(pwd)

VTK_PATH=$CWD/vtk
VTK_REV=master

if [ -z $PACKAGE_PATH ]; then
  PACKAGE_PATH=$VTK_PATH
fi

VTK_SRC=$VTK_PATH/vtk
VTK_CompileTools_BLD=$VTK_PATH/CompileTools
VTK_BLD=$VTK_PATH/bld
VTK_INSTALL=$VTK_PATH/install
ANDROID_NDK=/home/sankhesh/Projects/Android/android-ndk-r16b-linux-x86_64/android-ndk-r16b

if [ ! -d "$VTK_SRC" ]; then
  git clone https://gitlab.kitware.com/vtk/vtk.git $VTK_SRC
  cd $VTK_SRC
  git reset --hard $VTK_REV
else
  cd $VTK_SRC
  git fetch origin --prune --tags
  git checkout $VTK_REV
fi

VTK_VERSION=$(git describe)

if [ -d "$VTK_BLD" ]; then
  rm -rf $VTK_BLD
fi
mkdir -p $VTK_BLD

mkdir -p $VTK_CompileTools_BLD
cd $VTK_CompileTools_BLD
cmake -GNinja \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DVTK_BUILD_ALL_MODULES:BOOL=OFF \
  -DVTK_Group_Rendering:BOOL=OFF \
  -DVTK_Group_StandAlone:BOOL=ON \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DBUILD_EXAMPLES:BOOL=OFF \
  -DBUILD_TESTING:BOOL=OFF \
  $VTK_SRC
ninja vtkCompileTools

cd $VTK_BLD
cmake -GNinja \
  -DCMAKE_SYSTEM_NAME:STRING=Android \
  -DCMAKE_SYSTEM_VERSION:STRING=21 \
  -DCMAKE_ANDROID_ARCH_ABI:STRING=armeabi \
  -DCMAKE_ANDROID_NDK:PATH=$ANDROID_NDK \
  -DVTKCompileTools_DIR:PATH=$VTK_CompileTools_BLD \
  -DCMAKE_BUILD_TYPE:STRING=Release \
  -DCMAKE_INSTALL_PREFIX=$VTK_INSTALL \
  -DBUILD_TESTING:BOOL=OFF \
  -DBUILD_SHARED_LIBS:BOOL=ON \
  -DBUILD_DOCUMENTATION:BOOL=OFF \
  -DBUILD_DICOM_PROGRAMS:BOOL=OFF \
  -DVTK_Group_StandAlone:BOOL=OFF \
  -DVTK_Group_Rendering:BOOL=OFF \
  -DModule_vtkCommonCore:BOOL=ON \
  -DModule_vtkCommonDataModel:BOOL=ON \
  -DModule_vtkCommonMisc:BOOL=ON \
  -DModule_vtkCommonSystem:BOOL=ON \
  -DModule_vtkDICOM:BOOL=ON \
  -DModule_vtkIOImage:BOOL=ON \
  -DModule_vtkImagingCore:BOOL=ON \
  -DModule_vtkParallelCore:BOOL=ON \
  -DModule_vtkRenderingCore:BOOL=ON \
  -DModule_vtkRenderingVolume:BOOL=ON \
  $VTK_SRC
  # -DVTK_USE_SYSTEM_EXPAT:BOOL=ON \
  # -DVTK_USE_SYSTEM_JPEG:BOOL=ON \
  # -DVTK_USE_SYSTEM_PNG:BOOL=ON \
  # -DVTK_USE_SYSTEM_TIFF:BOOL=ON \
  # -DVTK_USE_SYSTEM_ZLIB:BOOL=ON \

ninja
# Creating the binary tarballs
# ninja install
# PLAT_CODE=$(grep DISTRIB_CODENAME /etc/lsb-release | sed 's/.*=//')
# PLAT_ARCH=$(uname -m)
# cd $VTK_INSTALL
# PACKAGE_NAME=$PACKAGE_PATH/vtk-$VTK_VERSION-$PLAT_CODE-$PLAT_ARCH
# tar czf $PACKAGE_NAME.tar.gz *

# printf "Package $PACKAGE_NAME.tar.gz created.\n" \

cd $CWD
END=$(date +%s)
printf "\n[INFO] It took $(($END - $START)) seconds to complete " \
  "vtk packaging\n"
