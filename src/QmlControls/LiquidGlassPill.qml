// 1st iteration
// // LiquidGlassPill.qml
// // True liquid glass status pill for QGC MainStatusIndicator
// //
// // Usage:
// //   LiquidGlassPill {
// //       statusText:   "Not Ready"
// //       accentColor:  "#FF453A"
// //       dotAnimating: true
// //       onClicked:    dropMainStatusIndicator()
// //   }

// import QtQuick
// import QtQuick.Effects

// Item {
//     id: root

//     // ── Public API ────────────────────────────────────────────────────────
//     property string statusText:   "Disconnected"
//     property color  accentColor:  "#888888"
//     property bool   dotAnimating: false
//     property string vtolText:     ""          // e.g. "FW (vtol)" — shows inner badge

//     implicitWidth:  _row.implicitWidth + 36
//     implicitHeight: 36

//     signal clicked()

//     // ── Z0: Colored glow shadow under pill ────────────────────────────────
//     Rectangle {
//         anchors.centerIn: parent
//         width:   parent.width  + 20
//         height:  parent.height + 20
//         radius:  height / 2
//         color:   "transparent"
//         visible: root.accentColor.toString() !== "#888888"

//         Rectangle {
//             anchors.centerIn: parent
//             width:   parent.width  - 8
//             height:  parent.height - 8
//             radius:  height / 2
//             color:   Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.20)
//             layer.enabled: true
//             layer.effect: MultiEffect {
//                 blurEnabled: true
//                 blur:        1.0
//                 blurMax:     32
//             }
//         }
//     }

//     // ── Z1: Gradient border — light wrapping around glass edge ────────────
//     // Top-left bright, bottom-right dim, subtle bright again at bottom
//     Rectangle {
//         anchors.fill:    parent
//         anchors.margins: -1
//         radius:          (height) / 2
//         gradient: Gradient {
//             orientation: Gradient.Diagonal
//             GradientStop { position: 0.00; color: Qt.rgba(1,1,1,0.55) }
//             GradientStop { position: 0.20; color: Qt.rgba(1,1,1,0.22) }
//             GradientStop { position: 0.45; color: Qt.rgba(1,1,1,0.06) }
//             GradientStop { position: 0.75; color: Qt.rgba(1,1,1,0.14) }
//             GradientStop { position: 1.00; color: Qt.rgba(1,1,1,0.42) }
//         }
//     }

//     // ── Z2: Glass body ────────────────────────────────────────────────────
//     Rectangle {
//         id:             _glassBg
//         anchors.fill:   parent
//         radius:         height / 2
//         color:          Qt.rgba(1, 1, 1, 0.075)

//         Behavior on color { ColorAnimation { duration: 160 } }
//     }

//     // ── Z3: Top specular band ─────────────────────────────────────────────
//     // Most critical glass cue: bright highlight at top edge
//     Rectangle {
//         anchors.top:          parent.top
//         anchors.topMargin:    1
//         anchors.left:         parent.left
//         anchors.leftMargin:   parent.width * 0.07
//         anchors.right:        parent.right
//         anchors.rightMargin:  parent.width * 0.07
//         height:               parent.height * 0.44
//         radius:               height / 2
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.28) }
//             GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.07) }
//             GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
//         }
//     }

//     // ── Z4: Bottom inner shadow ───────────────────────────────────────────
//     Rectangle {
//         anchors.bottom:        parent.bottom
//         anchors.bottomMargin:  1
//         anchors.left:          parent.left
//         anchors.leftMargin:    parent.width * 0.1
//         anchors.right:         parent.right
//         anchors.rightMargin:   parent.width * 0.1
//         height:                parent.height * 0.30
//         radius:                height / 2
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.00) }
//             GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.14) }
//         }
//     }

//     // ── Content ────────────────────────────────────────────────────────────
//     Row {
//         id:                  _row
//         anchors.centerIn:    parent
//         spacing:             8
//         leftPadding:         14
//         rightPadding:        14

//         // Dot + halo
//         Item {
//             width:  16; height: 16
//             anchors.verticalCenter: parent.verticalCenter

