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

import java.io.File;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.taskdefs.MatchingTask;
import org.apache.tools.ant.types.FileSet;
import org.w3c.dom.Document;
import org.w3c.dom.Element;

/**
 * Adapter for xsddoc processor to Apache Ant.
 *
 * <p>Generates XML Schema documentation using the xsddoc tool.</p>
 * <h3>Parameters</h3>
 * <p><table border="1" cellspacing="0" cellpadding="2">
 * <tr><td><b>Attribute</b></td><td><b>Description</b></td><td><b>Required</b></td></tr>
 * <tr><td>schemaLoaction</td><td><b>deprecated</b>, see <code>file</code> parameter</td>
 * <td rowspan="3">Exactly one of the these or nested &lt;fileset></td></tr>
 * <tr><td>file</td><td>shortcut for specifying a single file fileset</td></tr>
 * <tr><td>dir</td><td>shortcut for specifying a single folder fileset</td></tr>
 * <tr><td>out</td><td>destination directory for output files</td><td>Yes</td></tr>
 * <tr><td>xml</td><td>If output should be XML instead of HTML. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>css</td><td>provide external CSS file</td><td>&amp;</td></tr>
 * <tr><td>title</td><td><b>deprecated</b>, see <code>doctitle</code> parameter</td><td>No</td></tr>
 * <tr><td>doctitle</td><td>Include title for the package index(first) page (html-code)</td><td>No</td></tr>
 * <tr><td>header</td><td>Include header text for each page (html-code)</td><td>No</td></tr>
 * <tr><td>footer</td><td>Include footer text for each page (html-code)</td><td>No</td></tr>
 * <tr><td>bottom</td><td>Include bottom text for each page (html-code)</td><td>No</td></tr>
 * <tr><td>failonerror</td><td>Log a warning message, but do not stop the
 * build, when the file to copy does not exist or one of the nested filesets
 * points to a directory that doesn't exist or an error occurs while copying.
 * (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>verbose</td><td>Output messages about what xsddoc is doing. (yes | no). Default is yes</td><td>No</td></tr>
 * <tr><td>quiet</td><td>Be quiet about what xsddoc is doing. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>debug</td><td>Output internal messages about what xsddoc is doing. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>hideSubTypes</td><td>hide sub types references. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>hideLocalUsage</td><td>hide local usage references. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>hideTypes</td><td>hide types in overview pages. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>hideGroups</td><td>hide groups in overview pages. (yes | no). Default is no</td><td>No</td></tr>
 * <tr><td>hideAttributes</td><td>hide attributes in overview pages. (yes | no). Default is no</td><td>No</td></tr>
 * <tr>
 * </table></p>
 *
 * <h3>Parameters specified as nested elements</h3>
 *
 * <h4>fileset</h4>
 * <p>
 * <a href="http://ant.apache.org/manual/CoreTypes/fileset.html">FileSets</a>
 * are used to select sets of files to process. To use a fileset, the todir
 * attribute must be set.</p>
 *
 * <h4>doctitle</h4>
 * <p>Same as the <code>doctitle</code> attribute, but you can nest text
 * inside the element this way.</p>
 * <h4>header</h4>
 * <p>Similar to <code>&lt;doctitle&gt;</code>.</p>
 * <h4>footer</h4>
 * <p>Similar to <code>&lt;doctitle&gt;</code>.</p>
 * <h4>bottom</h4>
 * <p>Similar to <code>&lt;doctitle&gt;</code>.</p>
 *
 * <dl><dt><b>Usage in Apache Ant build files:</b></dt><dd><pre>
 *&lt;!--
 *  Define xsddoc task.
 *-->
 *&lt;taskdef name="xsddoc" classname="net.sf.xframe.xsddoc.Task"/>
 *
 *&lt;!--
 *  Use xsddoc task.
 *-->
 *&lt;xsddoc file="myschema.xsd"
 *         out="doc/schema/myschema">
 *  &lt;doctitle>&lt;![CDATA[XML <code>Schema</code> for XML Schema]]>&lt;/doctitle>
 *&lt;/xsddoc>
 * </pre></dl>
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 *
 */
public final class Task extends MatchingTask {

    /** namespace of XML schema. */
    private static final String SCHEMA_NS = "http://www.w3.org/2001/XMLSchema";

    /** documentation footer. */
    private Html footer;

    /** Documentation Title. */
    private Html doctitle;

    /** Documentation header. */
    private Html header;

