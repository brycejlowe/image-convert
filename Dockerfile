FROM centos:7

# get external repositories
RUN yum install -y \
    https://repo.ius.io/ius-release-el7.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install dependencies for building ImageMagick
RUN yum install -y automake libtool gcc-c++ make \
    git2u python36u \
    libjpeg-devel libpng-devel

# subsequent compiles will source pacakges from /usr/local
ENV PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}"

# download and install libde265 (required by libheic)
ENV LIBDE265_VERSION="v1.0.3"
RUN LIBDE265_SRC=/usr/local/src/ibde265 && \
    git clone https://github.com/strukturag/libde265.git --branch=${LIBDE265_VERSION} ${LIBDE265_SRC} && \
    cd ${LIBDE265_SRC} && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    rm -rf ${LIBDE265_SRC}

# download and install libheic (modify PKG_CONFIG_PATH as it requires libde265 
# that was buit previously)
ENV LIBHEIF_VERSION="v1.5.1"
RUN LIBHEIC_SRC=/usr/local/src/libheic && \
    git clone https://github.com/strukturag/libheif.git --branch=${LIBHEIF_VERSION} ${LIBHEIC_SRC} && \
    cd ${LIBHEIC_SRC} && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install && \
    rm -rf ${LIBHEIC_SRC}

# install imagemagick
ENV IMAGEMAGICK_VERSION="7.0.8-68"
RUN IMAGEMAGICK_SRC=/usr/local/src/imagemagick && \
    git clone https://github.com/ImageMagick/ImageMagick.git --branch=${IMAGEMAGICK_VERSION} ${IMAGEMAGICK_SRC} && \
    cd ${IMAGEMAGICK_SRC} && \
    ./configure && \
    make && \
    make install && \
    rm -rf ${IMAGEMAGICK_SRC}

COPY image_convert.py /usr/local/bin/image_convert.py
RUN chmod +x /usr/local/bin/image_convert.py

CMD ["/usr/local/bin/image_convert.py"]