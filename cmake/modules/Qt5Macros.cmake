# This file is included by FindQt5.cmake, don't include it directly.

# Copyright (C) 2001-2009 Kitware, Inc.
# Copyright (C) 2011 Collabora Ltd. <http://www.collabora.co.uk/>
# Copyright (C) 2011 Nokia Corporation
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

MACRO (QT5_GET_MOC_FLAGS _moc_flags)
  SET(${_moc_flags})
  GET_DIRECTORY_PROPERTY(_inc_DIRS INCLUDE_DIRECTORIES)

  FOREACH(_current ${_inc_DIRS})
    IF("${_current}" MATCHES "\\.framework/?$")
      STRING(REGEX REPLACE "/[^/]+\\.framework" "" framework_path "${_current}")
      SET(${_moc_flags} ${${_moc_flags}} "-F${framework_path}")
    ELSE()
      SET(${_moc_flags} ${${_moc_flags}} "-I${_current}")
    ENDIF()
  ENDFOREACH()

  GET_DIRECTORY_PROPERTY(_defines COMPILE_DEFINITIONS)
  FOREACH(_current ${_defines})
    SET(${_moc_flags} ${${_moc_flags}} "-D${_current}")
  ENDFOREACH()

  IF(Q_WS_WIN)
    SET(${_moc_flags} ${${_moc_flags}} -DWIN32)
  ENDIF()

ENDMACRO ()

# helper macro to set up a moc rule
MACRO (QT5_CREATE_MOC_COMMAND infile outfile moc_flags moc_options)
  # For Windows, create a parameters file to work around command line length limit
  IF (WIN32)
    # Pass the parameters in a file.  Set the working directory to
    # be that containing the parameters file and reference it by
    # just the file name.  This is necessary because the moc tool on
    # MinGW builds does not seem to handle spaces in the path to the
    # file given with the @ syntax.
    GET_FILENAME_COMPONENT(_moc_outfile_name "${outfile}" NAME)
    GET_FILENAME_COMPONENT(_moc_outfile_dir "${outfile}" PATH)
    IF(_moc_outfile_dir)
      SET(_moc_working_dir WORKING_DIRECTORY ${_moc_outfile_dir})
    ENDIF()
    SET (_moc_parameters_file ${outfile}_parameters)
    SET (_moc_parameters ${moc_flags} ${moc_options} -o "${outfile}" "${infile}")
    STRING (REPLACE ";" "\n" _moc_parameters "${_moc_parameters}")
    FILE (WRITE ${_moc_parameters_file} "${_moc_parameters}")
    ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
                       COMMAND ${QT_MOC_EXECUTABLE} @${_moc_outfile_name}_parameters
                       DEPENDS ${infile}
                       ${_moc_working_dir}
                       VERBATIM)
  ELSE ()
    ADD_CUSTOM_COMMAND(OUTPUT ${outfile}
                       COMMAND ${QT_MOC_EXECUTABLE}
                       ARGS ${moc_flags} ${moc_options} -o ${outfile} ${infile}
                       DEPENDS ${infile})
  ENDIF ()
ENDMACRO ()
