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
    message(STATUS "Clean files: ${AUX_CLEAN_FILES}")
    set (AUX_CLEAN_FILES
        "${AUX_CLEAN_FILES}"
        "${PN}.log"
        "${PN}.mpx"
    )

endmacro(mmPicture)

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
endmacro(texify)

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
