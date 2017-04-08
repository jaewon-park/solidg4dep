FROM ubuntu:14.04

MAINTAINER jaewon.park@vt.edu

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git dpkg-dev make g++ gcc cmake \
    binutils libx11-dev libxpm-dev libxft-dev \
    libxext-dev libpng12-dev libjpeg-turbo8-dev \
    python gfortran libssl-dev wget libgsl0ldbl libgsl0-dev




ENV SITEROOT="/sw"

RUN mkdir /sw \
    && cd /sw \
    && mkdir external \
    && mkdir build \
    && cd build \
    && mkdir clhep-build \
    && cd clhep-build \
