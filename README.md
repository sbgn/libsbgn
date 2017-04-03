# LibSBGN

Software support library for the [Systems Biology Graphical Notation (SBGN)](http://www.sbgn.org).

Documentation about LibSBGN and the development process is available from the Wiki  
https://github.com/sbgn/sbgn/wiki/LibSBGN  
Documentation about SBGN is available from the SBGN homepage    
http://sbgn.org

## How to cite
**Software support for SBGN maps: SBGN-ML and LibSBGN**  
*van Iersel MP, Villéger AC, Czauderna T, Boyd SE, Bergmann FT, Luna A, Demir E, Sorokin A, Dogrusoz U, Matsuoka Y, Funahashi A, Aladjem MI, Mi H, Moodie SL, Kitano H, Le Novère N, Schreiber F.*  
Bioinformatics, 28(15):2016-2021, 2012 [PubMed](https://www.ncbi.nlm.nih.gov/pubmed/22581176)

## How to build

To build the java version of LibSBGN, you need to have installed:

* Git [download](https://git-scm.com/downloads)
* Java JDK [download](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html)
* Ant [download](https://ant.apache.org/bindownload.cgi)

First clone the repository via
```
git clone https://github.com/sbgn/libsbgn.git
cd libsbgn
```

Get the latest stable release otherwise you will work with the unstable development version
```
git fetch
git checkout milestone-2
```

Than build the library with ant from the source directory
```
ant
```
This will result in the creation of `/dist/org.sbgn.jar` which you can include in your project.

To build the documentation in `/docs/` use
```
ant doc
```

To run the tests use 
```
ant test
``` 

## Files

Here is an explanation of the directories in this project:


    cpp_binding    - C++ version of LibSBGN  
    example-files  - some example SBGN-ML files, larger and more complete than the test-cases  
    licenses       - license information  
    org.sbgn       - LibSBGN source code (Java version)  
    resources      - general resources, including XML Schema (SBGN.xsd)  
    specifications - Auto-generated documentation for the XML Schema  
	test-files     - SBGN-ML test cases and reference images  
    tools		   - 
    validation     - schematron validation rules, test-cases and resources  
    

## Authors

Alice Villeger  
Augustin Luna  
Frank Bergmann  
Martijn van Iersel  
Sarah Boyd  
Tobias Czauderna  
Stuart Moodie  
Matthias König  

### Contact

Contact our mailinglist:  
sbgn-libsbgn@lists.sourceforge.net

Our official website:  
https://github.com/sbgn/libsbgn
