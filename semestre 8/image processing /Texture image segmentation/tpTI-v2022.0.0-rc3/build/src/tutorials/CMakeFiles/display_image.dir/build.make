# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.25

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /opt/homebrew/Cellar/cmake/3.25.2/bin/cmake

# The command to remove a file.
RM = /opt/homebrew/Cellar/cmake/3.25.2/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build"

# Include any dependencies generated for this target.
include src/tutorials/CMakeFiles/display_image.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include src/tutorials/CMakeFiles/display_image.dir/compiler_depend.make

# Include the progress variables for this target.
include src/tutorials/CMakeFiles/display_image.dir/progress.make

# Include the compile flags for this target's objects.
include src/tutorials/CMakeFiles/display_image.dir/flags.make

src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.o: src/tutorials/CMakeFiles/display_image.dir/flags.make
src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.o: /Users/clementinegrethen/Documents/Enseeiht/enseeiht\ 2nd\ year/semestre\ 8/image\ processing\ /Texture\ image\ segmentation/tpTI-v2022.0.0-rc3/src/tutorials/display_image.cpp
src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.o: src/tutorials/CMakeFiles/display_image.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.o"
	cd "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials" && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.o -MF CMakeFiles/display_image.dir/display_image.cpp.o.d -o CMakeFiles/display_image.dir/display_image.cpp.o -c "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/src/tutorials/display_image.cpp"

src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/display_image.dir/display_image.cpp.i"
	cd "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials" && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/src/tutorials/display_image.cpp" > CMakeFiles/display_image.dir/display_image.cpp.i

src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/display_image.dir/display_image.cpp.s"
	cd "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials" && /Library/Developer/CommandLineTools/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/src/tutorials/display_image.cpp" -o CMakeFiles/display_image.dir/display_image.cpp.s

# Object files for target display_image
display_image_OBJECTS = \
"CMakeFiles/display_image.dir/display_image.cpp.o"

# External object files for target display_image
display_image_EXTERNAL_OBJECTS =

bin/display_image: src/tutorials/CMakeFiles/display_image.dir/display_image.cpp.o
bin/display_image: src/tutorials/CMakeFiles/display_image.dir/build.make
bin/display_image: /usr/local/lib/libopencv_gapi.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_highgui.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_ml.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_objdetect.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_photo.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_stitching.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_video.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_videoio.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_imgcodecs.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_dnn.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_calib3d.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_features2d.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_flann.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_imgproc.4.7.0.dylib
bin/display_image: /usr/local/lib/libopencv_core.4.7.0.dylib
bin/display_image: src/tutorials/CMakeFiles/display_image.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable ../../bin/display_image"
	cd "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials" && $(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/display_image.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
src/tutorials/CMakeFiles/display_image.dir/build: bin/display_image
.PHONY : src/tutorials/CMakeFiles/display_image.dir/build

src/tutorials/CMakeFiles/display_image.dir/clean:
	cd "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials" && $(CMAKE_COMMAND) -P CMakeFiles/display_image.dir/cmake_clean.cmake
.PHONY : src/tutorials/CMakeFiles/display_image.dir/clean

src/tutorials/CMakeFiles/display_image.dir/depend:
	cd "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3" "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/src/tutorials" "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build" "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials" "/Users/clementinegrethen/Documents/Enseeiht/enseeiht 2nd year/semestre 8/image processing /Texture image segmentation/tpTI-v2022.0.0-rc3/build/src/tutorials/CMakeFiles/display_image.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : src/tutorials/CMakeFiles/display_image.dir/depend

