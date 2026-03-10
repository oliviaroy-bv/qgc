// // C:\BV_GCS\qgc\src\QmlControls\ToolStripHoverButton.qml
// import QtQuick
// import QtQuick.Controls

// import QGroundControl
// import QGroundControl.Controls

// Button {
//     id:             control
//     width:          contentLayoutItem.contentWidth + (contentMargins * 2)
//     height:         width
//     hoverEnabled:   !ScreenTools.isMobile
//     enabled:        toolStripAction.enabled
//     visible:        toolStripAction.visible
//     imageSource:    toolStripAction.showAlternateIcon ? modelData.alternateIconSource : modelData.iconSource
//     text:           toolStripAction.text
//     checked:        toolStripAction.checked
//     checkable:      toolStripAction.dropPanelComponent || modelData.checkable

//     property var    toolStripAction:    undefined
//     property var    dropPanel:          undefined
//     property alias  radius:             buttonBkRect.radius
//     property alias  fontPointSize:      innerText.font.pointSize
//     property alias  imageSource:        innerImage.source
//     property alias  contentWidth:       innerText.contentWidth

//     property bool forceImageScale11: false
//     property real imageScale:        forceImageScale11 && (text == "") ? 0.8 : 0.6
//     property real contentMargins:    innerText.height * 0.1

//     property color _currentContentColor:  (checked || pressed) ? qgcPal.buttonHighlightText : qgcPal.windowTransparentText
//     property color _currentContentColorSecondary:  (checked || pressed) ? qgcPal.windowTransparentText : qgcPal.buttonHighlight

//     signal dropped(int index)

//     onCheckedChanged: toolStripAction.checked = checked

//     onClicked: {
//         if (mainWindow.allowViewSwitch()) {
//             dropPanel.hide()
//             if (!toolStripAction.dropPanelComponent) {
//                 toolStripAction.triggered(this)
//             } else if (checked) {
//                 var panelEdgeTopPoint = mapToItem(_root, width, 0)
//                 dropPanel.show(panelEdgeTopPoint, toolStripAction.dropPanelComponent, this)
//                 checked = true
//                 control.dropped(index)
//             }
//         } else if (checkable) {
//             checked = !checked
//         }
//     }

//     QGCPalette { id: qgcPal; colorGroupEnabled: control.enabled }

//     contentItem: Item {
//         id:                 contentLayoutItem
//         anchors.fill:       parent
//         anchors.margins:    contentMargins

//         Column {
//             anchors.centerIn:   parent
//             spacing:            0

//             Image {
//                 id:                         innerImageColorful
//                 height:                     contentLayoutItem.height * imageScale
//                 width:                      contentLayoutItem.width  * imageScale
//                 smooth:                     true
//                 mipmap:                     true
//                 fillMode:                   Image.PreserveAspectFit
//                 antialiasing:               true
//                 sourceSize.height:          height
//                 sourceSize.width:           width
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 source:                     control.imageSource
//                 visible:                    source != "" && modelData.fullColorIcon
//             }

//             QGCColoredImage {
//                 id:                         innerImage
//                 height:                     contentLayoutItem.height * imageScale
//                 width:                      contentLayoutItem.width  * imageScale
//                 smooth:                     true
//                 mipmap:                     true
//                 color:                      _currentContentColor
//                 fillMode:                   Image.PreserveAspectFit
//                 antialiasing:               true
//                 sourceSize.height:          height
//                 sourceSize.width:           width
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 visible:                    source != "" && !modelData.fullColorIcon

//                 QGCColoredImage {
//                     id:                         innerImageSecondColor
//                     source:                     modelData.alternateIconSource
//                     height:                     contentLayoutItem.height * imageScale
//                     width:                      contentLayoutItem.width  * imageScale
//                     smooth:                     true
//                     mipmap:                     true
//                     color:                      _currentContentColorSecondary
//                     fillMode:                   Image.PreserveAspectFit
//                     antialiasing:               true
//                     sourceSize.height:          height
//                     sourceSize.width:           width
//                     anchors.horizontalCenter:   parent.horizontalCenter
//                     visible:                    source != "" && modelData.biColorIcon
//                 }
//             }

