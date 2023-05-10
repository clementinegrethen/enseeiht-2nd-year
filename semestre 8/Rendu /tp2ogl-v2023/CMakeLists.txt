cmake_minimum_required(VERSION 3.10)
project(tp2 VERSION 2023.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

include(CheckIPOSupported)
check_ipo_supported(RESULT result)
message(STATUS "IPO supported: ${result}")
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ${result})

set(OpenGL_GL_PREFERENCE "GLVND")
find_package(OpenGL REQUIRED)
message(STATUS "OPENGL_gl_LIBRARY: ${OPENGL_gl_LIBRARY}")

if(MSVC)
    set(GLUT_ROOT_PATH "${CMAKE_SOURCE_DIR}/freeglut")
    message(STATUS "GLUT_ROOT_PATH: ${GLUT_ROOT_PATH}")
endif()
find_package(GLUT REQUIRED)
message(STATUS "GLUT_FOUND: ${GLUT_FOUND}")
message(STATUS "GLUT_INCLUDE_DIR: ${GLUT_INCLUDE_DIR}")
message(STATUS "GLUT_LIBRARIES: ${GLUT_LIBRARIES}")

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    set(MY_COMPILE_OPTIONS "-Wall;-Wextra;-pedantic;-Wno-comment;-Wshadow;-Wnon-virtual-dtor;-Wpedantic;-Wconversion;-Wmisleading-indentation;-Wsign-conversion")
elseif(MSVC)
    set(MY_COMPILE_OPTIONS "/W4;/permissive-")
endif()

if(APPLE)
    list(APPEND MY_COMPILE_OPTIONS "-Wno-deprecated-declarations")
endif()


add_executable(robot robot.cpp)
#target_include_directories(robot PUBLIC ${OPENGL_INCLUDE_DIR} ${GLUT_INCLUDE_DIR})
#target_link_libraries(robot PUBLIC ${OPENGL_opengl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLUT_LIBRARIES})
target_link_libraries(robot OpenGL::GL OpenGL::GLU GLUT::GLUT)

target_compile_options(robot PRIVATE ${MY_COMPILE_OPTIONS})

if(MSVC)
    target_compile_definitions(robot PUBLIC -DNOMINMAX)
endif()
