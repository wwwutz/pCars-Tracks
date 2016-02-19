.PHONY: all clean

all: pcarstracks.pdf

pcarstracks.tex:  logos-fp.tex all-tracks.tex all-toc.tex

pcarstracks.pdf: pcarstracks.tex logos-fp.tex all-tracks.tex all-toc.tex
	pdflatex $<
	pdflatex $<


logos-fp.tex: mkpages.pl
	./mkpages.pl

clean:
	latexmk -CA

