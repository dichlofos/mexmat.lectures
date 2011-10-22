DocName = "Algebra [3] - E.B. Vinberg"
RarName = "algebra-3s-vinberg"

t:
 #latex --src $(DocName).tex
 #dvips $(DocName).dvi
 rem "commented, texes do NOT match real code, please update sources"
a: t
 wt $(RarName).rar $(DocName).ps
c:
 del *.dvi *.mpx *.log *.aux *.toc
p: t
 gswin32c -sDEVICE=pdfwrite -sOutputFile=$(DocName).pdf -r1200 -dNOPAUSE -dBATCH -g9912x14028 $(DocName).ps
b: p
 wt $(RarName)-pdf.rar $(DocName).pdf
all: a b
 

