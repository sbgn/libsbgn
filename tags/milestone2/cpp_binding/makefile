.PHONY: clean test uninstall libsbgn


################ EDIT THESE SETTINGS ######################

# Location of Code Synthesis Library
XSD_BASE=$(HOME)/Development/ebi/xsd-3.3.0-i686-macosx

# Location of additional includes, such as Xerces C++ library
INCLUDES=-I/opt/local/include

# Location of libraries, such as Xerces C++ library 
LIBS=-L/opt/local/lib

################# LEAVE SETTINGS BELOW ####################


XSD := $(XSD_BASE)/bin/xsd

XSDFLAGS := --namespace-map http://sbgn.org/libsbgn/0.2=libsbgn::sn_0_2 --root-element sbgn --generate-doxygen

CXXFLAGS=$(INCLUDES) -I$(XSD_BASE)/libxsd -Wall -g

LDFLAGS=$(LIBS)

# All.
all: libsbgn test

# Library.
#
libsbgn: sbgn.cxx sbgn.hxx

sbgn.cxx sbgn.hxx: sbgn.xsd
	$(XSD) cxx-tree $(XSDFLAGS) $<

sbgn.xsd:
	cp ../resources/SBGN.xsd ./sbgn.xsd

%.o:%.cxx
	$(CXX) -c $(CXXFLAGS) $<

# Test.
#
test: sbgn2txt
	for i in ../test-files/*/*.sbgn; do \
		./sbgn2txt $$i; \
	done

sbgn2txt: sbgn2txt.o sbgn.o
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ sbgn2txt.o sbgn.o -lxerces-c

sbgn2txt.o: sbgn2txt.cxx sbgn.hxx

sbgn.o: sbgn.cxx sbgn.hxx

# Uninstall.
uninstall: clean
	rm -f sbgn.?xx

# Clean.
#
clean:
	rm -f sbgn.xsd *.o sbgn2txt