cmake_minimum_required(VERSION 3.10)
project(tp1 VERSION 2023.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 11)

#set(OpenGL_GL_PREFERENCE "GLVND")
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

set(TP_TARGETS "")

add_executable(helloteapot helloteapot.cpp)
list(APPEND TP_TARGETS "helloteapot")

# Uncomment the following lines to build helloteapot2 once you have added the cpp files
 add_executable(helloteapot2 helloteapot2.cpp)
list(APPEND TP_TARGETS "helloteapot2")

add_executable(moreteapots moreteapots.cpp)
list(APPEND TP_TARGETS "moreteapots")

# Uncomment the following lines to build navigator once you have added the cpp files
add_executable(navigator navigator.cpp)
list(APPEND TP_TARGETS "navigator")

foreach(TARGET IN LISTS TP_TARGETS)
    target_include_directories(${TARGET} PUBLIC ${OPENGL_INCLUDE_DIR} ${GLUT_INCLUDE_DIR})
    #target_link_libraries(${TARGET} PUBLIC ${OPENGL_opengl_LIBRARY} ${OPENGL_glu_LIBRARY} ${GLUT_LIBRARIES})
    target_link_libraries(${TARGET} PUBLIC OpenGL::GL OpenGL::GLU ${GLUT_LIBRARIES})
    target_compile_options(${TARGET} PRIVATE ${MY_COMPILE_OPTIONS})
    if(MSVC)
        target_compile_definitions(${TARGET} PUBLIC -DNOMINMAX)
    endif()
endforeach()
