// 1st iteration
// // LiquidGlassChip.qml
// // Glass status chip for sensor status rows
// //
// // Usage:
// //   LiquidGlassChip { chipText: "Normal";   chipColor: "#30D158" }
// //   LiquidGlassChip { chipText: "Error";    chipColor: "#FF453A" }
// //   LiquidGlassChip { chipText: "Disabled"; chipColor: "#555555" }

// import QtQuick

// Item {
//     id: root

//     property string chipText:  ""
//     property color  chipColor: "#30D158"

//     implicitWidth:  _txt.implicitWidth + 22
//     implicitHeight: 24

//     // ── Gradient border ───────────────────────────────────────────────────
//     Rectangle {
//         anchors.fill:    parent
//         anchors.margins: -1
//         radius:          height / 2
//         gradient: Gradient {
//             orientation: Gradient.Diagonal
//             GradientStop { position: 0.0; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.75) }
//             GradientStop { position: 0.4; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.22) }
//             GradientStop { position: 0.7; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.08) }
//             GradientStop { position: 1.0; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.45) }
//         }
//     }

//     // ── Body ──────────────────────────────────────────────────────────────
//     Rectangle {
//         anchors.fill: parent
//         radius:       height / 2
//         color:        Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.13)
//     }

//     // ── Top specular ──────────────────────────────────────────────────────
//     Rectangle {
//         anchors.top:          parent.top
//         anchors.topMargin:    1
//         anchors.left:         parent.left
//         anchors.leftMargin:   parent.width * 0.12
//         anchors.right:        parent.right
//         anchors.rightMargin:  parent.width * 0.12
//         height:               parent.height * 0.48
//         radius:               height / 2
//         gradient: Gradient {
//             GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.22) }
//             GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
//         }
//     }

//     // ── Label ──────────────────────────────────────────────────────────────
//     Text {
//         id:                     _txt
//         anchors.centerIn:       parent
//         text:                   root.chipText
//         color:                  root.chipColor
//         font.pointSize:         ScreenTools.smallFontPointSize
//         font.weight:            Font.Bold
//         font.letterSpacing:     0.4
//         horizontalAlignment:    Text.AlignHCenter
//     }
// }

// 2nd iteration
// LiquidGlassChip.qml

import QtQuick
import QGroundControl.Controls

Item {
    id: root
    property string chipText:  ""
    property color  chipColor: "#30D158"

    implicitWidth:  _txt.implicitWidth + 22
    implicitHeight: 22

    Rectangle {
        anchors.fill:    parent; anchors.margins: -1
        radius:          height / 2
        gradient: Gradient {
            orientation: Gradient.Diagonal
            GradientStop { position: 0.0; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.75) }
            GradientStop { position: 0.4; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.20) }
            GradientStop { position: 0.7; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.08) }
            GradientStop { position: 1.0; color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.45) }
        }
    }
    Rectangle {
        anchors.fill: parent; radius: height / 2
        color: Qt.rgba(root.chipColor.r, root.chipColor.g, root.chipColor.b, 0.14)
    }
    Rectangle {
        anchors.top:         parent.top; anchors.topMargin: 1
        anchors.left:        parent.left; anchors.leftMargin: parent.width * 0.12
        anchors.right:       parent.right; anchors.rightMargin: parent.width * 0.12
        height:              parent.height * 0.48; radius: height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.24) }
            GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
        }
    }
    Text {
        id:                  _txt
        anchors.centerIn:    parent
        text:                root.chipText
        color:               root.chipColor
        font.pointSize:      ScreenTools.smallFontPointSize
        font.weight:         Font.Bold
        font.letterSpacing:  0.4
        horizontalAlignment: Text.AlignHCenter
    }
}
