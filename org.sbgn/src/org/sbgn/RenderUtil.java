package org.sbgn;

import java.io.IOException;
import java.io.StringWriter;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.stream.XMLStreamException;

import org.jdom.Namespace;
import org.sbgn.bindings.Arc;
import org.sbgn.bindings.ColorDefinition;
import org.sbgn.bindings.G;
import org.sbgn.bindings.Glyph;
import org.sbgn.bindings.LinearGradient;
import org.sbgn.bindings.LinearGradient.Stop;
import org.sbgn.bindings.ListOfColorDefinitions;
import org.sbgn.bindings.ListOfGradientDefinitions;
import org.sbgn.bindings.ListOfStyles;
import org.sbgn.bindings.Map;
import org.sbgn.bindings.RenderInformation;
import org.sbgn.bindings.SBGNBase;
import org.sbgn.bindings.Sbgn;
import org.sbgn.bindings.Style;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

/**
 * Utility class to make it easier dealing with Render information in Sbgn
 * elements.
 *
 */
public class RenderUtil {

	/**
	 * returns the render information object contained in an annotation of the given
	 * map element.
	 * 
	 * @param map the map element to get the RenderInformation off
	 * @return the render information object, or null if not found
	 * 
	 * @throws JAXBException
	 */
	public static RenderInformation getRenderInformation(Map map) throws JAXBException {
		return getRenderInformation((SBGNBase) map);
	}

	/**
	 * returns the render information object contained in an annotation of the given
	 * sbgn document.
	 * 
	 * @param document the sbgn document
	 * @return the render information object, or null if not found
	 * 
	 * @throws JAXBException
	 */
	public static RenderInformation getRenderInformation(Sbgn document) throws JAXBException {
		return getRenderInformation((SBGNBase) document);
	}

	/**
	 * While theoretically any sbgn element could contain a render information
	 * object, it really should only be on a map element (or the document element).
	 * The element will be searched in the following two namespaces:
	 * 
	 * - http://www.sbml.org/sbml/level3/version1/render/version1 -
	 * http://projects.eml.org/bcb/sbml/render/level2
	 * 
	 * with the former being preferred, as it is the official standard.
	 * 
	 * @param sbgnElement the element containing the render annotation
	 * @return the render information object, or null if not found.
	 * 
	 * @throws JAXBException
	 */
	private static RenderInformation getRenderInformation(SBGNBase sbgnElement) throws JAXBException {
		Element elt = SbgnUtil.getAnnotation(sbgnElement, "http://www.sbml.org/sbml/level3/version1/render/version1");

		if (elt == null) {
			elt = SbgnUtil.getAnnotation(sbgnElement, "http://projects.eml.org/bcb/sbml/render/level2");
			if (elt != null) {
				// well jaxb can't parse stuff from 2 namespaces, so we just move things into the l3 namespace
				elt = XmlUtil.replaceNamespace(elt, 
					Namespace.getNamespace("http://projects.eml.org/bcb/sbml/render/level2"), 
					Namespace.getNamespace("render", "http://www.sbml.org/sbml/level3/version1/render/version1"), 
					true);
					
				// see what we have
				System.out.println(XmlUtil.toString(elt));
			}
			else
			{
				return null;
			}
		}

		// also need to transform if we are in the dault namespace, otherwise the jaxb marshaller cant' find the 
		// information
		else if (XmlUtil.usesDefaultNamespace(elt))
		{
			elt = XmlUtil.replaceNamespace(elt, 
					Namespace.getNamespace("http://www.sbml.org/sbml/level3/version1/render/version1"), 
					Namespace.getNamespace("render", "http://www.sbml.org/sbml/level3/version1/render/version1"), 
					true);
		}



		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Unmarshaller unmarshaller = context.createUnmarshaller();

		RenderInformation result = (RenderInformation) unmarshaller.unmarshal(elt);
		return result;
	}

