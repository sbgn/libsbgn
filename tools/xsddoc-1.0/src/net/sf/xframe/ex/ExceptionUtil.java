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
package net.sf.xframe.ex;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Method;
import java.util.StringTokenizer;

/**
 * This class provides basic facilities for manipulating exceptions.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class ExceptionUtil {

    /** line seperator. */
    private static final String LINE_SEPARATOR =
        System.getProperty("line.separator");

    /** name of method getCause. */
    private static final String GET_CAUSE_NAME = "getCause";

    /** parameters to getCause methods. */
    private static final Class[] GET_CAUSE_PARAMTYPES = new Class[0];

    /**
     * Private constructor to prevent instantiation.
     */
    private ExceptionUtil() {
    }

    /**
     * Generate string for specified exception and the cause of
     * this exception (if any).
     * @param throwable a <code>Throwable</code>
     * @return the stack trace as a <code>String</code>
     */
    public static String printStackTrace(final Throwable throwable) {
        return printStackTrace(throwable, 0, true);
    }

    /**
     * Generate string for specified exception and if printCascading
     * is true will print all cascading exceptions.
     * @param throwable a <code>Throwable</code>
     * @param printCascading if <code>true</code> will print all cascading
     *                       exceptions
     * @return the stack trace as a <code>String</code>
     */
    public static String printStackTrace(final Throwable throwable,
                                         final boolean printCascading) {
        return printStackTrace(throwable, 0, printCascading);
    }

    /**
     * Serialize the specified <code>Throwable</code> to a string.
     * Restrict the number of frames printed out to the specified depth.
     * If the depth specified is <code>0</code> then all the frames are
     * converted into a string.
     * @param throwable a <code>Throwable</code>
     * @param depth number of stack trace frames to show
     * @return the stack trace as a <code>String</code>
     */
    public static String printStackTrace(final Throwable throwable,
                                         final int depth) {
        int dp = depth;
        final String[] lines = captureStackTrace(throwable);
        if (0 == dp || dp > lines.length) {
            dp = lines.length;
        }
        final StringBuffer sb = new StringBuffer();
        for (int i = 0; i < dp; i++) {
            sb.append(lines[i]);
            sb.append(LINE_SEPARATOR);
        }
        return sb.toString();
    }

    /**
     * Generate exception string for specified exception to specified depth
     * and all Cascading exceptions if printCascading is true.
     * @param throwable a <code>Throwable</code>
     * @param depth number of stack trace frames to show
     * @param printCascading if <code>true</code> will print all cascading
     *                        exceptions
     * @return the stack trace as a <code>String</code>
     */
    public static String printStackTrace(final Throwable throwable,
                                         final int depth,
                                         final boolean printCascading) {
        return printStackTrace(throwable, depth, printCascading, true);
    }

    /**
     * Generate exception string for specified exception to specified depth
     * and all Cascading exceptions if printCascading is true. If useReflection
     * is true then the method will also attempt to use reflection to find a
     * method with signature <code>Throwable getCause()</code>. This makes
     * it compatible with JDK1.4 mechanisms for nesting exceptions.
     * @param throwable a <code>Throwable</code>
     * @param depth number of stack trace frames to show
     * @param printCascading if <code>true</code> will print all cascading
     *                       exceptions
     * @param useReflection if <code>true</code> will use reflection to handle
     *                      JDK1.4 nested exceptions
     * @return the stack trace as a <code>String</code>
     */
    public static String printStackTrace(final Throwable throwable,
                                         final int depth,
                                         final boolean printCascading,
                                         final boolean useReflection) {
        final String result = printStackTrace(throwable, depth);
        if (!printCascading) {
            return result;
        }
        final StringBuffer sb = new StringBuffer();
        sb.append(result);
        Throwable cause = getCause(throwable, useReflection);
        while (null != cause) {
            sb.append("rethrown from");
            sb.append(LINE_SEPARATOR);
            sb.append(printStackTrace(cause, depth));
            cause = getCause(cause, useReflection);
        }
        return sb.toString();
    }

    /**
     * Utility method to get cause of exception.
     * @param throwable a <code>Throwable</code>
     * @param useReflection if <code>true</code> will use reflection to handle
     *                      JDK1.4 nested exceptions
     * @return cause of specified exception
     */
    public static Throwable getCause(final Throwable throwable, final boolean useReflection) {
        if (throwable instanceof CascadingThrowable) {
            return ((CascadingThrowable) throwable).getCause();
        } else if (useReflection) {
            try {
                final Class clazz = throwable.getClass();
                final Method method =
                    clazz.getMethod(GET_CAUSE_NAME, GET_CAUSE_PARAMTYPES);
                return (Throwable) method.invoke(throwable, null);
            } catch (final Throwable t) {
                return null;
            }
        } else {
            return null;
        }
    }

    /**
     * Captures the stack trace associated with this exception.
     *
     * @param throwable a <code>Throwable</code>
     * @return an array of Strings describing stack frames.
     */
    public static String[] captureStackTrace(final Throwable throwable) {
        final StringWriter sw = new StringWriter();
        throwable.printStackTrace(new PrintWriter(sw, true));
        return splitString(sw.toString(), LINE_SEPARATOR);
    }

    /**
     * Splits the string on every token into an array of stack frames.
     *
     * @param string the string to split
     * @param onToken the token to split on
     * @return the resultant array
     */
    private static String[] splitString(final String string,
                                        final String onToken) {
        final StringTokenizer tokenizer = new StringTokenizer(string, onToken);
        final String[] result = new String[tokenizer.countTokens()];
        for (int i = 0; i < result.length; i++) {
            result[i] = tokenizer.nextToken();
        }
        return result;
    }

    /**
     * Returns the message of a throwable or the class name if the message is
     * null or empty.
     *
     * @param t any throwable
     * @return message or class name
     */
    public static String getMessage(final Throwable t) {
        final String s = t.getMessage();
        if (s == null || "".equals(s)) {
            return t.getClass().getName();
        }
        return s;
    }
}
