// LiquidGlassDrawer.qml
// The main drawer panel — a thick glass sheet that sits over the map.
// Wrap ToolIndicatorPage / contentComponent content inside this.
//
// This provides ONLY the glass surface shell.
// Drop your content into the default property (children).

import QtQuick
import QtQuick.Effects

Item {
    id: root

    // ── Public API ────────────────────────────────────────────────────────
    default property alias content: _contentSlot.children
    property bool          showHandle: true

    implicitWidth:  360
    implicitHeight: _contentSlot.implicitHeight + (showHandle ? 30 : 16)

    // ── Z0: Deep drop shadow with color bleed ─────────────────────────────
    Rectangle {
        anchors.fill:    parent
        anchors.margins: -20
        radius:          28 + 20
        color:           "transparent"

        Rectangle {
            anchors.fill:    parent
            anchors.margins: 8
            radius:          parent.radius - 8
            color:           Qt.rgba(0,0,0,0.50)
            layer.enabled:   true
            layer.effect:    MultiEffect {
                blurEnabled: true
                blur:        1.0
                blurMax:     40
            }
        }
    }

    // ── Z1: Gradient border — glass edge refraction ───────────────────────
    Rectangle {
        anchors.fill:    parent
        anchors.margins: -1
        radius:          29
        gradient: Gradient {
            orientation: Gradient.Diagonal
            GradientStop { position: 0.00; color: Qt.rgba(1,1,1,0.52) }
            GradientStop { position: 0.12; color: Qt.rgba(1,1,1,0.24) }
            GradientStop { position: 0.35; color: Qt.rgba(1,1,1,0.07) }
            GradientStop { position: 0.55; color: Qt.rgba(1,1,1,0.04) }
            GradientStop { position: 0.78; color: Qt.rgba(1,1,1,0.12) }
            GradientStop { position: 1.00; color: Qt.rgba(1,1,1,0.38) }
        }
    }

    // ── Z2: Glass body (the blurred panel) ───────────────────────────────
    Rectangle {
        id:           _glassBg
        anchors.fill: parent
        radius:       28
        color:        Qt.rgba(1, 1, 1, 0.07)

        // Backdrop blur — Qt 6.5+ MultiEffect on a BlurHelper or inline
        // For QGC typically we use layer.effect:
        layer.enabled: true
        layer.effect:  MultiEffect {
            blurEnabled:   false       // Set true if using Qt 6.5 with backdrop support
            saturation:    0.25
            brightness:    0.04
        }
    }

    // ── Z3: Large top specular band ───────────────────────────────────────
    // Simulates light striking the top face of the glass slab
    Rectangle {
        anchors.top:          parent.top
        anchors.topMargin:    1
        anchors.left:         parent.left
        anchors.leftMargin:   parent.width * 0.05
        anchors.right:        parent.right
        anchors.rightMargin:  parent.width * 0.05
        height:               parent.height * 0.32
        radius:               28

        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.18) }
            GradientStop { position: 0.4; color: Qt.rgba(1,1,1,0.05) }
            GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
        }
    }

    // ── Z4: Bottom inner shadow line ──────────────────────────────────────
    Rectangle {
        anchors.bottom:        parent.bottom
        anchors.bottomMargin:  1
        anchors.left:          parent.left
        anchors.leftMargin:    parent.width * 0.05
        anchors.right:         parent.right
        anchors.rightMargin:   parent.width * 0.05
        height:                parent.height * 0.18
        radius:                28
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.00) }
            GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.14) }
        }
    }

    // ── Z5: Drag handle ───────────────────────────────────────────────────
    Rectangle {
        anchors.top:              parent.top
        anchors.topMargin:        12
        anchors.horizontalCenter: parent.horizontalCenter
        width:   38; height: 5
        radius:  3
        visible: root.showHandle
        color:   Qt.rgba(1,1,1,0.22)
    }

    // ── Z6: Content ───────────────────────────────────────────────────────
    Item {
        id:              _contentSlot
        anchors.top:     parent.top
        anchors.topMargin: root.showHandle ? 28 : 8
        anchors.left:    parent.left
        anchors.right:   parent.right
        anchors.bottom:  parent.bottom
    }
}