	/**
	 * sets the render information on the given sbgn document 
	 * @param document the document
	 * @param ri the render information object to set
	 * 
	 * @throws XMLStreamException
	 * @throws JAXBException
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public static void setRenderInformation(Sbgn document, RenderInformation ri)
			throws XMLStreamException, JAXBException, ParserConfigurationException, SAXException, IOException {
		setRenderInformation((SBGNBase) document, ri);
	}

	/**
	 * sets the render information on the given sbgn map
	 * @param map the map to store the render information on 
	 * @param ri the render information object to set. 
	 * 
	 * @throws XMLStreamException
	 * @throws JAXBException
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	public static void setRenderInformation(Map map, RenderInformation ri)
			throws XMLStreamException, JAXBException, ParserConfigurationException, SAXException, IOException {
		setRenderInformation((SBGNBase) map, ri);
	}

	/**
	 * While theoretically the object could be set on any SBGN element, the Map 
	 * element, or the Document element are the best place to store the 
	 * information on. 
	 * 
	 * This method will serialize the given render information object and store 
	 * it as annotation in the
	 * 
	 *  - http://www.sbml.org/sbml/level3/version1/render/version1
	 *  
	 * namespace. 
	 * 
	 * @param sbgnElement the sbgn element to store the render infomration on
	 * @param ri the render information to store. 
	 * 
	 * @throws XMLStreamException
	 * @throws JAXBException
	 * @throws ParserConfigurationException
	 * @throws SAXException
	 * @throws IOException
	 */
	private static void setRenderInformation(SBGNBase sbgnElement, RenderInformation ri)
			throws XMLStreamException, JAXBException, ParserConfigurationException, SAXException, IOException {
		StringWriter writer = new StringWriter();
		JAXBContext context = JAXBContext.newInstance("org.sbgn.bindings");
		Marshaller marshaller = context.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, Boolean.TRUE);
		marshaller.setProperty(Marshaller.JAXB_FRAGMENT, Boolean.TRUE);
		marshaller.marshal(ri, writer);

