// LiquidGlassButton.qml
// Liquid glass action button — supports filled accent and ghost variants
//
// Usage:
//   LiquidGlassButton { text: "Arm";   accentColor: "#30D158"; filled: true  }
//   LiquidGlassButton { text: "Dismiss"; filled: false }

import QtQuick
import QtQuick.Effects

Item {
    id: root

    // ── Public API ────────────────────────────────────────────────────────
    property string text:        ""
    property color  accentColor: "#0A84FF"
    property bool   filled:      false       // true = tinted fill, false = ghost
    property bool   enabled:     true

    implicitWidth:  _label.implicitWidth + 48
    implicitHeight: 44

    signal clicked()

    opacity: root.enabled ? 1.0 : 0.45

    // ── Z0: Accent color glow shadow ──────────────────────────────────────
    Rectangle {
        anchors.centerIn: parent
        width:   parent.width  + 16
        height:  parent.height + 16
        radius:  height / 2
        color:   "transparent"
        visible: root.filled

        Rectangle {
            anchors.centerIn: parent
            width:   parent.width  - 8
            height:  parent.height - 8
            radius:  height / 2
            color:   Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.22)
            layer.enabled: true
            layer.effect: MultiEffect {
                blurEnabled: true
                blur:        1.0
                blurMax:     28
            }
        }
    }

    // ── Z1: Gradient border ───────────────────────────────────────────────
    Rectangle {
        anchors.fill:    parent
        anchors.margins: -1
        radius:          height / 2
        gradient: Gradient {
            orientation: Gradient.Diagonal
            GradientStop {
                position: 0.0
                color: root.filled
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.75)
                    : Qt.rgba(1,1,1,0.50)
            }
            GradientStop {
                position: 0.30
                color: root.filled
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.28)
                    : Qt.rgba(1,1,1,0.18)
            }
            GradientStop {
                position: 0.65
                color: root.filled
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.10)
                    : Qt.rgba(1,1,1,0.06)
            }
            GradientStop {
                position: 1.0
                color: root.filled
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.45)
                    : Qt.rgba(1,1,1,0.35)
            }
        }
    }

    // ── Z2: Glass body ────────────────────────────────────────────────────
    Rectangle {
        id:           _body
        anchors.fill: parent
        radius:       height / 2
        color: root.filled
            ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.20)
            : Qt.rgba(1,1,1,0.075)
        Behavior on color { ColorAnimation { duration: 150 } }
    }

    // ── Z3: Top specular ──────────────────────────────────────────────────
    Rectangle {
        anchors.top:          parent.top
        anchors.topMargin:    1
        anchors.left:         parent.left
        anchors.leftMargin:   parent.width * 0.08
        anchors.right:        parent.right
        anchors.rightMargin:  parent.width * 0.08
        height:               parent.height * 0.46
        radius:               height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1,1,1, root.filled ? 0.32 : 0.22) }
            GradientStop { position: 0.6; color: Qt.rgba(1,1,1,0.06) }
            GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
        }
    }

    // ── Z4: Bottom shadow ──────────────────────────────────────────────────
    Rectangle {
        anchors.bottom:        parent.bottom
        anchors.bottomMargin:  1
        anchors.left:          parent.left
        anchors.leftMargin:    parent.width * 0.12
        anchors.right:         parent.right
        anchors.rightMargin:   parent.width * 0.12
        height:                parent.height * 0.28
        radius:                height / 2
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.00) }
            GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.15) }
        }
    }

    // ── Label ──────────────────────────────────────────────────────────────
    Text {
        id:                     _label
        anchors.centerIn:       parent
        text:                   root.text
        color: root.filled
            ? (root.accentColor.hslLightness > 0.5 ? Qt.rgba(0,0,0,0.85) : "#ffffff")
            : Qt.rgba(1,1,1,0.75)
        font.pointSize:         ScreenTools.defaultFontPointSize
        font.weight:            Font.DemiBold
        font.letterSpacing:     0.3
        horizontalAlignment:    Text.AlignHCenter
        verticalAlignment:      Text.AlignVCenter
    }

    // ── Interaction ────────────────────────────────────────────────────────
    property bool _pressed: false
    scale: _pressed ? 0.96 : 1.0
    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutBack } }

    MouseArea {
        anchors.fill:  parent
        enabled:       root.enabled
        hoverEnabled:  true
        onPressed:     { root._pressed = true }
        onReleased:    { root._pressed = false }
        onClicked:     root.clicked()
        onContainsMouseChanged: {
            _body.color = containsMouse
                ? (root.filled
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.30)
                    : Qt.rgba(1,1,1,0.13))
                : (root.filled
                    ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.20)
                    : Qt.rgba(1,1,1,0.075))
        }
    }
}
