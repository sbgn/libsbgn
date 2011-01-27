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

import javax.xml.transform.TransformerException;

import net.sf.xframe.ex.XFrameException;
import net.sf.xframe.xsddoc.util.XMLUtil;

import org.xml.sax.SAXParseException;

/**
 * Exception class for excpetions occuring in the xsddoc processor.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 *
 */
public class ProcessorException extends XFrameException {

    /**
     * Construct a new <code>ProcessorException</code> instance.
     *
     * @param message The detail message for this exception.
     */
    public ProcessorException(final String message) {
        super(message);
    }

    /**
     * Construct a new <code>ProcessorException</code> instance.
     *
     * @param throwable the root cause of the exception
     */
    public ProcessorException(final Throwable throwable) {
        super(throwable);
    }

    /**
     * Construct a new <code>ProcessorException</code> instance.
     *
     * @param message The detail message for this exception.
     * @param throwable the root cause of the exception
     */
    public ProcessorException(final String message, final Throwable throwable) {
        super(message, throwable);
    }

    /**
     * @see java.lang.Throwable#getLocalizedMessage()
     */
    public final String getLocalizedMessage() {
        if (getCause() == null) {
            return super.getLocalizedMessage();
        } if (this.getCause() instanceof TransformerException) {
            return XMLUtil.getLocallizedMessageAndLocation((TransformerException) getCause());
        } else if (this.getCause() instanceof SAXParseException) {
            return XMLUtil.getLocallizedMessageAndLocation((SAXParseException) getCause());
        } else {
            return getCause().getLocalizedMessage();
        }
    }

    /**
     * @see java.lang.Throwable#getMessage()
     */
    public final String getMessage() {
        if (getCause() == null) {
            return super.getMessage();
        } if (this.getCause() instanceof TransformerException) {
            return XMLUtil.getLocallizedMessageAndLocation((TransformerException) getCause());
        }
        return getCause().getMessage();
    }
}
