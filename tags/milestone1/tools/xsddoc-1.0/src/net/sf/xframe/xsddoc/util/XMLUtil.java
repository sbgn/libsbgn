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
package net.sf.xframe.xsddoc.util;

import java.io.File;

import javax.xml.transform.TransformerException;

import org.apache.xml.utils.URI;
import org.apache.xml.utils.URI.MalformedURIException;
import org.xml.sax.SAXParseException;

/**
 * This class is used to resolve relative URIs and SystemID
 * strings into absolute URIs.
 *
 * <p>This is a generic utility for resolving URIs, other than the
 * fact that it's declared to throw TransformerException.  Please
 * see code comments for details on how resolution is performed.</p>
 *
 * <p>This utility class should be used instead of the original
 * class <code>org.apache.xml.utils.SystemIDResolver</code> to be independent
 * of xerces.</p>
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class XMLUtil {

    /**
     * Private constructor to prevent instantiation.
     */
    private XMLUtil() {
    }

    /**
     * Get absolute URI from a given relative URI.
     *
     * <p>The URI is resolved relative to the system property "user.dir"
     * if it is available; if not (i.e. in an Applet perhaps which
     * throws SecurityException) then it is currently resolved
     * relative to "" or a blank string.  Also replaces all
     * backslashes with forward slashes.</p>
     *
     * @param uri Relative URI to resolve
     *
     * @return Resolved absolute URI or the input relative URI if
     *         it could not be resolved.
     */
    public static String getAbsoluteURIFromRelative(final String uri) {
        String result = uri;
        String curdir = "";
        try {
            curdir = System.getProperty("user.dir");
        } catch (SecurityException se) {
            curdir = "";
        }
        if (null != curdir) {
            String base;
            if (curdir.startsWith(File.separator)) {
                base = "file://" + curdir;
            } else {
                base = "file:///" + curdir;
            }
            if (result != null) {
                // Note: this should arguably stick in a '/' forward
                //  slash character instead of the file separator,
                //  since we're effectively assuming it's a hierarchical
                //  URI and adding in the abs_path separator -s
                result = base + System.getProperty("file.separator") + uri;
            } else {
                result = base + System.getProperty("file.separator");
            }
        }

        if (null != result && (result.indexOf('\\') > -1)) {
            result = result.replace('\\', '/');
        }
        return result;
    }

    /**
     * Take a SystemID string and try and turn it into a good absolute URL.
     *
     * @param url A URL string, which may be relative or absolute.
     *
     * @return The resolved absolute URI
     */
    public static String getAbsoluteURI(final String url) {
        if (url.startsWith("..")) {
            return new File(url).getAbsolutePath();
        }
        if (url.startsWith(File.separator)) {
            return "file://" + url;
        } else if (url.indexOf(':') < 0) {
            return getAbsoluteURIFromRelative(url);
        }
        return url;
    }

    /**
     * Take a SystemID string and try and turn it into a good absolute URL.
     *
     * @param urlString SystemID string
     * @param base Base URI to use to resolve the given systemID
     *
     * @return The resolved absolute URI
     * @throws TransformerException thrown if the string can't be turned into a URL.
     */
    public static String getAbsoluteURI(final String urlString, final String base) throws TransformerException {
        String theUrlString = urlString;
        String theBase = base;
        boolean isAbsouteUrl = false;
        boolean needToResolve = false;
        if (theUrlString.indexOf(':') > 0) {
            isAbsouteUrl = true;
        } else if (theUrlString.startsWith(File.separator)) {
            theUrlString = "file://" + theUrlString;
            isAbsouteUrl = true;
        }
        if ((!isAbsouteUrl) && ((null == theBase) || (theBase.indexOf(':') < 0))) {
            if (theBase != null && theBase.startsWith(File.separator)) {
                theBase = "file://" + theBase;
            } else {
                theBase = getAbsoluteURIFromRelative(theBase);
            }
        }
        if ((null != theBase) && needToResolve) {
            if (theBase.equals(theUrlString)) {
                theBase = "";
            } else {
                final int protcolLength = theBase.indexOf(':') + 1;
                theUrlString = theUrlString.substring(protcolLength);
                isAbsouteUrl = false;
            }
        }
        if (null != theBase && (theBase.indexOf('\\') > -1)) {
            theBase = theBase.replace('\\', '/');
        }
        if (null != theUrlString && (theUrlString.indexOf('\\') > -1)) {
            theUrlString = theUrlString.replace('\\', '/');
        }
        final URI uri;
        try {
            if ((null == theBase) || (theBase.length() == 0) || (isAbsouteUrl)) {
                uri = new URI(theUrlString);
            } else {
                URI baseURI = new URI(theBase);

                uri = new URI(baseURI, theUrlString);
            }
        } catch (MalformedURIException mue) {
            throw new TransformerException(mue);
        }

        String uriStr = uri.toString();

        if ((Character.isLetter(uriStr.charAt(0))
            && (uriStr.charAt(1) == ':')
            && (uriStr.charAt(2) == '/')
            && (uriStr.length() == 3 || uriStr.charAt(3) != '/'))
            || ((uriStr.charAt(0) == '/') && (uriStr.length() == 1 || uriStr.charAt(1) != '/'))) {
            uriStr = "file:///" + uriStr;
        }
        return uriStr;
    }

    /**
     * Get the localized error message of a TransformerException with location
     * information appended.
     *
     * @param e the exception
     * @return A <code>String</code> representing the error message with
     *         location information appended.
     */
    public static String getLocallizedMessageAndLocation(final TransformerException e) {
        String systemID = null;
        int line = 0;
        int column = 0;
        if (null != e.getLocator()) {
            systemID = e.getLocator().getSystemId();
            line = e.getLocator().getLineNumber();
            column = e.getLocator().getColumnNumber();
        }
        final String message = e.getLocalizedMessage();
        return formaLocallizedMessageAndLocation(systemID, line, column, message);
    }

    /**
     * Formats the systemId, column and row into to a String.
     *
     * @param e the exception
     * @return formatted location
     */
    public static String getLocallizedMessageAndLocation(final SAXParseException e) {
        final String systemID = e.getSystemId();
        final int line = e.getLineNumber();
        final int column = e.getColumnNumber();
        final String message = e.getLocalizedMessage();
        return formaLocallizedMessageAndLocation(systemID, line, column, message);
    }

    /**
     * Formats a message and a location into a locallized string.
     *
     * @param systemID the systemID of the file (optional)
     * @param line the line number within the file (optional)
     * @param column the column  number within the file (optional)
     * @param message the message
     * @return a locallized message string with location
     */
    private static String formaLocallizedMessageAndLocation(final String systemID,
            final int line, final int column, final String message) {
        final StringBuffer sbuffer = new StringBuffer();
        if (null != systemID) {
            sbuffer.append(systemID);
        }
        if (0 != line) {
            sbuffer.append(":").append(line);
        }
        if (0 != column) {
            sbuffer.append(":").append(column);
        }
        if (null != message) {
            sbuffer.append(" ").append(message);
        }
        return sbuffer.toString();
    }
}
