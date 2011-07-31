package org.sbgn;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;

/**
 * Work-around for java bug http://bugs.sun.com/view_bug.do?bug_id=4508058
 * Java does not properly handle the UTF-8 byte-order-mark. This problem can manifest as 
 * a "Content is not allowed in Prolog" error when reading XML.
 * <p>
 * This class will detect the byte order mark and instantiate the appropriate reader. 
 * Source: http://blog.publicobject.com/2010/08/handling-byte-order-mark-in-java.html
 */
public class InputStreamToReader
{
	public static Reader inputStreamToReader(InputStream xin) throws IOException 
	{
		BufferedInputStream in = new BufferedInputStream(xin);
		in.mark(3);
		int byte1 = in.read();
		int byte2 = in.read();
		if (byte1 == 0xFF && byte2 == 0xFE) {
			return new InputStreamReader(in, "UTF-16LE");
		} else if (byte1 == 0xFF && byte2 == 0xFF) {
			return new InputStreamReader(in, "UTF-16BE");
		} else {
			int byte3 = in.read();
			if (byte1 == 0xEF && byte2 == 0xBB && byte3 == 0xBF) {
				return new InputStreamReader(in, "UTF-8");
			} else {
				in.reset();
				return new InputStreamReader(in);
			}
		}
	}
}
