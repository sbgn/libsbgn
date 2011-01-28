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

import net.sf.xframe.ex.XFrameException;

/**
 * Exception class indicating problems with a schema.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 *
 */
public class SchemaException extends XFrameException {

    /**
     * Construct a new <code>SchemaException</code> instance.
     *
     * @param message The detail message for this exception.
     */
    public SchemaException(final String message) {
        super(message);
    }

    /**
     * Construct a new <code>SchemaException</code> instance.
     *
     * @param throwable the root cause of the exception
     */
    public SchemaException(final Throwable throwable) {
        super(throwable);
    }

    /**
     * Construct a new <code>SchemaException</code> instance.
     *
     * @param message The detail message for this exception.
     * @param throwable the root cause of the exception
     */
    public SchemaException(final String message, final Throwable throwable) {
        super(message, throwable);
    }

}