//             QGCLabel {
//                 id:                         innerText
//                 text:                       control.text
//                 color:                      _currentContentColor
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 font.bold:                  !innerImage.visible && !innerImageColorful.visible
//                 opacity:                    !innerImage.visible ? 0.8 : 1.0
//             }
//         }
//     }

//     background: Rectangle {
//         id:     buttonBkRect
//         color:  (control.checked || control.pressed) ?
//                     qgcPal.buttonHighlight :
//                     ((control.enabled && control.hovered) ? qgcPal.toolStripHoverColor : "transparent")
//     }
// }


// C:\BV_GCS\qgc\src\QmlControls\ToolStripHoverButton.qml
// import QtQuick
// import QtQuick.Controls
// import Qt5Compat.GraphicalEffects
// // Qt5: import QtGraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Button {
//     id:             control
//     width:          contentLayoutItem.contentWidth + (contentMargins * 2)
//     height:         width
//     hoverEnabled:   !ScreenTools.isMobile
//     enabled:        toolStripAction.enabled
//     visible:        toolStripAction.visible
//     imageSource:    toolStripAction.showAlternateIcon ? modelData.alternateIconSource : modelData.iconSource
//     text:           toolStripAction.text
//     checked:        toolStripAction.checked
//     checkable:      toolStripAction.dropPanelComponent || modelData.checkable

//     property var    toolStripAction:    undefined
//     property var    dropPanel:          undefined
//     property alias  radius:             buttonBkRect.radius
//     property alias  fontPointSize:      innerText.font.pointSize
//     property alias  imageSource:        innerImage.source
//     property alias  contentWidth:       innerText.contentWidth

//     property bool   forceImageScale11:  false
//     property real   imageScale:         forceImageScale11 && (text == "") ? 0.8 : 0.6
//     property real   contentMargins:     innerText.height * 0.1

//     // ── Colour tokens ─────────────────────────────────────────────────────────
//     // Icon / label colour:  white when idle, accent-cyan on hover, white on press/check
//     readonly property color _accentCyan:    Qt.rgba(0.00, 0.83, 1.00, 1.0)
//     readonly property color _accentGreen:   Qt.rgba(0.00, 1.00, 0.60, 1.0)   // Takeoff / Land
//     readonly property color _accentOrange:  Qt.rgba(1.00, 0.55, 0.10, 1.0)   // RTL
//     readonly property color _accentRed:     Qt.rgba(1.00, 0.22, 0.35, 1.0)   // Pause / emergency

//     // Resolve per-action accent from button label so each action gets its own colour
//     readonly property color _resolvedAccent: {
//         var t = control.text.toLowerCase()
//         if (t === "takeoff" || t === "land")  return _accentGreen
//         if (t === "rtl"     || t === "return") return _accentOrange
//         if (t === "pause")                    return _accentRed
//         return _accentCyan
//     }

//     readonly property color _iconColor: {
//         if (control.checked || control.pressed) return Qt.rgba(1, 1, 1, 1.0)
//         if (control.hovered)                    return _resolvedAccent
//         return Qt.rgba(1, 1, 1, control.enabled ? 0.78 : 0.30)
//     }

//     readonly property color _labelColor: {
//         if (control.checked || control.pressed) return Qt.rgba(1, 1, 1, 1.0)
//         if (control.hovered)                    return Qt.rgba(1, 1, 1, 0.95)
//         return Qt.rgba(1, 1, 1, control.enabled ? 0.52 : 0.25)
//     }

//     // Legacy palette aliases — kept so nothing else breaks
//     property color _currentContentColor:          _iconColor
//     property color _currentContentColorSecondary: _resolvedAccent

//     signal dropped(int index)

//     onCheckedChanged: toolStripAction.checked = checked

//     onClicked: {
//         if (mainWindow.allowViewSwitch()) {
//             dropPanel.hide()
//             if (!toolStripAction.dropPanelComponent) {
//                 toolStripAction.triggered(this)
//             } else if (checked) {
//                 var panelEdgeTopPoint = mapToItem(_root, width, 0)
//                 dropPanel.show(panelEdgeTopPoint, toolStripAction.dropPanelComponent, this)
//                 checked = true
//                 control.dropped(index)
//             }
//         } else if (checkable) {
//             checked = !checked
//         }
//     }

