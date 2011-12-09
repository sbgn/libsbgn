graph [
  sbgn [
    role "ENTITYRELATIONSHIP"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 110.0
      y 50.0
      w 20.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 20.0
      type "rectangle"
    ]
    label "F"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "STATEVALUE"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 120.0
      y 160.0
      w 120.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "CaMKII"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
      fontStyle "plain"
      type "text"
    ]
    labelgraphics2 [
      alignment "center"
      anchor "bbc"
      color "#000000"
      fontName "Arial"
      fontSize 11
      fontStyle "box"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "mt:prot"
      type "text"
    ]
    labelgraphics3 [
      alignment "center"
      anchor "btr"
      color "#000000"
      fontName "Arial"
      fontSize 11
      fontStyle "capsule"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "T306"
      type "text"
    ]
    labelgraphics4 [
      alignment "center"
      anchor "btl"
      color "#000000"
      fontName "Arial"
      fontSize 11
      fontStyle "capsule"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "P@T286"
      type "text"
    ]
    sbgn [
      role "ENTITY"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 70.0
      y 50.0
      w 20.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 20.0
      type "rectangle"
    ]
    label "T"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "STATEVALUE"
    ]
  ]
  edge [
    id 1
    source 1
    target 2
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 90.0 y 90.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      arrowheadstyle "assignment"
      docking [
        target "-0.5;-5.0"
      ]
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "ASSIGNMENT"
    ]
  ]
  edge [
    id 2
    source 3
    target 2
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 90.0 y 90.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      arrowheadstyle "assignment"
      docking [
        target "-0.5;-5.0"
      ]
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "ASSIGNMENT"
    ]
  ]
]
