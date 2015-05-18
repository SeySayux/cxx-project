#########################################################################
#
# <<< PROJECT NAME >>> (build script)
# Copyright (C) <<< YEAR >>> <<< YOUR NAME >>> <<< YOUR EMAIL >>>
#
# <<< LICENSE HERE >>>
#
##########################################################################

# <<< UNCOMMENT THESE WHEN USING AUTOCPACK >>>
add_executable(${PROJECT_NAME} # WIN32 MACOSX_BUNDLE
    main.cpp

    # ${AUTOCPACK_W32_ICON}
)

target_link_libraries(${PROJECT_NAME}
)

# <<< UNCOMMENT THIS WHEN USING AUTOCPACK >>>
# auto_cpack_deploy(${PROJECT_NAME})