//     QGCPalette { id: qgcPal; colorGroupEnabled: control.enabled }

//     // ── CONTENT ───────────────────────────────────────────────────────────────
//     contentItem: Item {
//         id:                 contentLayoutItem
//         anchors.fill:       parent
//         anchors.margins:    contentMargins

//         Column {
//             anchors.centerIn:   parent
//             spacing:            ScreenTools.defaultFontPixelWidth * 0.15

//             // Full-colour icon (e.g. 3D view)
//             Image {
//                 id:                         innerImageColorful
//                 height:                     contentLayoutItem.height * imageScale
//                 width:                      contentLayoutItem.width  * imageScale
//                 smooth:                     true
//                 mipmap:                     true
//                 fillMode:                   Image.PreserveAspectFit
//                 antialiasing:               true
//                 sourceSize.height:          height
//                 sourceSize.width:           width
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 source:                     control.imageSource
//                 visible:                    source !== "" && modelData.fullColorIcon

//                 // Dim when disabled
//                 opacity: control.enabled ? 1.0 : 0.35
//                 Behavior on opacity { NumberAnimation { duration: 180 } }
//             }

//             // Tinted mono icon
//             QGCColoredImage {
//                 id:                         innerImage
//                 height:                     contentLayoutItem.height * imageScale
//                 width:                      contentLayoutItem.width  * imageScale
//                 smooth:                     true
//                 mipmap:                     true
//                 color:                      control._iconColor
//                 fillMode:                   Image.PreserveAspectFit
//                 antialiasing:               true
//                 sourceSize.height:          height
//                 sourceSize.width:           width
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 visible:                    source !== "" && !modelData.fullColorIcon

//                 Behavior on color { ColorAnimation { duration: 180 } }

//                 // Bi-colour overlay icon
//                 QGCColoredImage {
//                     id:                         innerImageSecondColor
//                     source:                     modelData.alternateIconSource
//                     height:                     contentLayoutItem.height * imageScale
//                     width:                      contentLayoutItem.width  * imageScale
//                     smooth:                     true
//                     mipmap:                     true
//                     color:                      control._resolvedAccent
//                     fillMode:                   Image.PreserveAspectFit
//                     antialiasing:               true
//                     sourceSize.height:          height
//                     sourceSize.width:           width
//                     anchors.horizontalCenter:   parent.horizontalCenter
//                     visible:                    source !== "" && modelData.biColorIcon
//                 }
//             }

//             // Label
//             QGCLabel {
//                 id:                         innerText
//                 text:                       control.text
//                 color:                      control._labelColor
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 font.bold:                  !innerImage.visible && !innerImageColorful.visible
//                 font.letterSpacing:         0.4
//                 opacity:                    !innerImage.visible ? 0.8 : 1.0

//                 Behavior on color { ColorAnimation { duration: 180 } }
//             }
//         }
//     }

//     // ── BACKGROUND ────────────────────────────────────────────────────────────
//     background: Item {
//         id: buttonBkItem

//         property alias radius: buttonBkRect.radius

//         // Base glass rect
//         Rectangle {
//             id:             buttonBkRect
//             anchors.fill:   parent
//             color: {
//                 if (control.checked || control.pressed)
//                     return Qt.rgba(0.0, 0.83, 1.0, 0.18)   // cyan tint when active
//                 if (control.enabled && control.hovered)
//                     return Qt.rgba(1, 1, 1, 0.09)           // white tint on hover
//                 return Qt.rgba(1, 1, 1, 0.0)               // transparent at rest
//             }
//             border.color: {
//                 if (control.checked || control.pressed)
//                     return Qt.rgba(0.0, 0.83, 1.0, 0.40)
//                 if (control.enabled && control.hovered)
//                     return Qt.rgba(1, 1, 1, 0.16)
//                 return Qt.rgba(1, 1, 1, 0.0)
//             }
//             border.width:   1

//             Behavior on color        { ColorAnimation { duration: 150 } }
//             Behavior on border.color { ColorAnimation { duration: 150 } }

