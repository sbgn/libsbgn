package org.sbgn;

import java.io.File;

import javax.xml.bind.JAXBException;
import javax.xml.transform.TransformerException;

import org.sbgn.SbgnUtil;
import org.sbgn.bindings.Arc;
import org.sbgn.bindings.ColorDefinition;
import org.sbgn.bindings.Glyph;
import org.sbgn.bindings.LinearGradient;
import org.sbgn.bindings.Map;
import org.sbgn.bindings.RenderInformation;
import org.sbgn.bindings.Sbgn;
import org.sbgn.bindings.Style;

public class ReadExampleWithRender
{

	private static void printRenderInfo(RenderInformation ri)
	{
		if (ri == null)
		{
			System.out.println("no render info");
			return;
		}

		if (ri.getBackgroundColor() != null && ri.getBackgroundColor().length() > 0)
		{
			System.out.println(String.format(" background color: %s", ri.getBackgroundColor()));
		}

		if (ri.getListOfColorDefinitions() != null)
		{
			for (ColorDefinition cd : ri.getListOfColorDefinitions().getColorDefinition())
			{
				System.out.println(String.format(" color def: %s = %s", cd.getId(), cd.getValue()));
			}
		}

		if (ri.getListOfGradientDefinitions() != null)
		{
			for (LinearGradient grad : ri.getListOfGradientDefinitions().getLinearGradient())
			{
				System.out.println(String.format(" grad def: %s = # %d stops", grad.getId(), grad.getStop().size()));
			}
		}

		if (ri.getListOfStyles() != null)
		{
			for (Style style : ri.getListOfStyles().getStyle())
			{
				System.out.println(String.format(" style def: applies to ids: %s  and types: %s", style.getIdList(), style.getTypeList()));
			}
		}

	}

	public static void main(String[] args) throws JAXBException, TransformerException
	{
		// our sbgnml file goes in "f"

		String fileName = "../test-files/PD/adh.sbgn";

		if (args.length > 0)
			fileName = args[0];

		File f = new File (fileName);
				
		// Now read from "f" and put the result in "sbgn"
		Sbgn sbgn = SbgnUtil.readFromFile(f);

		// map is a container for the glyphs and arcs 
		Map map = sbgn.getMap().get(0);

		RenderInformation ri = RenderUtil.getRenderInformation(map);
		if (ri == null)
		{
			System.out.println("This file contains no render information.");
			return;
		}
		else 
		{
			printRenderInfo(ri);
		}


		
		// we can get a list of glyphs (nodes) in this map with getGlyph()
		for (Glyph g : map.getGlyph())
		{
			// print the sbgn class of this glyph
			System.out.print (" Glyph with class " + g.getId());
			
			// if there is a label, print it as well
			if (g.getLabel() != null)
				System.out.print (", and label " + g.getLabel().getText());
			else
				System.out.print (", without label");

			// lets see if we have a render style for it
			Style style = RenderUtil.getStyle(ri, g);
			if (style != null)
			{
				System.out.println (String.format(", with style: fill: %s, stroke: %s, stroke-width: %f", 
				RenderUtil.getStyleProperty(style, "fill"), RenderUtil.getStyleProperty(style, "stroke"), 
				RenderUtil.getStyleProperty(style, "strokeWidth")));
			}
			else{
				System.out.println (", without style");
			}

		}

		// we can get a list of arcs (edges) in this map with getArc()
		for (Arc a : map.getArc())
		{
			// print the class of this arc
			System.out.println (" Arc with class " + a.getClazz());
		}
	
	}
}
