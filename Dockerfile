FROM ubuntu:14.04

MAINTAINER jaewon.park@vt.edu

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git dpkg-dev make g++ gcc cmake \
    binutils libx11-dev libxpm-dev libxft-dev \
    libxext-dev libpng12-dev libjpeg-turbo8-dev \
    python gfortran libssl-dev wget libgsl0ldbl libgsl0-dev




ENV SITEROOT="/sw"
ENV BUILDDIR="/sw/build"

ENV PATH=$SITEROOT/external/cmake/bin:$PATH

ENV ROOT_TAR="root_v6.05.02.Linux-ubuntu14-x86_64-gcc4.8.tar.gz"
ENV ROOT_DL="https://root.cern.ch/download/$ROOT_TAR"

ENV ROOTSYS="/cern/root/"
ENV PATH="$ROOTSYS/bin:$PATH"
ENV LD_LIBRARY_PATH="$ROOTSYS/lib:$LD_LIBRARY_PATH"


RUN mkdir /cern && cd /cern \
    && wget $ROOT_DL \
    && tar xzfv $ROOT_TAR \
    && rm -rf $ROOT_TAR \
    && mkdir /sw \
    && cd /sw \
    && mkdir external \
    && mkdir build \
    && cd build \
    && wget --no-check-certificate https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz \
    && tar zxf cmake-3.7.2.tar.gz \
    && cd cmake-3.7.2 \
    && ./bootstrap --prefix=$SITEROOT/external/cmake \
    && make -j 4 \
    && make install \
    && cd ../ \
    && wget http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.4.3.tgz \
    && tar zxf clhep-2.3.4.3.tgz \
    && mkdir clhep-build \
    && cd clhep-build \
    && cmake -DCMAKE_INSTALL_PREFIX=$SITEROOT/external/clhep ../2.3.4.3/CLHEP \
    && make -j 4 \
    && make test \
    && make install \
    && wget http://geant4.cern.ch/support/source/geant4.10.02.p03.tar.gz \
    && tar zxf geant4.10.02.p03.tar.gz \
    && mkdir -p geant4-build \
    && cd geant4-build \
    && cmake -DCMAKE_INSTALL_PREFIX=$SITEROOT/geant4 \
             -EXPAT_LIBRARY=/usr/lib64 \
             -DGEANT4_INSTALL_DATA=ON \
             -DGEANT4_USE_OPENGL_X11=ON \
             -DXERCESC_LIBRARY=/usr/lib64/libxerces-c.so \
             -DGEANT4_USE_GDML=ON \
             -DGEANT4_USE_RAYTRACER_X11=ON \
             ../geant4.10.02.p03 \
    && make -j 4 \
    && make install

