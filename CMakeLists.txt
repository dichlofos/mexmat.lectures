cmake_minimum_required(VERSION 2.8.0)
project (MMLectures NONE)
## Logic is pretty clear. Especially if you know automake.
set(LATEX_texify_opts --src)
set(LATEX_latex_opts)
set(DVIPS_dvips_opts)
set(MPOST_mpost_opts --tex=latex)
set(GS_gs_opts -sDEVICE=pdfwrite -r1200 -dNOPAUSE -dBATCH -g9912x14028)
set(ARC_winrar_opts  a -md4096 -s -m5)
set(ARC_gzip_opts --best)

function(require_program program names)
  list(REMOVE_AT ARGV 0)
  foreach(alter ${ARGV})
    find_program(${program} ${alter})
    if (NOT "${${program}}" STREQUAL "${program}-NOTFOUND")
      set("${program}_OPTS" "${${program}_${alter}_opts}" PARENT_SCOPE)
    endif()
  endforeach(alter)
  if( "${${program}}" STREQUAL "${program}-NOTFOUND")
    message(FATAL_ERROR "Required program ${program} not found. Aborted.")
  endif()
  message(STATUS "Found ${program} via ${${program}}")
endfunction(require_program)

require_program(LATEX texify latex)
require_program(DVIPS dvips)
require_program(MPOST mpost)
require_program(GS gs)
require_program(ARC winrar gzip)
require_program(ASY asy)

# Of course, It is exteremely wrong. But what else can I do,
# faced extemely non-expressive language?
function(archive filename)
  get_filename_component(arcbin ${ARC} NAME)
  if (${arcbin} STREQUAL "gzip")
    message(STATUS "Processing archive")
    add_custom_target("${filename}.gz"
      COMMAND ${ARC} ${ARC_OPTS} ${filename}
      DEPENDS ${filename})
    add_dependencies(archive "${filename}.gz")
  elseif(${arcbin} STREQUAL "winrar")
    add_custom_command(OUTPUT  "${filename}.rar"
		COMMAND ${ARC} ${ARC_OPTS} "${filename}.rar" ${filename}
		DEPENDS ${filename})
    add_dependencies(archive "${filename}.gz")
  endif()   
  add_dependencies(archive "bar.zoo")
endfunction(archive)

macro(mmPicture)
	set (PN "${ARGV0}")
	set (TN "${ARGV1}")
	add_custom_command(OUTPUT
		"${PN}.done"
		COMMAND "${MPOST}" ${MPOST_OPTS} "${PN}.mp" && touch "${PN}.done"
		DEPENDS "${PN}.mp"
	)
	add_custom_target("MetaPosing ${PN} for ${TN}" ALL DEPENDS "${PN}.done")
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
	add_custom_command(OUTPUT
		"${FN}.dvi"
		COMMAND "${LATEX}" ${LATEX_OPTS} "${FN}.tex"
		DEPENDS "${FN}.tex"
	)
	add_custom_command(OUTPUT
		"${FN}.ps"
		COMMAND "${DVIPS}" "${FN}.dvi"
		DEPENDS "${FN}.dvi"
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
		COMMAND "${ARC}" ${ARC_TEXT_OPTS} "${RN}.rar" "${FN}.ps"
		DEPENDS "${FN}.ps"
	)
	add_custom_command(OUTPUT
		"${RN}-pdf.rar"
		COMMAND "${ARC}" ${ARC_BIN_OPTS} "${RN}-pdf.rar" "${FN}.pdf"
		DEPENDS "${FN}.pdf"
	)
	add_custom_command(OUTPUT
		"${RN}.pdf"
		COMMAND cp "${FN}.pdf" "${RN}.pdf"
		DEPENDS "${FN}.pdf"
	)
	add_custom_target("Make ${FN}.dvi" ALL DEPENDS "${FN}.dvi")
	add_custom_target("Make ${FN}.ps" ALL DEPENDS "${FN}.ps")
	add_custom_target("Make ${FN}.pdf" ALL DEPENDS "${FN}.pdf")
	add_custom_target("Make ${RN}.rar" ALL DEPENDS "${RN}.rar")
	add_custom_target("Make ${RN}-pdf.rar" ALL DEPENDS "${RN}-pdf.rar")
	add_custom_target("Make ${RN}.pdf" ALL DEPENDS "${RN}.pdf")
	
	if (PN)
		message(STATUS "Processing pictures for ${FN}...")
		mmPicture("${PN}" "${FN}")
	endif (PN)
	set (AUX_CLEAN_FILES
		"${AUX_CLEAN_FILES}"
		"${FN}.aux"
		"${FN}.log"
		"${FN}.toc"
		"${FN}.ind"
		"${FN}.ilg"
		"${FN}.idx"
	)
	set_directory_properties(PROPERTIES
		ADDITIONAL_MAKE_CLEAN_FILES "${AUX_CLEAN_FILES}")
endmacro(texify)

function(mmPack)
	set (RN "${ARGV0}")
	set (FN "${ARGV1}")
	add_custom_command(OUTPUT
		"${RN}.rar"
		COMMAND "${ARC}" ${ARC_BIN_OPTS} "${RN}.rar" "${FN}"
		DEPENDS "${FN}"
	)
	add_custom_target("Make ${RN}.rar" ALL DEPENDS "${RN}.rar")
endfunction(mmPack)


add_subdirectory(algebra)
add_subdirectory(calculus)
add_subdirectory(ccalculus)
add_subdirectory(fcalculus)
add_subdirectory(mechanics)
add_subdirectory(misc)
add_subdirectory(nt)
add_subdirectory(prog)
add_subdirectory(rcalculus)

add_subdirectory(test)