//             // Top micro-shimmer per button
//             Rectangle {
//                 anchors.top:                parent.top
//                 anchors.topMargin:          1
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 width:                      parent.width * 0.55
//                 height:                     1
//                 visible:                    control.hovered || control.checked || control.pressed
//                 opacity:                    control.hovered ? 0.9 : 0.5
//                 gradient: Gradient {
//                     orientation: Gradient.Horizontal
//                     GradientStop { position: 0.0; color: "transparent" }
//                     GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.30) }
//                     GradientStop { position: 1.0; color: "transparent" }
//                 }
//                 Behavior on opacity { NumberAnimation { duration: 150 } }
//             }
//         }

//         // Accent glow line at bottom of button (only on hover / active)
//         Rectangle {
//             id:                         accentLine
//             anchors.bottom:             parent.bottom
//             anchors.bottomMargin:       3
//             anchors.horizontalCenter:   parent.horizontalCenter
//             width:                      parent.width * 0.45
//             height:                     2
//             radius:                     1
//             color:                      control._resolvedAccent
//             opacity:                    (control.hovered || control.checked || control.pressed) ? 0.90 : 0.0

//             Behavior on opacity { NumberAnimation { duration: 200 } }

//             // Soft glow around the accent line
//             layer.enabled: true
//             layer.effect: Glow {
//                 radius:             4
//                 samples:            9
//                 color:              control._resolvedAccent
//                 transparentBorder:  true
//             }
//         }

//         // Checked state: left edge accent bar
//         Rectangle {
//             anchors.left:           parent.left
//             anchors.leftMargin:     0
//             anchors.top:            parent.top
//             anchors.topMargin:      buttonBkRect.radius
//             anchors.bottom:         parent.bottom
//             anchors.bottomMargin:   buttonBkRect.radius
//             width:                  2
//             radius:                 1
//             color:                  control._resolvedAccent
//             opacity:                control.checked ? 0.90 : 0.0

//             Behavior on opacity { NumberAnimation { duration: 200 } }
//         }
//     }

//     // ── PRESS SCALE ANIMATION ─────────────────────────────────────────────────
//     states: [
//         State {
//             name: "pressed"
//             when: control.pressed
//             PropertyChanges { target: control; scale: 0.93 }
//         },
//         State {
//             name: "normal"
//             when: !control.pressed
//             PropertyChanges { target: control; scale: 1.0 }
//         }
//     ]

//     transitions: [
//         Transition {
//             to: "pressed"
//             NumberAnimation { property: "scale"; duration: 80;  easing.type: Easing.OutQuad }
//         },
//         Transition {
//             to: "normal"
//             NumberAnimation { property: "scale"; duration: 180; easing.type: Easing.OutBack; easing.overshoot: 1.3 }
//         }
//     ]
// }

// C:\BV_GCS\qgc\src\QmlControls\ToolStripHoverButton.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
// Qt5: import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls

