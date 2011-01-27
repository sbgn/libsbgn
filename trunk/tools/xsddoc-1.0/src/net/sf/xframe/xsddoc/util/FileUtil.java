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
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Static file utility methods.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class FileUtil {

    /** Size of buffer when copying files. */
    private static final int COPY_BUFFER_SIZE = 8192;

    /** file separator from <code>File.separator</code>. */
    private static final String FILE_SEP = File.separator;

    /**
     * Private default constructor to prevent instantiation.
     */
    private FileUtil() {
    }

    /**
     * Copy a file.
     *
     * @param in <code>InputStream</code>
     * @param destFile out as <code>File</code>
     * @throws IOException if file cannot ne copied
     */
    public static void copyFile(final InputStream in, final File destFile) throws IOException {
        if (destFile.exists() && destFile.isFile()) {
            destFile.delete();
        }
        FileOutputStream out = null;
        try {
            out = new FileOutputStream(destFile);
            copyFile(in, out);
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }

    /**
     * Copy a file.
     *
     * @param in <code>InputStream</code>
     * @param out as <code>OutputStream</code>
     * @throws IOException if file cannot ne copied
     */
    public static void copyFile(final InputStream in, final OutputStream out) throws IOException {
        final byte[] buffer = new byte[COPY_BUFFER_SIZE];
        int count = 0;
        do {
            out.write(buffer, 0, count);
            count = in.read(buffer, 0, buffer.length);
        } while (count != -1);
    }

    /**
     * Copy a file.
     *
     * @param in <code>InputStream</code>
     * @param destFile out file name
     * @throws IOException if file cannot ne copied
     */
    public static void copyFile(final InputStream in, final String destFile) throws IOException {
        copyFile(in, new File(destFile));
    }

    /**
     * Copy a file.
     *
     * @param inFile source file name
     * @param destFile destination file name
     * @throws IOException if file cannot ne copied
     */
    public static void copyFile(final String inFile, final String destFile) throws IOException {
        FileInputStream in = null;
        try {
            in = new FileInputStream(inFile);
            copyFile(in, destFile);
        } finally {
            if (in != null) {
                in.close();
            }
        }
    }

    /**
     * Returns the location of a file relative to a base file.
     *
     * @param baseFile the base file
     * @param file the file to be resolved
     * @return resolved location
     */
    public static String getLocation(final String baseFile, final String file) {
        if (baseFile == null || file.indexOf(':') > 0) {
            return file;
        }
        final String parent = new File(baseFile).getParent();
        if (parent == null) {
            return file;
        }
        return parent + FILE_SEP + file;
    }
}
