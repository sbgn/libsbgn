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

/**
 * String Utility methods.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class StringUtil {

    /**
     * Private default constructor to prevent instantiation.
     */
    private StringUtil() {
    }

    /**
     * Replaces all occurances of a character within chars with a new character.
     *
     * <p><b>Example</b><br/>
     * <code>StringUtil.replace("temp\test/test.txt", "\\/", '_')</code><br/>
     * results to <code>"temp.test.test.txt"</code></p>
     * @param text the text where to replace in
     * @param oldChar old character to replace
     * @param newChar new character to replace with
     * @return replaced text
     */
    public static String replace(final String text, final char oldChar, final char newChar) {
        final StringBuffer result = new StringBuffer(text);
        for (int i = 0; i < result.length(); i++) {
            if (result.charAt(i) == oldChar) {
                result.setCharAt(i, newChar);
            }
        }
        return result.toString();
    }

    /**
     * Replaces all occurances of characters of within chars with a new character.
     *
     * <p><b>Example</b><br/>
     * <code>StringUtil.replace("temp\test/test.txt", "\\/", '_')</code><br/>
     * results to <code>"temp.test.test.txt"</code></p>
     * @param text the text where to replace in
     * @param chars list of characters to replace
     * @param newChar new character to replace with
     * @return replaced text
     */
    public static String replace(final String text, final String chars, final char newChar) {
        final StringBuffer result = new StringBuffer(text);
        for (int i = 0; i < result.length(); i++) {
            for (int k = 0; k < chars.length(); k++) {
                if (result.charAt(i) == chars.charAt(k)) {
                    result.setCharAt(i, newChar);
                }
            }
        }
        return result.toString();
    }

    /**
     * Checks if two strings are equal.
     * The two strings are considered equal, if both references are
     * <code>null</code> or both strings are equal.
     *
     * @param string1 a string to compare
     * @param string2 another string to compare with
     * @return <code>true</code> if the two strings are equal,
     *         else <code>false</code>
     */
    public static boolean equals(final String string1, final String string2) {
        if (string1 != null) {
            return string1.equals(string2);
        }
        return string2 == null;
    }
}
