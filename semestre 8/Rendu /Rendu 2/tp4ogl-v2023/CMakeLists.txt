cmake_minimum_required(VERSION 3.10)

project( tp4 LANGUAGES CXX VERSION 2023.1.0)

option(BUILD_TESTS "Build tests" OFF)
option(BUILD_SHARED_LIBS "Build shared libs" ON)
option(ENABLE_WARNINGS_AS_ERRORS "Treat warnings as errors" OFF)

if(BUILD_SHARED_LIBS)
    if(WIN32)
        # export all symbols on a windows build of dynamic libs
        set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS  ON)
    endif()
endif()

#include(CheckIPOSupported)
#check_ipo_supported(RESULT result)
#message(STATUS "IPO supported: ${result}")
#set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ${result})

# compile options for all targets depending on the compiler and the system
if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(MY_COMPILE_OPTIONS "-Wall;-Wextra;-pedantic;-Wno-comment;-Wshadow;-Wnon-virtual-dtor;-Wpedantic;-Wconversion;-Wmisleading-indentation;-Wsign-conversion;-Wfloat-equal")
    if(ENABLE_WARNINGS_AS_ERRORS)
        list(APPEND MY_COMPILE_OPTIONS "-Werror")
    endif()
elseif(MSVC)
    set(MY_COMPILE_OPTIONS "/W4;/permissive-")
    if(ENABLE_WARNINGS_AS_ERRORS)
        list(APPEND MY_COMPILE_OPTIONS "/WX")
    endif()
endif()
if(APPLE)
    list(APPEND MY_COMPILE_OPTIONS "-Wno-deprecated-declarations")
endif()

# compile definitions for all targets depending on the compiler and the system
set(MY_COMPILE_DEFINITIONS "")
if(MSVC)
    set(MY_COMPILE_DEFINITIONS "-DNOMINMAX;-D_USE_MATH_DEFINES")
endif()

#########################################################
#
# EXTERNAL LIBRARIES
#
#########################################################

#########################################################
# FIND OPENGL
#########################################################
set(OpenGL_GL_PREFERENCE "GLVND")
find_package(OpenGL REQUIRED)
message(STATUS "OPENGL_gl_LIBRARY: ${OPENGL_gl_LIBRARY}")

#########################################################
# FIND GLUT
#########################################################
if(MSVC)
    set(GLUT_ROOT_PATH "${CMAKE_SOURCE_DIR}/freeglut")
    message(STATUS "GLUT_ROOT_PATH: ${GLUT_ROOT_PATH}")
endif()
find_package(GLUT REQUIRED)
message(STATUS "GLUT_FOUND: ${GLUT_FOUND}")
message(STATUS "GLUT_INCLUDE_DIR: ${GLUT_INCLUDE_DIR}")
message(STATUS "GLUT_LIBRARIES: ${GLUT_LIBRARIES}")

if(CMAKE_SYSTEM_NAME STREQUAL Linux)
    #########################################################
    # FIND Threads, not used but necessary for linkning on linux
    # funny story, even if it is not used it is needed by other
    # dependencies which do not propagate their dependencies (?)
    #########################################################
    find_package(Threads REQUIRED)
    # this force all libs to be include even if not directly used
    set(CMAKE_EXE_LINKER_FLAGS  "-Wl,--no-as-needed")
endif()

#########################################################
# SET COMPILATION FLAGS FOR C++17
#########################################################
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(RENDERER_INCLUDE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(RENDERER_SOURCES
        src/MeshModel.cpp
        src/MeshModel.hpp
        src/core.cpp
        src/core.hpp
        src/rendering.cpp
        src/rendering.hpp
        src/geometry.cpp
        src/geometry.hpp
        src/loop.cpp
        src/loop.hpp
        src/objReader.cpp
        src/objReader.hpp)
add_library(renderer ${RENDERER_SOURCES})
target_include_directories(renderer PUBLIC $<BUILD_INTERFACE:${RENDERER_INCLUDE_DIR}>)
target_link_libraries( renderer OpenGL::GL OpenGL::GLU GLUT::GLUT )
target_compile_options(renderer PRIVATE ${MY_COMPILE_OPTIONS})
target_compile_definitions(renderer PUBLIC ${MY_COMPILE_DEFINITIONS})
if(CMAKE_SYSTEM_NAME STREQUAL Linux)
    target_link_libraries( renderer ${CMAKE_THREAD_LIBS_INIT} )
endif()


add_executable( visualizer src/main.cpp)
target_link_libraries( visualizer renderer OpenGL::GL OpenGL::GLU GLUT::GLUT )
target_compile_options(visualizer PRIVATE ${MY_COMPILE_OPTIONS})
target_compile_definitions(visualizer PUBLIC ${MY_COMPILE_DEFINITIONS})
if(CMAKE_SYSTEM_NAME STREQUAL Linux)
    target_link_libraries( visualizer ${CMAKE_THREAD_LIBS_INIT} )
endif()

if(BUILD_TESTS)
    find_package(Boost COMPONENTS unit_test_framework REQUIRED)
    enable_testing()
    set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
    include(BoostTestHelper)

    set(TEST_TARGETS "src/tests/test_objReader.cpp;src/tests/test_core.cpp;src/tests/test_geometry.cpp")
    foreach (TEST_TARGET ${TEST_TARGETS})
        add_boost_test(SOURCE ${TEST_TARGET} LINK renderer PREFIX renderer COMPILE_OPTIONS ${MY_COMPILE_OPTIONS} COMPILE_DEFINITIONS ${MY_COMPILE_DEFINITIONS})
    endforeach ()

endif()
