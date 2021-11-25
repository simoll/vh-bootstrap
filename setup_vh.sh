GITHUB=https://github.com

DIR=$(dirname $(readlink -f $0))

# Prepare environment
PREFIX=${HOME}/install
mkdir -p ${PREFIX}

CMAKE_SRC=${DIR}/cmake-src
NINJA_SRC=${DIR}/ninja-src
LLVM_SRC=${DIR}/llvm-project

# CMake
git clone ${GITHUB}/KitWare/CMake.git -b release ${CMAKE_SRC}
mkdir -p ${CMAKE_SRC}/build
cd ${CMAKE_SRC}/build && ../bootstrap --prefix=${PREFIX} && make && make install
CMAKE=${PREFIX}/bin/cmake

# Ninja
git clone ${GITHUB}/ninja-build/ninja -b release ${NINJA_SRC}
mkdir -p ${NINJA_SRC}/build
cd ${NINJA_SRC}/build && ${CMAKE} -DCMAKE_INSTALL_PREFIX=${PREFIX} ../ && make && make install
NINJA=${PREFIX}/bin/ninja


# LLVM
git clone ${GITHUB}/llvm/llvm-project.git -b release/12.x ${LLVM_SRC}
LLVM_BUILD=${DIR}/build_llvm
mkdir -p ${LLVM_BUILD}
cd ${LLVM_BUILD} && ${CMAKE} -G Ninja ${LLVM_SRC}/llvm \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_OPTIMIZED_TABLEGEN=Yes \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DCMAKE_CXX_FLAGS="-O3 -DNDEBUG -march=native" \
    -DCMAKE_C_FLAGS="-O3 -DNDEBUG -march=native" \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DCLANG_DEFAULT_LINKER="lld"

cd ${LLVM_BUILD} && ${NINJA}
cd ${LLVM_BUILD} && ${NINJA} install




# Finalize setup
INIT_SCRIPT=${HOME}/.prefix.sh

cat > ${INIT_SCRIPT} << EOF
export PATH=${PREFIX}/bin:${PATH}
export LD_LIBRARY_PATH=${PREFIX}/lib:${LD_LIBRARY_PATH}
export CC=${PREFIX}/bin/clang
export CXX=${PREFIX}/bin/clang++
EOF
