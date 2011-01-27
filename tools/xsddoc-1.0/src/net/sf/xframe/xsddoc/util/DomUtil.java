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

import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * DOM Utility methods.
 *
 * @author <a href="mailto:kriede@users.sourceforge.net">Kurt Riede</a>
 */
public final class DomUtil {

    /**
     * Private default constructor to prevent instantiation.
     */
    private DomUtil() {
    }

    /**
     * Returns the first child node that is an element (type == ELEMENT_NODE).
     *
     * @param node the parent node
     * @return the first child element or <code>null</code> if non available
     */
    public static Node getFirstElementChild(final Node node) {
        final NodeList children = node.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            final Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                return child;
            }
        }
        return null;
    }

    /**
     * Returns the value of a named attribute of a given node.
     *
     * @param node an element node
     * @param name the name of an attribute
     * @return the attributes value or <code>null</code> if the attribute doesn't exist.
     */
    public static String getAttributeValue(final Node node, final String name) {
        try {
            return node.getAttributes().getNamedItem(name).getNodeValue();
        } catch (NullPointerException e) {
            return null;
        }
    }

    /**
     * Removes all duplicate children from a given node.
     *
     * @param parent the parent node of the children to process.
     * @return the given node
     */
    public static Node removeDuplicates(final Node parent) {
        if (parent == null) {
         return null;
        }
        final NodeList children = parent.getChildNodes();
        for (int i = children.getLength() - 1; i >= 0; i--) {
            final Node child = children.item(i);
            if (child.getNodeType() == Node.ELEMENT_NODE) {
                if (hasDuplicate(children, child)) {
                    parent.removeChild(child);
                }
            }
        }
        return parent;
    }

    /**
     * Checks if a node has a duplicate within a given NodeList.
     * The node itself might be contained in the list, but is ignored in the
     * check.
     *
     * @param children the node list to search in for duplicates
     * @param node the node to compare with
     * @return <code>true</code> if a duplicate is found, else <code>false</code>
     */
    private static boolean hasDuplicate(final NodeList children, final Node node) {
        for (int i = 0; i < children.getLength(); i++) {
            final Node child = children.item(i);
            if (child != node && child.getNodeType() == Node.ELEMENT_NODE) {
                if (equals(node, child)) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * Checks if two nodes are equal.
     * Two nodes are considered equal, if all the following conditions are valid:
     * <ul>
     * <li>both, node1 and node2 are not <code>null</code></li>
     * <li>the names are equal</li>
     * <li>all attributes of node1 are available in node2 and have the same value</li>
     * </ul>
     * <p>Text nodes are not compared.</p>
     * <p></p>
     *
     * @param node1 a node to compare
     * @param node2 another node to compare with
     * @return <code>true</code> if the two nodes are equal,
     *         else <code>false</code>
     */
    private static boolean equals(final Node node1, final Node node2) {
        if (node1 == null || node2 == null) {
            return false;
        }
        if (!node1.getNodeName().equals(node2.getNodeName())) {
            return false;
        }
        final NamedNodeMap attributes = node1.getAttributes();
        for (int i = 0; i < attributes.getLength(); i++) {
            final Node attribute1 = attributes.item(i);
            final NamedNodeMap attributes2 = node2.getAttributes();
            if (attributes2 == null) {
                return false; // no attributes available in node2, but expected
            }
            final Node attribute2 = node2.getAttributes().getNamedItem(attribute1.getNodeName());
            if (attribute2 == null) {
                return false; // attribute missing in node2
            }
            if (!StringUtil.equals(attribute1.getNodeValue(), attribute2.getNodeValue())) {
                return false; // attribute values are not equal
            }
        }
        return true; // no difference found so far: assume equality
    }
}
