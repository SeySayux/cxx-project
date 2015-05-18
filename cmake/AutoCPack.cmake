#########################################################################
#
# AutoCPack.cmake (build script)
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

# Set up global variables
if(NOT DEFINED CPACK_PACKAGE_VERSION)
    set(CPACK_PACKAGE_VERSION
        "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
endif()

set(CPACK_PACKAGE_FILE_NAME
    "${AUTOCPACK_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")

if(WIN32)
    set(CPACK_NSIS_DISPLAY_NAME "${AUTOCPACK_PROJECT_NAME}")
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "${AUTOCPACK_PROJECT_NAME}")
    set(CPACK_GENERATOR "NSIS")
elseif(APPLE)
    set(CPACK_DMG_VOLUME_NAME "${AUTOCPACK_PROJECT_NAME}")
    set(CPACK_GENERATOR "DragNDrop")
endif()

# Qt doesn't provide this for us anymore...
set(AUTOCPACK_QT5_PLUGIN_DIR ${_qt5Core_install_prefix}/plugins)
if(WIN32)
    set(AUTOCPACK_QT5_LIBRARY_DIR ${_qt5Core_install_prefix}/bin)
else()
    set(AUTOCPACK_QT5_LIBRARY_DIR ${_qt5Core_install_prefix}/lib)
endif()

# Include main CPack module
include(CPack)

# Macro to run deployment procedure on target
macro(auto_cpack_deploy target)

    # Set up per-target variables
    if(WIN32)
        set(CPACK_NSIS_INSTALLED_ICON_NAME ${target}.exe)
        set(CPACK_NSIS_CREATE_ICONS "CreateShortCut '\$SMPROGRAMS\\\\$STARTMENU_FOLDER\\\\${CPACK_PACKAGE_DESCRIPTION_SUMMARY}.lnk' '\$INSTDIR\\\\${target}.exe'")

        set(AUTOCPACK_BINARY_DEST ".")
        set(AUTOCPACK_RESOURCE_DEST "data")
        set(AUTOCPACK_LIBRARY_DEST ".")
        set(AUTOCPACK_QT_PLUGIN_DEST_DIR "plugins")
        set(AUTOCPACK_QT_CONFIG_DEST_DIR ".")

    elseif(APPLE)
        set(AUTOCPACK_BUNDLE_ROOT "${target}.app/Contents")

        set(AUTOCPACK_BINARY_DEST ".")
        set(AUTOCPACK_RESOURCE_DEST "${AUTOCPACK_BUNDLE_ROOT}/Resources")
        set(AUTOCPACK_LIBRARY_DEST "${AUTOCPACK_BUNDLE_ROOT}/Frameworks")
        set(AUTOCPACK_QT_PLUGIN_DEST_DIR "${AUTOCPACK_BUNDLE_ROOT}/plugins")
        set(AUTOCPACK_QT_CONFIG_DEST_DIR "${AUTOCPACK_RESOURCE_DEST}")
    endif()

    # Setup OS X plist
    if(APPLE AND DEFINED AUTOCPACK_OSX_PLIST_PATH)
        if(${AUTOCPACK_OSX_PLIST_PATH} MATCHES "\\.in$")
            set(_acp_plist ${CMAKE_BINARY_DIR}/Info.plist)
            configure_file(${AUTOCPACK_OSX_PLIST_PATH} ${_acp_plist})
        else()
            set(_acp_plist ${AUTOCPACK_OSX_PLIST_PATH})
        endif()

        set_target_properties(${target} PROPERTIES
            MACOSX_BUNDLE_INFO_PLIST ${_acp_plist})
    endif()

    # Installation
    install(TARGETS ${target}
        RUNTIME DESTINATION ${AUTOCPACK_BINARY_DEST}
        BUNDLE DESTINATION ${AUTOCPACK_BINARY_DEST})

    if(APPLE AND DEFINED AUTOCPACK_OSX_ICONS)
        install(FILES ${AUTOCPACK_OSX_ICONS}
            DESTINATION ${AUTOCPACK_RESOURCE_DEST})
    endif()

    # Check for Qt
    set(_use_qt off)

    get_target_property(_linked_libs Synthesis INTERFACE_LINK_LIBRARIES)

    foreach(_lib ${_linked_libs})
        get_target_property(_libs ${_lib} INTERFACE_LINK_LIBRARIES)
        set(_linked_libs ${_linked_libs} ${_libs})
    endforeach()

    # Install Qt plugins
    foreach(_lib ${_linked_libs})
    if("${_lib}" MATCHES "^Qt5")
        set(_use_qt on)

        string(REPLACE "::" "" _target ${_lib})
        foreach(_plugin ${${_target}_PLUGINS})
            get_target_property(_loc ${_plugin} LOCATION)
            string(REGEX MATCH "[a-zA-Z0-9]+/[^/]+$" _relloc ${_loc})
            string(REGEX MATCH "^[a-zA-Z0-9]+" _dirname ${_relloc})

            message("${_loc}")
            install(FILES "${_loc}"
                DESTINATION "${AUTOCPACK_QT_PLUGIN_DEST_DIR}/${_dirname}"
                COMPONENT Runtime)
        endforeach()
    endif()
    endforeach()

    # Install qt.conf file
    if(${_use_qt})
    install(CODE "
        file(WRITE
            \"\${CMAKE_INSTALL_PREFIX}/${AUTOCPACK_QT_CONFIG_DEST_DIR}/qt.conf\"
            \"[Paths]\nPlugins = plugins\")
        " COMPONENT Runtime)
    endif()

    # Deployment
    if(WIN32)
        set(EXECUTABLE_SUFFIX ".exe")
    elseif(APPLE)
        set(EXECUTABLE_SUFFIX ".app")
    endif()

    install(CODE "
        file(GLOB_RECURSE QTPLUGINS
            \"\${CMAKE_INSTALL_PREFIX}/${AUTOCPACK_QT_PLUGIN_DEST_DIR}/*${CMAKE_SHARED_LIBRARY_SUFFIX}\")
        include(BundleUtilities)
        fixup_bundle(\${CMAKE_INSTALL_PREFIX}/${target}${EXECUTABLE_SUFFIX}
            \"\${QTPLUGINS}\"
            \"${AUTOCPACK_QT5_LIBRARY_DIR}\")
        " COMPONENT RUNTIME)
endmacro()

