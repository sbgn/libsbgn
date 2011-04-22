graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 60.0
      y 150.0
      w 20.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.5
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label ""
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "PROCESS"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 60.0
      y 250.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "oval"
    ]
    label "GA-3P"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "SIMPLECHEMICAL"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 60.0
      y 50.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "oval"
    ]
    label "DHA-P"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "SIMPLECHEMICAL"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 210.0
      y 150.0
      w 120.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.5
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "<html><center>triose-P<br>isomerase"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  edge [
    id 1
    source 1
    target 2
    SBGN [
      BendOut "60.0;170.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 60.0 y 170.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 10.0
    ]
    sbgn [
      role "PRODUCTION"
    ]
  ]
  edge [
    id 2
    source 1
    target 3
    SBGN [
      BendIn "60.0;130.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 60.0 y 130.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 10.0
    ]
    sbgn [
      role "REVERSIBLECONSUMPTION"
    ]
  ]
  edge [
    id 3
    source 4
    target 1
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "catalysis"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "CATALYSIS"
    ]
  ]
]
