graph [
  sbgn [
    role "ENTITYRELATIONSHIP"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 63.0
      y 40.0
      w 36.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 20.0
      type "rectangle"
    ]
    label "PSD"
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
      x 90.0
      y 200.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "GluR"
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
      fontSize 24
      fontStyle "pin"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "<html>&nbsp;"
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
      x 117.0
      y 40.0
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
  node [
    id 4
    zlevel -1

    graphics [
      x 117.0
      y 80.0
      w 12.0
      h 12.0
      fill "#000000"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
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
      role "OUTCOME"
    ]
  ]
  node [
    id 5
    zlevel -1

    graphics [
      x 63.0
      y 80.0
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
    source 1
    target 5
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
    id 2
    source 3
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
    target 5
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "stimulation"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "STIMULATION"
    ]
  ]
  edge [
    id 4
    source 4
    target 2
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
    id 5
    source 5
    target 2
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "assignment"
      docking [
        target "-0.5;-5.0"
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
]
