#########################################################################
#
# <<< PROJECT NAME >>> (build script)
# Copyright (C) <<< YEAR >>> <<< YOUR NAME >>> <<< YOUR EMAIL >>>
#
# <<< LICENSE HERE >>>
#
##########################################################################

# Disable warning about 'test' target being used for CTest
cmake_policy(SET CMP0037 OLD)

include_directories(
    ${CMAKE_SOURCE_DIR}/src
    ${gtest_SOURCE_DIR}/include
)

link_directories(
    ${CMAKE_BINARY_DIR}/src
    ${gtest_BINARY_DIR}
)

add_executable(TestSuite
    main.cpp
)

# <<< ALSO LINK YOUR CORE LIBRARY HERE >>>
target_link_libraries(TestSuite gtest)

add_custom_target(test TestSuite DEPENDS TestSuite)

