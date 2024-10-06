# LibSBGN
[![](https://jitpack.io/v/sbgn/libsbgn.svg)](https://jitpack.io/#sbgn/libsbgn)

[![](https://github.com/sbgn/libsbgn/actions/workflows/jdk8-maven.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk8-maven.yml) [![](https://github.com/sbgn/libsbgn/actions/workflows/jdk11-maven.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk11-maven.yml) [![](https://github.com/sbgn/libsbgn/actions/workflows/jdk16-maven.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk16-maven.yml)

[![](https://github.com/sbgn/libsbgn/actions/workflows/jdk8-ant.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk8-ant.yml) [![](https://github.com/sbgn/libsbgn/actions/workflows/jdk11-ant.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk11-ant.yml) [![](https://github.com/sbgn/libsbgn/actions/workflows/jdk16-ant.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk16-ant.yml) [![](https://github.com/sbgn/libsbgn/actions/workflows/jdk17-ant.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk17-ant.yml) [![](https://github.com/sbgn/libsbgn/actions/workflows/jdk21-ant.yml/badge.svg)](https://github.com/sbgn/libsbgn/actions/workflows/jdk21-ant.yml)


Software support library for the [Systems Biology Graphical Notation (SBGN)](http://www.sbgn.org).

Documentation about LibSBGN and the development process is available from the Wiki  
https://github.com/sbgn/sbgn/wiki/LibSBGN  
Documentation about SBGN is available from the SBGN homepage    
http://sbgn.org

## How to cite
**Software support for SBGN maps: SBGN-ML and LibSBGN**  
*van Iersel MP, Villéger AC, Czauderna T, Boyd SE, Bergmann FT, Luna A, Demir E, Sorokin A, Dogrusoz U, Matsuoka Y, Funahashi A, Aladjem MI, Mi H, Moodie SL, Kitano H, Le Novère N, Schreiber F.*  
Bioinformatics, 28(15):2016-2021, 2012 [PubMed](https://www.ncbi.nlm.nih.gov/pubmed/22581176)

## Using libsbgn

As of milestone 3, thanks to [jitpack.io](https://jitpack.io/#sbgn/libsbgn), it is easy to use libsbgn right away withL 

### gradle: 

Step 1. Add the JitPack repository to your build file

Add it in your root build.gradle at the end of repositories:

	allprojects {
		repositories {
			...
			maven { url 'https://jitpack.io' }
		}
	}
Step 2. Add the dependency

	dependencies {
	        implementation 'com.github.sbgn:libsbgn:Tag'
	}


### Maven
Step 1. Add the JitPack repository to your build file

	<repositories>
		<repository>
		    <id>jitpack.io</id>
		    <url>https://jitpack.io</url>
		</repository>
	</repositories>
Step 2. Add the dependency

	<dependency>
	    <groupId>com.github.sbgn</groupId>
	    <artifactId>libsbgn</artifactId>
	    <version>Tag</version>
	</dependency> 

### sbt

Add it in your build.sbt at the end of resolvers:

 
    resolvers += "jitpack" at "https://jitpack.io"
        
    
Step 2. Add the dependency

	
	libraryDependencies += "com.github.sbgn" % "libsbgn" % "Tag"

### leiningen

Add it in your project.clj at the end of repositories:

 
    :repositories [["jitpack" "https://jitpack.io"]]
        
    
Step 2. Add the dependency

	
	:dependencies [[com.github.sbgn/libsbgn "Tag"]]	
Share this release: 

## Example code
If you would like to see how to use libsbgn, have a look at some of the examples: 

* [reading SBGN](org.sbgn/examples/org/sbgn/ReadExample.java)
* [writing SBGN](org.sbgn/examples/org/sbgn/WriteExample.java)
* [writing SBGN with annotation glyph](org.sbgn/examples/org/sbgn/WriteExampleAnnotation.java)
* [reading SBGN render information](org.sbgn/examples/org/sbgn/ReadExampleWithRender.java)
* [writing SBGN render information](org.sbgn/examples/org/sbgn/WriteRenderExtensionExample.java)


## How to build

To build the java version of LibSBGN, you need to have installed:

* Git [download](https://git-scm.com/downloads)
* Java JDK [download](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html)
* Ant [download](https://ant.apache.org/bindownload.cgi)

### Building with Maven

First clone the repository via
```
git clone https://github.com/sbgn/libsbgn.git
cd libsbgn
```

then compile using `mvn install`.


### Building with Ant

Add Git, Java JDK, and Ant to your path

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
ant -f ant-build-script.xml
```
This will result in the creation of `/dist/org.sbgn.jar` which you can include in your project.

To build the documentation in `/docs/` use
```
ant -f ant-build-script.xml doc
```

To run the tests use 
```
ant -f ant-build-script.xml test
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
