#########################################################################
#
# EnableCxx11.cmake (build script)
# Copyright (C) 2015 Frank Erens <frank@synthi.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
#########################################################################

# Flags to enable C++11
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # Clang
    set(CMAKE_CXX_FLAGS
        "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++" )
    set(CMAKE_EXE_LINKER_FLAGS
        "-std=c++11 -stdlib=libc++")
    set(CMAKE_SHARED_LINKER_FLAGS
        "-std=c++11 -stdlib=libc++")
    set(CMAKE_MODULE_LINKER_FLAGS
        "-std=c++11 -stdlib=libc++")
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    # GCC >= 4.5.3
    if(CMAKE_CXX_COMPILER_VERSION STRGREATER "4.7./")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    else(CMAKE_CXX_COMPILER_VERSION STRGREATER "4.5.2")
            set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
    endif()
endif()
