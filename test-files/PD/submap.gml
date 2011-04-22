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
      y 100.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
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
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    labelgraphics4 [
      alignment "left"
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
    id 2
    zlevel -1

    graphics [
      x 330.0
      y 100.0
      w 220.0
      h 120.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 2.0
      type "rectangle"
    ]
    label "<html><center>MAPK<br>cascade"
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
      role "SUBMAP"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 260.0
      y 100.0
      w 80.0
      h 40.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
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
      fontSize 18
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
      x 400.0
      y 100.0
      w 80.0
      h 40.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      type "tagl"
    ]
    label "ERK"
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
      role "TAGLEFT"
    ]
  ]
  node [
    id 5
    zlevel -1

    graphics [
      x 570.0
      y 100.0
      w 100.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "ERK"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 18
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "left"
      anchor "bbl"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain,oval"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "2P"
      type "text"
    ]
    sbgn [
      role "MACROMOLECULE"
    ]
  ]
  edge [
    id 1
    source 5
    target 4
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "none"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      thickness 1.0
    ]
    sbgn [
      role "EQUIVALENCEARC"
    ]
  ]
  edge [
    id 2
    source 1
    target 3
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "none"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      thickness 1.0
    ]
    sbgn [
      role "EQUIVALENCEARC"
    ]
  ]
]
