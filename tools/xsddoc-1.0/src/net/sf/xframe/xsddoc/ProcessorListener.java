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

/**
 * Listener interface for logging.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public interface ProcessorListener {

    /**
     * @param message the message of the event
     */
    void debug(String message);

    /**
     * @param message the message of the event
     */
    void info(String message);

    /**
     * @param message the message of the event
     */
    void warn(String message);

    /**
     * @param message the message of the event
     */
    void error(String message);

    /**
     * @param message the message of the event
     */
    void fatal(String message);
}