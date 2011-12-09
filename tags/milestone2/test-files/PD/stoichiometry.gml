graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 80.0
      y 80.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    label "lactose"
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
      x 280.0
      y 80.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    label "galactose"
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
      x 180.0
      y 80.0
      w 20.0
      h 20.0
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
    source 3
    target 2
    SBGN [
      BendOut "200.0;80.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 200.0 y 80.0 ]
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
    tgtLabel [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "box"
      position [
        absHor 0.0
        absVert -8.0
        alignSegment 0
        relAlign 0.666
      ]
      text "1"
      type "text"
    ]
  ]
  edge [
    id 2
    source 1
    target 3
    SBGN [
      BendIn "160.0;80.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 160.0 y 80.0 ]
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
    srcLabel [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "box"
      position [
        absHor 0.0
        absVert -8.0
        alignSegment 0
        relAlign 0.333
      ]
      text "2"
      type "text"
    ]
  ]
]