//             // Expanding halo
//             Rectangle {
//                 anchors.centerIn: parent
//                 width: 16; height: 16; radius: 8
//                 color: Qt.rgba(root.accentColor.r, root.accentColor.g,
//                                root.accentColor.b, 0)
//                 visible: root.dotAnimating

//                 SequentialAnimation on color {
//                     running: root.dotAnimating; loops: Animation.Infinite
//                     ColorAnimation {
//                         to: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.45)
//                         duration: 900; easing.type: Easing.InOutSine
//                     }
//                     ColorAnimation {
//                         to: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.0)
//                         duration: 900; easing.type: Easing.InOutSine
//                     }
//                 }
//                 SequentialAnimation on scale {
//                     running: root.dotAnimating; loops: Animation.Infinite
//                     NumberAnimation { to: 1.9; duration: 900; easing.type: Easing.InOutSine }
//                     NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InOutSine }
//                 }
//             }

//             // Core dot
//             Rectangle {
//                 anchors.centerIn: parent
//                 width: 7; height: 7; radius: 4
//                 color: root.accentColor
//             }
//         }

//         // Label
//         Text {
//             text:               root.statusText
//             color:              root.accentColor
//             font.pointSize:     ScreenTools.defaultFontPointSize * 1.05
//             font.weight:        Font.DemiBold
//             font.letterSpacing: 0.3
//             anchors.verticalCenter: parent.verticalCenter
//             Behavior on color { ColorAnimation { duration: 200 } }
//         }

//         // Optional VTOL badge
//         Item {
//             visible:        root.vtolText !== ""
//             implicitWidth:  _vtolTxt.implicitWidth + 16
//             implicitHeight: 20
//             anchors.verticalCenter: parent.verticalCenter

//             // Badge border
//             Rectangle {
//                 anchors.fill:    parent
//                 anchors.margins: -1
//                 radius:          height / 2
//                 gradient: Gradient {
//                     orientation: Gradient.Diagonal
//                     GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.30) }
//                     GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.10) }
//                 }
//             }
//             // Badge bg
//             Rectangle {
//                 anchors.fill: parent; radius: height / 2
//                 color: Qt.rgba(1,1,1,0.07)
//             }
//             // Badge specular
//             Rectangle {
//                 anchors.top: parent.top; anchors.topMargin: 1
//                 anchors.left: parent.left; anchors.leftMargin: 3
//                 anchors.right: parent.right; anchors.rightMargin: 3
//                 height: parent.height * 0.45; radius: height / 2
//                 gradient: Gradient {
//                     GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.20) }
//                     GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
//                 }
//             }
//             Text {
//                 id:                 _vtolTxt
//                 anchors.centerIn:   parent
//                 text:               root.vtolText
//                 color:              Qt.rgba(1,1,1,0.50)
//                 font.pointSize:     ScreenTools.smallFontPointSize
//                 font.weight:        Font.Medium
//                 font.letterSpacing: 0.5
//             }
//         }
//     }

//     // ── Interaction ────────────────────────────────────────────────────────
//     property bool _pressed: false
//     scale: _pressed ? 0.955 : 1.0
//     Behavior on scale { NumberAnimation { duration: 110; easing.type: Easing.OutBack } }

//     MouseArea {
//         anchors.fill:   parent
//         hoverEnabled:   true
//         onPressed:      { root._pressed = true }
//         onReleased:     { root._pressed = false }
//         onClicked:      root.clicked()
//         onContainsMouseChanged:
//             _glassBg.color = containsMouse ? Qt.rgba(1,1,1,0.13) : Qt.rgba(1,1,1,0.075)
//     }
// }


// 2nd iteration
// LiquidGlassPill.qml

import QtQuick
import QGroundControl.Controls

