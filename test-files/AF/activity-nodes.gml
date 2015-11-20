graph [
  sbgn [
    mapid "map1"
    milestone "milestone3"
    role "ACTIVITYFLOW"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 90.0
      y 80.0
      w 120.0
      h 100.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      opacity 1.0
      rounding 0.0
      type "rectangle"
    ]
    label "<html><center>membrane<br>potential<br>activity"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
      anchor "btl"
      color "#000000"
      fontName "Arial"
      fontSize 10
      fontStyle "plain,hexagon"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "<html><center>increase in<br>membrane<br>potential"
      type "text"
    ]
    sbgn [
      glyphid "g1"
      role "BIOLOGICALACTIVITY"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 90.0
      y 269.5
      w 108.0
      h 75.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      opacity 1.0
      rounding 0.0
      type "rectangle"
    ]
    label "<html><center>sodium<br>channel<br>activity"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
      anchor "btl"
      color "#000000"
      fontName "Arial"
      fontSize 10
      fontStyle "plain,roundrect"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "<html><center>sodium<br>channel"
      type "text"
    ]
    sbgn [
      glyphid "g2"
      role "BIOLOGICALACTIVITY"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 90.0
      y 480.0
      w 120.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      opacity 1.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.ObservableShape"
    ]
    label "depolarization"
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
      glyphid "g3"
      role "PHENOTYPE"
    ]
  ]
  edge [
    id 1
    source 1
    target 2
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "stimulation"
      frameThickness 1.5
      gradient 0.0
      opacity 1.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      glyphid "a1"
      role "POSITIVEINFLUENCE"
    ]
  ]
  edge [
    id 2
    source 2
    target 3
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "trigger"
      frameThickness 1.5
      gradient 0.0
      opacity 1.0
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      glyphid "a2"
      role "NECESSARYSTIMULATION"
    ]
  ]
]
