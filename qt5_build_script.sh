#!/usr/bin/env bash

START=$(date +%s)

CWD=$(pwd)

QT_PATH=/home/sankhesh/Projects/Qt

QT_SRC=$QT_PATH/src
QT_BLD=$QT_PATH/bld
QT_INSTALL=$QT_PATH/install
export QTDIR=$QT_BLD/qtbase
export PATH=$QT_BLD/bin:$QT_SRC/qtrepotools/bin:$PATH

SRC_EXISTED="y"
if [ ! -d "$QT_SRC" ]; then
  printf "\n[INFO] $QT_SRC does not exist. Checking out source."
  git clone git://code.qt.io/qt/qt5.git $QT_SRC
  SRC_EXISTED=""
fi

CLEAN_BLD="n"
if [ ! -z "$SRC_EXISTED" ]; then
  if [ -d "$QT_BLD" ]; then
    printf "\n[QUESTION] $QT_BLD exists. Clean build tree? [y/N]:"
    read CLEAN_BLD
  fi
else
  CLEAN_BLD="y"
fi

if [ $CLEAN_BLD == "y" -o $CLEAN_BLD == "Y" ]; then
  rm -rf $QT_BLD
  mkdir -p $QT_BLD
fi

INIT="n"
if [ ! -z $SRC_EXISTED ]; then
  printf "\n[QUESTION] Initialize Qt submodules? [y/N]:"
  read INIT
else
  INIT="y"
fi

if [ $INIT == "y" -o $INIT == "Y" ]; then
  cd $QT_SRC
  perl init-repository \
	--module-subset=all,-qt3d,-qtactiveqt,-qtandroidextras,-qtcanvas3d,-qtconnectivity,-qtdoc,-qtdocgallery,-qtengineio,-qtfeedback,-qtlocation,-qtmacextras,-qtpim,-qtqa,-qtscript,-qtsensors,-qttranslations,-qtwebengine,-qtwebkit,-qtwinextras,-qtx11extras
fi

# Get the current checked out tag
cd $QT_SRC
TAG=$(git describe)
printf "\n[QUESTION] TAG to build [$TAG]"
read TAG
if [ ! -z $TAG ]; then
  printf "\n[INFO] Checking out tag: $TAG"
  git checkout $TAG
fi

printf "\n[INFO] All checks complete. Initiating configure step."
cd $QT_BLD
$QT_SRC/configure -opensource -confirm-license -debug-and-release \
  -platform linux-g++ -no-icu -opengl desktop \
  -nomake tests -nomake examples -qt-xcb\
  -prefix $QT_INSTALL
  -skip qt3d \
  -skip qtactiveqt \
  -skip qtandroidextras \
  -skip qtcanvas3d \
  -skip qtconnectivity \
  -skip qtdoc \
  -skip qtdocgallery \
  -skip qtengineio \
  -skip qtfeedback \
  -skip qtlocation \
  -skip qtmacextras \
  -skip qtpim \
  -skip qtqa \
  -skip qtscript \
  -skip qtsensors \
  -skip qttranslations \
  -skip qtwebengine \
  -skip qtwebkit \
  -skip qtwinextras \
  -skip qtx11extras

printf "\n[INFO] Configure complete. Initiating build."
make -j24
printf "\n[INFO] Build complete."

printf "\n[INFO] Initiating install."
make install -j24
printf "\n[INFO] Install complete."

cd $CWD
END=$(date +%s)
printf "\n[INFO] It took $(($END - $START)) seconds to complete\n"
