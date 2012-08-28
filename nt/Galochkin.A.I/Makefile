# I will always fight for unicode.
# For Debian-based, you need texlive-binaries
# Altho, of course, you know, what is apt-file.
SOURCE=main.tex *.tex
pdf: ${SOURCE}
	-mkdir build 
	cp mmlogo.2 build/mmlogo.2
	xelatex  -halt-on-error -file-line-error -output-directory=build main.tex 
clear:
	-rm -rf build/*