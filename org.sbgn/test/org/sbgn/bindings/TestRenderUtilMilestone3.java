package org.sbgn.bindings;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;

import javax.xml.bind.JAXBException;

import org.sbgn.*;
import org.xml.sax.InputSource;

import junit.framework.TestCase;

public class TestRenderUtilMilestone3 extends TestCase {
    static File file1 = new File("test-files/PD/render-info.sbgn");

    private static void checkDocument(Sbgn doc) throws JAXBException {
        assertTrue(doc != null);
        assertTrue(doc.getMap().size() == 1);

        Map map = doc.getMap().get(0);
        assertTrue(map != null);

        RenderInformation info = RenderUtil.getRenderInformation(map);
        assertTrue(info != null);

        assertTrue(info.getListOfColorDefinitions().getColorDefinition().size() == 2);
        assertTrue(info.getListOfGradientDefinitions().getLinearGradient().size() == 1);
        assertTrue(info.getListOfStyles().getStyle().size() == 1);

        Glyph g1 = map.getGlyph().get(0);
        assertTrue(g1 != null);

        Style style = RenderUtil.getStyle(info, g1);
        assertTrue(style != null);

        Float strokeWidth = (Float) RenderUtil.getStyleProperty(style, "strokeWidth");
        assertTrue(strokeWidth == 3.0f);
    }

    public static void testReadFromFile() throws JAXBException {
        assertTrue(file1.exists());

        Sbgn doc = SbgnUtil.readFromFile(file1);
        checkDocument(doc);
    }

    public static void testReadFromFileReader() throws JAXBException, IOException {
        assertTrue(file1.exists());

        Sbgn doc = SbgnUtil.readFrom(new FileReader(file1));
        checkDocument(doc);
    }

    public static void testReadFromFileInputStream() throws JAXBException, IOException {
        assertTrue(file1.exists());

        Sbgn doc = SbgnUtil.readFrom(new FileInputStream(file1));
        checkDocument(doc);
    }

    public static void testReadFromStringReader() throws JAXBException, IOException
    {
        assertTrue (file1.exists());
        
        String content = Util.readString(file1);
        assertTrue(content.length() > 0);

        Sbgn doc = SbgnUtil.readFrom(new StringReader(content));
        checkDocument(doc);    
    }
    
    public static void testReadFromByteArrayInputStream() throws JAXBException, IOException
    {
        assertTrue (file1.exists());
        
        String content = Util.readString(file1);
        assertTrue(content.length() > 0);

        Sbgn doc = SbgnUtil.readFrom(new ByteArrayInputStream(content.getBytes("UTF-8")));
        checkDocument(doc);    
    }

    
    public static void testReadFromFileInputSourceFromReader() throws JAXBException, IOException {
        assertTrue(file1.exists());

        Sbgn doc = SbgnUtil.readFrom(new InputSource(new FileReader(file1)));
        checkDocument(doc);
    }

    public static void testReadFromFileInputSourceFromStream() throws JAXBException, IOException {
        assertTrue(file1.exists());

        Sbgn doc = SbgnUtil.readFrom(new InputSource(new FileInputStream(file1)));
        checkDocument(doc);
    }


    public static void testReadFromStringInputSourceFromStream() throws JAXBException, IOException
    {
        assertTrue (file1.exists());
       
        String content = Util.readString(file1);
        assertTrue(content.length() > 0);

        Sbgn doc = SbgnUtil.readFrom(new InputSource(new ByteArrayInputStream(content.getBytes("UTF-8"))));
        checkDocument(doc);    
    }

    public static void testReadFromStringInputSourceFromReader() throws JAXBException, IOException
    {
        assertTrue (file1.exists());
        
        String content = Util.readString(file1);
        assertTrue(content.length() > 0);

        Sbgn doc = SbgnUtil.readFrom(new InputSource(new StringReader(content)));
        checkDocument(doc);    
    }
}
