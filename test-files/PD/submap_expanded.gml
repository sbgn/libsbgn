# generated with VANTED V2.1.0 at Thu May 23 21:22:26 CEST 2013
graph [
  sbgn [
    role "PROCESSDESCRIPTION"
  ]
  directed 1
  node [
    id 1
    zlevel -1

    graphics [
      x 80.0
      y 50.0
      w 100.0
      h 60.0
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
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "TAGRIGHT"
    ]
  ]
  node [
    id 2
    zlevel -1

    graphics [
      x 250.0
      y 50.0
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
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
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
    id 3
    zlevel -1

    graphics [
      x 250.0
      y 160.0
      w 20.0
      h 20.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "rectangle"
    ]
    label "<html><b>&#92;&#92;"
    labelgraphics [
      alignment "left"
      anchor "c"
      color "#000000"
      fontName "Arial"
      fontSize 14
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "OMITTEDPROCESS"
    ]
  ]
  node [
    id 4
    zlevel -1

    graphics [
      x 400.0
      y 160.0
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
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    labelgraphics1 [
      alignment "center"
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
  node [
    id 5
    zlevel -1

    graphics [
      x 570.0
      y 160.0
      w 100.0
      h 60.0
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
      fontSize 12
      fontStyle "plain"
      type "text"
    ]
    sbgn [
      role "TAGLEFT"
    ]
  ]
  node [
    id 6
    zlevel -1

    graphics [
      x 120.0
      y 160.0
      w 60.0
      h 60.0
      fill "#FFFFFF"
      outline "#000000"
      frameThickness 2.0
      gradient 0.0
      rounding 0.0
      type "de.ipk_gatersleben.ag_nw.graffiti.plugins.shapes.SourceSinkShape"
    ]
    sbgn [
      role "SOURCESINK"
    ]
  ]
  edge [
    id 1
    source 2
    target 3
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "last"
      arrowheadstyle "catalysis"
      docking [
        source "0;12"
      ]
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      thickness 18.0
    ]
    sbgn [
      role "CATALYSIS"
    ]
  ]
  edge [
    id 2
    source 4
    target 5
    graphics [
      fill "#000000"
      outline "#000000"
      arrow "none"
      frameThickness 2.0
      gradient 0.0
      rounding 5.0
      thickness 10.0
    ]
    sbgn [
      role "EQUIVALENCEARC"
    ]
  ]
  edge [
    id 3
    source 2
    target 1
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
    id 4
    source 6
    target 3
    SBGN [
      BendIn "230.0;160.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 230.0 y 160.0 ]
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
    id 5
    source 3
    target 4
    SBGN [
      BendOut "270.0;160.0"
    ]
    graphics [
      fill "#000000"
      outline "#000000"
      Line [
        point [ x 0.0 y 0.0 ]
        point [ x 270.0 y 160.0 ]
        point [ x 0.0 y 0.0 ]
      ]
      arrow "last"
      frameThickness 1.5
      gradient 0.0
      rounding 5.0
      type "org.graffiti.plugins.views.defaults.PolyLineEdgeShape"
      thickness 10.0
    ]
    sbgn [
      role "PRODUCTION"
    ]
  ]
]
