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

import net.sf.xframe.ex.ExceptionUtil;

/**
 * Command line interface of xsddoc.
 *
 * <dl><dt><b>Usage:</b></dt><dd><pre>xsddoc [-option] schema
 *              (to document a schema)
 *where options include:
 *    -o -out &lt;folder>      Set the output folder
 *    -t -doctitle &lt;title>  Set the documentation title
 *    -h -header &lt;header>   Set the documentation header
 *    -f -footer &lt;footer>   Set the documentation footer
 *    -b -bottom &lt;bottom>   Set the documentation bottom
 *    -v -verbose           Output messages about what xsddoc is doing
 *    -q -quiet             Donot output any messages
 *    -s -hideSubTypes      hide sub types references
 *    -l -hideSubLocalUsage hide show local usage references
 *    -p -hideTypes         hide types in overview pages
 *    -g -hideGroups        hide groups in overview pages
 *    -a -hideAttributes    hide attributes in overview pages
 *    -xml                  output as XML instead of HTML
 *    -css &lt;css-file>    provide external CSS file
 *    -version              Only output version of xsddoc
 *    -launch               Launch documentation after creation
 *    -cf                   Create output folder if not exists
 *    -d -debug             Output debug messages
 *    -? -help              Print this help message
 *</pre></dl>
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class Main {

    /** version info. */
    private static final String VERSION = "1.0";

    /**
     * Private default constructor to prevent instantiation.
     */
    private Main() {
    }

    /**
     * Main method of command line interface of xsddoc.
     *
     * @param args Array of command line arguments
     */
    public static void main(final String[] args) {
        final Processor processor = new Processor();
        try {
            if (args.length < 1) {
                System.out.println("Missing schema argument.");
                usage();
                return;
            }
            int i = 0;
            while (i < args.length) {
                if (args[i].charAt(0) == '-') {
                    final String option = args[i].substring(1);
                    if ("o".equals(option) || "out".equals(option)) {
                        processor.setOut(args[++i]);
                    } else if ("t".equals(option) || "doctitle".equals(option)) {
                        processor.setDoctitle(args[++i]);
                    } else if ("h".equals(option) || "header".equals(option)) {
                        processor.setHeader(args[++i]);
                    } else if ("f".equals(option) || "footer".equals(option)) {
                        processor.setFooter(args[++i]);
                    } else if ("b".equals(option) || "bottom".equals(option)) {
                        processor.setBottom(args[++i]);
                    } else if ("v".equals(option) || "verbose".equals(option)) {
                        processor.setVerbose(true);
                    } else if ("q".equals(option) || "quiet".equals(option)) {
                        processor.setVerbose(false);
                    } else if ("d".equals(option) || "debug".equals(option)) {
                        processor.setDebug(true);
                    } else if ("s".equals(option) || "hideSubTypes".equals(option)) {
                        processor.setHideSubTypes(true);
                    } else if ("l".equals(option) || "hideLocalUsage".equals(option)) {
                        processor.setHideLocalUsage(true);
                    } else if ("p".equals(option) || "hideTypes".equals(option)) {
                        processor.setHideTypes(true);
                    } else if ("g".equals(option) || "hideGroups".equals(option)) {
                        processor.setHideGroups(true);
                    } else if ("a".equals(option) || "hideAttributes".equals(option)) {
                        processor.setHideAttributes(true);
                    } else if ("c".equals(option) || "css".equals(option)) {
                        processor.setCss(args[++i]);
                    } else if ("x".equals(option) || "xml".equals(option)) {
                        processor.setXml(true);
                    } else if ("cf".equals(option)) {
                        processor.setCreateFolder(true);
                    } else if ("launch".equals(option)) {
                        processor.setLaunch(true);
                    } else if ("version".equals(option)) {
                        System.out.println("xframe - xsddoc version " + VERSION);
                        return;
                    } else if ("?".equals(option) || "help".equals(option)) {
                        usage();
                        return;
                    } else {
                        System.out.println("unknown parameter: " + option);
                        usage();
                        return;
                    }
                } else {
                    processor.setSchemaLocation(args[i]);
                    break;
                }
                i++;
            }
            System.out.println("xsddoc starting.");
            processor.execute();
        } catch (Error e) {
            System.out.println(e.getLocalizedMessage());
            System.out.println(ExceptionUtil.printStackTrace(e));
        } catch (RuntimeException e) {
            System.out.println(e.getLocalizedMessage());
            System.out.println(ExceptionUtil.printStackTrace(e));
        } catch (Exception e) {
            System.out.println(e.getLocalizedMessage());
            if (processor.isDebug()) {
                System.out.println(ExceptionUtil.printStackTrace(e));
            }
        }
        System.out.println("xsddoc finished.");
    }

    /**
     * Print usage information to standard out.
     */
    private static void usage() {
        System.out.println("Usage: xsddoc [-option] schema");
        System.out.println("             (to document a schema)");
        System.out.println("where options include:");
        System.out.println("    -o -out <folder>      Set the output folder");
        System.out.println("    -t -doctitle <title>  Set the documentation title");
        System.out.println("    -h -header <header>   Set the documentation header");
        System.out.println("    -f -footer <footer>   Set the documentation footer");
        System.out.println("    -b -bottom <bottom>   Set the documentation bottom");
        System.out.println("    -v -verbose           Output messages about what xsddoc is doing");
        System.out.println("    -q -quiet             Be quiet about what xsddoc is doing");
        System.out.println("    -s -hideSubTypes      hide sub types references");
        System.out.println("    -l -hideSubLocalUsage hide show local usage references");
        System.out.println("    -p -hideTypes         hide types in overview pages");
        System.out.println("    -g -hideGroups        hide groups in overview pages");
        System.out.println("    -a -hideAttributes    hide attributes in overview pages");
        System.out.println("    -css &lt;css-file>    provide external CSS file");
        System.out.println("    -xml                  output as XML instead of HTML");
        System.out.println("    -launch               Launch documentation after creation");
        System.out.println("    -cf                   Create output folder if not exists");
        System.out.println("    -version              Only output version of xsddoc");
        System.out.println("    -d -debug             Output debug messages");
        System.out.println("    -? -help              Print this help message");
    }
}
