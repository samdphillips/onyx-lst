
noinst_DATA = impman.pdf

CLEANFILES = $(noinst_DATA)

pdf-local: $(noinst_DATA)

%.pdf: %.ps
	ps2pdf $<

%.ps: %.me
	./dformat $< | pic | groff -me | psselect 1,_,_1,_,2-_2 > $@

