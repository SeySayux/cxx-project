#########################################################################
#
# <<< PROJECT NAME >>> (build script)
# Copyright (C) <<< YEAR >>> <<< YOUR NAME >>> <<< YOUR EMAIL >>>
#
# <<< LICENSE HERE >>>
#
##########################################################################

# <<< PLEASE REMOVE ALL COMMENTS LIKE THESE WHEN CREATING A NEW PROJECT! >>>
cmake_minimum_required(VERSION 2.8.11)
project(hello) # <<< EDIT THIS >>>

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake")

set(PROJECT_NAME ${CMAKE_PROJECT_NAME}) # <<< EDIT THIS WHEN DIFFERENT >>>

# C++11 support
include(EnableCxx11)

# <<< UNCOMMENT THESE WHEN USING QT >>>
# Qt
# find_package(Qt5Widgets REQUIRED)
# set(CMAKE_AUTOMOC ON)
# set(CMAKE_INCLUDE_CURRENT_DIR ON)

# <<< UNCOMMENT THESE WHEN USING AUTOCPACK >>>
# CPack
# include(CPackSettings.cmake)
# include(AutoCPack)

add_subdirectory(src)
add_subdirectory(deps/gtest EXCLUDE_FROM_ALL)
add_subdirectory(test)
