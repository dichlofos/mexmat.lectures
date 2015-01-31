# A part of MMLectures build infrastructure
# Common texify/packing macro definitions
#
# Please make a review of changes that can break it
#
# Author and maintainer: Mikhail Veltishchev <dichlofos-mv@yandex.ru>


macro(mmPicture)
    set (PN "${ARGV0}")
    set (TN "${ARGV1}")
    add_custom_command(OUTPUT
        "generated/${PN}.done"
        COMMAND "${RUN_MPOST}" ${PN}.done ${MPOST} ${MPOST_OPTS} "../${PN}.mp"
        DEPENDS "${PN}.mp"
    )
    add_custom_target("MetaPosing ${PN} for ${TN}" ALL DEPENDS "generated/${PN}.done")
    add_dependencies("Make ${TN}.dvi" "MetaPosing ${PN} for ${TN}")
    set (AUX_CLEAN_FILES
        "${AUX_CLEAN_FILES}"
        "${PN}.log"
        "${PN}.mpx"
    )

endmacro(mmPicture)

macro(mmPictureEx)
    set (PN "${ARGV0}")
    set (TN "${ARGV1}")
    get_filename_component(pic_name_ ${PN} NAME_WE)
    add_custom_command(OUTPUT
        "generated/${PN}.done"
        COMMAND "${RUN_MPOST}" ${PN}.done ${MPOST} ${MPOST_OPTS} "../${PN}"
        DEPENDS "${PN}"
    )
    add_custom_target("MetaPosing ${PN} for ${TN}" ALL DEPENDS "generated/${PN}.done")
    add_dependencies("Make ${TN}.dvi" "MetaPosing ${PN} for ${TN}")
    set (AUX_CLEAN_FILES
        "${AUX_CLEAN_FILES}"
        "${pic_name_}.log"
        "${pic_name_}.mpx"
    )

endmacro()

