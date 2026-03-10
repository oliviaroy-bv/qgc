// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
// import QtQuick.Dialogs

// import QGroundControl
// import QGroundControl.Controls
// import QGroundControl.FlyView

// Item {
//     required property var guidedValueSlider

//     id:     control
//     width:  parent.width
//     height: ScreenTools.toolbarHeight

//     property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
//     property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
//     property color  _mainStatusBGColor: qgcPal.brandingPurple
//     property real   _leftRightMargin:   ScreenTools.defaultFontPixelWidth * 0.75
//     property var    _guidedController:  globals.guidedControllerFlyView

//     function dropMainStatusIndicatorTool() {
//         mainStatusIndicator.dropMainStatusIndicator();
//     }

//     QGCPalette { id: qgcPal }

//     QGCFlickable {
//         anchors.fill:       parent
//         contentWidth:       toolBarLayout.width
//         flickableDirection: Flickable.HorizontalFlick

//         Row {
//             id:         toolBarLayout
//             height:     parent.height
//             spacing:    0

//             Item {
//                 id:     leftPanel
//                 width:  leftPanelLayout.implicitWidth
//                 height: parent.height

//                 // Gradient background behind Q button and main status indicator
//                 Rectangle {
//                     id:         gradientBackground
//                     height:     parent.height
//                     width:      mainStatusLayout.width
//                     opacity:    qgcPal.windowTransparent.a

//                     gradient: Gradient {
//                         orientation: Gradient.Horizontal
//                         GradientStop { position: 0; color: _mainStatusBGColor }
//                         //GradientStop { position: qgcButton.x + qgcButton.width; color: _mainStatusBGColor }
//                         GradientStop { position: 1; color: qgcPal.window }
//                     }
//                 }

//                 // Standard toolbar background to the right of the gradient
//                 Rectangle {
//                     anchors.left:   gradientBackground.right
//                     anchors.right:  parent.right
//                     height:         parent.height
//                     color:          qgcPal.windowTransparent
//                 }

//                 RowLayout {
//                     id:         leftPanelLayout
//                     height:     parent.height
//                     spacing:    ScreenTools.defaultFontPixelWidth * 2

//                     RowLayout {
//                         id:         mainStatusLayout
//                         height:     parent.height
//                         spacing:    0

//                         QGCToolBarButton {
//                             id:                 qgcButton
//                             Layout.fillHeight:  true
//                             icon.source:        "/res/QGCLogoFull.svg"
//                             logo:               true
//                             onClicked:          mainWindow.showToolSelectDialog()
//                         }

//                         MainStatusIndicator {
//                             id:                 mainStatusIndicator
//                             Layout.fillHeight:  true
//                         }
//                     }

//                     QGCButton {
//                         id:         disconnectButton
//                         text:       qsTr("Disconnect")
//                         onClicked:  _activeVehicle.closeVehicle()
//                         visible:    _activeVehicle && _communicationLost
//                     }

//                     FlightModeIndicator {
//                         Layout.fillHeight:  true
//                         visible:            _activeVehicle
//                     }
//                 }
//             }
//             Item {
//                 id:     centerPanel
//                 // center panel takes up all remaining space in toolbar between left and right panels
//                 width:  Math.max(guidedActionConfirm.visible ? guidedActionConfirm.width : 0, control.width - (leftPanel.width + rightPanel.width))
//                 height: parent.height

//                 Rectangle {
//                     anchors.fill:   parent
//                     color:          qgcPal.windowTransparent
//                 }

//                 GuidedActionConfirm {
//                     id:                         guidedActionConfirm
//                     height:                     parent.height
//                     anchors.horizontalCenter:   parent.horizontalCenter
//                     guidedController:           control._guidedController
//                     guidedValueSlider:          control.guidedValueSlider
//                     messageDisplay:             guidedActionMessageDisplay
//                 }
//             }

//             Item {
//                 id:     rightPanel
//                 width:  flyViewIndicators.width
//                 height: parent.height

//                 Rectangle {
//                     anchors.fill:   parent
//                     color:          qgcPal.windowTransparent
//                 }

//                 FlyViewToolBarIndicators {
//                     id:     flyViewIndicators
//                     height: parent.height
//                 }
//             }
//         }
//     }

