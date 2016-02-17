SVGS = $(wildcard *.svg)
PDFS = $(patsubst %.svg, %.pdf, $(SVGS))

# PDFS = $(patsubst %.svg, %.pdf, $(wildcard *.svg))

all: $(PDFS)

$(PDFS): $(SVGS)


%.pdf: %.svg
	inkscape -T --export-area-drawing --without-gui --export-pdf=$@ --file=$<
