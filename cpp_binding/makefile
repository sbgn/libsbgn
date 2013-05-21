.PHONY: clean test distclean all


################ EDIT THESE SETTINGS ######################

PREFIX=/usr/local

# Location of Code Synthesis Library
XSD_BASE=./xsd-3.3.0-i686-macosx

# Location of additional includes, such as Xerces C++ library
INCLUDES=-I/usr/local/include -I /opt/local/include

# Location of libraries, such as Xerces C++ library 
LIBS=-L/usr/local/lib -L /opt/local/lib

################# LEAVE SETTINGS BELOW ####################


XSD := $(XSD_BASE)/bin/xsd

XSDFLAGS := --namespace-map http://sbgn.org/libsbgn/0.2=libsbgn::sn_0_2 --root-element sbgn \
	--generate-serialization --generate-doxygen

CXXFLAGS=$(INCLUDES) -I$(XSD_BASE)/libxsd -Wall -g

LDFLAGS=$(LIBS)

# All.
all: libsbgn.a

# Library.
#
libsbgn.so: sbgn.cxx sbgn.hxx sbgn.o
	$(CXX) -shared -Wl,-soname,libsbgn.so -o libsbgn.so sbgn.cxx

sbgn.cxx sbgn.hxx: sbgn.xsd
	$(XSD) cxx-tree $(XSDFLAGS) $<

libsbgn.a: sbgn.cxx sbgn.hxx sbgn.o
	$(AR) rcs libsbgn.a sbgn.o

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

sbgn2txt: sbgn2txt.o libsbgn.a
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ sbgn2txt.o -lxerces-c -lsbgn -L.

sbgn2txt.o: sbgn2txt.cxx sbgn.hxx

# Install.
install:
	install -d $(PREFIX)/include/
	install -d $(PREFIX)/lib/
	install -m644 sbgn.hxx $(PREFIX)/include/
	install -m755 libsbgn.a $(PREFIX)/lib/
	if [ -e libsbgn.so ]; then \
		install -m755 libsbgn.so $(PREFIX)/lib/; \
	fi

# Thorough clean of all files
distclean: clean
	rm -f sbgn.?xx

# Clean.
#
clean:
	rm -f sbgn.xsd *.o sbgn2txt libsbgn.*
