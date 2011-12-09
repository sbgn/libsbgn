graph [
  sbgn [
    role "ENTITYRELATIONSHIP"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 70.0
      y 180.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "A"
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
      role "ENTITY"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 350.0
      y 180.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "B"
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
      role "ENTITY"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 230.0
      y 280.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.ObservableShape"
    ]
    label "phenotype X"
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
      role "PHENOTYPE"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 230.0
      y 180.0
      w 42.0
      h 42.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    labelgraphics2 [
      alignment "center"
      anchor "bbc"
      color "#000000"
      fontName "Arial"
      fontSize 4
      fontStyle "plain,fcircle"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "<html>&nbsp;"
      type "text"
    ]
    sbgn [
      role "MULTIINTERACTION"
    ]
  ]
  edge [
    id 1
    source 1
    target 4
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "first"
      arrowtailstyle "assignment"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    label "2"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "box"
      type "text"
    ]
    sbgn [
      role "INTERACTION"
    ]
  ]
  edge [
    id 2
    source 2
    target 4
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "first"
      arrowtailstyle "assignment"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "INTERACTION"
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
]