//     // The guided action message display is outside of the GuidedActionConfirm control so that it doesn't end up as
//     // part of the Flickable
//     Rectangle {
//         id:                         guidedActionMessageDisplay
//         anchors.top:                control.bottom
//         anchors.topMargin:          _margins
//         x:                          control.mapFromItem(guidedActionConfirm.parent, guidedActionConfirm.x, 0).x + (guidedActionConfirm.width - guidedActionMessageDisplay.width) / 2
//         width:                      messageLabel.contentWidth + (_margins * 2)
//         height:                     messageLabel.contentHeight + (_margins * 2)
//         color:                      qgcPal.windowTransparent
//         radius:                     ScreenTools.defaultBorderRadius
//         visible:                    guidedActionConfirm.visible

//         QGCLabel {
//             id:         messageLabel
//             x:          _margins
//             y:          _margins
//             width:      ScreenTools.defaultFontPixelWidth * 30
//             wrapMode:   Text.WordWrap
//             text:       guidedActionConfirm.message
//         }

//         PropertyAnimation {
//             id:         messageOpacityAnimation
//             target:     guidedActionMessageDisplay
//             property:   "opacity"
//             from:       1
//             to:         0
//             duration:   500
//         }

//         Timer {
//             id:             messageFadeTimer
//             interval:       4000
//             onTriggered:    messageOpacityAnimation.start()
//         }
//     }

//     ParameterDownloadProgress {
//         anchors.fill: parent
//     }
// }


// ==============================================================
// ==============================================================
// ==============================================================

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

// Use the correct import for your Qt version:
// Qt 6.x:
import Qt5Compat.GraphicalEffects
// Qt 5.x (comment out above and uncomment below):
// import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FlyView

