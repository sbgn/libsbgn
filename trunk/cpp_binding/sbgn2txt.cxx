#include <memory>   // std::auto_ptr
#include <iostream>

#include "sbgn.hxx"

using namespace std;

void displayLabel(libsbgn::sn_0_2::label l, std::string indent)
{
    cout << indent << "Label " << l.text() << endl;
    if (l.bbox())
    {
        cout << indent << "\tBbox " << l.bbox()->x() << " " << l.bbox()->y();
        cout << " " << l.bbox()->w() << " " << l.bbox()->h() << endl;
    }
}

void displayGlyph(libsbgn::sn_0_2::glyph g, std::string indent)
{
    cout << indent << "Glyph " << g.id() << " (" << g.class_() << ")" << endl;
    if (g.label())
    {
        displayLabel(*(g.label()), indent+"\t");
    }
    if (g.clone())
    {
        cout << indent << "\tClone" << endl;
        if (g.clone()->label())
        {
            displayLabel(*(g.clone()->label()), indent+"\t\t");
        }
    }

    for (libsbgn::sn_0_2::glyph::port_const_iterator p (g.port ().begin ()); p != g.port ().end (); ++p)
    {
        cout << indent << "\tPort " << p->id() << " " << p->x() << " " << p->y() << endl;
    }
                
    cout << indent << "\tBbox " << g.bbox().x() << " " << g.bbox().y();
    cout << " " << g.bbox().w() << " " << g.bbox().h() << endl;

    if (g.orientation())
    {
        cout << indent << "\tOrientation " << g.orientation() << endl;    
    }

    for (libsbgn::sn_0_2::glyph::glyph1_const_iterator subglyph (g.glyph1 ().begin ()); subglyph != g.glyph1 ().end (); ++subglyph)
    {
        displayGlyph(*subglyph, indent+"\t");
    }
}

int main (int argc, char* argv[])
{
    if (argc == 1)
    {
        cerr << "Enter a list of sbgn files as arguments" << endl;
        return 1;
    }

    for (int i = 1; i < argc; ++i)
    {
        try
        {
            xml_schema::properties props;
	    const char* schema_file = "../../resources/SBGN.xsd";
	    //props.no_namespace_schema_location (schema_file);
            props.schema_location ("http://sbgn.org/libsbgn/0.2", schema_file);
	    std::string fname = std::string(argv[i]);

            auto_ptr<libsbgn::sn_0_2::sbgn> s ( libsbgn::sn_0_2::sbgn_ (fname, 0, props) );

            std::cout << "****** " << fname << " ******" << std::endl;
	    const libsbgn::sn_0_2::map* m = &s->map ();
            // for (libsbgn::sn_0_2::sbgn::map::const_iterator m = smap.begin (); m != smap.end (); ++m)
            // {
                cout << "Map" << endl;

                for (libsbgn::sn_0_2::map::glyph_const_iterator g (m->glyph ().begin ()); g != m->glyph ().end (); ++g)
                {
                    displayGlyph(*g, "\t");
                }  

                for (libsbgn::sn_0_2::map::arc_const_iterator a (m->arc ().begin ()); a != m->arc ().end (); ++a)
                {
                    cout << "\tArc from " << a->source() << " to " << a->target() << " (" << a->class_() << ")" << endl;
                    cout << "\t\tstarts at " << a->start().x() << " " << a->start().y() << endl;                
                    for (libsbgn::sn_0_2::arc::next_const_iterator n (a->next ().begin ()); n != a->next ().end (); ++n)
                    {
                        if (n->point().size() == 0)
                        {
                            cout << "\t\tthen travels through " << n->x() << " " << n->y() << endl;             
                        }
                        if (n->point().size() == 1)
                        {
                            cout << "\t\tthen travels through " << n->x() << " " << n->y();
                            cout << "(quadratic Bezier " << n->point().begin()->x();
                            cout << " " << n->point().begin()->y() << ")" << endl;              
                        }
                        if (n->point().size() == 2)
                        {
                            cout << "\t\tthen travels through " << n->x() << " " << n->y();
                            cout << "(cubic Bezier " << n->point().begin()->x();
                            cout << " " << n->point().begin()->y();
                            cout << ", "<< (n->point().begin()++)->x();
                            cout << " " << (n->point().begin()++)->y() << ")" << endl;              
                        }
                    }
                    if (a->end().point().size() == 0)
                    {
                        cout << "\t\tand ends at " << a->end().x() << " " << a->end().y() << endl;                
                    }
                    if (a->end().point().size() == 1)
                    {
                        cout << "\t\tand ends at " << a->end().x() << " " << a->end().y();
                        cout << "(quadratic Bezier " << a->end().point().begin()->x();
                        cout << " " << a->end().point().begin()->y() << ")" << endl;                                
                    }
                    if (a->end().point().size() == 2)
                    {
                        cout << "\t\tand ends at " << a->end().x() << " " << a->end().y();
                        cout << "(cubic Bezier " << a->end().point().begin()->x();
                        cout << " " << a->end().point().begin()->y();
                        cout << ", "<< (a->end().point().begin()++)->x();
                        cout << " " << (a->end().point().begin()++)->y() << ")" << endl;              
                    }
                    for(libsbgn::sn_0_2::arc::glyph_const_iterator gi = a->glyph().begin(); gi != a->glyph().end(); ++gi)
                    {
                        cout << "\t\tArc stoichiometry:" << endl;
                        displayGlyph(*gi, "\t\t");
                    }
                 }
		//            }
        }
        catch (const xml_schema::exception& e)
        {
            cerr << "SBGNML parsing error... " << endl;
            cerr << e << endl;
            return 1;
        }
    }
}
