FROM ubuntu:14.04

MAINTAINER Jaewon Park <jaewon.park@vt.edu>

USER root

RUN apt-get update

RUN apt-get -y install wget cmake cmake-curses-gui build-essential \
        libqt4-opengl libqt4-opengl-dev qt4-qmake libqt4-dev libx11-dev \
        libxmu-dev libxpm-dev libxft-dev

ENV ROOT_TAR="root_v6.05.02.Linux-ubuntu14-x86_64-gcc4.8.tar.gz"
ENV ROOT_DL="https://root.cern.ch/download/$ROOT_TAR"

ENV ROOTSYS="/cern/root/"
ENV PATH="$ROOTSYS/bin:$PATH"
ENV LD_LIBRARY_PATH="$ROOTSYS/lib:$LD_LIBRARY_PATH"

RUN mkdir /cern && cd /cern \
    && wget $ROOT_DL \
    && tar xzfv $ROOT_TAR \
    && rm -rf $ROOT_TAR

RUN mkdir -p ~/GEANT4/source; \
    cd ~/GEANT4/source; \
    wget http://geant4.cern.ch/support/source/geant4.10.01.tar.gz

RUN cd ~/GEANT4/source; \
    tar -xzf geant4.10.01.tar.gz

RUN mkdir -p ~/GEANT4/build; \
    cd ~/GEANT4/build; \
    cmake ~/GEANT4/source/geant4.10.01 -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_USE_QT=ON -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_USE_RAYTRACER_X11=ON -DGEANT4_INSTALL_DATA=ON \
    -Wno-dev; \
    make -j`grep -c processor /proc/cpuinfo`; \
    make install; \
    echo ' . geant4.sh' >> ~/.bashrc \
    echo 'export G4ROOT=$SITEROOT/geant4' >> ~/.bashrc \
    echo 'export CMAKE_MODULE_PATH=$G4ROOT/lib64/Geant4-10.1.2/Modules/' >> ~/.bashrc \
    echo "alias cmake='cmake -DGeant4_DIR=$G4ROOT/lib64/Geant4-10.1.2/'" >> ~/.bashrc \
    echo 'export ROOTSYS="/cern/root/"' >> ~/.bashrc \
    echo 'export PATH="$ROOTSYS/bin:$PATH"' >>  ~/.bashrc \
    echo 'export LD_LIBRARY_PATH="$ROOTSYS/lib:$LD_LIBRARY_PATH"' >>  ~/.bashrc
