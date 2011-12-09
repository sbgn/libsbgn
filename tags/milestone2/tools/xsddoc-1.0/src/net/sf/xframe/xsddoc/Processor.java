/*
This file is part of the xframe software package
hosted at http://xframe.sourceforge.net

Copyright (c) 2003 Kurt Riede.

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/
package net.sf.xframe.xsddoc;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.ErrorListener;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.URIResolver;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.xframe.ex.ExceptionUtil;
import net.sf.xframe.xsddoc.util.BrowserLauncher;
import net.sf.xframe.xsddoc.util.DomUtil;
import net.sf.xframe.xsddoc.util.FileUtil;
import net.sf.xframe.xsddoc.util.StringUtil;
import net.sf.xframe.xsddoc.util.XMLUtil;

import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

/**
 * The xsddoc processor.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class Processor {

    ////////////////////////////////////////////////
    // constants
    ////////////////////////////////////////////////

    /** Name of xsddoc-id attribute to mark a nested component for processing. */
    private static final String XSDDOCID_ATTR = "xsddocid";

    /** Unique prefix for xsddoc attributes. */
    public static final String XSDDOC_PREFIX = "net.sf.xframe.xsddoc";

    /** Namespace-URI of namespace of W3C-XML-Namespace. */
    public static final String NAMESPACE_NAMESPACE = "http://www.w3.org/2000/xmlns/";

    /** Namespace-URI of namespace of W3C-XML-Schema. */
    public static final String XMLSCHEMA_NAMESPACE = "http://www.w3.org/2001/XMLSchema";

    /** Namespace-URI of namespace of xsddoc. */
    public static final String XSDDOC_NAMESPACE = "http://xframe.sf.net/xsddoc/doc";

    /** Attribute name: targetNamespace. */
    public static final String TARGETNAMESPACE = "targetNamespace";

    /** Folder name for components that do not belong to a namespace. */
    public static final String NO_NAMESPACE = "noNamespace";

    /** protocol prefix for resource files. */
    public static final String RESOURCE_PROTOCOL = "resource:";

    /** File extension of HTML files. */
    private static final String HTML_EXT = ".html";

    /** File extension of XML files. */
    private static final String XML_EXT = ".xml";

    /** File separator from <code>File.separator</code>. */
    private static final String FILE_SEP = File.separator;

    /** Protocol prefix for internal temporary DOM sources. */
    private static final String DOM_PROTOCOL = "temp:";

    ////////////////////////////////////////////////
    // instance attributes
    ////////////////////////////////////////////////

    /** Package name of this class as a folder string. */
    private final String resourcePrefix = StringUtil.replace(this.getClass().getPackage().getName(), '.', '/');

    /** Reference to the XML document builder factory. */
    private DocumentBuilderFactory builderFactory = null;

    /** Reference to the document builder. */
    private DocumentBuilder builder = null;

    /** Reference to the transformer factory. */
    private TransformerFactory tFactory = null;

    /** Index transformer of all components. */
    private Transformer tIndexAll = null;

    /** Index transformer. */
    private Transformer tIndex = null;

    /** overviewAll transformer. */
    private Transformer tOverviewAll = null;

    /** overviewNamespaces transformer. */
    private Transformer tOverviewNamespaces = null;

    /** overviewNamespace transformer. */
    private Transformer tOverviewNamespace = null;

    /** schemaSummary transformer. */
    private Transformer tSchemaSummary = null;

    /** schemaIndex transformer. */
    private Transformer tSchemaIndex = null;

    /** component transformer. */
    private Transformer tComponent = null;

    /** html transformer. */
    private Transformer tHtml = null;

    /** help transformer. */
    private Transformer tHelp = null;

    /** Cache of loaded schemas. */
    private Map schemaCache = new HashMap();

    /** Cache of sources of loaded schemas. */
    private Map sourceCache = new HashMap();

    /** Cache of imported schemas. */
    private Map importCache = new HashMap();

    /** filename of schema. */
    private String mainSchemaLocation = "";

    /** Main schema. */
    private Document mainSchema = null;

    /** documentation footer. */
    private String footer = "";

    /** Documentation Title. */
    private String doctitle;

    /** Documentation header. */
    private String header = "";

    /** Documentation bottom. */
    private String bottom = "";

    /** out folder. */
    private String out = ".";

    /** home folder of xsddoc. */
    private String xsddocHome = ".";

    /** Filename of optional external CSS file. */
    private String css = null;

    /** if verbose mode or not. */
    private boolean verbose = true;

    /** if debug mode or not. */
    private boolean debug = false;

    /** if generated documentation should be launched after creation. */
    private boolean launch = false;

    /** if output folder should be created. */
    private boolean createFolder = false;

    /** if xml mode or not. */
    private boolean xml = false;

    /** if sub types should not be shown. */
    private boolean hideSubTypes = false;

    /** if local usage should not be shown. */
    private boolean hideLocalUsage = false;

    /** if types should be shown in overview pages. */
    private boolean hideTypes = false;

    /** if attributes should be shown in overview pages. */
    private boolean hideAttributes = false;

    /** if groups should be shown in overview pages. */
    private boolean hideGroups = false;

    /** Optional name of proxy host. */
    private String proxyHost;

    /** Optional name of proxy port. */
    private String proxyPort;

    /** Indicates if the processor is initialized. */
    private boolean initialized = false;

    /** Map of all already processed schema locations. */
    private Map schemaLocationProcessedMap = new HashMap();

    /** Reference to the current activ listener. */
    private ProcessorListener listener;

    ////////////////////////////////////////////////
    // instantiation
    ////////////////////////////////////////////////

    /**
     * Default constructor.
     */
    public Processor() {
        listener = new ConsoleListener();
    }

    ////////////////////////////////////////////////
    // properties
    ////////////////////////////////////////////////

    /**
     * Setter method for header property.
     *
     * @param theHeader the header to use
     */
    public void setHeader(final String theHeader) {
        this.header = theHeader;
    }

    /**
     * Setter method for footer property.
     *
     * @param theFooter the footer to use
     */
    public void setFooter(final String theFooter) {
        this.footer = theFooter;
    }

    /**
     * Setter method for bottom property.
     *
     * @param theBottom the bottom to use
     */
    public void setBottom(final String theBottom) {
        this.bottom = theBottom;
    }

    /**
     * Setter method for title property.
     *
     * @param theDoctitle schema title to use
     */
    public void setDoctitle(final String theDoctitle) {
        this.doctitle = theDoctitle;
    }

    /**
     * Setter method for schemaLocation property.
     *
     * @param theSchemaLocation location of XML schema to use
     */
    public void setSchemaLocation(final String theSchemaLocation) {
        this.mainSchemaLocation = theSchemaLocation;
    }

    /**
     * Setter method for mainSchema property.
     *
     * @param document DOM of main schema
     */
    public void setMainSchema(final Document document) {
        mainSchema = document;
    }

    /**
     * Setter method for out property.
     *
     * @param theOut output folder to use
     */
    public void setOut(final String theOut) {
        this.out = theOut;
    }

    /**
     * Setter method for CSS property.
     *
     * @param theCss output external CSS file to use
     */
    public void setCss(final String theCss) {
        this.css = theCss;
    }

    /**
     * Setter method for verbose property.
     *
     * @param theVerbose be verbose or not
     */
    public void setVerbose(final boolean theVerbose) {
        this.verbose = theVerbose;
    }

    /**
     * Setter method for debug property.
     *
     * @param theDebug output debug information or not
     */
    public void setDebug(final boolean theDebug) {
        this.debug = theDebug;
        if (debug) {
            this.verbose = true;
        }
    }

    /**
     * Getter method for debug property.
     *
     * @return if debug mode enabled or not
     */
    public boolean isDebug() {
        return debug;
    }

    /**
     * Getter method for createFolder property.
     *
     * @return if output folder should be created
     */
    protected boolean isCreateFolder() {
        return createFolder;
    }

    /**
     * Setter method for createFolder property.
     *
     * @param theCreateFolder if output folder should be created
     */
    protected void setCreateFolder(final boolean theCreateFolder) {
        this.createFolder = theCreateFolder;
    }

    /**
     * Getter method for launch property.
     *
     * @return if generated documentation should be launched after creation
     */
    protected boolean isLaunch() {
        return launch;
    }

    /**
     * Setter method for launch property.
     *
     * @param theLaunch if generated documentation should be launched after creation
     */
    protected void setLaunch(final boolean theLaunch) {
        this.launch = theLaunch;
    }

    /**
     * Setter method for xml property.
     *
     * @param theXml if xml should be created or HTML
     */
    public void setXml(final boolean theXml) {
        this.xml = theXml;
    }

    /**
     * Setter method for hideLocalUsage property.
     *
     * @param theHideLocalUsage if local usage should be hidden or not
     */
    public void setHideLocalUsage(final boolean theHideLocalUsage) {
        this.hideLocalUsage = theHideLocalUsage;
    }

    /**
     * Setter method for hideSubTypes property.
     *
     * @param theHideSubTypes if sub types should be hidden or not
     */
    public void setHideSubTypes(final boolean theHideSubTypes) {
        this.hideSubTypes = theHideSubTypes;
    }

    /**
     * Setter method for hideAttributes property.
     *
     * @param theHideAttributes if attributes should be hidden or not
     */
    public void setHideAttributes(final boolean theHideAttributes) {
        hideAttributes = theHideAttributes;
    }

    /**
     * Setter method for hideGroups property.
     *
     * @param theHideGroups if groups should be hidden or not
     */
    public void setHideGroups(final boolean theHideGroups) {
        hideGroups = theHideGroups;
    }

    /**
     * Setter method for hideTypes property.
     *
     * @param theHideTypes if types should be hidden or not
     */
    public void setHideTypes(final boolean theHideTypes) {
        hideTypes = theHideTypes;
    }

    /**
     * Setter method for proxyHost property.
     *
     * @param theProxyHost The proxyHost to set.
     */
    public void setProxyHost(final String theProxyHost) {
        this.proxyHost = theProxyHost;
    }

    /**
     * Setter method for proxyPort property.
     *
     * @param theProxyPort The proxyPort to set.
     */
    public void setProxyPort(final String theProxyPort) {
        this.proxyPort = theProxyPort;
    }

    /**
     * Getter method for listener property.
     *
     * @return Returns the listener.
     */
    public ProcessorListener getListener() {
        return listener;
    }

    /**
     * Setter method for the listener.
     *
     * @param theListener The listener to set.
     */
    public void setListener(final ProcessorListener theListener) {
        this.listener = theListener;
    }

    /**
     * Depending on xml attribute returns file extension for XML ro HTML files.
     *
     * @return file extension
     */
    private String getExtension() {
        return xml ? XML_EXT : HTML_EXT;
    }

    ////////////////////////////////////////////////
    // execution
    ////////////////////////////////////////////////

    /**
     * Executes xsddoc.
     *
     * @throws ProcessorException if error occured during execution
     */
    public void execute() throws ProcessorException {
        if (out == null) {
            throw new ProcessorException("output folder is null");
        }
        final File outFile = new File(this.out);

        if (!outFile.exists()) {
            if (createFolder) {
                outFile.mkdirs();
            } else {
                throw new ProcessorException("output folder doesn't exist: " + outFile);
            }
        }
        if (!outFile.exists()) {
            throw new ProcessorException("output folder doesn't exist: " + outFile);
        }
        if (debug) {
            status();
        }
        try {
            if (!initialized) {
                initProxy();
                initBuilder();
                initTransformers();
            }
            process();
            if (launch) {
                BrowserLauncher.openURL(out + FILE_SEP + "index" + getExtension());
            }
        } catch (Exception e) {
            throw new ProcessorException(e.getLocalizedMessage(), e);
        }
    }

    /**
     * Executes xsddoc and returns a string with all messages and exceptions
     * that are normally sent to <tt>System.out</tt>.
     *
     * <p>This method can be used in batch processing to reuse an instance
     * of this class for multiple operations.</p>
     *
     * @return String with all messages and exceptions
     */
    public String run() {
        PrintStream stdOut = System.out;
        PrintStream stdErr = System.err;
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        PrintStream stream = new PrintStream(output);
        System.setOut(stream);
        System.setErr(stream);
        try {
            execute();
        } catch (Throwable e) {
            System.out.println("xsddoc failed with exception: " + e.getLocalizedMessage());
            if (isDebug()) {
                System.out.println(ExceptionUtil.printStackTrace(e));
            }
        }
        System.setOut(stdOut);
        System.setErr(stdErr);
        return output.toString();
    }

    /**
     * Write environment status to given PrintStream.
     */
    private void status() {
        getListener().debug("xsddoc.home: " + this.xsddocHome);
        getListener().debug("out.folder: " + this.out);
        getListener().debug("schema.location: " + this.mainSchemaLocation);
    }

    ////////////////////////////////////////////////
    // initialisation
    ////////////////////////////////////////////////

    /**
     * Initializes the proxy if defined.
     */
    private void initProxy() {
        if (proxyHost != null) {
            System.setProperty("http.proxySet", "true");
            System.setProperty("http.proxyHost", proxyHost);
            System.setProperty("http.proxyPort", proxyPort);
        }
    }

    /**
     * Initialise a namespace aware DocumentBuilder.
     *
     * @throws ParserConfigurationException if a DocumentBuilder
     *         cannot be created.
     */
    private void initBuilder() throws ParserConfigurationException {
        if (debug) {
            getListener().debug("create document builder");
        }
        builderFactory = DocumentBuilderFactory.newInstance();
        builderFactory.setNamespaceAware(true);
        builder = builderFactory.newDocumentBuilder();
    }

    /**
     * Initialises all needed transformers.
     *
     * @throws TransformerConfigurationException May throw this during the parse
     *         when it is constructing the Templates object and fails.
     * @throws IOException If any IO errors occur.
     */
    private void initTransformers()
        throws TransformerConfigurationException, IOException {
        Thread.currentThread().setContextClassLoader(getClass().getClassLoader());
        tFactory = TransformerFactory.newInstance();
        tFactory.setErrorListener(new ProcessorErrorListener());
        tFactory.setURIResolver(new ResourceResolver());
        tOverviewAll = createTransformer("overview-all.xsl");
        tOverviewNamespaces = createTransformer("overview-namespaces.xsl");
        tOverviewNamespace = createTransformer("overview-namespace.xsl");
        tSchemaSummary = createTransformer("schema-summary.xsl");
        tSchemaIndex = createTransformer("schema-index.xsl");
        tComponent = createTransformer("component.xsl");
        tIndexAll = createTransformer("index-all.xsl");
        tIndex = createTransformer("index.xsl");
        tHtml = createTransformer("xml2html.xsl");
        tHelp = createTransformer("help-doc.xsl");
    }

    /**
     * Creates a transformer for a given file name.
     *
     * @param fileName file/path of XSLT file for transformer.
     * @return new Transformer instance
     * @throws TransformerConfigurationException May throw this during the parse
     *            when it is constructing the Templates object and fails.
     * @throws IOException If any IO errors occur.
     */
    private Transformer createTransformer(final String fileName)
        throws TransformerConfigurationException, IOException {
        if (debug) {
            getListener().debug("create transformer for " + fileName);
        }
        final String resourceName = "/" + this.resourcePrefix + "/xslt/" + fileName;
        final Source source = getResourceSource(resourceName, RESOURCE_PROTOCOL + resourceName);
        final Transformer transformer = tFactory.newTransformer(source);
        transformer.setErrorListener(tFactory.getErrorListener());
        if (transformer == null) {
            throw new TransformerConfigurationException("Cannot create transformer for " + fileName);
        }
        return transformer;
    }

    ////////////////////////////////////////////////
    // processing
    ////////////////////////////////////////////////

    /**
     * Main processing method.
     *
     * @throws TransformerException May throw this during the parse
     *         when it is constructing the Templates object and fails.
     * @throws SAXException If any parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws SchemaException if the schema is not valid
     */
    private void process() throws TransformerException, SAXException, IOException, SchemaException {
        if (debug) {
            getListener().debug("start processing...");
        }
        FileUtil.copyFile(getResource("/" + this.resourcePrefix + "/css/stylesheet.css"), out + FILE_SEP + "stylesheet.css");
        if (css != null) {
            try {
                FileUtil.copyFile(css, out + FILE_SEP + "stylesheet.css");
            } catch (IOException e) {
                getListener().error("CSS file not found: " + css);
            }
        }
        final String systemId = getSystemId(mainSchemaLocation);
        final Document schema;
        if (this.mainSchema == null) {
            mainSchema = getDocument(systemId);
            schema = mainSchema;
        } else {
            schema = mainSchema;
        }
        final Source source = getSource(schema, systemId);
        transform(source, tIndex, out + FILE_SEP + "index" + getExtension());
        transform(source, tOverviewAll, out, "overview-all");
        transform(source, tOverviewNamespaces, out, "overview-namespaces");
        transform(source, tSchemaSummary, out, "schema-summary");
        transform(source, tIndexAll, out, "index-all");
        transform(source, tHelp, out, "help-doc");
        process(schema, mainSchemaLocation);
    }

    /**
     * Process a schema document.
     *
     * @param schema root node of schema to process
     * @param schemaLocation location of current schema
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     * @throws SAXException If any XML parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws SchemaException If the processor encounters an unexpected
     *         problem with the schema being processed, usually an invalid
     *         schema document.
     */
    private void process(final Document schema, final String schemaLocation)
        throws TransformerException, SAXException, IOException, SchemaException {
        if (debug) {
            getListener().debug("process schema " + schemaLocation);
        }
        final String namespaceURI = getTargetNamespace(schema);
        final String subfolder = out + FILE_SEP + getFolderFromURI(namespaceURI.equals("") ? NO_NAMESPACE : namespaceURI);
        new File(subfolder).mkdir();
        final Source source = getSource(schema, getSystemId(schemaLocation));
        transform(source, tOverviewNamespace, subfolder, "overview-namespace");
        transform(source, tSchemaIndex, subfolder, "index");
        schemaLocationProcessedMap.clear();
        processComponents(schema, schemaLocation);
    }

    /**
     * Process all schema component of a schema.
     * <p>Redefined components are ignored here.</p>
     *
     * @param schema root Node of DOM tree of current schema
     * @param schemaLocation location of current schema
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation
     * @throws SAXException If any XML parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws SchemaException If the processor encounters an unexpected
     *         problem with the schema being processed, usually an invalid
     *         schema document.
     */
    private void processComponents(final Document schema,
                                   final String schemaLocation)
        throws TransformerException, SAXException, IOException, SchemaException {
        if (debug) {
            getListener().debug("process components of schema " + schemaLocation);
        }
        final Element schemaRoot = schema.getDocumentElement();
        final NodeList components = schemaRoot.getChildNodes();
        for (int i = 0; i < components.getLength(); i++) {
            final Node component = components.item(i);
            if (component.getNodeType() == Node.ELEMENT_NODE) {
                processComponent(schema, schemaLocation, component, component, "");
            }
        }
    }

    /**
     * Process top level components and nested element components.
     *
     * @param schema root Node of DOM tree of current schema
     * @param schemaLocation location of current schema
     * @param rootComponent root component (must be equal to component argument for top level
     *        components; for nested components: the corresponding top level component)
     * @param component component to process
     * @param parentName name of parent component
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     * @throws SAXException If any XML parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws SchemaException If the processor encounters an unexpected
     *         problem with the schema being processed, usually an invalid
     *         schema document.
     */
    private void processComponent(final Document schema,
                                  final String schemaLocation,
                                  final Node rootComponent,
                                  final Node component,
                                  final String parentName)
        throws TransformerException, SAXException, IOException, SchemaException {
        final String componentType = rootComponent.getLocalName();
        final String namespaceURI = getTargetNamespace(schema);
        final String subfolder = out + FILE_SEP + getFolderFromURI(namespaceURI.equals("") ? NO_NAMESPACE : namespaceURI);
        if ("import".equals(componentType)) {
            processImport(component, schemaLocation);
        } else if ("include".equals(componentType)) {
            processInclude(schema, component, schemaLocation);
        } else if ("annotation".equals(componentType)) {
            return; // ignore annotations here
        } else if ("redefine".equals(componentType)) {
            processInclude(schema, component, schemaLocation);
        } else {
            final String localName = DomUtil.getAttributeValue(component, "name");
            final String name;
            if (parentName == null || "".equals(parentName)) {
                name = localName;
            } else {
                name = parentName + "." + localName;
            }
            if (name == null) {
                getListener().info("Ignoring unnamed component " + componentType);
                return;
            }
            if (verbose) {
                final String targetNamespace = DomUtil.getAttributeValue(schema.getDocumentElement(), TARGETNAMESPACE);
                getListener().info("process " + componentType + " {" + targetNamespace + "}" + name + " from file "
                        + schemaLocation);
            }
            new File(subfolder).mkdir();
            new File(subfolder + FILE_SEP + componentType).mkdir();
            final Source source = getSource(schema, getSystemId(schemaLocation));
            if (!"".equals(parentName)) {
                ((Element) component).setAttributeNS(NAMESPACE_NAMESPACE, "xmlns:" + XSDDOC_PREFIX, XSDDOC_NAMESPACE);
                ((Element) component).setAttributeNS(XSDDOC_NAMESPACE, XSDDOC_PREFIX + ":" + XSDDOCID_ATTR, "a");
            }
            try {
                if (xml) {
                    transform(source, tComponent, component,
                        subfolder + FILE_SEP + componentType + FILE_SEP + name + getExtension(),
                        namespaceURI, componentType, name);
                } else {
                    final Node result = transform(source, tComponent, component, namespaceURI, componentType, name);
                    transform(new DOMSource(result, DOM_PROTOCOL), tHtml,
                        subfolder + FILE_SEP + componentType + FILE_SEP + name + getExtension());
                }
            } catch (Throwable t) {
                final Node result = createError(namespaceURI, componentType, name, t);
                transform(new DOMSource(result, DOM_PROTOCOL), tHtml,
                    subfolder + FILE_SEP + componentType + FILE_SEP + name + getExtension());
                getListener().error("xsddoc caused an error: " + ExceptionUtil.getMessage(t));
                if (isDebug()) {
                    getListener().debug(ExceptionUtil.printStackTrace(t));
                }
            }
            if (!"".equals(parentName)) {
                ((Element) component).removeAttributeNS(XSDDOC_NAMESPACE, XSDDOCID_ATTR);
            }
            if ("element".equals(componentType) || "complexType".equals(componentType) || "group".equals(componentType)) {
                searchLocalElementDeclarations(schema, schemaLocation, rootComponent, component, name);
            }
        }
    }

    /**
     * Creates an error page for a schema component.
     *
     * @param namespaceURI namespace URI of current schema
     * @param componentType type of component
     * @param name name of component
     * @param throwable the exception that occured during processing
     * @return DOM document with error information
     */
    private Node createError(final String namespaceURI, final String componentType, final String name,
            final Throwable throwable) {
        final DOMImplementation domImpl = builder.getDOMImplementation();
        final Document document = domImpl.createDocument(XSDDOC_NAMESPACE, "xsddoc", null);
        final Element xsddocElement = document.getDocumentElement();
        final Element componentElement = document.createElementNS(XSDDOC_NAMESPACE, "component");
        componentElement.setAttributeNS(null, "namespace", namespaceURI);
        componentElement.setAttributeNS(null, "name", name);
        componentElement.setAttributeNS(null, "type", componentType);
        xsddocElement.appendChild(componentElement);
        final Element errorElement = document.createElementNS(XSDDOC_NAMESPACE, "error");
        componentElement.appendChild(errorElement);
        final Text errorText = document.createTextNode(ExceptionUtil.printStackTrace(throwable));
        errorElement.appendChild(errorText);
        return document;
    }

    /**
     * Search for local declarations within a given component.
     *
     * @param schema root Node of DOM tree of current schema
     * @param schemaLocation location of current schema
     * @param rootComponent root component (must be equal to component argument for top level
     *        components; for nested components: the corresponding top level component)
     * @param component component to search in
     * @param parentName name of parent component
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation
     * @throws SAXException If any XML parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws SchemaException If the processor encounters an unexpected
     *         problem with the schema being processed, usually an invalid
     *         schema document.
     */
    private void searchLocalElementDeclarations(final Document schema,
                                                final String schemaLocation,
                                                final Node rootComponent,
                                                final Node component,
                                                final String parentName)
        throws TransformerException, SAXException, IOException, SchemaException {
        final NodeList components = component.getChildNodes();
        Node nestedComponent = null;
        for (int i = 0; i < components.getLength(); i++) {
            nestedComponent = components.item(i);
            if (nestedComponent.getNodeType() == Node.ELEMENT_NODE) {
                if ("element".equals(nestedComponent.getLocalName())) {
                    final String ref = DomUtil.getAttributeValue(nestedComponent, "ref");
                    final String type = DomUtil.getAttributeValue(nestedComponent, "type");
                    if (ref == null && type == null) {
                        processComponent(schema, schemaLocation, rootComponent, nestedComponent, parentName);
                    }
                } else {
                    searchLocalElementDeclarations(schema, schemaLocation, rootComponent, nestedComponent, parentName);
                }
            }
        }
    }

    /**
     * Process include element within the current schema.
     * <p>If the included schema doesn't have a target namespace, it is
     * processed as a cameleon schema, meaning the target namespace of the
     * including schema is temporary inherited to the included schema.</p>
     *
     * @param schema root Node of DOM tree of current schema
     * @param component the include element
     * @param schemaLocation location of current schema
     * @throws SAXException If any XML parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     * @throws SchemaException If the processor encounters an unexpected
     *         problem with the schema being processed, usually an invalid
     *         schema document.
     */
    private void processInclude(final Document schema,
                                final Node component,
                                final String schemaLocation)
        throws SAXException, IOException, TransformerException, SchemaException {
        final String rawSchemaLocation = DomUtil.getAttributeValue(component, "schemaLocation");
        if (rawSchemaLocation == null || "".equals(rawSchemaLocation)) {
            getListener().error("included schema without schemaLocation");
            return;
        }
        if (schemaLocationProcessedMap.containsKey(rawSchemaLocation)) {
            return;
        }
        schemaLocationProcessedMap.put(rawSchemaLocation, Boolean.TRUE);
        final String includedSchemaLocation = FileUtil.getLocation(schemaLocation, rawSchemaLocation);
        if (debug) {
            getListener().debug("process included schema " + includedSchemaLocation);
        }
        final Document includedSchema = getDocument(getSystemId(includedSchemaLocation));
        boolean isCameleon = false;
        if ("".equals(getTargetNamespace(includedSchema))) {
            isCameleon = true;
            setTargetNamespace(includedSchema, getTargetNamespace(schema));
        }
        processComponents(includedSchema, includedSchemaLocation);
        final NodeList components = component.getChildNodes();
        for (int i = 0; i < components.getLength(); i++) {
            final Node redefinedComponent = components.item(i);
            if (redefinedComponent.getNodeType() == Node.ELEMENT_NODE) {
                processComponent(schema, schemaLocation, redefinedComponent, redefinedComponent, "");
            }
        }
        if (isCameleon) {
            setTargetNamespace(includedSchema, "");
        }
    }

    /**
     * Process import element within the current schema.
     *
     * @param component the import element
     * @param schemaLocation location of current schema
     * @throws SAXException If any XML parse errors occur.
     * @throws IOException If any IO errors occur.
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     * @throws SchemaException If the processor encounters an unexpected
     *         problem with the schema being processed, usually an invalid
     *         schema document.
     */
    private void processImport(final Node component,
                               final String schemaLocation)
        throws SAXException, IOException, TransformerException, SchemaException {
        final String rawSchemaLocation = DomUtil.getAttributeValue(component, "schemaLocation");
        final String importedNamespace = DomUtil.getAttributeValue(component, "namespace");
        if (rawSchemaLocation == null || "".equals(rawSchemaLocation)) {
            getListener().error("imported schema without schemaLocation: " + importedNamespace);
            return;
        }
        if (schemaLocationProcessedMap.containsKey(rawSchemaLocation)) {
            return;
        }
        schemaLocationProcessedMap.put(rawSchemaLocation, Boolean.TRUE);
        final String importedSchemaLocation = FileUtil.getLocation(schemaLocation, rawSchemaLocation);
        if (debug) {
            getListener().info("process imported schema " + importedSchemaLocation);
        }
        if (!importCache.containsKey(importedSchemaLocation)) {
            importCache.put(importedSchemaLocation, importedSchemaLocation);
            final Document importedSchema = getDocument(getSystemId(importedSchemaLocation));
            process(importedSchema, importedSchemaLocation);
        } else if (debug) {
            getListener().debug("Abort import (already processed): " + importedSchemaLocation);
        }
    }

    ////////////////////////////////////////////////
    // transformation
    ////////////////////////////////////////////////

    /**
     * Transforms a source to either xml or html depending on current state of
     * processor.
     *
     * @param source the source
     * @param transformer the transformer
     * @param subfolder the target subfolder
     * @param fileName the target filename (without extension)
     * @throws IOException If any IO errors occur.
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     */
    private void transform(final Source source, final Transformer transformer,
                           final String subfolder, final String fileName)
        throws IOException, TransformerException {
        if (xml) {
            transform(source, transformer, subfolder + FILE_SEP + fileName + getExtension());
        } else {
            final Node result = transform(source, transformer);
            DomUtil.removeDuplicates(DomUtil.getFirstElementChild(result));
            transform(new DOMSource(result, DOM_PROTOCOL), tHtml, subfolder + FILE_SEP + fileName + getExtension());
        }
    }

    /**
     * Transforms a named and typed schema component from an XML Source to
     * a DOM tree.
     *
     * @param source The Source to read from
     * @param transformer the Transformer to transform with
     * @param component component to process
     * @param namespace targetNamespace of schema component
     * @param type type of schema component
     * @param name name of schema component
     * @return root Node of the resulting DOM tree
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     */
    private Node transform(final Source source, final Transformer transformer,
                           final Node component, final String namespace,
                           final String type, final String name)
        throws TransformerException {
        transformer.setParameter("component", component);
        transformer.setParameter("namespace", namespace);
        transformer.setParameter("type", type);
        transformer.setParameter("name", name);
        return transform(source, transformer);
    }

    /**
     * Transforms a named and typed schema component from an XML Source to
     * a file.
     *
     * @param source The Source to read from
     * @param transformer the Transformer to transform with
     * @param component component to process
     * @param outFile filename of output file
     * @param namespace targetNamespace of schema component
     * @param type type of schema component
     * @param name name of schema component
     * @throws FileNotFoundException  if the file exists but is a directory
     *         rather than a regular file, does not exist but cannot
     *         be created, or cannot be opened for any other reason
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     */
    private void transform(final Source source, final Transformer transformer, final Node component,
                           final String outFile, final String namespace, final String type, final String name)
        throws FileNotFoundException, TransformerException {
        transformer.setParameter("component", component);
        transformer.setParameter("namespace", namespace);
        transformer.setParameter("type", type);
        transformer.setParameter("name", name);
        transform(source, transformer, outFile);
    }

    /**
     * Transforms an XML Source with a given transformer into a DOM tree for
     * further processing.
     *
     * @param source The Source to read from
     * @param transformer the Transformer to transform with
     * @return root Node of the resulting DOM tree
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     */
    private Node transform(final Source source, final Transformer transformer)
        throws TransformerException {
        final DOMResult domResult = new DOMResult();
        setParameters(transformer);
        transformer.transform(source, domResult);
        return domResult.getNode();
    }

    /**
     * Transforms an XML source with a given transformer and writes result to
     * a file.
     *
     * @param source The Source to read from
     * @param transformer the Transformer to transform with
     * @param outFile filename of output file
     * @throws FileNotFoundException  if the file exists but is a directory
     *         rather than a regular file, does not exist but cannot
     *         be created, or cannot be opened for any other reason
     * @throws TransformerException If an unrecoverable error occurs
     *         during the course of the transformation.
     */
    private void transform(final Source source, final Transformer transformer, final String outFile)
        throws FileNotFoundException, TransformerException {
        if (debug) {
            getListener().debug("create " + outFile);
        }
        setParameters(transformer);
        transformer.transform(source, new StreamResult(new FileOutputStream(outFile)));
    }

    /**
     * Set xsddoc parameters to the transformer.
     *
     * @param transformer the transformer
     */
    private void setParameters(final Transformer transformer) {
        transformer.setParameter("schemaLocation", this.mainSchemaLocation);
        transformer.setParameter("doctitle", this.doctitle);
        if (this.header != null) {
            transformer.setParameter("header", this.header);
        } else {
            transformer.setParameter("header", this.doctitle);
        }
        if (this.footer != null) {
            transformer.setParameter("footer", this.footer);
        } else {
            transformer.setParameter("footer", "");
        }
        if (this.bottom != null) {
            transformer.setParameter("bottom", this.bottom);
        } else {
            transformer.setParameter("bottom", "");
        }
        transformer.setParameter("hideSubTypes", this.hideSubTypes ? "true" : "false");
        transformer.setParameter("hideLocalUsage", this.hideLocalUsage ? "true" : "false");
        transformer.setParameter("hideTypes", this.hideTypes ? "true" : "false");
        transformer.setParameter("hideAttributes", this.hideAttributes ? "true" : "false");
        transformer.setParameter("hideGroups", this.hideGroups ? "true" : "false");
        //DomUtil.getFirstElementChild(mainSchema);
        NodeList nl = mainSchema.getChildNodes();
        transformer.setParameter("mainSchema", nl);
    }

    ////////////////////////////////////////////////
    // helper
    ////////////////////////////////////////////////

    /**
     * Returns the SystemId for a given path.
     *
     * @param path the path
     * @return SystemId for given filename
     * @throws MalformedURLException If the path cannot be parsed as a URL
     */
    private String getSystemId(final String path) throws MalformedURLException {
        if (path.indexOf(':') > 0) {
            return path;
        }
        final File file = new File(path).getAbsoluteFile();
        final URL url = file.toURL();
        final String systemId = url.toExternalForm();
        return systemId;
    }

    /**
     * Returns identifier of target namespace or <code>"noNamespace"</code> if no
     * targetNamespace defined or empty.
     *
     * @param schema the schema to analyse
     * @return target namespace or <code>"noNamespace"</code> if no
     *         targetNamespace defined or empty
     */
    String getTargetNamespace(final Document schema) {
        final String targetNameSpace = DomUtil.getAttributeValue(schema.getDocumentElement(), TARGETNAMESPACE);
        return targetNameSpace == null ? "" : targetNameSpace;
    }

    /**
     * Sets or overwrites the targetNamespace in a schema.
     * <p>Setting the target namespace of schema means
     * <ul>
     * <li>setting the attribute <code>targetNamespace</code> to the value
     * of the target namespace and</li>
     * <li>setting the default namespace to the target namespace</li>
     * </ul>
     * @param schema the schema modify
     * @param namespace identifier
     */
    void setTargetNamespace(final Document schema, final String namespace) {
        final Element schemaElement = (Element) DomUtil.getFirstElementChild(schema);
        schemaElement.setAttributeNS(NAMESPACE_NAMESPACE, "xmlns", namespace);
        schemaElement.setAttribute(TARGETNAMESPACE, namespace == null ? "noNamespace" : namespace);
        //schemaElement.setAttributeNS(XMLSCHEMA_NAMESPACE, TARGETNAMESPACE, namespace == null ? "noNamespace" : namespace);
    }

    /**
     * Converts an URI to a folder name.
     *
     * <p>All characters that are not allowed in file names are replaced with
     * underscore.</p>
     *
     * @param uri the URI
     * @return folder name for that URI
     */
    private String getFolderFromURI(final String uri) {
        return StringUtil.replace(uri, ":/\\#?&!", '_');
    }

    /**
     * Returns an InputStream to a named resource.
     *
     * @param resourceName name of resource
     * @return InputStream to named resource
     * @throws IOException If named resource not found
     */
    private InputStream getResource(final String resourceName) throws IOException {
        if (debug) {
            getListener().debug("Loading resource " + resourceName);
        }
        synchronized (this) {
            final InputStream inputStream = this.getClass().getResourceAsStream(resourceName);
            if (inputStream == null) {
                throw new IOException("could not find resource " + resourceName);
            }
            return inputStream;
        }
    }

    /**
     * Cache handler for schema document cache.
     * <p>Creates, caches and returns cached DOM documents for given system-IDs.</p>
     * <p>Only schema with a valid target namespace are cached
     * This implies that cameleon schema are not cached.
     * This is important because a cameleon schema changes the
     * target namspace depending on the refering schema's target
     * namespace.</p>
     *
     * @param systemId system-ID of schema
     * @return DOM Document node of the schema
     * @throws SAXException If any parse errors occur.
     * @throws IOException If any IO errors occur.
     * @deprecated use getSource instead
     */
    Document getDocument(final String systemId) throws SAXException, IOException {
        Document doc = (Document) schemaCache.get(systemId);
        if (doc == null) {
            doc = builder.parse(systemId);
            if (doc != null) {
                final String targetNamespace = getTargetNamespace(doc);
                if (targetNamespace != null && !"".equals(targetNamespace)) {
                    schemaCache.put(systemId, doc);
                }
            }
        }
        return doc;
    }

    /**
     * Cache handler for sources of schema documents.
     * <p>Creates, caches and returns Source objects to given system-IDs.</p>
     *
     * @param doc DOM document
     * @param systemId system-ID of schema
     * @return Source of the schema
     * @throws SAXException If any parse errors occur.
     * @throws IOException If any IO errors occur.
     */
    Source getSource(final Document doc, final String systemId) throws SAXException, IOException {
        Source source = null; // XXX (Source) sourceCache.get(systemId);
        if (source == null) {
            if (doc == null) {
                source = new DOMSource(getDocument(systemId), systemId);
            } else {
                source = new DOMSource(doc, systemId);
            }
            sourceCache.put(systemId, source);
        }
        return source;
    }

    /**
     * Creates a source for a resource XML file.
     *
     * @param resourceName name of resource
     * @param systemId system-ID for the resource
     * @return Source of the schema
     * @throws IOException If any IO errors occur.
     */
    Source getResourceSource(final String resourceName, final String systemId) throws IOException {
        return new StreamSource(getResource(resourceName), systemId);
    }

    /**
     * URIResolver for resource files.
     */
    private final class ResourceResolver implements URIResolver {

        /** Reference to schema resolver. */
        private final URIResolver schemaResolver = new SchemaResolver();

        /**
         * URI resolver for XSLT files stored as resources in the xsddoc.jar file.
         * <p>Loaded resources are cached.</p>
         *
         * @see javax.xml.transform.URIResolver#resolve(java.lang.String, java.lang.String)
         * @param href An href attribute, which may be relative or absolute
         * @param base The base URI in effect when the href attribute was
         *             encountered.
         * @return A Source object, or null if the href cannot be resolved, and the
         *         processor should try to resolve the URI itself.
         * @throws TransformerException if an error occurs when trying to
         *         resolve the URI.
         */
        public Source resolve(final String href, final String base) throws TransformerException {
            try {
                if (href == null || "".equals(href)) {
                    return null; // should not happen
                } else if (href.indexOf(":") > 0) {
                    if (href.startsWith(RESOURCE_PROTOCOL)) {
                        final String resourceName = href.substring(base.indexOf(":") + 1);
                        return getResourceSource(resourceName, href);
                    }
                } else if (base != null) {
                    if (base.startsWith(RESOURCE_PROTOCOL)) {
                        final String baseName = base.substring(base.indexOf(":") + 1);
                        final String resourceName = baseName.substring(0, baseName.lastIndexOf("/") + 1) + href;
                        return getResourceSource(resourceName, RESOURCE_PROTOCOL + resourceName);
                    }
                }
                return schemaResolver.resolve(href, base);
            } catch (IOException e) {
                throw new TransformerException("Cannot resolve URI " + href + " for base URI " + base, e);
            }
        }
    }

    /**
     * URIResolver for included, imported or redefined schema files.
     */
    private final class SchemaResolver implements URIResolver {

        /**
         * Resolves a schema reference from <code>xs:include</code>,
         * <code>xs:import</code> or <code>xs:redefine</code> tags.
         *
         * <p>XSL-scripts that use the <code>document()</code> function can optionaly
         * add a <code>targetNamespace</code> CGI parameter to allow resolving
         * cameleon schema.</p>
         *
         * @param href An href attribute, which may be relative or absolute
         * @param base The base URI in effect when the href attribute was
         * @return A Source object, or null if the href cannot be resolved, and the
         *         processor should try to resolve the URI itself.
         * @throws TransformerException if an error occurs when trying to
         *         resolve the URI.
         */
        public Source resolve(final String href, final String base) throws TransformerException {
            try {
                final Document schema = getDocument(XMLUtil.getAbsoluteURI(href, base));
                if ("".equals(getTargetNamespace(schema))) {
                    final Document baseSchema = getDocument(base);
                    final String targetNamespace = getTargetNamespace(baseSchema);
                    setTargetNamespace(schema, targetNamespace);
                    return getSource(schema, XMLUtil.getAbsoluteURI(href, base));
                }
                return getSource(null, XMLUtil.getAbsoluteURI(href, base));
            } catch (SAXException e) {
                throw new TransformerException("Cannot resolve schema URI " + href + " for base URI " + base, e);
            } catch (IOException e) {
                throw new TransformerException("Cannot resolve schema URI " + href + " for base URI " + base, e);
            }
        }
    }

    /**
     * Error listener writing all events to console.
     */
    private final class ProcessorErrorListener implements ErrorListener {

        /**
         * Handler for warnings in transformations.
         *
         * @see javax.xml.transform.ErrorListener#warning(javax.xml.transform.TransformerException)
         * @param e The warning information encapsulated in a transformer exception
         */
        public void warning(final TransformerException e) {
            getListener().warn("xsddoc caused a warning: " + XMLUtil.getLocallizedMessageAndLocation(e));
        }

        /**
         * Handler for errors in transformations.
         *
         * @see javax.xml.transform.ErrorListener#error(javax.xml.transform.TransformerException)
         * @param e The error information encapsulated in a transformer exception
         */
        public void error(final TransformerException e) {
            getListener().error("xsddoc caused an error: " + XMLUtil.getLocallizedMessageAndLocation(e));
        }

        /**
         * Handler for fatal errors in transformations.
         *
         * @see javax.xml.transform.ErrorListener#fatalError(javax.xml.transform.TransformerException)
         * @param e The error information encapsulated in a transformer exception
         */
        public void fatalError(final TransformerException e) {
            getListener().fatal("xsddoc caused a fatal error: " + XMLUtil.getLocallizedMessageAndLocation(e));
            if (isDebug()) {
                getListener().debug(ExceptionUtil.printStackTrace(e));
            }
        }
    }

    /**
     * Implementation of the {@link net.sf.xframe.xsddoc.ProcessorListener}
     * interface that simple logs everything to the console.
     */
    public final class ConsoleListener implements ProcessorListener {

        /**
         * @see net.sf.xframe.xsddoc.ProcessorListener#debug(java.lang.String)
         */
        public void debug(final String message) {
            System.out.println(message);
        }

        /**
         * @see net.sf.xframe.xsddoc.ProcessorListener#info(java.lang.String)
         */
        public void info(final String message) {
            System.out.println(message);
        }

        /**
         * @see net.sf.xframe.xsddoc.ProcessorListener#warn(java.lang.String)
         */
        public void warn(final String message) {
            System.out.println(message);
        }

        /**
         * @see net.sf.xframe.xsddoc.ProcessorListener#error(java.lang.String)
         */
        public void error(final String message) {
            System.out.println(message);
        }

        /**
         * @see net.sf.xframe.xsddoc.ProcessorListener#fatal(java.lang.String)
         */
        public void fatal(final String message) {
            System.out.println(message);
        }
    }
}