Button {
    id:             control
    width:          contentLayoutItem.contentWidth + (contentMargins * 2)
    height:         width
    hoverEnabled:   !ScreenTools.isMobile
    enabled:        toolStripAction.enabled
    visible:        toolStripAction.visible
    imageSource:    toolStripAction.showAlternateIcon ? modelData.alternateIconSource : modelData.iconSource
    text:           toolStripAction.text
    checked:        toolStripAction.checked
    checkable:      toolStripAction.dropPanelComponent || modelData.checkable

    property var    toolStripAction:    undefined
    property var    dropPanel:          undefined
    property alias  radius:             buttonBkRect.radius
    property alias  fontPointSize:      innerText.font.pointSize
    property alias  imageSource:        innerImage.source
    property alias  contentWidth:       innerText.contentWidth

    property bool   forceImageScale11:  false
    property real   imageScale:         forceImageScale11 && (text == "") ? 0.8 : 0.6
    property real   contentMargins:     innerText.height * 0.1

    // ── Colour tokens ─────────────────────────────────────────────────────────
    // Icon / label colour:  white when idle, accent-cyan on hover, white on press/check
    readonly property color _accentCyan:    Qt.rgba(0.00, 0.83, 1.00, 1.0)
    readonly property color _accentGreen:   Qt.rgba(0.00, 1.00, 0.60, 1.0)   // Takeoff / Land
    readonly property color _accentOrange:  Qt.rgba(1.00, 0.55, 0.10, 1.0)   // RTL
    readonly property color _accentRed:     Qt.rgba(1.00, 0.22, 0.35, 1.0)   // Pause / emergency

    // Resolve per-action accent from button label so each action gets its own colour
    readonly property color _resolvedAccent: {
        var t = control.text.toLowerCase()
        if (t === "takeoff" || t === "land")  return _accentGreen
        if (t === "rtl"     || t === "return") return _accentOrange
        if (t === "pause")                    return _accentRed
        return _accentCyan
    }

    readonly property color _iconColor: {
        if (control.checked || control.pressed) return Qt.rgba(1, 1, 1, 1.0)
        if (control.hovered)                    return _resolvedAccent
        return Qt.rgba(1, 1, 1, control.enabled ? 0.78 : 0.30)
    }

    readonly property color _labelColor: {
        if (control.checked || control.pressed) return Qt.rgba(1, 1, 1, 1.0)
        if (control.hovered)                    return Qt.rgba(1, 1, 1, 0.95)
        return Qt.rgba(1, 1, 1, control.enabled ? 0.52 : 0.25)
    }

    // Legacy palette aliases — kept so nothing else breaks
    property color _currentContentColor:          _iconColor
    property color _currentContentColorSecondary: _resolvedAccent

    signal dropped(int index)

    onCheckedChanged: toolStripAction.checked = checked

    onClicked: {
        if (mainWindow.allowViewSwitch()) {
            dropPanel.hide()
            if (!toolStripAction.dropPanelComponent) {
                toolStripAction.triggered(this)
            } else if (checked) {
                var panelEdgeTopPoint = mapToItem(_root, width, 0)
                dropPanel.show(panelEdgeTopPoint, toolStripAction.dropPanelComponent, this)
                checked = true
                control.dropped(index)
            }
        } else if (checkable) {
            checked = !checked
        }
    }

    QGCPalette { id: qgcPal; colorGroupEnabled: control.enabled }

    // ── CONTENT ───────────────────────────────────────────────────────────────
    contentItem: Item {
        id:                 contentLayoutItem
        anchors.fill:       parent
        anchors.margins:    contentMargins

        Column {
            // Shift icon+label slightly above center so label clears the accent line
            anchors.horizontalCenter:       parent.horizontalCenter
            anchors.verticalCenter:         parent.verticalCenter
            anchors.verticalCenterOffset:   -ScreenTools.defaultFontPixelWidth * 0.5
            spacing:                        ScreenTools.defaultFontPixelWidth * 0.15

            // Full-colour icon (e.g. 3D view)
            Image {
                id:                         innerImageColorful
                height:                     contentLayoutItem.height * imageScale
                width:                      contentLayoutItem.width  * imageScale
                smooth:                     true
                mipmap:                     true
                fillMode:                   Image.PreserveAspectFit
                antialiasing:               true
                sourceSize.height:          height
                sourceSize.width:           width
                anchors.horizontalCenter:   parent.horizontalCenter
                source:                     control.imageSource
                visible:                    source !== "" && modelData.fullColorIcon

                // Dim when disabled
                opacity: control.enabled ? 1.0 : 0.35
                Behavior on opacity { NumberAnimation { duration: 180 } }
            }

            // Tinted mono icon
            QGCColoredImage {
                id:                         innerImage
                height:                     contentLayoutItem.height * imageScale
                width:                      contentLayoutItem.width  * imageScale
                smooth:                     true
                mipmap:                     true
                color:                      control._iconColor
                fillMode:                   Image.PreserveAspectFit
                antialiasing:               true
                sourceSize.height:          height
                sourceSize.width:           width
                anchors.horizontalCenter:   parent.horizontalCenter
                visible:                    source !== "" && !modelData.fullColorIcon

                Behavior on color { ColorAnimation { duration: 180 } }

                // Bi-colour overlay icon
                QGCColoredImage {
                    id:                         innerImageSecondColor
                    source:                     modelData.alternateIconSource
                    height:                     contentLayoutItem.height * imageScale
                    width:                      contentLayoutItem.width  * imageScale
                    smooth:                     true
                    mipmap:                     true
                    color:                      control._resolvedAccent
                    fillMode:                   Image.PreserveAspectFit
                    antialiasing:               true
                    sourceSize.height:          height
                    sourceSize.width:           width
                    anchors.horizontalCenter:   parent.horizontalCenter
                    visible:                    source !== "" && modelData.biColorIcon
                }
            }

            // Label
            QGCLabel {
                id:                         innerText
                text:                       control.text
                color:                      control._labelColor
                anchors.horizontalCenter:   parent.horizontalCenter
                font.bold:                  !innerImage.visible && !innerImageColorful.visible
                font.letterSpacing:         0.4
                opacity:                    !innerImage.visible ? 0.8 : 1.0

                Behavior on color { ColorAnimation { duration: 180 } }
            }
        }
    }

    // ── BACKGROUND ────────────────────────────────────────────────────────────
    background: Item {
        id: buttonBkItem

        property alias radius: buttonBkRect.radius

        // Base glass rect
        Rectangle {
            id:             buttonBkRect
            anchors.fill:   parent
            color: {
                if (control.checked || control.pressed)
                    return Qt.rgba(0.0, 0.83, 1.0, 0.18)   // cyan tint when active
                if (control.enabled && control.hovered)
                    return Qt.rgba(1, 1, 1, 0.09)           // white tint on hover
                return Qt.rgba(1, 1, 1, 0.0)               // transparent at rest
            }
            border.color: {
                if (control.checked || control.pressed)
                    return Qt.rgba(0.0, 0.83, 1.0, 0.40)
                if (control.enabled && control.hovered)
                    return Qt.rgba(1, 1, 1, 0.16)
                return Qt.rgba(1, 1, 1, 0.0)
            }
            border.width:   1

            Behavior on color        { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }

            // Top micro-shimmer per button
            Rectangle {
                anchors.top:                parent.top
                anchors.topMargin:          1
                anchors.horizontalCenter:   parent.horizontalCenter
                width:                      parent.width * 0.55
                height:                     1
                visible:                    control.hovered || control.checked || control.pressed
                opacity:                    control.hovered ? 0.9 : 0.5
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.30) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                Behavior on opacity { NumberAnimation { duration: 150 } }
            }
        }

        // Accent glow line — pinned to the very bottom edge, outside text area
        Rectangle {
            id:                         accentLine
            anchors.bottom:             parent.bottom
            anchors.bottomMargin:       0          // flush with bottom edge of button
            anchors.horizontalCenter:   parent.horizontalCenter
            width:                      parent.width * 0.55
            height:                     2
            radius:                     1
            color:                      control._resolvedAccent
            opacity:                    (control.hovered || control.checked || control.pressed) ? 0.90 : 0.0

            Behavior on opacity { NumberAnimation { duration: 200 } }

            // Soft glow — kept tight so it doesn't bleed into label above
            layer.enabled: true
            layer.effect: Glow {
                radius:             3
                samples:            7
                color:              control._resolvedAccent
                transparentBorder:  true
            }
        }

        // Checked state: left edge accent bar
        Rectangle {
            anchors.left:           parent.left
            anchors.leftMargin:     0
            anchors.top:            parent.top
            anchors.topMargin:      buttonBkRect.radius
            anchors.bottom:         parent.bottom
            anchors.bottomMargin:   buttonBkRect.radius
            width:                  2
            radius:                 1
            color:                  control._resolvedAccent
            opacity:                control.checked ? 0.90 : 0.0

            Behavior on opacity { NumberAnimation { duration: 200 } }
        }
    }

    // ── PRESS SCALE ANIMATION ─────────────────────────────────────────────────
    states: [
        State {
            name: "pressed"
            when: control.pressed
            PropertyChanges { target: control; scale: 0.93 }
        },
        State {
            name: "normal"
            when: !control.pressed
            PropertyChanges { target: control; scale: 1.0 }
        }
    ]

    transitions: [
        Transition {
            to: "pressed"
            NumberAnimation { property: "scale"; duration: 80;  easing.type: Easing.OutQuad }
        },
        Transition {
            to: "normal"
            NumberAnimation { property: "scale"; duration: 180; easing.type: Easing.OutBack; easing.overshoot: 1.3 }
        }
    ]
}