    /** Documentation bottom. */
    private Html bottom;

    /** Folder of schema files in case of folder based schema localisation. */
    private String dir = null;

    /** schema location in case of a single schema file.*/
    private String file = null;

    /** Fileset in case of fileset based schema localisation. */
    private Vector filesets = new Vector();

    /** Reference to the xsddoc processor. */
    private Processor processor = null;

    /**
     * Whether to stop the build, when the file to process does not exist or
     * one of the nested filesets points to a directory that doesn't exist or
     * an error occurs while copying.
     */
    private boolean failonerror = true;

    /** if verbose mode or not. */
    private boolean verbose = false;

    /** if debug mode or not. */
    private boolean debug = false;

    /** Reference to a DOM document builder. */
    private DocumentBuilder builder = null;

    /**
     * Default constructor.
     */
    public Task() {
        processor = new Processor();
    }

    /**
     * Execute xsddoc task.
     *
     * @throws BuildException if execution of xsddoc task failed
     */
    public void execute() throws BuildException {
        try {
            process();
        } catch (Exception e) {
            if (failonerror) {
                if (e instanceof BuildException) {
                    throw (BuildException) e;
                }
                throw new BuildException(e);
            }
            log(e.getMessage(), Project.MSG_WARN);
        }
    }

    /**
     * Execute xsddoc task.
     *
     * @throws ProcessorException if error occured during execution
     */
    private void process() throws ProcessorException {
        final int isFile = (file == null ? 0 : 1);
        final int isDir = (dir == null ? 0 : 1);
        final int isFileset = (filesets.size() == 0 ? 0 : 1);
        if (isFile + isDir + isFileset != 1) {
            throw new BuildException("Exactly one of the file or dir attributes, or a fileset element, must be set.");
        }
        if (doctitle != null) {
            processor.setDoctitle(doctitle.getText());
        }
        if (header != null) {
            processor.setHeader(header.getText());
        }
        if (footer != null) {
            processor.setFooter(footer.getText());
        }
        if (bottom != null) {
            processor.setBottom(bottom.getText());
        }
        if (file != null) {
            processor.setSchemaLocation(file);
            processor.execute();
        }
        if (dir != null) {
            final Document mediatorSchema = createDocument();
            final File folder = new File(dir);
            if (!folder.exists()) {
                throw new BuildException("not a directory: " + folder.getAbsolutePath());
            }
            final String[] files = folder.list();
            for (int i = 0; i < files.length; i++) {
                if (debug) {
                    System.out.println("found file " + files[i]);
                }
                final File theFile = new File(files[i]);
                if (!theFile.isDirectory()) {
                    addSchema(mediatorSchema, folder.getAbsolutePath(), files[i]);
                } else {
                    if (debug) {
                        System.out.println("Seems not to be a file " + files[i]);
                    }
                }
            }
            processor.setSchemaLocation(folder.getAbsolutePath() + File.separator + "mediator-schema");
            processor.setMainSchema(mediatorSchema);
            processor.execute();
        }
        if (filesets.size() > 0) {
            final Document mediatorSchema = createDocument();
            for (int i = 0; i < filesets.size(); i++) {
                final FileSet fileSet = (FileSet) filesets.elementAt(i);
                final DirectoryScanner scanner = fileSet.getDirectoryScanner(getProject());
                addSchemas(mediatorSchema, scanner.getBasedir().getAbsolutePath(), scanner);
            }
            processor.setSchemaLocation(getProject().getBaseDir().getAbsolutePath() + File.separator + "mediator-schema");
            processor.setMainSchema(mediatorSchema);
            processor.execute();
        }
    }

    /**
     * Creates a new empty DOM document.
     *
     * @return mediator schema as a DOM document
     */
    private Document createDocument() {
        final Document mediatorSchema = getDocumentBuilder().getDOMImplementation().createDocument(SCHEMA_NS, "schema", null);
        return mediatorSchema;
    }

    /**
     * Returns a DOM document builder.
     *
     * @return DOM document builder
     * @throws BuildException if the DocumentBuilder cannot be created
     */
    private DocumentBuilder getDocumentBuilder() throws BuildException {
        if (builder != null) {
            return builder;
        }
        try {
            final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            builder = factory.newDocumentBuilder();
            return builder;
        } catch (ParserConfigurationException e) {
            throw new BuildException(e);
        }
    }

