graph [
  sbgn [
    role "ENTITYRELATIONSHIP"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 190.0
      y 50.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "Sense"
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
      anchor "btc"
      color "#000000"
      fontName "Arial"
      fontSize 10
      fontStyle "plain,box"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "mt:dna"
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
      x 190.0
      y 250.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 15.0
      type "rectangle"
    ]
    label "3' primer"
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
      fontSize 10
      fontStyle "plain,box"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "mt:dna"
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
      x 190.0
      y 130.0
      w 12.0
      h 12.0
      fill "#000000"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    sbgn [
      role "OUTCOME"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 190.0
      y 170.0
      w 12.0
      h 12.0
      fill "#000000"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "oval"
    ]
    sbgn [
      role "OUTCOME"
    ]
  ]
  node [
    id 5
    zlevel -1

    graphics [
      x 330.0
      y 130.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.ObservableShape"
    ]
    label "Observable A"
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
    id 6
    zlevel -1

    graphics [
      x 60.0
      y 170.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.ObservableShape"
    ]
    label "Observable B"
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
  edge [
    id 1
    source 1
    target 3
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
      role "INTERACTION"
    ]
  ]
  edge [
    id 3
    source 4
    target 2
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "assignment"
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
    id 4
    source 4
    target 6
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "inhibitor"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "INHIBITION"
    ]
  ]
  edge [
    id 5
    source 3
    target 5
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "modulation"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "MODULATION"
    ]
  ]
]
