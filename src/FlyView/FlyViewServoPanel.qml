// C:\BV_GCS\qgc\src\FlyView\FlyViewServoPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
// Qt5: import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls
// import MAVLink

Item {
    id:     root
    width:  panelColumn.width  + (ScreenTools.defaultFontPixelWidth  * 4.0)
    height: panelColumn.height + (ScreenTools.defaultFontPixelHeight * 1.5)

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    // ── Sizing tokens (scale with screen DPI) ────────────────────────────────
    readonly property real _pad:        ScreenTools.defaultFontPixelWidth  * 1.2
    readonly property real _rowH:       ScreenTools.defaultFontPixelHeight * 3.2
    readonly property real _badgeW:     ScreenTools.defaultFontPixelWidth  * 5.5
    readonly property real _btnW:       ScreenTools.defaultFontPixelWidth  * 8.0
    readonly property real _pwmW:       ScreenTools.defaultFontPixelWidth  * 8.0
    readonly property real _radius:     ScreenTools.defaultFontPixelWidth  * 0.7
    readonly property real _panelR:     ScreenTools.defaultFontPixelWidth  * 1.6
    readonly property real _colSpacing: ScreenTools.defaultFontPixelWidth  * 1.2
    readonly property real _rowSpacing: ScreenTools.defaultFontPixelWidth  * 0.9

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    // ── GLASS PANEL BACKGROUND ───────────────────────────────────────────────
    Item {
        id:             glassBackground
        anchors.fill:   parent
        z:              0

        layer.enabled:  true
        layer.effect:   OpacityMask {
            maskSource: Rectangle {
                width:  glassBackground.width
                height: glassBackground.height
                radius: _panelR
            }
        }

        // Dark tint — panel has no map directly behind it so we use solid glass
        Rectangle {
            anchors.fill:   parent
            color:          Qt.rgba(0.04, 0.047, 0.09, 0.88)
        }

        // Upper inner brightness glow
        Rectangle {
            anchors.top:    parent.top
            anchors.left:   parent.left
            anchors.right:  parent.right
            height:         parent.height * 0.25
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    // Outer border
    Rectangle {
        anchors.fill:   parent
        color:          "transparent"
        radius:         _panelR
        border.color:   Qt.rgba(1, 1, 1, 0.10)
        border.width:   1
        z:              1
    }

    // Top shimmer
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
            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.35) }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    // ── HEADER ROW ───────────────────────────────────────────────────────────
    // Row {
    //     id:                         headerRow
    //     anchors.top:                parent.top
    //     anchors.topMargin:          ScreenTools.defaultFontPixelHeight * 0.7
    //     anchors.horizontalCenter:   parent.horizontalCenter
    //     spacing:                    _colSpacing
    //     z:                          3

    //     // Badge column header (blank — aligns with S-badge)
    //     Item { width: _badgeW; height: _rowH * 0.7 }

    //     // Button column headers
    //     Repeater {
    //         model: ["Low", "Mid", "High"]
    //         Item {
    //             width:  _btnW
    //             height: _rowH * 0.7
    //             Text {
    //                 anchors.centerIn:   parent
    //                 text:               modelData
    //                 color:              Qt.rgba(1, 1, 1, 0.35)
    //                 font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.6
    //                 font.letterSpacing: 0.5
    //             }
    //         }
    //     }

    //     // Divider spacer
    //     Item { width: 1; height: _rowH * 0.7 }

    //     // PWM column headers
    //     Repeater {
    //         model: ["PWM Lo", "PWM Hi"]
    //         Item {
    //             width:  _pwmW
    //             height: _rowH * 0.7
    //             Text {
    //                 anchors.centerIn:   parent
    //                 text:               modelData
    //                 color:              Qt.rgba(0.0, 0.83, 1.0, 0.45)
    //                 font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.4
    //                 font.letterSpacing: 0.3
    //             }
    //         }
    //     }
    // }

    // // Thin header separator
    // Rectangle {
    //     id:                         headerSep
    //     anchors.top:                headerRow.bottom
    //     anchors.topMargin:          ScreenTools.defaultFontPixelWidth * 0.3
    //     anchors.horizontalCenter:   parent.horizontalCenter
    //     width:                      parent.width * 0.88
    //     height:                     1
    //     z:                          3
    //     gradient: Gradient {
    //         orientation: Gradient.Horizontal
    //         GradientStop { position: 0.0; color: "transparent" }
    //         GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.08) }
    //         GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.08) }
    //         GradientStop { position: 1.0; color: "transparent" }
    //     }
    // }

    // ── SERVO ROWS ────────────────────────────────────────────────────────────
    Column {
        id:                         panelColumn
        anchors.top:                parent.top
        anchors.topMargin:          ScreenTools.defaultFontPixelWidth * 0.5
        anchors.horizontalCenter:   parent.horizontalCenter
        spacing:                    _rowSpacing
        z:                          3

        Repeater {
            model: 6   // Servos S9 – S14

            delegate: Item {
                id:     servoRow
                width:  rowContent.implicitWidth
                height: _rowH

                property int    servoNumber:    9 + index
                property bool   _rowHovered:    lowMouse.containsMouse ||
                                                midMouse.containsMouse ||
                                                highMouse.containsMouse

                // Row hover highlight
                Rectangle {
                    anchors.fill:   parent
                    radius:         _radius
                    color:          servoRow._rowHovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                Row {
                    id:                 rowContent
                    anchors.centerIn:   parent
                    spacing:            _colSpacing

                    // ── S-badge ──────────────────────────────────────────────
                    Rectangle {
                        width:              _badgeW
                        height:             _rowH * 0.72
                        radius:             _radius
                        color:              Qt.rgba(0.0, 0.83, 1.0, 0.10)
                        border.color:       Qt.rgba(0.0, 0.83, 1.0, 0.22)
                        border.width:       1
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            anchors.centerIn:   parent
                            text:               "S" + servoNumber
                            color:              Qt.rgba(0.0, 0.83, 1.0, 0.90)
                            font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.8
                            font.bold:          true
                            font.letterSpacing: 0.3
                        }
                    }

                    // ── Low button ───────────────────────────────────────────
                    ServoButton {
                        id:         lowBtn
                        btnLabel:   "Low"
                        mouseId:    lowMouse
                        btnW:       _btnW
                        btnH:       _rowH * 0.72
                        btnRadius:  _radius
                        accentColor: Qt.rgba(0.0, 1.0, 0.55, 1)   // green — low = safe

                        MouseArea {
                            id:             lowMouse
                            anchors.fill:   parent
                            hoverEnabled:   true
                            onClicked:      sendServoCommand(servoNumber, parseInt(lowPwm.text))
                        }
                    }

                    // ── Mid button ───────────────────────────────────────────
                    ServoButton {
                        btnLabel:   "Mid"
                        mouseId:    midMouse
                        btnW:       _btnW
                        btnH:       _rowH * 0.72
                        btnRadius:  _radius
                        accentColor: Qt.rgba(0.0, 0.83, 1.0, 1)   // cyan — neutral

                        MouseArea {
                            id:             midMouse
                            anchors.fill:   parent
                            hoverEnabled:   true
                            onClicked:     _activeVehicle.servoTest(servoNumber, parseInt(midPwm.text), true)
                        }
                    }

                    // ── High button ──────────────────────────────────────────
                    ServoButton {
                        btnLabel:   "High"
                        mouseId:    highMouse
                        btnW:       _btnW
                        btnH:       _rowH * 0.72
                        btnRadius:  _radius
                        accentColor: Qt.rgba(1.0, 0.55, 0.10, 1)  // orange — high = caution

                        MouseArea {
                            id:             highMouse
                            anchors.fill:   parent
                            hoverEnabled:   true
                            onClicked:      sendServoCommand(servoNumber, parseInt(highPwm.text))
                        }
                    }

                    // ── Divider ──────────────────────────────────────────────
                    Rectangle {
                        width:                  1
                        height:                 _rowH * 0.55
                        anchors.verticalCenter: parent.verticalCenter
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.10) }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }

                    // ── Low PWM input ────────────────────────────────────────
                    PwmInput {
                        id:         lowPwm
                        pwmW:       _pwmW
                        pwmH:       _rowH * 0.72
                        pwmRadius:  _radius
                        initText:   "1000"
                    }

                    // ── High PWM input ───────────────────────────────────────
                    PwmInput {
                        id:         highPwm
                        pwmW:       _pwmW
                        pwmH:       _rowH * 0.72
                        pwmRadius:  _radius
                        initText:   "2000"
                    }
                }

                // Bottom row separator (skip last row)
                Rectangle {
                    visible:                index < 5
                    anchors.bottom:         parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:                  parent.width * 0.92
                    height:                 1
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.05) }
                        GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.05) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
            }
        }
    }

    // ── INTERNAL COMPONENT: ServoButton ──────────────────────────────────────
    component ServoButton: Item {
        id:             sBtn
        property real   btnW:       48
        property real   btnH:       24
        property real   btnRadius:  4
        property string btnLabel:   ""
        property color  accentColor: Qt.rgba(0.0, 0.83, 1.0, 1)
        property var    mouseId:    null

        width:  btnW
        height: btnH
        anchors.verticalCenter: parent.verticalCenter

        // Resolve hover/press from the externally-supplied MouseArea
        readonly property bool _hov: mouseId ? mouseId.containsMouse : false
        readonly property bool _prs: mouseId ? mouseId.pressed       : false

        // Glass button background
        Rectangle {
            anchors.fill:   parent
            radius:         sBtn.btnRadius
            color: {
                if (sBtn._prs) return Qt.rgba(
                    sBtn.accentColor.r,
                    sBtn.accentColor.g,
                    sBtn.accentColor.b, 0.22)
                if (sBtn._hov) return Qt.rgba(1, 1, 1, 0.09)
                return Qt.rgba(1, 1, 1, 0.04)
            }
            border.color: {
                if (sBtn._prs || sBtn._hov) return Qt.rgba(
                    sBtn.accentColor.r,
                    sBtn.accentColor.g,
                    sBtn.accentColor.b, sBtn._prs ? 0.60 : 0.30)
                return Qt.rgba(1, 1, 1, 0.10)
            }
            border.width:   1

            Behavior on color        { ColorAnimation { duration: 130 } }
            Behavior on border.color { ColorAnimation { duration: 130 } }

            // Top micro-shimmer
            Rectangle {
                anchors.top:                parent.top
                anchors.topMargin:          1
                anchors.horizontalCenter:   parent.horizontalCenter
                width:                      parent.width * 0.5
                height:                     1
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, sBtn._hov ? 0.28 : 0.12) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
                Behavior on color { ColorAnimation { duration: 130 } }
            }
        }

        // Label
        Text {
            anchors.centerIn:   parent
            text:               sBtn.btnLabel
            font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.7
            font.letterSpacing: 0.2
            color: {
                if (sBtn._prs || sBtn._hov) return Qt.rgba(
                    sBtn.accentColor.r,
                    sBtn.accentColor.g,
                    sBtn.accentColor.b, 1.0)
                return Qt.rgba(1, 1, 1, 0.70)
            }
            Behavior on color { ColorAnimation { duration: 130 } }
        }

        // Press scale
        states: [
            State { name: "pr"; when: sBtn._prs; PropertyChanges { target: sBtn; scale: 0.92 } },
            State { name: "no"; when: !sBtn._prs; PropertyChanges { target: sBtn; scale: 1.0 } }
        ]
        transitions: [
            Transition { to: "pr"; NumberAnimation { property: "scale"; duration: 70;  easing.type: Easing.OutQuad } },
            Transition { to: "no"; NumberAnimation { property: "scale"; duration: 160; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
        ]
    }

    // ── INTERNAL COMPONENT: PwmInput ─────────────────────────────────────────
    component PwmInput: Item {
        id:             pwmItem
        property real   pwmW:       48
        property real   pwmH:       24
        property real   pwmRadius:  4
        property string initText:   "1000"

        width:  pwmW
        height: pwmH
        anchors.verticalCenter: parent.verticalCenter

        // Expose text to outside via alias
        property alias text: pwmField.text

        Rectangle {
            anchors.fill:   parent
            radius:         pwmItem.pwmRadius
            color:          pwmField.activeFocus
                                ? Qt.rgba(0.0, 0.83, 1.0, 0.08)
                                : Qt.rgba(0, 0, 0, 0.30)
            border.color:   pwmField.activeFocus
                                ? Qt.rgba(0.0, 0.83, 1.0, 0.45)
                                : Qt.rgba(1, 1, 1, 0.10)
            border.width:   1

            Behavior on color        { ColorAnimation { duration: 150 } }
            Behavior on border.color { ColorAnimation { duration: 150 } }

            // Focus shimmer
            Rectangle {
                visible:                    pwmField.activeFocus
                anchors.top:                parent.top
                anchors.topMargin:          1
                anchors.horizontalCenter:   parent.horizontalCenter
                width:                      parent.width * 0.5
                height:                     1
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Qt.rgba(0.0, 0.83, 1.0, 0.40) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }
        }

        TextInput {
            id:                     pwmField
            anchors.fill:           parent
            anchors.leftMargin:     2
            anchors.rightMargin:    2
            text:                   pwmItem.initText
            color:                  activeFocus
                                        ? Qt.rgba(0.0, 0.83, 1.0, 1.0)
                                        : Qt.rgba(1, 1, 1, 0.65)
            font.pixelSize:         ScreenTools.defaultFontPixelWidth * 1.65
            horizontalAlignment:    Text.AlignHCenter
            verticalAlignment:      Text.AlignVCenter
            validator:              IntValidator { bottom: 800; top: 2200 }
            selectionColor:         Qt.rgba(0.0, 0.83, 1.0, 0.35)
            selectedTextColor:      "white"

            Behavior on color { ColorAnimation { duration: 150 } }
        }
    }

    // ── MAVLink command sender (unchanged logic) ──────────────────────────────
    function sendServoCommand(servoNum, pwmValue) {
        if (!_activeVehicle) {
            console.log("No active vehicle")
            return
        }
        console.log("Servo", servoNum, "→", pwmValue)
        _activeVehicle.sendMavCommand(
            _activeVehicle.defaultComponentId,
            183,
            true,
            servoNum,
            pwmValue,
            0, 0, 0, 0, 0
        )

        // _activeVehicle.commandLong(
        //         MAV_CMD_DO_SET_SERVO
        //         servoNum,       // param1
        //         pwmValue,       // param2
        //         0,
        //         0,
        //         0,
        //         0,
        //         0
        //     )

    }
}
