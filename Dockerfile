FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -y git vim g++ gdb

RUN apt-get install -y wget lsb-release apt-transport-https

# -- Install Clang, Cmake & other useful build tools

RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - && \
    echo "deb [arch=amd64] https://packages.irods.org/apt/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/renci-irods.list && \
    apt-get update





RUN apt-get install -y  \
    irods-externals-boost1.60.0-0       \
    irods-externals-boost1.67.0-0       \
    irods-externals-clang3.8-0          \
    irods-externals-clang6.0-0          \
    irods-externals-clang-runtime3.8-0  \
    irods-externals-clang-runtime6.0-0  \
    irods-externals-cmake3.5.2-0        \
    irods-externals-cmake3.11.4-0       \
    irods-externals-json3.0.1-0         \
    irods-externals-json3.1.2-0         \
    irods-externals-libarchive3.1.2-0   \
    irods-externals-libarchive3.3.2-0   \
    irods-externals-libarchive3.3.2-1

WORKDIR /root

# -- Install and compile debug vsn of libcxx

RUN git clone http://github.com/llvm/llvm-project

RUN apt-get install make

RUN cd llvm-project && \
    mkdir build && \
    cd build && \
    /opt/irods-externals/cmake3.11.4-0/bin/cmake \
        -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_PROJECTS="libcxx;libcxxabi" ../llvm && \
    make -j3 cxx cxxabi

### rr begin
RUN apt-get install -y ccache cmake make g++-multilib gdb pkg-config \
      coreutils python3-pexpect manpages-dev git ninja-build capnproto \
      libcapnp-dev

RUN git clone http://github.com/mozilla/rr && \
    mkdir obj && cd obj && \
    cmake ../rr && \
    make -j8 && \
    make install
### rr end

# -- Compile a c++ Demo program

COPY demo.cpp .
RUN  /opt/irods-externals/clang6.0-0/bin/clang++ -Wl,-rpath=$HOME/llvm-project/build/lib demo.cpp -stdlib=libc++ -nostdinc++ -g -O0 -std=c++17 \
     -L/root/llvm-project/build/lib     -I/root/llvm-project/build/include/c++/v1

# -- Install & configure the pretty-printers

RUN  git clone https://github.com/koutheir/libcxx-pretty-printers

RUN  cd libcxx-pretty-printers && git checkout 5ffbf2487bf8da7f08bc1c8650a4396d2ff15403

RUN  PP_SRC_DIR=~/libcxx-pretty-printers/src && \
     ln -s $PP_SRC_DIR/gdbinit .gdbinit && \
     sed -i.orig -e "s!<path.*>!$PP_SRC_DIR!" $PP_SRC_DIR/gdbinit

