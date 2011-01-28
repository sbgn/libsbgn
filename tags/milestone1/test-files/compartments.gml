graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 310.0
      y 140.0
      w 440.0
      h 140.0
      fill "#FFFFFF"
      outline "#666666"
      frameThickness 15.0
      gradient 0.0
      rounding 55.0
      type "rectangle"
    ]
    label "extracellular"
    labelgraphics [
      alignment "left"
      anchor "t"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "bold"
      type "text"
    ]
    sbgn [
      role "COMPARTMENT"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 310.0
      y 360.0
      w 440.0
      h 260.0
      fill "#FFFFFF"
      outline "#666666"
      frameThickness 15.0
      gradient 0.0
      rounding 55.0
      type "rectangle"
    ]
    label "cytosol"
    labelgraphics [
      alignment "left"
      anchor "t"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "bold"
      type "text"
    ]
    sbgn [
      role "COMPARTMENT"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 430.0
      y 230.0
      w 140.0
      h 160.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.ComplexShape"
    ]
    label ""
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "COMPLEX"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 220.0
      y 160.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "IGF"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  node [
    id 5
    zlevel -1

    graphics [
      x 170.0
      y 280.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "IGFR"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  node [
    id 6
    zlevel -1

    graphics [
      x 290.0
      y 280.0
      w 20.0
      h 20.0
      fill "#000000"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    label ""
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "ASSOCIATION"
    ]
  ]
  node [
    id 7
    zlevel -1

    graphics [
      x 430.0
      y 201.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "IGF"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  node [
    id 8
    zlevel -1

    graphics [
      x 430.0
      y 262.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "IGFR"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  edge [
    id 1
    source 4
    target 6
    SBGN [
      BendIn "270.0;280.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 270.0 y 280.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "none"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 10.0
    ]
    sbgn [
      role "CONSUMPTION"
    ]
  ]
  edge [
    id 2
    source 5
    target 6
    SBGN [
      BendIn "270.0;280.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 270.0 y 280.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "none"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 10.0
    ]
    sbgn [
      role "CONSUMPTION"
    ]
  ]
  edge [
    id 3
    source 6
    target 3
    SBGN [
      BendOut "310.0;280.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 310.0 y 280.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      docking [
        target "-1;0.62"
      ]
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "PRODUCTION"
    ]
  ]
]
