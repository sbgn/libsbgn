graph [
  sbgn [
    role "ACTIVITYFLOW"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 100.0
      y 130.0
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
      role "DELAY"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 100.0
      y 40.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "<html>late<br>effect"
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
  node [
    id 3
    zlevel -1

    graphics [
      x 100.0
      y 210.0
      w 108.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "<html>early<br>effect"
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
    source 3
    target 1
    SBGN [
      BendIn "100.0;172.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 100.0 y 172.0 ]
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
      role "LOGICARC"
    ]
  ]
  edge [
    id 2
    source 1
    target 2
    SBGN [
      BendOut "100.0;88.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 100.0 y 88.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      arrowheadstyle "stimulation"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 15.0
    ]
    sbgn [
      role "POSITIVEINFLUENCE"
    ]
  ]
]
