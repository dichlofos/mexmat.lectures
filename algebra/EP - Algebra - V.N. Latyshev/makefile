DocName = "EP - Algebra - V.N. Latyshev"
RarName = "ep-algebra-latyshev"

t:
 latex --src $(DocName).tex
 dvips $(DocName).dvi
a: t
 wt $(RarName).rar $(DocName).ps
c:
 del *.dvi *.mpx *.log *.aux *.toc
p: t
 gswin32c -sDEVICE=pdfwrite -sOutputFile=$(DocName).pdf -r1200 -dNOPAUSE -dBATCH -g9912x14028 $(DocName).ps
b: p
 wr $(RarName)-pdf.rar $(DocName).pdf 
 cp $(DocName).pdf $(RarName).pdf
all: a b