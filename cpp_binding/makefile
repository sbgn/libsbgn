root := ./XSD2CPP/examples

XSDFLAGS := --namespace-map http://sbgn.org/libsbgn/pd/0.1=libsbgn::pd_0_1 --root-element sbgn --generate-doxygen

include $(root)/build/cxx/rules.make
include $(root)/build/xsd/tree-rules.make

# All.
all: libsbgn test

# Library.
#
libsbgn: sbgn.cxx sbgn.hxx

sbgn.cxx sbgn.hxx: sbgn.xsd

sbgn.xsd:
	cp ../resources/SBGN.xsd ./sbgn.xsd

# Test.
#
test: sbgn2txt
	find ../test-files -name "*.sbgn" | xargs ./sbgn2txt

sbgn2txt: sbgn2txt.o sbgn.o

sbgn2txt.o: sbgn2txt.cxx sbgn.hxx

sbgn.o: sbgn.cxx sbgn.hxx

# Uninstall.
uninstall: clean
	rm -f sbgn.?xx

# Clean.
#
clean:
	rm -f sbgn.xsd *.o sbgn2txt