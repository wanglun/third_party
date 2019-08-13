#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUTPUT=${DIR}/output
CORES=4

ZLIB_TAR=${DIR}/zlib-1.2.11.tar.gz
ZLIB_DIR=${DIR}/zlib-1.2.11

MINIZIP_TAR=${DIR}/minizip-2.7.3.tar.gz
MINIZIP_DIR=${DIR}/minizip-2.7.3

GFLAGS_TAR=${DIR}/gflags-2.2.1.tar.gz
GFLAGS_DIR=${DIR}/gflags-2.2.1

GLOG_TAR=${DIR}/glog-0.3.5.tar.gz
GLOG_DIR=${DIR}/glog-0.3.5

PROTOBUF_TAR=${DIR}/protobuf-2.5.0.tar.gz
PROTOBUF_DIR=${DIR}/protobuf-2.5.0

LEVELDB_TAR=${DIR}/leveldb-1.20.tar.gz
LEVELDB_DIR=${DIR}/leveldb-1.20

GTEST15_TAR=${DIR}/gtest-1.5.0.tar.gz
GTEST15_DIR=${DIR}/googletest-release-1.5.0

GTEST_TAR=${DIR}/gtest-1.8.0.tar.gz
GTEST_DIR=${DIR}/googletest-release-1.8.0

RAPIDJSON_TAR=${DIR}/rapidjson-1.1.0.tar.gz
RAPIDJSON_DIR=${DIR}/rapidjson-1.1.0

BRPC_TAR=${DIR}/brpc-0.9.5.tar.gz
BRPC_DIR=${DIR}/brpc-0.9.5

OPENSSL_TAR=${DIR}/openssl-1.1.1.tar.gz
OPENSSL_DIR=${DIR}/openssl-1.1.1

BOOST_TAR=${DIR}/boost_1_68_0.tar.gz
BOOST_DIR=${DIR}/boost_1_68_0

mkdir -p ${OUTPUT}

function build_zlib() {
	tar xzf ${ZLIB_TAR} -C ${DIR}
	cd ${ZLIB_DIR} && mkdir -p build && cd build
	cmake .. -DBUILD_SHARED_LIBS=1 -DBUILD_STATIC_LIBS=1 -DCMAKE_INSTALL_PREFIX=${OUTPUT}
	make -j${CORES} && make install
}

function build_minizip() {
	tar xzf ${MINIZIP_TAR} -C ${DIR}
	cd ${MINIZIP_DIR} && mkdir -p build && cd build
	cmake .. -DBUILD_SHARED_LIBS=0 -DBUILD_STATIC_LIBS=1 -DCMAKE_INSTALL_PREFIX=${OUTPUT} -DUSE_BZIP2=OFF
	make -j${CORES} && make install
}

function build_gflags() {
	tar xzf ${GFLAGS_TAR} -C ${DIR}
	cd ${GFLAGS_DIR} && mkdir -p build && cd build
	cmake .. -DBUILD_SHARED_LIBS=1 -DBUILD_STATIC_LIBS=1 -DCMAKE_INSTALL_PREFIX=${OUTPUT}
	make -j${CORES} && make install
}

function build_glog() {
	tar xzf ${GLOG_TAR} -C ${DIR}
	cd ${GLOG_DIR} && mkdir -p build && cd build
	cmake .. -DBUILD_SHARED_LIBS=0 -DBUILD_STATIC_LIBS=1 -DCMAKE_INSTALL_PREFIX=${OUTPUT}
	make -j${CORES} && make install
}

function build_gtest() {
	tar xzf ${GTEST_TAR} -C ${DIR}
	cd ${GTEST_DIR} && mkdir -p build && cd build
	cmake .. -DBUILD_SHARED_LIBS=0 -DBUILD_STATIC_LIBS=1 -DCMAKE_INSTALL_PREFIX=${OUTPUT}
	make -j${CORES} && make install
}

function build_protobuf() {
	tar xzf ${PROTOBUF_TAR} -C ${DIR}
	tar xzf ${GTEST15_TAR} -C ${DIR}
	cd ${PROTOBUF_DIR} && cp -a ${GTEST15_DIR} ./gtest
	./autogen.sh && ./configure --prefix=${OUTPUT} --with-zlib && make -j${CORES} && make install
}

function build_leveldb() {
	tar xzf ${LEVELDB_TAR} -C ${DIR}
	cd ${LEVELDB_DIR} && ./build_detect_platform configs . && make
	cp -a include/* ${OUTPUT}/include && cp -a out-static/libleveldb.a ${OUTPUT}/lib && cp -a out-shared/libleveldb.so* ${OUTPUT}/lib
}

function build_openssl() {
	tar xzf ${OPENSSL_TAR} -C ${DIR}
	cd ${OPENSSL_DIR} && ./config --prefix=${OUTPUT} --openssldir=${OUTPUT}/ssl && make -j${CORES} && make install
}

function build_rapidjson() {
	tar xzf ${RAPIDJSON_TAR} -C ${DIR}
	cd ${RAPIDJSON_DIR} && cp -a include/* ${OUTPUT}/include/
}

function build_brpc() {
	tar xzf ${BRPC_TAR} -C ${DIR}
	cd ${BRPC_DIR} && mkdir -p build && cd build
	cmake .. -DCMAKE_PREFIX_PATH=${OUTPUT} -DBUILD_SHARED_LIBS=0 -DBUILD_STATIC_LIBS=1 -DCMAKE_INSTALL_PREFIX=${OUTPUT} && make -j${CORES} && make install
}

function main() {
	build_zlib
	build_minizip
	build_gflags
	build_glog
	build_gtest
	build_protobuf
	build_leveldb
	build_openssl
	build_rapidjson
	build_brpc
}

main
