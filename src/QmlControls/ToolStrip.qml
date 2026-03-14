// C:\BV_GCS\qgc\src\QmlControls\ToolStrip.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
// Qt5: import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls

Item {
    id:         _root
    width:      ScreenTools.defaultFontPixelWidth * 8
    height:     Math.min(maxHeight, toolStripColumn.height + (flickable.anchors.margins * 3))

    property alias  model:      repeater.model
    property real   maxHeight   ///< Maximum height for control, determines whether text is hidden to make control shorter
    property var    fontSize:   ScreenTools.smallFontPointSize

    // Wire this to your map item in FlyView.qml:
    //   toolStrip.mapSourceItem: flightMap
    property var    mapSourceItem: null

    property var _dropPanel: dropPanel

    function simulateClick(buttonIndex) {
        var button = toolStripColumn.children[buttonIndex]
        if (button.checkable) {
            button.checked = !button.checked
        }
        button.clicked()
    }

    signal dropped(int index)

    // ── GLASS BACKGROUND ─────────────────────────────────────────────────────
    Item {
        id:             glassBackground
        anchors.fill:   parent
        z:              0

        // Clip to rounded rect
        layer.enabled:  true
        layer.effect:   OpacityMask {
            maskSource: Rectangle {
                width:  glassBackground.width
                height: glassBackground.height
                radius: ScreenTools.defaultFontPixelWidth * 1.2
            }
        }

        // 1. Capture map behind the strip
        ShaderEffectSource {
            id:             blurSource
            anchors.fill:   parent
            sourceItem:     _root.mapSourceItem
            live:           true
            visible:        false
        }

        // 2. Frosted blur
        FastBlur {
            anchors.fill:   parent
            source:         blurSource
            radius:         52
        }

        // 3. Dark tint
        Rectangle {
            anchors.fill:   parent
            color:          Qt.rgba(0.04, 0.047, 0.08, 0.58)
        }

        // 4. Upper inner glow
        Rectangle {
            anchors.top:    parent.top
            anchors.left:   parent.left
            anchors.right:  parent.right
            height:         parent.height * 0.3
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.055) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    // Outer border + shimmer — sits outside the clipped layer
    Rectangle {
        anchors.fill:   parent
        color:          "transparent"
        radius:         ScreenTools.defaultFontPixelWidth * 1.2
        border.color:   Qt.rgba(1, 1, 1, 0.10)
        border.width:   1
        z:              1
    }

    // Top shimmer highlight
    Rectangle {
        anchors.top:                parent.top
        anchors.topMargin:          1
        anchors.horizontalCenter:   parent.horizontalCenter
        width:                      parent.width * 0.55
        height:                     1
        z:                          2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.38) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // Left accent edge
    Rectangle {
        anchors.left:           parent.left
        anchors.leftMargin:     0
        anchors.top:            parent.top
        anchors.topMargin:      ScreenTools.defaultFontPixelWidth * 1.2
        anchors.bottom:         parent.bottom
        anchors.bottomMargin:   ScreenTools.defaultFontPixelWidth * 1.2
        width:                  2
        z:                      2
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.3; color: Qt.rgba(0.0, 0.78, 1.0, 0.30) }
            GradientStop { position: 0.7; color: Qt.rgba(0.0, 0.78, 1.0, 0.30) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // ── DEAD MOUSE AREA ───────────────────────────────────────────────────────
    DeadMouseArea {
        anchors.fill:   parent
        z:              1
    }

    // ── FLICKABLE + BUTTON COLUMN ─────────────────────────────────────────────
    QGCFlickable {
        id:                 flickable
        anchors.margins:    ScreenTools.defaultFontPixelWidth * 0.6
        anchors.fill:       parent
        contentHeight:      toolStripColumn.height
        flickableDirection: Flickable.VerticalFlick
        clip:               true
        z:                  3

        Column {
            id:             toolStripColumn
            anchors.left:   parent.left
            anchors.right:  parent.right
            spacing:        ScreenTools.defaultFontPixelWidth * 0.8

            Repeater {
                id: repeater

                ToolStripHoverButton {
                    id:                 buttonTemplate
                    anchors.left:       toolStripColumn.left
                    anchors.right:      toolStripColumn.right
                    height:             ScreenTools.defaultFontPixelWidth * 7 //width
                    radius:             ScreenTools.defaultFontPixelWidth * 0.9
                    fontPointSize:      _root.fontSize
                    toolStripAction:    modelData
                    dropPanel:          _dropPanel
                    onDropped: (index) => _root.dropped(index)

                    onCheckedChanged: {
                        if (checked) {
                            for (var i = 0; i < repeater.count; i++) {
                                if (i != index) {
                                    var button = repeater.itemAt(i)
                                    if (button.checked) {
                                        button.checked = false
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ── DROP PANEL ────────────────────────────────────────────────────────────
    ToolStripDropPanel {
        id:         dropPanel
        toolStrip:  _root
        z:          10
    }
}
