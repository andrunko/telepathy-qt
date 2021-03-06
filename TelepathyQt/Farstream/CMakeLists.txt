if(FARSTREAM_COMPONENTS_FOUND)
    include_directories(${TELEPATHY_FARSTREAM_INCLUDE_DIR}
                        ${TELEPATHY_GLIB_INCLUDE_DIR}
                        ${FARSTREAM_INCLUDE_DIR}
                        ${GSTREAMER_INCLUDE_DIRS}
                        ${GLIB2_INCLUDE_DIR}
                        ${LIBXML2_INCLUDE_DIR}
                        ${DBUS_GLIB_INCLUDE_DIR}
                        ${DBUS_INCLUDE_DIR})

    set(telepathy_qt_farstream_SRCS
        channel.cpp)

    set(telepathy_qt_farstream_HEADERS
        Channel
        channel.h
        Global
        global.h
        PendingChannel)

    set(telepathy_qt_farstream_MOC_SRCS
        channel.h)

    # generate client moc files
    tpqt_generate_mocs(${telepathy_qt_farstream_MOC_SRCS})

    # Create the library
    if (ENABLE_COMPILER_COVERAGE)
        add_library(telepathy-qt${QT_VERSION_MAJOR}-farstream STATIC
                    ${telepathy_qt_farstream_SRCS} ${telepathy_qt_farstream_MOC_SRCS})
    else ()
        add_library(telepathy-qt${QT_VERSION_MAJOR}-farstream SHARED
                    ${telepathy_qt_farstream_SRCS} ${telepathy_qt_farstream_MOC_SRCS})
    endif ()
    add_library(TelepathyQt${QT_VERSION_MAJOR}::Farstream ALIAS telepathy-qt${QT_VERSION_MAJOR}-farstream)

    # We are building Telepathy-Qt-Farstream
    target_compile_definitions(telepathy-qt${QT_VERSION_MAJOR}-farstream PRIVATE
        BUILDING_TP_QT_FARSTREAM
        QT_NO_KEYWORDS)

    # Link
    target_link_libraries(telepathy-qt${QT_VERSION_MAJOR}-farstream
        Qt5::Core
        Qt5::DBus
        ${GOBJECT_LIBRARIES}
        ${GLIB2_LIBRARIES}
        ${TELEPATHY_FARSTREAM_LIBRARIES}
        ${TELEPATHY_GLIB_LIBRARIES}
        telepathy-qt${QT_VERSION_MAJOR}
        ${TP_QT_LIBRARY_LINKER_FLAGS})

    if (ENABLE_COMPILER_COVERAGE)
        target_link_libraries(telepathy-qt${QT_VERSION_MAJOR}-farstream gcov)
    endif ()

    # Set the correct version number
    set_target_properties(telepathy-qt${QT_VERSION_MAJOR}-farstream PROPERTIES
                                                       EXPORT_NAME Farstream
                                                       SOVERSION ${TP_QT_ABI_VERSION}
                                                       VERSION ${TP_QT_LIBRARY_VERSION})

    # Install the library
    install(TARGETS telepathy-qt${QT_VERSION_MAJOR}-farstream
            EXPORT TelepathyQt${QT_VERSION_MAJOR}Targets
            RUNTIME DESTINATION ${LIB_INSTALL_DIR} COMPONENT farstream
            LIBRARY DESTINATION ${LIB_INSTALL_DIR} COMPONENT farstream
            ARCHIVE DESTINATION ${LIB_INSTALL_DIR} COMPONENT farstream_libs)

    # Install headers
    install(FILES ${telepathy_qt_farstream_HEADERS}
            DESTINATION ${INCLUDE_INSTALL_DIR}/telepathy-qt${QT_VERSION_MAJOR}/TelepathyQt/Farstream
            COMPONENT farstream_headers)

    # pkg-config files, only if not on windows
    if (NOT WIN32)
        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/TelepathyQtFarstream.pc.in
                       ${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}Farstream.pc)
        configure_file(${CMAKE_CURRENT_SOURCE_DIR}/TelepathyQtFarstream-uninstalled.pc.in
                       ${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}Farstream-uninstalled.pc)
        install(FILES ${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}Farstream.pc
                DESTINATION ${LIB_INSTALL_DIR}/pkgconfig COMPONENT pkgconfig)
    endif ()

    set(_TelepathyQtFarstreamConfig_INSTALL_DIR ${LIB_INSTALL_DIR}/cmake/TelepathyQt${QT_VERSION_MAJOR}Farstream)

    # Configure the actual Config file
    configure_package_config_file(TelepathyQtFarstreamConfig.cmake.in
        "${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}FarstreamConfig.cmake"
        INSTALL_DESTINATION ${_TelepathyQtFarstreamConfig_INSTALL_DIR}
        PATH_VARS CMAKE_INSTALL_PREFIX INCLUDE_INSTALL_DIR LIB_INSTALL_DIR
        NO_CHECK_REQUIRED_COMPONENTS_MACRO)

    # this file is used by to check if the installed version can be used.
    write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}FarstreamConfigVersion.cmake
                                     VERSION ${PACKAGE_VERSION} COMPATIBILITY SameMajorVersion)

    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}FarstreamConfigVersion.cmake
                  ${CMAKE_CURRENT_BINARY_DIR}/TelepathyQt${QT_VERSION_MAJOR}FarstreamConfig.cmake
            DESTINATION ${_TelepathyQtFarstreamConfig_INSTALL_DIR}
            COMPONENT headers)

endif()
