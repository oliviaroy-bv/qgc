import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import QGroundControl
import QGroundControl.Controls

// Reusable frosted glass panel for toolbar indicators
Rectangle {
    id: root
    
    property alias contentItem: contentLoader.sourceComponent
    property color accentColor: "#00d4ff"
    
    color: "transparent"
    
    // Glass background with blur
    Item {
        id: glassLayer
        anchors.fill: parent
        z: 0
        
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: glassLayer.width
                height: glassLayer.height
                radius: 12
            }
        }
        
        // Base glass color
        Rectangle {
            anchors.fill: parent
            color: Qt.rgba(0.02, 0.024, 0.045, 0.85)
        }
        
        // Top highlight
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.3
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.08) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
        
        // Bottom shadow
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.2
            gradient: Gradient {
                GradientStop { position: 0.0; color: "transparent" }
                GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.3) }
            }
        }
    }
    
    // Subtle outer border
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        radius: 12
        border.color: Qt.rgba(1, 1, 1, 0.15)
        border.width: 1
        z: 1
    }
    
    // Top shimmer
    Rectangle {
        anchors.top: parent.top
        anchors.topMargin: 1
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.5
        height: 1
        z: 2
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.4) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }
    
    // Content
    Loader {
        id: contentLoader
        anchors.fill: parent
        anchors.margins: 12
        z: 3
    }
}