# DEPRECATED, use mmTexifyEx instead
macro(texify)
    set (FN "${ARGV0}")
    set (RN "${ARGV1}")
    set (PN "${ARGV2}")

    # TODO: change to format
    # texify (SOURCE ..., ..., ... PICTURES ..., ... INCLUDE ...)
    add_custom_command(OUTPUT
        "generated/${FN}.dvi"
        COMMAND "${RUN_LATEX}" ${LATEX} ${LATEX_OPTS} "../${FN}.tex"
        DEPENDS "${FN}.tex"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    add_custom_command(OUTPUT
        "generated/${FN}.ps"
        COMMAND "${RUN_DVIPS}" ${DVIPS} "${FN}.dvi"
        DEPENDS "generated/${FN}.dvi"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    add_custom_command(OUTPUT
        "${FN}.pdf"
        COMMAND "${GS}" ${GS_OPTS} "-sOutputFile=${FN}.pdf" "${FN}.ps"
        DEPENDS "${FN}.ps"
    )
    add_custom_command(OUTPUT
        "${FN}.pdf"
        COMMAND "${GS}" ${GS_OPTS} "-sOutputFile=${FN}.pdf" "${FN}.ps"
        DEPENDS "${FN}.ps"
    )
    add_custom_command(OUTPUT
        "${RN}.rar"
        COMMAND "${RAR}" ${RAR_TEXT_OPTS} "${RN}.rar" "${FN}.ps"
        DEPENDS "${FN}.ps"
    )
    add_custom_command(OUTPUT
        "${RN}-pdf.rar"
        COMMAND "${RAR}" ${RAR_BIN_OPTS} "${RN}-pdf.rar" "${FN}.pdf"
        DEPENDS "${FN}.pdf"
    )
    add_custom_command(OUTPUT
        "${RN}.pdf"
        COMMAND cp "${FN}.pdf" "${RN}.pdf"
        DEPENDS "${FN}.pdf"
    )
    add_custom_target("Make ${FN}.dvi" ALL DEPENDS "generated/${FN}.dvi")
    add_custom_target("Make ${FN}.ps" ALL DEPENDS "generated/${FN}.ps")
    # disable for a while, to test only building while moving to generated/ structure
    #add_custom_target("Make ${FN}.pdf" ALL DEPENDS "${FN}.pdf")
    #add_custom_target("Make ${RN}.rar" ALL DEPENDS "${RN}.rar")
    #add_custom_target("Make ${RN}-pdf.rar" ALL DEPENDS "${RN}-pdf.rar")
    #add_custom_target("Make ${RN}.pdf" ALL DEPENDS "${RN}.pdf")

    if (PN)
        message(STATUS "Processing pictures for ${FN}...")
        mmPicture("${PN}" "${FN}")
    endif (PN)

    set (AUX_CLEAN_FILES
        "${AUX_CLEAN_FILES}"
        "generated"
    )
    set_directory_properties(PROPERTIES
        ADDITIONAL_MAKE_CLEAN_FILES "${AUX_CLEAN_FILES}")
endmacro()


macro(mm_texify_ex)
    set (args_ ${ARGN})
    set (sources_)
    set (pictures_)
    set (include_)
    set (archive_)

    set (mode_ "begin")
    foreach (arg_ IN LISTS args_)
        if (arg_ STREQUAL "SOURCES")
            set(mode_ "sources")
        elseif (arg_ STREQUAL "PICTURES")
            set(mode_ "pictures")
        elseif (arg_ STREQUAL "INCLUDE")
            set(mode_ "include")
        elseif (arg_ STREQUAL "ARCHIVE")
            set(mode_ "archive")
        #message("!!!!!!!!!!!!!!!!!!arg: ${arg_}")
        elseif (mode_ STREQUAL "sources")
            set (sources_ ${sources_} ${arg_})
        elseif (mode_ STREQUAL "pictures")
            set (pictures_ ${pictures_} ${arg_})
        elseif (mode_ STREQUAL "include")
            set (include_ ${include_} ${arg_})
        elseif (mode_ STREQUAL "archive")
            set (archive_ ${arg_})
        endif()
    endforeach()

    set (FN "${sources_}")
    set (PN "${pictures_}")
    set (RN "${archive_}")
    message("  Processing ${sources_}")
    message("    pictures: ${pictures_}")
    message("    include: ${include_}")
    message("    archive: ${include_}")

    add_custom_command(OUTPUT
        "generated/${FN}.dvi"
        COMMAND "${RUN_LATEX}" ${LATEX} ${LATEX_OPTS} "../${FN}.tex"
        DEPENDS "${FN}.tex" ${include_}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    add_custom_command(OUTPUT
        "generated/${FN}.ps"
        COMMAND "${RUN_DVIPS}" ${DVIPS} "${FN}.dvi"
        DEPENDS "generated/${FN}.dvi"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    add_custom_command(OUTPUT
        "${FN}.pdf"
        COMMAND "${GS}" ${GS_OPTS} "-sOutputFile=${FN}.pdf" "${FN}.ps"
        DEPENDS "${FN}.ps"
    )
    add_custom_command(OUTPUT
        "${FN}.pdf"
        COMMAND "${GS}" ${GS_OPTS} "-sOutputFile=${FN}.pdf" "${FN}.ps"
        DEPENDS "${FN}.ps"
    )
    add_custom_command(OUTPUT
        "${RN}.rar"
        COMMAND "${RAR}" ${RAR_TEXT_OPTS} "${RN}.rar" "${FN}.ps"
        DEPENDS "${FN}.ps"
    )
    add_custom_command(OUTPUT
        "${RN}-pdf.rar"
        COMMAND "${RAR}" ${RAR_BIN_OPTS} "${RN}-pdf.rar" "${FN}.pdf"
        DEPENDS "${FN}.pdf"
    )
    add_custom_command(OUTPUT
        "${RN}.pdf"
        COMMAND cp "${FN}.pdf" "${RN}.pdf"
        DEPENDS "${FN}.pdf"
    )
    add_custom_target("Make ${FN}.dvi" ALL DEPENDS "generated/${FN}.dvi")
    add_custom_target("Make ${FN}.ps" ALL DEPENDS "generated/${FN}.ps")
    # disable for a while, to test only building while moving to generated/ structure
    #add_custom_target("Make ${FN}.pdf" ALL DEPENDS "${FN}.pdf")
    #add_custom_target("Make ${RN}.rar" ALL DEPENDS "${RN}.rar")
    #add_custom_target("Make ${RN}-pdf.rar" ALL DEPENDS "${RN}-pdf.rar")
    #add_custom_target("Make ${RN}.pdf" ALL DEPENDS "${RN}.pdf")

    if (PN)
        message(STATUS "Processing pictures for ${FN}...")
        mmPictureEx("${PN}" "${FN}")
    endif (PN)

    set (AUX_CLEAN_FILES
        "${AUX_CLEAN_FILES}"
        "generated"
    )
    set_directory_properties(PROPERTIES
        ADDITIONAL_MAKE_CLEAN_FILES "${AUX_CLEAN_FILES}")


endmacro(mm_texify_ex)

macro(mmPack)
    set (RN "${ARGV0}")
    set (FN "${ARGV1}")
    add_custom_command(OUTPUT
        "${RN}.rar"
        COMMAND "${RAR}" ${RAR_BIN_OPTS} "${RN}.rar" "${FN}"
        DEPENDS "${FN}"
    )
    add_custom_target("Make ${RN}.rar" ALL DEPENDS "${RN}.rar")
endmacro(mmPack)

macro(mmToDo)
    string(REPLACE "${CMAKE_SOURCE_DIR}/" "" _relative_source_dir "${CMAKE_CURRENT_SOURCE_DIR}")
    message(STATUS "TODO: ${ARGV0} at ${_relative_source_dir}")
endmacro(mmToDo)