    /**
     * Adds a set of schemas defined by the files in a DirectoryScanner to
     * a mediator schema.
     *
     * <p>A mediator schema is a schema that does nothing else than import
     * a set of other schemas.</p>
     *
     * @param mediatorSchema the mediator schema
     * @param base base file to resolve relative paths
     * @param scanner DirectoryScanner that defines the schema files to mediate
     */
    private void addSchemas(final Document mediatorSchema, final String base, final DirectoryScanner scanner) {
        final String[] files = scanner.getIncludedFiles();
        for (int i = 0; i < files.length; i++) {
            addSchema(mediatorSchema, base, files[i]);
        }
    }

    /**
     * Adds a schema defined by a file name to a mediator schema.
     * If the document at the given schema location is not a schema file,
     * the document is not added.
     *
     * @param mediatorSchema the meditator schema
     * @param base base file to resolve relative paths
     * @param schemaLocation location of the schema to add
     */
    private void addSchema(final Document mediatorSchema, final String base, final String schemaLocation) {
        String namespace = null;
        namespace = getNamespace(base, schemaLocation);
        if (namespace == null) {
            if (debug) {
                System.out.println("Seems not to be a schema, ignoring " + schemaLocation);
            }
            return;
        }
        if (verbose) {
            System.out.println("found schema " + schemaLocation);
        }
        final Element importNode = mediatorSchema.createElementNS(SCHEMA_NS, "import");
        final String schemaLoc = (new File(base, schemaLocation)).getAbsolutePath();
        importNode.setAttribute("schemaLocation", schemaLoc);
        importNode.setAttribute("namespace", namespace);
        mediatorSchema.getDocumentElement().appendChild(importNode);
    }

