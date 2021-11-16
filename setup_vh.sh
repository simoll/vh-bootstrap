GITHUB=https://github.com

DIR=$(dirname $(readlink -f $0))

# Prepare environment
PREIFX=${HOME}/install
mkdir -p ${PREFIX}

CMAKE_SRC=${DIR}/cmake-crt
NINJA_SRC=${DIR}/cmake-crt
LLVM_SRC=${DIR}/cmake-crt

# CMake
git clone ${GITHUB}/KitWare/CMake.git -b release ${CMAKE_SRC}
mkdir -p ${CMAKE_SRC}/build
cd ${CMAKE_SRC}/build && ./bootstrap -DCMAKE_INSTALL_PREFIX=${PREFIX} && make && make install


# Ninja

git clone ${GITHUB}/llvm/llvm-project.git -b release/12.x



# Finalize setup
INIT_SCRIPT=${HOME}/.prefix.sh

cat > ${INIT_SCRIPT} << EOF
export PATH=${PREFIX}/install/bin:${PATH}
export LD_LIBRARY_PATH=${PREFIX}/install/bilib:${LD_LIBRARY_PATH}
EOF