		SbgnUtil.addAnnotation(sbgnElement, writer.toString());

	}

	/**
	 * Adds a new color definition to the specified render information object 
	 * with given id and color string. 
	 * The color string should be of the form '#AARRGGBB' or '#RRGGBB'. Here 
	 * AA refers to a transparency value between 00 and FF.  Here 00 means the 
	 * color is 100% transparent and FF means it is 100% opaque. RR represents 
	 * the red portion of the color (again between 00 and FF), GG the green 
	 * portion and BB the blue portion.  
	 * 
	 * @param ri the render information object on which to create the color 
	 * definition object
	 * @param id the id for the new color definition object 
	 * @param argbString the RGB or ARGB string in the format as specified 
	 * above.
	 *  
	 * @return the color definition object in case some values need to be 
	 * changed later
	 */
	public static ColorDefinition addColorDefinition(RenderInformation ri, String id, String argbString) {
		ColorDefinition cd = new ColorDefinition();
		cd.setId(id);
		cd.setValue(argbString);

		if (ri.getListOfColorDefinitions() == null) {
			ri.setListOfColorDefinitions(new ListOfColorDefinitions());
		}

		ri.getListOfColorDefinitions().getColorDefinition().add(cd);
		return cd;
	}

	/** 
	 * adds a new style object to the render information object, with specified 
	 * idList (the id of map elements the style should apply to), fill (the id 
	 * of a color definition or gradient definition, or an ARGB / RGB string), 
	 * stroke (the id of a color definition or an ARGB/ RGB string)and 
	 * specified stroke width. 
	 * 
	 * @param ri the render information object on which to create the style
	 * @param idList a space separated string of all ids that this style should 
	 * apply to. 
	 * @param fill the id of a color definition or gradient definition, or an 
	 * ARGB / RGB string. The fill specifies how the element should be filled. 
	 * @param stroke the id of a color definition or an ARGB/ RGB string. The 
	 * stroke specifies how the element should be outlined
	 * @param strokeWidth a floating point value specifying how thick the 
	 * outline should be
	 * 
	 * @return the style object, so additional values can be adjusted later.  
	 */
	public static Style addStyle(RenderInformation ri, String idList, String fill, String stroke, float strokeWidth) {
		if (ri.getListOfStyles() == null) {
			ri.setListOfStyles(new ListOfStyles());
		}

		Style style = new Style();
		if (idList != null && idList.length() > 0)
			style.setIdList(idList);

		G g = new G();
		if (fill != null && fill.length() > 0)
			g.setFill(fill);
		if (stroke != null && stroke.length() > 0)
			g.setStroke(stroke);
		g.setStrokeWidth(strokeWidth);
		style.setG(g);

		ri.getListOfStyles().getStyle().add(style);
		return style;
	}

	/**
	 * Adds a linear gradient to the given render information object, with 
	 * specified id. The gradient will begin at x1=0%, y1=0% with color1, 
	 * and then change to x2=100%, y2=100% to color2. 
	 * 
	 * @param ri the render information object on which to create the linear gradient
	 * @param id the id of the gradient
	 * @param color1 the id of the color definition (or ARGB/RGB string) to start the gradient with. 
	 * @param color2 the id of the color definition (or ARGB/RGB string) to end the gradient with. 
	 *  
	 * @return the gradient object, in case additional properties need to be adjusted later
	 */
	public static LinearGradient addGradient(RenderInformation ri, String id, String color1, String color2)
	{
		return addGradient(ri, id, new String[][] {new String[] {"0%", color1}, new String[] {"100%", color2}});
	}

	/**
	 * Adds a linear gradient to the given render information object, with specified id. The gradient will go along the line of x1=0%, y1=0%  to x2=100%, y2=100% with the colors changing as specified in the stops array. 
	 * 
	 * @param ri the render information object on which to create the linear gradient
	 * @param id the id of the gradient
	 * @param stops a 2D array of strings holding the gradient stops. Each entry in the array should consist of another array of 2 strings, representing the percentage and the id (or ARGB/RGB string) of a color to use at that percentage. For example the convenience method with 2 colors, uses the stops: new String[][] {new String[] {"0%", color1}, new String[] {"100%", color2}} 
	 * @return the gradient object, in case additional properties need to be adjusted later
	 */
	public static LinearGradient addGradient(RenderInformation ri, String id, String[][] stops)
	{
		return addGradient(ri, id, "0%", "0%", "100%", "100%", stops );		
	}

	/**
	 * Adds a linear gradient to the given render information object, with specified id.
	 * 
	 * @param ri the render information object on which to create the linear gradient
	 * @param id the id of the gradient
	 * @param x1 start x percentage relative to the bounding box at which to start the gradient
	 * @param y1 start y percentage relative to the bounding box at which to start the gradient
	 * @param x2 end x percentage relative to the bounding box at which to end the gradient
	 * @param y2 end y percentage relative to the bounding box at which to end the gradient
	 * @param stops a 2D array of strings holding the gradient stops. Each entry in the array should consist of another array of 2 strings, representing the percentage and the id (or ARGB/RGB string) of a color to use at that percentage. For example the convenience method with 2 colors, uses the stops: new String[][] {new String[] {"0%", color1}, new String[] {"100%", color2}}
	 * @return the gradient object, in case additional properties need to be adjusted later
	 */
	public static LinearGradient addGradient(RenderInformation ri, String id, String x1, String y1, String x2, String y2, String[][] stops)
	{
		if (ri.getListOfGradientDefinitions() == null)
			ri.setListOfGradientDefinitions(new ListOfGradientDefinitions());
		LinearGradient gradient = new LinearGradient();
		gradient.setId(id);

		gradient.setX1(x1);
		gradient.setY1(y1);
		gradient.setX2(x2);
		gradient.setY2(y2);		

		for (int i = 0; i < stops.length; i++)
		{
			String[] current = stops[i];
			if (current == null || current.length != 2)
				continue;

			Stop stop = new Stop();
			stop.setOffset(current[0]);
			stop.setStopColor(current[1]);

			gradient.getStop().add(stop);
		}

		ri.getListOfGradientDefinitions().getLinearGradient().add(gradient);
		return gradient;
	}

	/**
	 * Returns the style object for the given SBGN element. For that it will look first through the styles by their idlist, and then if not found tries to find a style that matches the elements class.  
	 * 
	 * @param ri the render information object to search
	 * @param sbgnElement the sbgn element. 
	 * 
	 * @return the style object if found, null otherwise
	 */
	public static Style getStyle(RenderInformation ri, Glyph sbgnElement)
	{
		if (ri.getListOfStyles() == null) return null;

		Style result = getStyleById(ri, sbgnElement.getId());

		if (result == null)
			result = getStyleByClass(ri, sbgnElement.getClazz());

		return result;
	}

	/**
	 * Returns the style object for the given SBGN element. For that it will look first through the styles by their idlist, and then if not found tries to find a style that matches the elements class.  
	 * 
	 * @param ri the render information object to search
	 * @param sbgnElement the sbgn element. 
	 * 
	 * @return the style object if found, null otherwise
	 */
	public static Style getStyle(RenderInformation ri, Arc sbgnElement)
	{
		if (ri.getListOfStyles() == null) return null;

		Style result = getStyleById(ri, sbgnElement.getId());

		if (result == null)
			result = getStyleByClass(ri, sbgnElement.getClazz());

		return result;
	}

	/**
	 * returns the style object for a style in the given render information object, that has the specified id in its idlist
	 * 
	 * @param ri the render information object to search
	 * @param id the id of the element this style should apply to
	 * 
	 * @return the style object if found, null otherwise
	 */
	public static Style getStyleById(RenderInformation ri, String id)
	{
		if (ri.getListOfStyles() == null) return null;

		if (id == null || id.length() == 0  ) return null;

		for (Style style : ri.getListOfStyles().getStyle())
		{
			String idList = style.getIdList();
			if (idList == null)
			  continue;
			idList = idList.replace("&#32;", " ");
			idList = idList.trim();
			if (idList.equals(id))
				return style;
			if (idList.startsWith(id + " "))
				return style;
			if (idList.endsWith(" " + id))
				return style;
			if (idList.contains(" " + id + " "))
				return style;
		}

		return null;
	}

	/**
	 * returns the style object for a style in the given render information object, that has the specified clazz in its typeList
	 * 
	 * @param ri the render information object to search
	 * @param clazz the class of the element the style should apply to
	 * 
	 * @return the style object if found, null otherwise
	 */
	public static Style getStyleByClass(RenderInformation ri, String clazz)
	{
		if (ri.getListOfStyles() == null) return null;

		if (clazz == null || clazz.length() == 0  ) return null;

		for (Style style : ri.getListOfStyles().getStyle())
		{
			String typeList = style.getTypeList();
			if (typeList == null)
			  continue;

			typeList = typeList.replace("&#32;", " ");
			typeList = typeList.trim();
			if (typeList.equals(clazz))
				return style;
			if (typeList.startsWith(clazz + " "))
				return style;
			if (typeList.endsWith(" " + clazz))
				return style;
			if (typeList.contains(" " + clazz + " "))
				return style;
		}

		return null;
	}

	/**
	 * Returns the color definition with the given id
	 * 
	 * @param ri the render information object to look through
	 * @param id the id to find
	 * 
	 * @return the color definition with given id, or null
	 */
	public static ColorDefinition getColorDefinition(RenderInformation ri, String id)
	{
		if (ri == null || ri.getListOfColorDefinitions() == null)
			return null;

		for (ColorDefinition cd : ri.getListOfColorDefinitions().getColorDefinition())
			if (cd.getId().equals(id))
				return cd;
		return null;
	}


	/**
	 * Return the gradient definition with the given id
	 * 
	 * @param ri the render information object to look through
	 * @param id the id of the gradient to find. 
	 * 
	 * @return the gradient definition with given id, or null
	 */
	public static LinearGradient getGradient(RenderInformation ri, String id)
	{
		if (ri == null || ri.getListOfGradientDefinitions() == null)
			return null;

		for (LinearGradient grad : ri.getListOfGradientDefinitions().getLinearGradient())
			if (grad.getId().equals(id))
				return grad;
		return null;	
	}

	public static Object getStyleProperty(Style style, String property)
	{
		if (style == null || style.getG() == null)
			return "";

		if (property.equalsIgnoreCase("fill"))
			return style.getG().getFill();
		if (property.equalsIgnoreCase("stroke"))
			return style.getG().getStroke();
		if (property.equalsIgnoreCase("strokeWidth"))
			return style.getG().getStrokeWidth();
		if (property.equalsIgnoreCase("FontFamily"))
			return style.getG().getFontFamily();
		if (property.equalsIgnoreCase("FontSize"))
			return style.getG().getFontSize();
	
		return "";
	}

}