Item {
    required property var guidedValueSlider

    // ── NEW: pass your map item from FlyView.qml so blur can sample it
    //   In FlyView.qml, use:  FlyViewToolBar { mapSourceItem: flightMap; ... }
    property var mapSourceItem: null

    id:     control
    width:  parent.width
    height: ScreenTools.toolbarHeight

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property bool   _communicationLost: _activeVehicle ? _activeVehicle.vehicleLinkManager.communicationLost : false
    property color  _mainStatusBGColor: qgcPal.brandingPurple
    property real   _leftRightMargin:   ScreenTools.defaultFontPixelWidth * 0.75
    property var    _guidedController:  globals.guidedControllerFlyView

    function dropMainStatusIndicatorTool() {
        mainStatusIndicator.dropMainStatusIndicator();
    }

    QGCPalette { id: qgcPal }

    // ─────────────────────────────────────────────────────────────────
    //  LIQUID GLASS TOOLBAR BACKGROUND
    //  Layers (bottom → top):
    //    1. ShaderEffectSource  — captures whatever is behind the toolbar
    //    2. FastBlur            — blurs that captured image (frosted effect)
    //    3. Dark tint rect      — semi-transparent dark overlay
    //    4. Top shimmer line    — the "liquid" highlight at the very top
    //    5. Inner glow rect     — soft upper-half brightness
    //    6. Bottom border line  — subtle separator from content below
    // ─────────────────────────────────────────────────────────────────
    Item {
        id:             glassBackground
        anchors.fill:   parent
        z:              0

        // 1. Capture the map (or whatever is rendered behind this toolbar)
        ShaderEffectSource {
            id:             blurSource
            anchors.fill:   parent
            sourceItem:     control.mapSourceItem
            live:           true
            visible:        false
        }

        // 2. Frosted blur — increase radius for more blur, decrease for performance
        FastBlur {
            id:             backgroundBlur
            anchors.fill:   parent
            source:         blurSource
            radius:         56
        }

        // 3. Dark semi-transparent tint over the blur
        //    Tweak the last value (0.52) for more/less transparency
        Rectangle {
            anchors.fill:   parent
            color:          Qt.rgba(0.04, 0.047, 0.08, 0.52)
        }

        // 4. Top shimmer highlight — the signature "liquid glass" line
        Rectangle {
            id:                         topShimmer
            anchors.top:                parent.top
            anchors.horizontalCenter:   parent.horizontalCenter
            width:                      parent.width * 0.75
            height:                     1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: "transparent" }
                GradientStop { position: 0.25; color: Qt.rgba(1, 1, 1, 0.18) }
                GradientStop { position: 0.5;  color: Qt.rgba(1, 1, 1, 0.42) }
                GradientStop { position: 0.75; color: Qt.rgba(1, 1, 1, 0.18) }
                GradientStop { position: 1.0;  color: "transparent" }
            }
        }

        // 5. Upper-half inner brightness glow
        Rectangle {
            anchors.top:    parent.top
            anchors.left:   parent.left
            anchors.right:  parent.right
            height:         parent.height * 0.5
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.055) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }

        // 6. Bottom border — subtle separator
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            anchors.right:  parent.right
            height:         1
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: "transparent" }
                GradientStop { position: 0.15; color: Qt.rgba(1, 1, 1, 0.10) }
                GradientStop { position: 0.85; color: Qt.rgba(1, 1, 1, 0.10) }
                GradientStop { position: 1.0;  color: "transparent" }
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────
    //  TOOLBAR CONTENT (unchanged structure, z:1 so it sits above glass)
    // ─────────────────────────────────────────────────────────────────
    QGCFlickable {
        anchors.fill:       parent
        contentWidth:       toolBarLayout.width
        flickableDirection: Flickable.HorizontalFlick
        z:                  1

        Row {
            id:         toolBarLayout
            height:     parent.height
            spacing:    0

            // ── LEFT PANEL ──────────────────────────────────────────
            Item {
                id:     leftPanel
                width:  leftPanelLayout.implicitWidth
                height: parent.height

                // Glass tint for the left branding section
                // Slightly more opaque than center/right to ground the logo area
                Rectangle {
                    id:             leftPanelGlass
                    anchors.fill:   parent
                    color:          Qt.rgba(0.03, 0.035, 0.07, 0.30)

                    // Left-edge accent — brand color whisper
                    Rectangle {
                        anchors.left:   parent.left
                        anchors.top:    parent.top
                        anchors.bottom: parent.bottom
                        width:          2
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.3; color: Qt.rgba(
                                control._mainStatusBGColor.r,
                                control._mainStatusBGColor.g,
                                control._mainStatusBGColor.b,
                                0.55)
                            }
                            GradientStop { position: 0.7; color: Qt.rgba(
                                control._mainStatusBGColor.r,
                                control._mainStatusBGColor.g,
                                control._mainStatusBGColor.b,
                                0.55)
                            }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }
                }

                RowLayout {
                    id:         leftPanelLayout
                    height:     parent.height
                    spacing:    ScreenTools.defaultFontPixelWidth * 2

                    RowLayout {
                        id:         mainStatusLayout
                        height:     parent.height
                        spacing:    0

                        QGCToolBarButton {
                            id:                 qgcButton
                            Layout.fillHeight:  true
                            icon.source:        "/res/QGCLogoFull.svg"
                            logo:               true
                            onClicked:          mainWindow.showToolSelectDialog()

                            // Glass pill highlight around the logo button
                            background: Rectangle {
                                color:          Qt.rgba(1, 1, 1, qgcButton.pressed ? 0.12 : (qgcButton.hovered ? 0.08 : 0.0))
                                radius:         4
                                border.color:   Qt.rgba(1, 1, 1, qgcButton.hovered ? 0.15 : 0.0)
                                border.width:   1
                                Behavior on color { ColorAnimation { duration: 150 } }
                            }
                        }

                        MainStatusIndicator {
                            id:                 mainStatusIndicator
                            Layout.fillHeight:  true
                        }
                    }

                    QGCButton {
                        id:         disconnectButton
                        text:       qsTr("Disconnect")
                        onClicked:  _activeVehicle.closeVehicle()
                        visible:    _activeVehicle && _communicationLost

                        // Glass-style disconnect button
                        background: Rectangle {
                            color:          Qt.rgba(0.9, 0.15, 0.15, 0.25)
                            radius:         6
                            border.color:   Qt.rgba(1, 0.3, 0.3, 0.45)
                            border.width:   1
                        }
                        contentItem: Text {
                            text:               disconnectButton.text
                            color:              Qt.rgba(1, 0.5, 0.5, 1)
                            font:               disconnectButton.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment:   Text.AlignVCenter
                        }
                    }

                    FlightModeIndicator {
                        Layout.fillHeight:  true
                        visible:            _activeVehicle
                    }
                }
            }

            // ── CENTER PANEL ─────────────────────────────────────────
            Item {
                id:     centerPanel
                width:  Math.max(guidedActionConfirm.visible ? guidedActionConfirm.width : 0, control.width - (leftPanel.width + rightPanel.width))
                height: parent.height

                // Transparent — glass background shows through from glassBackground
                Rectangle {
                    anchors.fill:   parent
                    color:          "transparent"
                }

                GuidedActionConfirm {
                    id:                         guidedActionConfirm
                    height:                     parent.height
                    anchors.horizontalCenter:   parent.horizontalCenter
                    guidedController:           control._guidedController
                    guidedValueSlider:          control.guidedValueSlider
                    messageDisplay:             guidedActionMessageDisplay
                }
            }

            // ── RIGHT PANEL ──────────────────────────────────────────
            Item {
                id:     rightPanel
                width:  flyViewIndicators.width
                height: parent.height

                // Transparent — glass background shows through
                Rectangle {
                    anchors.fill:   parent
                    color:          "transparent"

                    // Right-edge fade — mirrors the left brand accent
                    Rectangle {
                        anchors.right:  parent.right
                        anchors.top:    parent.top
                        anchors.bottom: parent.bottom
                        width:          ScreenTools.defaultFontPixelWidth * 1.5
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.18) }
                        }
                    }
                }

                FlyViewToolBarIndicators {
                    id:     flyViewIndicators
                    height: parent.height
                }
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────
    //  GUIDED ACTION MESSAGE DISPLAY
    //  Kept outside Flickable (unchanged logic) — glass styled
    // ─────────────────────────────────────────────────────────────────
    Item {
        id:                         guidedActionMessageDisplay
        anchors.top:                control.bottom
        anchors.topMargin:          ScreenTools.defaultFontPixelWidth
        x:                          control.mapFromItem(guidedActionConfirm.parent, guidedActionConfirm.x, 0).x + (guidedActionConfirm.width - guidedActionMessageDisplay.width) / 2
        width:                      messageLabel.contentWidth + (ScreenTools.defaultFontPixelWidth * 2)
        height:                     messageLabel.contentHeight + (ScreenTools.defaultFontPixelWidth * 2)
        visible:                    guidedActionConfirm.visible
        z:                          100

        // Glass background for the message bubble
        Rectangle {
            anchors.fill:   parent
            color:          Qt.rgba(0.04, 0.047, 0.08, 0.82)
            radius:         ScreenTools.defaultBorderRadius
            border.color:   Qt.rgba(1, 1, 1, 0.12)
            border.width:   1

            // Top shimmer on message bubble
            Rectangle {
                anchors.top:                parent.top
                anchors.topMargin:          1
                anchors.horizontalCenter:   parent.horizontalCenter
                width:                      parent.width * 0.5
                height:                     1
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.30) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        QGCLabel {
            id:         messageLabel
            x:          ScreenTools.defaultFontPixelWidth
            y:          ScreenTools.defaultFontPixelWidth
            width:      ScreenTools.defaultFontPixelWidth * 30
            wrapMode:   Text.WordWrap
            text:       guidedActionConfirm.message
            color:      Qt.rgba(1, 1, 1, 0.90)
        }

        PropertyAnimation {
            id:         messageOpacityAnimation
            target:     guidedActionMessageDisplay
            property:   "opacity"
            from:       1
            to:         0
            duration:   500
        }

        Timer {
            id:             messageFadeTimer
            interval:       4000
            onTriggered:    messageOpacityAnimation.start()
        }
    }

    // ─────────────────────────────────────────────────────────────────
    //  PARAMETER DOWNLOAD PROGRESS — unchanged, sits on top of glass
    // ─────────────────────────────────────────────────────────────────
    ParameterDownloadProgress {
        anchors.fill:   parent
        z:              2
    }
}
