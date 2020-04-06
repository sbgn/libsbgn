package org.sbgn;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;

import javax.xml.bind.JAXBException;

import org.junit.Test;
import org.sbgn.bindings.Sbgn;

public class SbgnUtilTest {

  @Test
  public void testUtfEncodingWithDifferentSystemFileEncoding() throws JAXBException {
    try {
      // modify the encoding that was taken from file.encoding system property
      // this is done at JVM startup therefore instead of changing system property we
      // must modify the cached value to simulate running it on the machine with
      // ISO-8859-1 encoding
      Field field = null;
      for (Field f : Charset.class.getDeclaredFields()) {
        if (f.getName().equals("defaultCharset")) {
          field = f;
        }
      }
      field.setAccessible(true);
      Field modifiersField = Field.class.getDeclaredField("modifiers");
      modifiersField.setAccessible(true);
      modifiersField.setInt(field, field.getModifiers() & ~Modifier.FINAL);

      field.set(null, StandardCharsets.ISO_8859_1);

      try {
        Sbgn sbgn = SbgnUtil.readFromFile(new File("test-files/PD/utf8_sbgn.0.2.sbgn"));
        assertEquals("β", sbgn.getMap().get(0).getGlyph().get(0).getLabel().getText());
      } finally {
        //restore default encoding to UTF-8
        field.set(null, StandardCharsets.UTF_8);
      }

    } catch (Exception e) {
      e.printStackTrace();
    }

  }

}
