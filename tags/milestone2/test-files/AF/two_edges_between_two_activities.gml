graph [
  sbgn [
    role "ACTIVITYFLOW"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 130.0
      y 40.0
      w 108.0
      h 40.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "Grb2"
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
      role "BIOLOGICALACTIVITY"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 240.0
      y 146.66666666666663
      w 108.0
      h 40.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "<html>GAB1<br>"
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
      role "BIOLOGICALACTIVITY"
    ]
  ]
  node [
    id 3
    zlevel -1

    graphics [
      x 70.0
      y 146.66666666666663
      w 108.0
      h 40.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "Spry"
    labelgraphics [
      alignment "center"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    labelgraphics2 [
      alignment "center"
      anchor "bbl"
      color "#000000"
      fontName "Arial"
      fontSize 9
      fontStyle "oval"
      position [
        localAlign 0.0
        relHor 0.0
        relVert 0.0
      ]
      text "<html>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
      type "text"
    ]
    sbgn [
      role "BIOLOGICALACTIVITY"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 140.0
      y 250.0
      w 108.0
      h 40.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "p85 PI3K"
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
      role "BIOLOGICALACTIVITY"
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
      rounding 5.0
      thickness 15.0
    ]
    sbgn [
      role "POSITIVEINFLUENCE"
    ]
  ]
  edge [
    id 2
    source 1
    target 3
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 70.0 y 80.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      arrowheadstyle "stimulation"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      quadcurve 1
      thickness 15.0
    ]
    sbgn [
      role "POSITIVEINFLUENCE"
    ]
  ]
  edge [
    id 3
    source 2
    target 4
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
      role "POSITIVEINFLUENCE"
    ]
  ]
  edge [
    id 4
    source 3
    target 1
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
      role "NEGATIVEINFLUENCE"
    ]
  ]
]