Item {
    id: root

    property string statusText:   "Disconnected"
    property color  accentColor:  "#888888"
    property bool   dotAnimating: false
    property string vtolText:     ""

    implicitWidth:  _row.implicitWidth + 36
    implicitHeight: 34

    signal clicked()

    // Gradient border
    Rectangle {
        anchors.fill:    parent
        anchors.margins: -1
        radius:          height / 2
        gradient: Gradient {
            orientation: Gradient.Diagonal
            GradientStop { position: 0.00; color: Qt.rgba(1,1,1,0.55) }
            GradientStop { position: 0.25; color: Qt.rgba(1,1,1,0.18) }
            GradientStop { position: 0.55; color: Qt.rgba(1,1,1,0.06) }
            GradientStop { position: 0.80; color: Qt.rgba(1,1,1,0.16) }
            GradientStop { position: 1.00; color: Qt.rgba(1,1,1,0.42) }
        }
    }

    // Glass body
    Rectangle {
        id:           _body
        anchors.fill: parent
        radius:       height / 2
        color:        Qt.rgba(1, 1, 1, 0.09)
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // Top specular
    Rectangle {
        anchors.top:         parent.top
        anchors.topMargin:   1
        anchors.left:        parent.left
        anchors.leftMargin:  parent.width * 0.08
        anchors.right:       parent.right
        anchors.rightMargin: parent.width * 0.08
        height:              parent.height * 0.44
        radius:              height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.30) }
            GradientStop { position: 0.6; color: Qt.rgba(1,1,1,0.06) }
            GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
        }
    }

    // Bottom shadow
    Rectangle {
        anchors.bottom:       parent.bottom
        anchors.bottomMargin: 1
        anchors.left:         parent.left
        anchors.leftMargin:   parent.width * 0.1
        anchors.right:        parent.right
        anchors.rightMargin:  parent.width * 0.1
        height:               parent.height * 0.30
        radius:               height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.00) }
            GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.14) }
        }
    }

    Row {
        id:               _row
        anchors.centerIn: parent
        spacing:          7
        leftPadding:      14
        rightPadding:     14

        Item {
            width: 14; height: 14
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.centerIn: parent
                width: 14; height: 14; radius: 7
                color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0)
                visible: root.dotAnimating
                SequentialAnimation on color {
                    running: root.dotAnimating; loops: Animation.Infinite
                    ColorAnimation { to: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.45); duration: 900; easing.type: Easing.InOutSine }
                    ColorAnimation { to: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.00); duration: 900; easing.type: Easing.InOutSine }
                }
                SequentialAnimation on scale {
                    running: root.dotAnimating; loops: Animation.Infinite
                    NumberAnimation { to: 1.9; duration: 900; easing.type: Easing.InOutSine }
                    NumberAnimation { to: 1.0; duration: 900; easing.type: Easing.InOutSine }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: 7; height: 7; radius: 4
                color: root.accentColor
            }
        }

        Text {
            text:               root.statusText
            color:              root.accentColor
            font.pointSize:     ScreenTools.defaultFontPointSize * 1.05
            font.weight:        Font.DemiBold
            font.letterSpacing: 0.3
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        Item {
            visible:        root.vtolText !== ""
            implicitWidth:  _vt.implicitWidth + 16
            implicitHeight: 18
            anchors.verticalCenter: parent.verticalCenter

            Rectangle {
                anchors.fill:    parent; anchors.margins: -1
                radius:          height / 2
                gradient: Gradient {
                    orientation: Gradient.Diagonal
                    GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.28) }
                    GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.08) }
                }
            }
            Rectangle {
                anchors.fill: parent; radius: height / 2
                color: Qt.rgba(1,1,1,0.07)
            }
            Text {
                id:                 _vt
                anchors.centerIn:   parent
                text:               root.vtolText
                color:              Qt.rgba(1,1,1,0.50)
                font.pointSize:     ScreenTools.smallFontPointSize
                font.weight:        Font.Medium
                font.letterSpacing: 0.5
            }
        }
    }

    property bool _pressed: false
    scale: _pressed ? 0.96 : 1.0
    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }

    MouseArea {
        anchors.fill:  parent
        hoverEnabled:  true
        onPressed:     root._pressed = true
        onReleased:    root._pressed = false
        onClicked:     root.clicked()
        onContainsMouseChanged:
            _body.color = containsMouse ? Qt.rgba(1,1,1,0.15) : Qt.rgba(1,1,1,0.09)
    }
}
