# A part of MMLectures build infrastructure
# Generic build system configuration options
# Please make a review of changes that can break it
#
# Author and maintainer: Mikhail Veltishchev <dichlofos-mv@yandex.ru>


find_program(LATEX NAMES latexmk texify latex)
find_program(DVIPS dvips)
find_program(MPOST mpost)
find_program(GS gs)
find_program(RAR winrar)
find_program(P7Z 7z)

set (MPOST_OPTS --tex=latex)
set (LATEX_OPTS --src-specials --interaction=nonstopmode)
set (GS_OPTS -sDEVICE=pdfwrite -r1200 -dNOPAUSE -dBATCH -g9912x14028)
set (RAR_TEXT_OPTS a -md4096 -s -m5)
set (RAR_BIN_OPTS a -md4096 -s -m5)
set (P7Z_OPTS a)

set (ARCHIVER ${P7Z})
set (ARCHIVER_OPTS ${P7Z_OPTS})

set (RUN_LATEX ${CMAKE_SOURCE_DIR}/run-latex.sh)
set (RUN_DVIPS ${CMAKE_SOURCE_DIR}/run-dvips.sh)
set (RUN_MPOST ${CMAKE_SOURCE_DIR}/run-mpost.sh)
set (RUN_ARCHIVER ${CMAKE_SOURCE_DIR}/run-archiver.sh)

message (STATUS "Found LaTeX: ${LATEX}")
message (STATUS "Found MetaPost: ${MPOST}")
