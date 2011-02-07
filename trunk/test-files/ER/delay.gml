graph [
  sbgn [
    role "ENTITYRELATIONSHIP"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 450.0
      y 295.0
      w 42.0
      h 42.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    label "<html><b>&#964;"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Serif"
      fontSize 25
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "DELAYOPERATOR"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 635.0
      y 140.0
      w 20.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 20.0
      type "rectangle"
    ]
    label "P"
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
    id 3
    zlevel -1

    graphics [
      x 590.0
      y 320.0
      w 180.0
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
    id 4
    zlevel -1

    graphics [
      x 635.0
      y 200.0
      w 1.0
      h 1.0
      fill "#000000"
      outline "#000000"
      frameThickness 1.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label ""
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
      role "HYPEREDGENODE"
    ]
  ]
  edge [
    id 1
    source 3
    target 1
    SBGN [
      BendIn "492.0;295.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 492.0 y 295.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "none"
      docking [
        source "-1;-0.8"
      ]
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "LOGICARC"
    ]
  ]
  edge [
    id 2
    source 2
    target 4
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "none"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "ASSIGNMENT"
    ]
  ]
  edge [
    id 3
    source 4
    target 3
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "assignment"
      docking [
        target "0.5;-5.0"
      ]
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "ASSIGNMENT"
    ]
  ]
  edge [
    id 4
    source 1
    target 4
    SBGN [
      BendOut "408.0;295.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 408.0 y 295.0 ]
        point [ x 410.0 y 200.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      arrowheadstyle "trigger"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "NECESSARYSTIMULATION"
    ]
  ]
]
