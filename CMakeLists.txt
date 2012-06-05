cmake_minimum_required(VERSION 2.8)
project (MMLectures "NONE")

find_program(LATEX NAMES latexmk texify latex)
find_program(DVIPS dvips)
find_program(MPOST mpost)
find_program(GS gs)
find_program(RAR winrar)

set (MPOST_OPTS --tex=latex)
set (LATEX_OPTS --src)
set (GS_OPTS -sDEVICE=pdfwrite -r1200 -dNOPAUSE -dBATCH -g9912x14028)
set (RAR_TEXT_OPTS a -md4096 -s -m5)
set (RAR_BIN_OPTS a -md4096 -s -m5)

message (STATUS "Found LaTeX: ${LATEX}")
message (STATUS "Found MetaPost: ${MPOST}")

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


add_subdirectory(algebra)
add_subdirectory(calculus)
add_subdirectory(ccalculus)
add_subdirectory(fcalculus)
add_subdirectory(mechanics)
add_subdirectory(nt)
add_subdirectory(rcalculus)
add_subdirectory(misc)