    /**
     * Extracts and returns the target namespace from a schema file.
     * The target namespace can be the empty string if the schema has no
     * target namespace. If the document is not a XML Schema, the returned value
     * is <tt>null</tt>.
     *
     * @param base base file name to resolve relative paths
     * @param filename file name of schema file
     * @return target namespace of schema or <tt>null</tt> if the document is not a schema
     */
    private String getNamespace(final String base, final String filename) {
        try {
            final Document schema = getDocumentBuilder().parse(new File(base, filename));
            final Element root = schema.getDocumentElement();
            if (!root.getLocalName().equals("schema") || !root.getNamespaceURI().equals(Task.SCHEMA_NS)) {
                return null;
            }
            return root.getAttribute("targetNamespace");
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    ////////////////////////////////////////////////
    // attribute setters
    ////////////////////////////////////////////////

    /**
     * Setter method for debug property.
     *
     * @param isDebug output debug information or not
     */
    public void setDebug(final boolean isDebug) {
        debug = isDebug;
        processor.setDebug(isDebug);
    }

    /**
     * Setter method for out property.
     *
     * @param out output folder to use
     */
    public void setOut(final String out) {
        processor.setOut(out);
    }

    /**
     * Setter method for schemaLocation property.
     *
     * @param schemaLocation location of XML schema to use
     * @deprecated use {@link #setFile(java.lang.String)} instead
     * @see #setFile(java.lang.String)
     */
    public void setSchemalocation(final String schemaLocation) {
        file = schemaLocation;
    }

    /**
     * Setter method for file property.
     *
     * @param theFile location of XML schema
     */
    public void setFile(final String theFile) {
        file = theFile;
    }

    /**
     * Setter method for dir property.
     *
     * @param theDir folder to search for schemas
     */
    public void setDir(final String theDir) {
        dir = theDir;
    }

    /**
     * Setter method for title property.
     *
     * @param title title to use
     * @deprecated use {@link #setDoctitle(java.lang.String)} instead
     * @see #setDoctitle(java.lang.String)
     */
    public void setTitle(final String title) {
        final Html html = new Html();
        html.addText(title);
        addDoctitle(html);
    }

    /**
     * Setter method for css property.
     *
     * @param css location of XML schema
     */
    public void setCss(final String css) {
        processor.setCss(css);
    }

    /**
     * Setter method for verbose property.
     *
     * @param isVerbose be verbose or not
     */
    public void setVerbose(final boolean isVerbose) {
        verbose = isVerbose;
        processor.setVerbose(isVerbose);
    }

    /**
     * Setter method for quiet property.
     *
     * @param isQuiet be quiet or not
     */
    public void setQuiet(final boolean isQuiet) {
        verbose = !isQuiet;
        processor.setVerbose(!isQuiet);
    }

    /**
     * Setter method for hideLocalUsage property.
     *
     * @param hideLocalUsage if local usage should be hidden or not
     */
    public void setHidelocalusage(final boolean hideLocalUsage) {
        processor.setHideLocalUsage(hideLocalUsage);
    }

    /**
     * Setter method for hideSubTypes property.
     *
     * @param hideSubTypes if sub types should be hidden or not
     */
    public void setHidesubtypes(final boolean hideSubTypes) {
        processor.setHideSubTypes(hideSubTypes);
    }

    /**
     * Setter method for hideTypes property.
     *
     * @param hideTypes if types should be hidden or not
     */
    public void setHidetypes(final boolean hideTypes) {
        processor.setHideTypes(hideTypes);
    }

    /**
     * Setter method for hideAttributes property.
     *
     * @param hideAttributes if attributes should be hidden or not
     */
    public void setHideattributes(final boolean hideAttributes) {
        processor.setHideAttributes(hideAttributes);
    }

    /**
     * Setter method for hideGroups property.
     *
     * @param hideGroups if groups should be hidden or not
     */
    public void setHidegroups(final boolean hideGroups) {
        processor.setHideGroups(hideGroups);
    }

    /**
     * Setter method for xml attribute.
     *
     * @param isXml boolean
     */
    public void setXml(final boolean isXml) {
        processor.setXml(isXml);
    }

    /**
     * Setter method for failonerror attribute.
     *
     * @param isFailonerror if should fail on error or not
     */
    public void setFailonerror(final boolean isFailonerror) {
        failonerror = isFailonerror;
    }

    ////////////////////////////////////////////////
    // nested tag setters
    ////////////////////////////////////////////////

    /**
     * Adds a set of files to be deleted.
     * @param set the set of files to be deleted
     */
    public void addFileset(final FileSet set) {
        filesets.addElement(set);
    }

    /**
     * Add a document title to use for the overview page.
     *
     * @param text the HTML element containing the document title.
     */
    public void addDoctitle(final Html text) {
        doctitle = text;
    }

    /**
     * Set the title of the generated overview page.
     *
     * @param theDoctitle the Document title.
     */
    public void setDoctitle(final String theDoctitle) {
        final Html html = new Html();
        html.addText(theDoctitle);
        addDoctitle(html);
    }

    /**
     * Set the header text to be placed at the top of each output file.
     *
     * @param theHeader the header text
     */
    public void setHeader(final String theHeader) {
        final Html html = new Html();
        html.addText(theHeader);
        addHeader(html);
    }

    /**
     * Set the header text to be placed at the top of each output file.
     *
     * @param theHeader the header text
     */
    public void addHeader(final Html theHeader) {
        header = theHeader;
    }

    /**
     * Set the footer text to be placed at the bottom of each output file.
     *
     * @param text the footer text.
     */
    public void addFooter(final Html text) {
        footer = text;
    }

    /**
     * Set the footer text to be placed at the bottom of each output file.
     *
     * @param theFooter the footer text.
     */
    public void setFooter(final String theFooter) {
        final Html html = new Html();
        html.addText(theFooter);
        addFooter(html);
    }

    /**
     * Set the text to be placed at the bottom of each output file.
     *
     * @param theBottom the bottom text.
     */
    public void setBottom(final String theBottom) {
        final Html html = new Html();
        html.addText(theBottom);
        addBottom(html);
    }

    /**
     * Set the text to be placed at the bottom of each output file.
     *
     * @param theBottom the bottom text.
     */
    public void addBottom(final Html theBottom) {
        bottom = theBottom;
    }

    /**
     * Setter method for createFolder attribute.
     *
     * @param createFolder if out folder should be created
     */
    protected void setCreateFolder(final boolean createFolder) {
        processor.setCreateFolder(createFolder);
    }

    /**
     * Setter method for lauch attribute.
     *
     * @param launch if documentation should be launched in browser
     */
    protected void setLauch(final boolean launch) {
        processor.setLaunch(launch);
    }

    /**
     * An HTML fragment in a nested element of the xsddoc task.
     *
     * This class is used for those nested xsddoc elements which can contain
     * HTML such as doctitle, footer or header.
     */
    public static final class Html {

        /** A buffer fot the text of the element. */
        private StringBuffer text = new StringBuffer();

        /**
         * Add text to the element.
         *
         * @param theText the text to be added.
         */
        public void addText(final String theText) {
            text.append(theText);
        }

        /**
         * Get the current text for the element.
         *
         * @return the current text.
         */
        public String getText() {
            return text.substring(0);
        }
    }
}
