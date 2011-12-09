graph [
  sbgn [
    role "ENTITYRELATIONSHIP"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 80.0
      y 130.0
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
      y 130.0
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
      x 180.0
      y 220.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.ObservableShape"
    ]
    label "Phenotype X"
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
      x 240.0
      y 40.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.PertubationShape"
    ]
    label "Heat"
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
      role "PERTURBINGAGENT"
    ]
  ]
  node [
    id 5
    zlevel -1

    graphics [
      x 240.0
      y 130.0
      w 1.0
      h 1.0
      fill "#000000"
      outline "#000000"
      frameThickness 1.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    sbgn [
      role "HYPEREDGENODE"
    ]
  ]
  node [
    id 6
    zlevel -1

    graphics [
      x 180.0
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
  edge [
    id 1
    source 1
    target 6
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
    source 5
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
    id 3
    source 4
    target 5
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "absoluteinhibitor"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "ABSOLUTEINHIBITION"
    ]
  ]
  edge [
    id 4
    source 6
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
      role "ABSOLUTEINHIBITION"
    ]
  ]
  edge [
    id 5
    source 6
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
