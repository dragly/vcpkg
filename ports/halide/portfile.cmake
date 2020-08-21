vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO halide/Halide
    REF 2e7b5ac9c19c5c06744732a0a74736372f3c0691
    SHA512 889a6ac36d22a82814b9cafa349c43ff00e294d9ec0970435e0337204881632d6e843118f25b4005d4cf5686cd2aeaa30063a2bb75106c3b752f8cc841d6b9f0
    HEAD_REF master
)

set(TARGET_X86 OFF)
set(TARGET_ARM OFF)
set(TARGET_AARCH64 OFF)
if (VCPKG_TARGET_ARCHITECTURE STREQUAL x86 OR VCPKG_TARGET_ARCHITECTURE STREQUAL x64)
    # llvm x86 components are required for llvm x64
    set(TARGET_X86 ON)
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL arm)
    set(TARGET_X86 OFF)
    if (TARGET_TRIPLET STREQUAL arm64)
        set(TARGET_AARCH64 ON)
    else()
        set(TARGET_ARM ON)
    endif()
endif()

if (VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    set(HALIDE_SHARED_LIBRARY ON)
else()
    set(HALIDE_SHARED_LIBRARY OFF)
endif()

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    app WITH_APPS
    test WITH_TESTS
    tutorials WITH_TUTORIALS
    docs WITH_DOCS
    utils WITH_UTILS
    python WITH_PYTHON_BINDINGS
    nativeclient TARGET_NATIVE_CLIENT
    hexagon TARGET_HEXAGON
    metal TARGET_METAL
    mips TARGET_MIPS
    powerpc TARGET_POWERPC
    ptx TARGET_PTX
    opencl TARGET_OPENCL
    opengl TARGET_OPENGL
    opengl TARGET_OPENGLCOMPUTE
    rtti HALIDE_ENABLE_RTTI
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS ${FEATURE_OPTIONS}
        -DTRIPLET_SYSTEM_ARCH=${TRIPLET_SYSTEM_ARCH}
        -DHALIDE_SHARED_LIBRARY=${HALIDE_SHARED_LIBRARY}
        -DTARGET_X86=${TARGET_X86}
        -DTARGET_ARM=${TARGET_ARM}
        -DTARGET_AARCH64=${TARGET_AARCH64}
        #-DTARGET_AMDGPU
        -DWARNINGS_AS_ERRORS=OFF
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/Halide)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)
#file(RENAME ${CURRENT_PACKAGES_DIR}/share/${PORT}/halide_config.cmake ${CURRENT_PACKAGES_DIR}/share/${PORT}/halide-config.cmake)
#file(RENAME ${CURRENT_PACKAGES_DIR}/share/${PORT}/halide_config.make ${CURRENT_PACKAGES_DIR}/share/${PORT}/halide-config.make)