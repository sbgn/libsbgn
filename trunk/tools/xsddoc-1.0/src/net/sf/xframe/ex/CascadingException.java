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

import java.io.PrintStream;
import java.io.PrintWriter;

/**
 * Class from which all xframe exceptions should inherit.
 * Allows recording of nested exceptions.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public class CascadingException extends Exception {

    /** The Throwable that caused this exception to be thrown. */
    private final Throwable cause;


    ////////////////////////////////////////////////
    //    construction
    ////////////////////////////////////////////////

    /**
     * Construct a new <code>CascadingException</code> instance.
     *
     * @param message The detail message for this exception.
     */
    public CascadingException(final String message) {
        this(message, null);
    }

    /**
     * Construct a new <code>CascadingException</code> instance.
     *
     * @param message The detail message for this exception.
     * @param throwable the root cause of the exception
     */
    public CascadingException(final String message, final Throwable throwable) {
        super(message);
        cause = throwable;
    }

    /**
     * Construct a new <code>CascadingException</code> instance.
     *
     * @param throwable the root cause of the exception
     */
    public CascadingException(final Throwable throwable) {
        super(throwable.getMessage());
        cause = throwable;
    }


    ////////////////////////////////////////////////
    //    interface CascadingThrowable
    ////////////////////////////////////////////////

    /**
     * Retrieve root cause of the exception.
     *
     * @return the root cause
     */
    public final Throwable getCause() {
        return cause;
    }


    ////////////////////////////////////////////////
    //    public methods
    ////////////////////////////////////////////////

    /**
     * Prints this <code>Throwable</code> and its backtrace to the
     * standard error stream.
     *
     * @see java.lang.Throwable#printStackTrace()
     */
    public final void printStackTrace() {
        super.printStackTrace();
    }

    /**
     * Prints this <code>Throwable</code> and its backtrace to the
     * specified print stream.
     *
     * @param s <code>PrintStream</code> to use for output
     *
     * @see java.lang.Throwable#printStackTrace(java.io.PrintStream)
     */
    public final void printStackTrace(final PrintStream s) {
        super.printStackTrace(s);
    }

    /**
     * Prints this <code>Throwable</code> and its backtrace to the specified
     * print writer.
     *
     * @param w <code>PrintWriter</code> to use for output
     *
     * @see java.lang.Throwable#printStackTrace(java.io.PrintWriter)
     */
    public final void printStackTrace(final PrintWriter w) {
        super.printStackTrace(w);
    }
}
