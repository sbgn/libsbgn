graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 320.0
      y 160.0
      w 20.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.0
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
      x 170.0
      y 160.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "RAF"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
      anchor "bbc"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain,oval"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "<html>&nbsp;"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 150.0
      y 50.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.0
      gradient 0.0
      rounding 5.0
      type "tag"
    ]
    label "RAS"
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
      role "TAGRIGHT"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 320.0
      y 50.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "RAS"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
      anchor "bbc"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain,oval"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "active"
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
      x 450.0
      y 160.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 1.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "RAF"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
      anchor "bbc"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain,oval"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "P"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  edge [
    id 1
    source 1
    target 5
    SBGN [
      BendOut "340.0;160.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 340.0 y 160.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      frameThickness 1.0
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
    source 2
    target 1
    SBGN [
      BendIn "300.0;160.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 300.0 y 160.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "none"
      frameThickness 1.0
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 1.0
    ]
    sbgn [
      role "CONSUMPTION"
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
      docking [
        source "0;12"
      ]
      frameThickness 1.0
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "CATALYSIS"
    ]
  ]
  edge [
    id 4
    source 4
    target 3
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "none"
      frameThickness 1.0
      gradient 0.0
      rounding 5.0
      thickness 1.0
    ]
    sbgn [
      role "EQUIVALENCEARC"
    ]
  ]
]
