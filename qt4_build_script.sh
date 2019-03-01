#!/usr/bin/env bash

START=$(date +%s)

CWD=$(pwd)

QT_PATH=/home/sankhesh/Projects/Qt4

QT_SRC=$QT_PATH/qt
QT_BLD=$QT_PATH/bld
QT_INSTALL=$QT_PATH/install
export QTDIR=$QT_BLD
export PATH=$QT_INSTALL/bin:$PATH

SRC_EXISTED="y"

if [ ! -d "$QT_SRC" ]; then
  printf "\n[INFO] $QT_SRC does not exist. Checking out source.\n"
  git clone git://code.qt.io/qt/qt.git $QT_SRC
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

# Get the current checked out tag
cd $QT_SRC
TAG=$(git describe)
if [ ! -z $SRC_EXISTED ]; then
  git fetch origin --tags --prune
fi
printf "\n[QUESTION] TAG to build [$TAG] (Enter 't' to list all tags):"
read TAG
if [ ! -z $TAG ]; then
  while [ $TAG == "t" -o $TAG == "T" ]; do
    git tag -l
    TAG=$(git describe)
    printf "\n[QUESTION] TAG to build [$TAG] (Enter 't' to list all tags):"
    read TAG
  done
  if [ ! -z $TAG ]; then
    printf "\n[INFO] Checking out tag: $TAG\n"
    git checkout $TAG
  fi
fi

printf "\n[INFO] All checks complete. Initiating configure step."
cd $QT_BLD
$QT_SRC/configure -opensource -confirm-license -release \
  -platform linux-g++ -prefix $QT_INSTALL -shared \
  -graphicssystem opengl \
  -no-accessibility \
  -no-audio-backend \
  -no-multimedia \
  -no-openssl \
  -no-phonon-backend \
  -no-qt3support \
  -no-script \
  -no-scripttools \
  -no-webkit

printf "\n[INFO] Configure complete. Initiating build."
make -j24
printf "\n[INFO] Build complete."

printf "\n[INFO] Initiating install."
make install -j24
printf "\n[INFO] Install complete."

cd $CWD
END=$(date +%s)
printf "\n[INFO] It took $(($END - $START)) seconds to complete\n"
