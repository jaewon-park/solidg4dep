FROM ubuntu:14.04

MAINTAINER jaewon.park@vt.edu

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git dpkg-dev make g++ gcc cmake \
    binutils libx11-dev libxpm-dev libxft-dev \
    libxext-dev libpng12-dev libjpeg-turbo8-dev \
    python gfortran libssl-dev wget libgsl0ldbl libgsl0-dev




ENV SITEROOT="/sw"
ENV PATH=$SITEROOT/external/cmake/bin:$PATH

RUN mkdir /sw \
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
    && make install

