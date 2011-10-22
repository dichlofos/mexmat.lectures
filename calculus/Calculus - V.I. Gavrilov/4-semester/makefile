DocName = "Calculus [4] - V.I. Gavrilov"
RarName = "calculus-4s-gavrilov"

t:
#mp --tex=latex pic.mp
 latex --src $(DocName).tex
 dvips $(DocName).dvi
a: t
 wt $(RarName).rar $(DocName).ps
c clean:
 del *.dvi *.mpx *.log *.aux *.toc
p: t
 gswin32c -sDEVICE=pdfwrite -sOutputFile=$(DocName).pdf -r1200 -dNOPAUSE -dBATCH -g9912x14028 $(DocName).ps
b: p
 wr $(RarName)-pdf.rar $(DocName).pdf
 cp $(DocName).pdf $(RarName).pdf
all: a b
