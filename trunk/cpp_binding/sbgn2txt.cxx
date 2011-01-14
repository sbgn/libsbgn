#include <memory>   // std::auto_ptr
#include <iostream>

#include "sbgn.hxx"

using namespace std;

void displayLabel(libsbgn::pd_0_1::label l, std::string indent)
{
    cout << indent << "Label " << l.text() << endl;
    if (l.bbox())
    {
        cout << indent << "\tBbox " << l.bbox()->x() << " " << l.bbox()->y();
        cout << " " << l.bbox()->w() << " " << l.bbox()->h() << endl;
    }
    if (l.font())
    {
        cout << indent << "\tFont " << l.font() << endl;
    }
    if (l.fontsize())
    {
        cout << indent << "\tFont size " << l.fontsize() << endl;
    }
}

void displayGlyph(libsbgn::pd_0_1::glyph g, std::string indent)
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

    for (libsbgn::pd_0_1::glyph::port_const_iterator p (g.port ().begin ()); p != g.port ().end (); ++p)
    {
        cout << indent << "\tPort " << p->id() << " " << p->x() << " " << p->y() << endl;
    }
                
    cout << indent << "\tBbox " << g.bbox().x() << " " << g.bbox().y();
    cout << " " << g.bbox().w() << " " << g.bbox().h() << endl;

    if (g.orientation())
    {
        cout << indent << "\tOrientation " << g.orientation() << endl;    
    }

    for (libsbgn::pd_0_1::glyph::glyph1_const_iterator subglyph (g.glyph1 ().begin ()); subglyph != g.glyph1 ().end (); ++subglyph)
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
            props.schema_location ("http://sbgn.org/libsbgn/pd/0.1", "../resources/SBGN.xsd");

            auto_ptr<libsbgn::pd_0_1::sbgn> s ( libsbgn::pd_0_1::sbgn_ (argv[i], 0, props) );

            std::cout << "****** " << argv[i] << " ******" << std::endl;

            for (libsbgn::pd_0_1::sbgn::map_const_iterator m (s->map ().begin ()); m != s->map ().end (); ++m)
            {
                cout << "Map" << endl;

                for (libsbgn::pd_0_1::map::glyph_const_iterator g (m->glyph ().begin ()); g != m->glyph ().end (); ++g)
                {
                    displayGlyph(*g, "\t");
                }  

                for (libsbgn::pd_0_1::map::arc_const_iterator a (m->arc ().begin ()); a != m->arc ().end (); ++a)
                {
                    cout << "\tArc from " << a->source() << " to " << a->target() << " (" << a->class_() << ")" << endl;
                    cout << "\t\tstarts at " << a->start().x() << " " << a->start().y() << endl;                
                    for (libsbgn::pd_0_1::arc::next_const_iterator n (a->next ().begin ()); n != a->next ().end (); ++n)
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
                    if (a->glyph())
                    {
                        cout << "\t\tArc stoichiometry:" << endl;
                        displayGlyph(*(a->glyph()), "\t\t");
                    }
                 }
            }
        }
        catch (const xml_schema::exception& e)
        {
            cerr << "SBGNML parsing error... " << endl;
            cerr << e << endl;
            return 1;
        }
    }
}