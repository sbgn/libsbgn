graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 380.0
      y 60.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "Monomer"
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
    id 2
    zlevel -1

    graphics [
      x 280.0
      y 60.0
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
  node [
    id 3
    zlevel -1

    graphics [
      x 170.0
      y 60.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      offX 10
      offY 10
      rounding 15.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.MultiRectangleShape"
    ]
    label "Dimer"
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
      anchor "btl"
      color "#000000"
      fontName "Arial"
      fontSize 10
      fontStyle "plain,box"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "N:2"
      type "text"
    ]
    sbgn [
      role "MULTIMERMACROMOLECULE"
    ]
  ]
  edge [
    id 1
    source 1
    target 2
    SBGN [
      BendIn "304.0;60.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 304.0 y 60.0 ]
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
    source 2
    target 3
    SBGN [
      BendOut "256.0;60.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 256.0 y 60.0 ]
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
]
