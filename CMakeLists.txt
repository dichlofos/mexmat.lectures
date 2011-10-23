project (MMLectures)

find_program(LATEX latex)
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

macro(picture)
	message(FATAL_ERROR "Not implemented yet. ")
endmacro(picture)

macro(texify)
	set (FN "${ARGV0}")
	set (RN "${ARGV1}")
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
	set (AUX_CLEAN_FILES
		"${FN}.aux"
		"${FN}.log"
		"${FN}.toc"
	)
	set_directory_properties(PROPERTIES
		ADDITIONAL_MAKE_CLEAN_FILES "${AUX_CLEAN_FILES}")
endmacro(texify)

add_subdirectory(algebra)