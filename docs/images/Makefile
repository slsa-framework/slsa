all : provenance.svg

%.svg : %.dot
	dot -Tsvg $< > $@
