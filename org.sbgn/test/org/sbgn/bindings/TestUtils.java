package org.sbgn.bindings;

import java.io.*;
import org.sbgn.*;
import org.xml.sax.InputSource;

import junit.framework.TestCase;

public class TestUtils extends TestCase {

    static File file1 = new File("test-files/PD/render-info-m2.sbgn");

    public static void testCopy()
    {
        assertTrue(file1.exists());
        String content = Util.readString(file1);        
        assertTrue(content.length() > 0);       
    }
    
    public static void testCopyFromStringInputSource() throws IOException
    {
        assertTrue(file1.exists());
        String content = Util.readString(file1);
        assertTrue(content.length() > 0);       
        
        StringWriter target = new StringWriter();
        InputSource source = new InputSource(new ByteArrayInputStream(content.getBytes("UTF-8")));
        
        Util.copyFile(source, target);

        String content2 = target.toString();
        
        assertTrue(content.equals(content2));
        
    }

    public static void testCopyFroFileInputSource() throws IOException
    {
        assertTrue(file1.exists());
        String content = Util.readString(file1);
        assertTrue(content.length() > 0);       
        
        StringWriter target = new StringWriter();
        InputSource source = new InputSource(new FileReader(file1));
        
        Util.copyFile(source, target);

        String content2 = target.toString();
        
        assertTrue(content.equals(content2));
        
    }


    public static void testUriFromInputSourceFromFileReader() throws FileNotFoundException
    {
        String uri = XmlUtil.getDocumentUri(new InputSource(new FileReader(file1)));
        assertTrue(uri != null && !uri.isEmpty());
        assertTrue(uri.contentEquals("http://sbgn.org/libsbgn/0.2"));
    }

    public static void testUriFromInputSourceFromFileInputStream() throws FileNotFoundException
    {
        String uri = XmlUtil.getDocumentUri(new InputSource(new FileInputStream(file1)));
        assertTrue(uri != null && !uri.isEmpty());
        assertTrue(uri.contentEquals("http://sbgn.org/libsbgn/0.2"));
    }

    public static void testUriFromFileInputStream() throws FileNotFoundException
    {
        String uri = XmlUtil.getDocumentUri(new FileInputStream(file1));
        assertTrue(uri != null && !uri.isEmpty());
        assertTrue(uri.contentEquals("http://sbgn.org/libsbgn/0.2"));
    }
}