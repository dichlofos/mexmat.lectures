DocName = "Calculus [2] - V.I. Gavrilov"
RarName = "calculus-2s-gavrilov"

t:
# mp --tex=latex t.mp
 latex --src $(DocName).tex
 dvips $(DocName).dvi
a: t
 wt $(RarName).rar $(DocName).ps
c clean:
 del *.dvi *.mpx *.log *.aux *.toc
p: t
 gs -sDEVICE=pdfwrite -sOutputFile=$(DocName).pdf -r1200 -dNOPAUSE -dBATCH -g9912x14028 $(DocName).ps
b: p
 wr $(RarName)-pdf.rar $(DocName).pdf
 cp $(DocName).pdf $(RarName).pdf
all: a b
