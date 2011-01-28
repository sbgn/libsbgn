graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 120.0
      y 270.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    label "Ethanol"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "SIMPLECHEMICAL"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 320.0
      y 180.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    label "NADH"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
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
      x 250.0
      y 110.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "ADH1"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 160.0
      y 180.0
      w 24.0
      h 24.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    sbgn [
      role "PROCESS"
    ]
  ]
  edge [
    id 1
    source 1
    target 4
    SBGN [
      BendIn "136.0;180.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 70.0 y 270.0 ]
        point [ x 70.0 y 180.0 ]
        point [ x 136.0 y 180.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "none"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "CONSUMPTION"
    ]
  ]
  edge [
    id 2
    source 4
    target 2
    SBGN [
      BendOut "184.0;180.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 184.0 y 180.0 ]
        point [ x 190.0 y 180.0 ]
        point [ x 190.0 y 240.0 ]
        point [ x 240.0 y 240.0 ]
        point [ x 240.0 y 180.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "PRODUCTION"
    ]
  ]
  edge [
    id 3
    source 3
    target 4
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 250.0 y 50.0 ]
        point [ x 160.0 y 50.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      arrowheadstyle "catalysis"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 18.0
    ]
    sbgn [
      role "CATALYSIS"
    ]
  ]
]
