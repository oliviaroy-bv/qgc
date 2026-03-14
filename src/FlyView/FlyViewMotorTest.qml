// // ─────────────────────────────────────────────────────────────────────────────
// //  FlyViewMotorTestDropPanel.qml  —  BonVGroundStation
// //  File: src/FlyView/FlyViewMotorTestDropPanel.qml
// //
// //  Drop panel shown when the Motor Test toolstrip button is clicked.
// //  Uses the standard QGC MotorComponent fact system where available,
// //  falls back to raw MAVLink DO_MOTOR_TEST for simpler testing.
// // ─────────────────────────────────────────────────────────────────────────────
// import QtQuick
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:     root
//     width:  panelCol.width  + ScreenTools.defaultFontPixelWidth  * 12
//     height: panelCol.height + ScreenTools.defaultFontPixelHeight * 3

//     property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

//     // ── Motor definitions ────────────────────────────────────────────────────
//     // Standard ArduCopter / PX4 motor numbering (adjust for your airframe)
//     readonly property var _motors: [
//         { num: 1, label: "M1" },
//         { num: 2, label: "M2" },
//         { num: 3, label: "M3" },
//         { num: 4, label: "M4" },
//         { num: 5, label: "M5" },
//         { num: 6, label: "M6" },
//     ]

//     // Throttle for the test (0–100 %)
//     property real  _throttle:    10
//     // Duration in seconds (0 = run until stopped)
//     property real  _duration:    2
//     // Which motor is currently being tested (-1 = none)
//     property int   _activeMotor: -1

//     // ── Send MAVLink DO_MOTOR_TEST ────────────────────────────────────────────
//     function testMotor(motorNum) {
//         if (!activeVehicle) return
//         // MOTOR_TEST_TYPE_THROTTLE_PERCENT = 1
//         // mavCmdDoMotorTest(motor_instance, throttle_type, throttle, timeout, motor_count, test_order)
//         activeVehicle.sendMavCommand(
//             activeVehicle.defaultComponentId,
//             MavlinkQmlSingleton.MAV_CMD_DO_MOTOR_TEST,
//             true,           // showError
//             motorNum,       // motor instance (1-based)
//             1,              // throttle type: percent
//             _throttle,      // throttle %
//             _duration,      // timeout seconds
//             0, 0, 0         // unused
//         )
//         _activeMotor = motorNum
//         activeTimer.restart()
//     }

//     function stopAll() {
//         if (!activeVehicle) return
//         // Send throttle=0 for each motor to ensure all stop
//         for (var i = 1; i <= _motors.length; i++) {
//             activeVehicle.sendMavCommand(
//                 activeVehicle.defaultComponentId,
//                 MavlinkQmlSingleton.MAV_CMD_DO_MOTOR_TEST,
//                 false,
//                 i, 1, 0, 0, 0, 0, 0
//             )
//         }
//         _activeMotor = -1
//     }

//     // Auto-clear active indicator after duration
//     Timer {
//         id:       activeTimer
//         interval: _duration * 1000 + 300
//         repeat:   false
//         onTriggered: _activeMotor = -1
//     }

//     // ── Layout ────────────────────────────────────────────────────────────────
//     Column {
//         id:             panelCol
//         anchors.centerIn: parent
//         spacing:        ScreenTools.defaultFontPixelHeight * 0.8
//         width:          ScreenTools.defaultFontPixelWidth * 75

//         // Header
//         Item {
//             width: parent.width; height: ScreenTools.defaultFontPixelHeight * 1.6
//             Text {
//                 anchors.centerIn: parent
//                 text:             qsTr("Motor Test")
//                 font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.90
//                 font.weight:      Font.SemiBold
//                 color:            Qt.rgba(0.0, 0.83, 1.0, 0.90)
//             }
//         }

//         // Warning banner
//         Rectangle {
//             width:  parent.width
//             height: warnText.height + ScreenTools.defaultFontPixelHeight * 0.8
//             radius: 6
//             color:  Qt.rgba(1.0, 0.55, 0.10, 0.15)
//             border.color: Qt.rgba(1.0, 0.55, 0.10, 0.40); border.width: 1
//             Text {
//                 id:                 warnText
//                 anchors.centerIn:   parent
//                 width:              parent.width - ScreenTools.defaultFontPixelWidth * 2
//                 text:               qsTr("⚠  Remove propellers before testing!")
//                 font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.72
//                 color:              Qt.rgba(1.0, 0.65, 0.20, 1.0)
//                 wrapMode:           Text.WordWrap
//                 horizontalAlignment: Text.AlignHCenter
//             }
//         }

//         // Throttle slider
//         Column {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelHeight * 0.3

//             Row {
//                 width: parent.width
//                 Text {
//                     text:           qsTr("Throttle")
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
//                     color:          Qt.rgba(1,1,1,0.70)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Item { width: parent.width - tLabel.width - tValLabel.contentWidth - 8; height: 1 }
//                 Text {
//                     id:             tValLabel
//                     text:           Math.round(_throttle) + "%"
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
//                     font.weight:    Font.SemiBold
//                     color:          Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Text { id: tLabel; width: 0 } // spacer anchor hack
//             }

//             Slider {
//                 id:     throttleSlider
//                 width:  parent.width
//                 from:   5; to: 100; stepSize: 5
//                 value:  _throttle
//                 onValueChanged: _throttle = value

//                 background: Rectangle {
//                     x: throttleSlider.leftPadding; y: throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width: throttleSlider.availableWidth; height: 4; radius: 2
//                     color: Qt.rgba(1,1,1,0.12)
//                     Rectangle {
//                         width:  throttleSlider.visualPosition * parent.width
//                         height: parent.height; radius: 2
//                         color:  Qt.rgba(0.0, 0.83, 1.0, 0.80)
//                     }
//                 }
//                 handle: Rectangle {
//                     x: throttleSlider.leftPadding + throttleSlider.visualPosition * (throttleSlider.availableWidth - width)
//                     y: throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width: 16; height: 16; radius: 8
//                     color:        Qt.rgba(0.0, 0.83, 1.0, 1.0)
//                     border.color: Qt.rgba(1,1,1,0.30); border.width: 1
//                 }
//             }
//         }

//         // Duration row
//         Row {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelWidth
//             Text {
//                 text:           qsTr("Duration (s):")
//                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.75
//                 color:          Qt.rgba(1,1,1,0.70)
//                 anchors.verticalCenter: parent.verticalCenter
//             }
//             Row {
//                 spacing: 4
//                 anchors.verticalCenter: parent.verticalCenter
//                 Repeater {
//                     model: [1, 2, 3, 5]
//                     delegate: Rectangle {
//                         width:  ScreenTools.defaultFontPixelWidth * 4
//                         height: ScreenTools.defaultFontPixelHeight * 1.4
//                         radius: 4
//                         color:  _duration === modelData ? Qt.rgba(0.0,0.83,1.0,0.20) : Qt.rgba(1,1,1,0.06)
//                         border.color: _duration === modelData ? Qt.rgba(0.0,0.83,1.0,0.55) : Qt.rgba(1,1,1,0.12)
//                         border.width: 1
//                         Text {
//                             anchors.centerIn: parent
//                             text:             modelData + "s"
//                             font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.72
//                             color:            _duration === modelData ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.75)
//                         }
//                         MouseArea {
//                             anchors.fill: parent
//                             cursorShape:  Qt.PointingHandCursor
//                             onClicked:    _duration = modelData
//                         }
//                     }
//                 }
//             }
//         }

//         // Motor buttons grid
//         Grid {
//             width:   parent.width
//             columns: 3
//             spacing: ScreenTools.defaultFontPixelWidth * 0.6

//             Repeater {
//                 model: _motors
//                 delegate: Rectangle {
//                     width:  (panelCol.width - 2 * ScreenTools.defaultFontPixelWidth * 0.6) / 3
//                     height: ScreenTools.defaultFontPixelHeight * 2.8
//                     radius: 7
//                     color: {
//                         if (_activeMotor === modelData.num) return Qt.rgba(0.0, 0.83, 1.0, 0.25)
//                         return motorMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.06)
//                     }
//                     border.color: {
//                         if (_activeMotor === modelData.num) return Qt.rgba(0.0, 0.83, 1.0, 0.70)
//                         return Qt.rgba(1,1,1,0.15)
//                     }
//                     border.width: 1
//                     Behavior on color        { ColorAnimation { duration: 80 } }
//                     Behavior on border.color { ColorAnimation { duration: 80 } }

//                     Column {
//                         anchors.centerIn: parent
//                         spacing:          2
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           "⚙"
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.0
//                             color:          _activeMotor === modelData.num
//                                                 ? Qt.rgba(0.0,0.83,1.0,1.0)
//                                                 : Qt.rgba(1,1,1,0.55)
//                             // Spin while active
//                             NumberAnimation on rotation {
//                                 running:  _activeMotor === modelData.num
//                                 from: 0; to: 360; duration: 600
//                                 loops: Animation.Infinite
//                             }
//                         }
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           modelData.label
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78
//                             font.weight:    Font.SemiBold
//                             color:          _activeMotor === modelData.num
//                                                 ? Qt.rgba(0.0,0.83,1.0,0.95)
//                                                 : Qt.rgba(1,1,1,0.82)
//                         }
//                     }

//                     MouseArea {
//                         id:           motorMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         enabled:      !!root.activeVehicle
//                         onClicked:    root.testMotor(modelData.num)
//                     }
//                 }
//             }
//         }

//         // Stop all button
//         Rectangle {
//             width:  parent.width
//             height: ScreenTools.defaultFontPixelHeight * 2.2
//             radius: 7
//             color:  stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
//             border.color: Qt.rgba(1.0,0.22,0.35,0.55); border.width: 1
//             Behavior on color { ColorAnimation { duration: 80 } }

//             Text {
//                 anchors.centerIn: parent
//                 text:             qsTr("■  Stop All")
//                 font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
//                 font.weight:      Font.SemiBold
//                 color:            Qt.rgba(1.0, 0.35, 0.45, 1.0)
//             }
//             MouseArea {
//                 id:           stopMa
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 cursorShape:  Qt.PointingHandCursor
//                 onClicked:    root.stopAll()
//             }
//         }

//         // No vehicle warning
//         Text {
//             width:              parent.width
//             visible:            !root.activeVehicle
//             text:               qsTr("No vehicle connected")
//             font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.72
//             color:              Qt.rgba(1,1,1,0.40)
//             horizontalAlignment: Text.AlignHCenter
//         }
//     }
// }


// // ─────────────────────────────────────────────────────────────────────────────
// //  FlyViewMotorTestDropPanel.qml  —  BonVGroundStation
// //  File: src/FlyView/FlyViewMotorTestDropPanel.qml
// // ─────────────────────────────────────────────────────────────────────────────
// import QtQuick
// import QtQuick.Controls
// import Qt5Compat.GraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Column {
//     id:      root
//     spacing: ScreenTools.defaultFontPixelHeight * 0.75
//     width:   ScreenTools.defaultFontPixelWidth * 80

//     property var  activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

//     property real _throttle:    10
//     property real _duration:    2
//     property int  _activeMotor: -1
//     property bool _enabled:     false

//     readonly property var _motors: [
//         { num: 1, label: "Motor A" },
//         { num: 2, label: "Motor B" },
//         { num: 3, label: "Motor C" },
//         { num: 4, label: "Motor D" },
//         { num: 5, label: "Motor E" },
//         { num: 6, label: "Motor F" },
//     ]

//     onActiveVehicleChanged: { if (!activeVehicle) { _enabled = false; _activeMotor = -1 } }

//     function testMotor(motorNum) {
//         if (!activeVehicle || !_enabled) return
//         activeVehicle.sendMavCommand(
//             activeVehicle.defaultComponentId,
//             MavlinkQmlSingleton.MAV_CMD_DO_MOTOR_TEST,
//             true,
//             motorNum, 1, _throttle, _duration, 0, 0, 0
//         )
//         _activeMotor = motorNum
//         activeTimer.restart()
//     }

//     function stopAll() {
//         if (!activeVehicle) return
//         for (var i = 1; i <= _motors.length; i++) {
//             activeVehicle.sendMavCommand(
//                 activeVehicle.defaultComponentId,
//                 MavlinkQmlSingleton.MAV_CMD_DO_MOTOR_TEST,
//                 false, i, 1, 0, 0, 0, 0, 0
//             )
//         }
//         _activeMotor = -1
//     }

//     Timer {
//         id:          activeTimer
//         interval:    _duration * 1000 + 300
//         repeat:      false
//         onTriggered: _activeMotor = -1
//     }

//         // ── Header ────────────────────────────────────────────────────────────
//         Text {
//             width:               parent.width
//             text:                qsTr("Motor Test")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.92
//             font.weight:         Font.SemiBold
//             color:               Qt.rgba(0.0, 0.83, 1.0, 0.90)
//             horizontalAlignment: Text.AlignHCenter
//         }

//         // ── Warning ───────────────────────────────────────────────────────────
//         Rectangle {
//             width:        parent.width
//             height:       warnText.implicitHeight + ScreenTools.defaultFontPixelHeight * 0.8
//             radius:       6
//             color:        Qt.rgba(1.0, 0.55, 0.10, 0.13)
//             border.color: Qt.rgba(1.0, 0.55, 0.10, 0.40); border.width: 1
//             Text {
//                 id:                  warnText
//                 anchors.centerIn:    parent
//                 width:               parent.width - ScreenTools.defaultFontPixelWidth * 2
//                 text:                qsTr("⚠  Remove propellers before testing!")
//                 font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//                 color:               Qt.rgba(1.0, 0.65, 0.20, 1.0)
//                 wrapMode:            Text.WordWrap
//                 horizontalAlignment: Text.AlignHCenter
//             }
//         }

//         // ── Enable / Disable safety toggle ────────────────────────────────────
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.4
//             radius:       7
//             color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.15) : Qt.rgba(1,1,1,0.06)
//             border.color: _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.55) : Qt.rgba(1,1,1,0.18)
//             border.width: 1
//             Behavior on color        { ColorAnimation { duration: 120 } }
//             Behavior on border.color { ColorAnimation { duration: 120 } }

//             Row {
//                 anchors.centerIn: parent
//                 spacing:          ScreenTools.defaultFontPixelWidth * 1.2

//                 // Toggle switch
//                 Rectangle {
//                     id:           toggleTrack
//                     width:        ScreenTools.defaultFontPixelWidth * 5
//                     height:       ScreenTools.defaultFontPixelHeight * 1.1
//                     radius:       height / 2
//                     anchors.verticalCenter: parent.verticalCenter
//                     color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.70) : Qt.rgba(1,1,1,0.18)
//                     Behavior on color { ColorAnimation { duration: 120 } }

//                     Rectangle {
//                         id:       toggleThumb
//                         width:    parent.height - 4
//                         height:   width
//                         radius:   width / 2
//                         anchors.verticalCenter: parent.verticalCenter
//                         x:        _enabled ? parent.width - width - 2 : 2
//                         color:    _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.55)
//                         Behavior on x     { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
//                         Behavior on color { ColorAnimation  { duration: 120 } }
//                     }
//                 }

//                 Text {
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:           _enabled
//                                         ? qsTr("Careful: Motor sliders are enabled")
//                                         : qsTr("Propellers are removed — Enable motor test")
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                     font.weight:    Font.Medium
//                     color:          _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.90) : Qt.rgba(1,1,1,0.50)
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }

//             MouseArea {
//                 anchors.fill: parent
//                 cursorShape:  Qt.PointingHandCursor
//                 enabled:      !!root.activeVehicle
//                 onClicked: {
//                     _enabled = !_enabled
//                     if (!_enabled) root.stopAll()
//                 }
//             }
//         }

//         // ── Throttle slider ───────────────────────────────────────────────────
//         Column {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelHeight * 0.25
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Row {
//                 width: parent.width
//                 Text {
//                     text:                   qsTr("Throttle")
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     color:                  Qt.rgba(1,1,1,0.70)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Item { width: parent.width - throttleLabel.contentWidth - throttleVal.contentWidth - 8; height: 1 }
//                 Text {
//                     id:                     throttleVal
//                     text:                   Math.round(_throttle) + "%"
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     font.weight:            Font.SemiBold
//                     color:                  Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Text { id: throttleLabel; width: 0 }
//             }

//             Slider {
//                 id:             throttleSlider
//                 width:          parent.width
//                 from:           5; to: 100; stepSize: 5
//                 value:          _throttle
//                 enabled:        _enabled
//                 onValueChanged: _throttle = value

//                 background: Rectangle {
//                     x: throttleSlider.leftPadding
//                     y: throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width: throttleSlider.availableWidth; height: 4; radius: 2
//                     color: Qt.rgba(1,1,1,0.12)
//                     Rectangle {
//                         width:  throttleSlider.visualPosition * parent.width
//                         height: parent.height; radius: 2
//                         color:  Qt.rgba(0.0, 0.83, 1.0, 0.80)
//                     }
//                 }
//                 handle: Rectangle {
//                     x: throttleSlider.leftPadding + throttleSlider.visualPosition * (throttleSlider.availableWidth - width)
//                     y: throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width: 16; height: 16; radius: 8
//                     color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.30)
//                     border.color: Qt.rgba(1,1,1,0.25); border.width: 1
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }
//         }

//         // ── Duration input ────────────────────────────────────────────────────
//         Row {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelWidth
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Text {
//                 text:                   qsTr("Runtime (s):")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                 color:                  Qt.rgba(1,1,1,0.70)
//                 anchors.verticalCenter: parent.verticalCenter
//             }

//             Rectangle {
//                 width:        ScreenTools.defaultFontPixelWidth * 7
//                 height:       ScreenTools.defaultFontPixelHeight * 1.7
//                 radius:       5
//                 color:        Qt.rgba(1,1,1,0.06)
//                 border.color: durationInput.activeFocus ? Qt.rgba(0.0,0.83,1.0,0.60) : Qt.rgba(1,1,1,0.20)
//                 border.width: 1
//                 Behavior on border.color { ColorAnimation { duration: 100 } }
//                 anchors.verticalCenter: parent.verticalCenter

//                 TextInput {
//                     id:                  durationInput
//                     anchors.centerIn:    parent
//                     width:               parent.width - 8
//                     text:                _duration.toString()
//                     font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
//                     color:               Qt.rgba(1,1,1,0.90)
//                     horizontalAlignment: TextInput.AlignHCenter
//                     inputMethodHints:    Qt.ImhFormattedNumbersOnly
//                     validator:           RegularExpressionValidator { regularExpression: /^[0-9]{1,3}(\.[0-9]{0,1})?$/ }
//                     selectByMouse:       true
//                     enabled:             _enabled

//                     onEditingFinished: {
//                         var v = parseFloat(text)
//                         if (!isNaN(v) && v > 0) _duration = v
//                         else { _duration = 2; text = "2" }
//                     }
//                 }
//             }

//             Text {
//                 text:                   qsTr("seconds")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.72
//                 color:                  Qt.rgba(1,1,1,0.40)
//                 anchors.verticalCenter: parent.verticalCenter
//             }
//         }

//         // ── Motor buttons ─────────────────────────────────────────────────────
//         Grid {
//             width:   parent.width
//             columns: 3
//             spacing: ScreenTools.defaultFontPixelWidth * 0.6

//             Repeater {
//                 model: _motors
//                 delegate: Rectangle {
//                     width:  (root.width - 2 * ScreenTools.defaultFontPixelWidth * 0.6) / 3
//                     height: ScreenTools.defaultFontPixelHeight * 2.8
//                     radius: 7

//                     color: {
//                         if (!_enabled)                          return Qt.rgba(1,1,1,0.04)
//                         if (_activeMotor === modelData.num)     return Qt.rgba(0.0,0.83,1.0,0.25)
//                         return mMa.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.07)
//                     }
//                     border.color: {
//                         if (!_enabled)                          return Qt.rgba(1,1,1,0.08)
//                         if (_activeMotor === modelData.num)     return Qt.rgba(0.0,0.83,1.0,0.70)
//                         return Qt.rgba(1,1,1,0.18)
//                     }
//                     border.width: 1
//                     opacity:      _enabled ? 1.0 : 0.4
//                     Behavior on color        { ColorAnimation { duration: 80 } }
//                     Behavior on border.color { ColorAnimation { duration: 80 } }
//                     Behavior on opacity      { NumberAnimation { duration: 120 } }

//                     Column {
//                         anchors.centerIn: parent
//                         spacing:          2
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           "⚙"
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.0
//                             color:          _activeMotor === modelData.num
//                                                 ? Qt.rgba(0.0,0.83,1.0,1.0)
//                                                 : Qt.rgba(1,1,1,0.50)
//                             NumberAnimation on rotation {
//                                 running:  _activeMotor === modelData.num
//                                 from: 0; to: 360; duration: 600
//                                 loops: Animation.Infinite
//                             }
//                         }
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           modelData.label
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                             font.weight:    Font.SemiBold
//                             color:          _activeMotor === modelData.num
//                                                 ? Qt.rgba(0.0,0.83,1.0,0.95)
//                                                 : Qt.rgba(1,1,1,0.80)
//                         }
//                     }

//                     MouseArea {
//                         id:           mMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
//                         enabled:      _enabled && !!root.activeVehicle
//                         onClicked:    root.testMotor(modelData.num)
//                     }
//                 }
//             }
//         }

//         // ── Stop All ──────────────────────────────────────────────────────────
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.2
//             radius:       7
//             color:        stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
//             border.color: Qt.rgba(1.0,0.22,0.35,0.55); border.width: 1
//             Behavior on color { ColorAnimation { duration: 80 } }

//             Text {
//                 anchors.centerIn: parent
//                 text:             qsTr("■  Stop All")
//                 font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
//                 font.weight:      Font.SemiBold
//                 color:            Qt.rgba(1.0, 0.35, 0.45, 1.0)
//             }
//             MouseArea {
//                 id:           stopMa
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 cursorShape:  Qt.PointingHandCursor
//                 onClicked:    root.stopAll()
//             }
//         }

//         // No vehicle notice
//         Text {
//             width:               parent.width
//             visible:             !root.activeVehicle
//             text:                qsTr("No vehicle connected")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//             color:               Qt.rgba(1,1,1,0.35)
//             horizontalAlignment: Text.AlignHCenter
//         }
// }



// // FlyViewMotorTestDropPanel.qml — BonVGroundStation
// // File: src/FlyView/FlyViewMotorTestDropPanel.qml

// import QtQuick
// import QtQuick.Controls
// import Qt5Compat.GraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:     root
//     width:  panelCol.width  + ScreenTools.defaultFontPixelWidth  * 15
//     height: panelCol.height + ScreenTools.defaultFontPixelHeight * 3

//     property var  activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
//     property real _throttle:     10
//     property real _duration:     2
//     property int  _activeMotor:  -1
//     property bool _enabled:      false

//     readonly property var _motors: [
//         { num: 1, label: "Motor A" },
//         { num: 2, label: "Motor B" },
//         { num: 3, label: "Motor C" },
//         { num: 4, label: "Motor D" },
//         { num: 5, label: "Motor E" },
//         { num: 6, label: "Motor F" },
//     ]

//     onActiveVehicleChanged: {
//         if (!activeVehicle) { _enabled = false; _activeMotor = -1 }
//     }

//     function testMotor(motorNum) {
//         if (!activeVehicle || !_enabled) return
//         // Matches MotorComponent: motorTest(motorIndex, throttlePct, timeoutSecs, showError)
//         activeVehicle.motorTest(motorNum, _throttle, _throttle === 0 ? 0 : _duration, true)
//         _activeMotor = motorNum
//         activeTimer.restart()
//     }

//     function stopAll() {
//         if (!activeVehicle) return
//         // throttle=0, timeout=0 stops motors immediately — same as MotorComponent's Stop button
//         for (var i = 1; i <= _motors.length; i++) {
//             activeVehicle.motorTest(i, 0, 0, true)
//         }
//         _activeMotor = -1
//     }

//     Timer {
//         id:          activeTimer
//         interval:    _duration * 1000 + 300
//         repeat:      false
//         onTriggered: _activeMotor = -1
//     }

//     Column {
//         id:               panelCol
//         anchors.centerIn: parent
//         spacing:          ScreenTools.defaultFontPixelHeight * 0.75
//         width:            ScreenTools.defaultFontPixelWidth * 80

//         // Header
//         Text {
//             width:               parent.width
//             text:                qsTr("Motor Test")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.92
//             font.weight:         Font.SemiBold
//             color:               Qt.rgba(0.0, 0.83, 1.0, 0.90)
//             horizontalAlignment: Text.AlignHCenter
//         }

//         // Warning banner
//         Rectangle {
//             width:        parent.width
//             height:       warnText.implicitHeight + ScreenTools.defaultFontPixelHeight * 0.8
//             radius:       6
//             color:        Qt.rgba(1.0, 0.55, 0.10, 0.13)
//             border.color: Qt.rgba(1.0, 0.55, 0.10, 0.40)
//             border.width: 1
//             Text {
//                 id:                  warnText
//                 anchors.centerIn:    parent
//                 width:               parent.width - ScreenTools.defaultFontPixelWidth * 2
//                 text:                qsTr("Remove propellers before testing!")
//                 font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//                 color:               Qt.rgba(1.0, 0.65, 0.20, 1.0)
//                 wrapMode:            Text.WordWrap
//                 horizontalAlignment: Text.AlignHCenter
//             }
//         }

//         // Enable / Disable safety toggle
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.4
//             radius:       7
//             color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.15) : Qt.rgba(1,1,1,0.06)
//             border.color: _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.55) : Qt.rgba(1,1,1,0.18)
//             border.width: 1
//             Behavior on color        { ColorAnimation { duration: 120 } }
//             Behavior on border.color { ColorAnimation { duration: 120 } }

//             Row {
//                 anchors.centerIn: parent
//                 spacing:          ScreenTools.defaultFontPixelWidth * 1.2

//                 Rectangle {
//                     id:     toggleTrack
//                     width:  ScreenTools.defaultFontPixelWidth * 5
//                     height: ScreenTools.defaultFontPixelHeight * 1.1
//                     radius: height / 2
//                     anchors.verticalCenter: parent.verticalCenter
//                     color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.70) : Qt.rgba(1,1,1,0.18)
//                     Behavior on color { ColorAnimation { duration: 120 } }

//                     Rectangle {
//                         width:  parent.height - 4
//                         height: width
//                         radius: width / 2
//                         anchors.verticalCenter: parent.verticalCenter
//                         x:      _enabled ? parent.width - width - 2 : 2
//                         color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.55)
//                         Behavior on x     { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
//                         Behavior on color { ColorAnimation  { duration: 120 } }
//                     }
//                 }

//                 Text {
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:           _enabled ? qsTr("Careful: Motor sliders are enabled")
//                                              : qsTr("Propellers removed - Enable motor test")
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                     font.weight:    Font.Medium
//                     color:          _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.90) : Qt.rgba(1,1,1,0.50)
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }

//             MouseArea {
//                 anchors.fill: parent
//                 cursorShape:  Qt.PointingHandCursor
//                 enabled:      !!root.activeVehicle
//                 onClicked: {
//                     _enabled = !_enabled
//                     if (!_enabled) root.stopAll()
//                 }
//             }
//         }

//         // Throttle slider
//         Column {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelHeight * 0.25
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Row {
//                 width: parent.width
//                 Text {
//                     text:                   qsTr("Throttle")
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     color:                  Qt.rgba(1,1,1,0.70)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Item { width: parent.width - throttleLabel.contentWidth - throttleVal.contentWidth - 8; height: 1 }
//                 Text {
//                     id:                     throttleVal
//                     text:                   Math.round(_throttle) + "%"
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     font.weight:            Font.SemiBold
//                     color:                  Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Text { id: throttleLabel; width: 0 }
//             }

//             Slider {
//                 id:             throttleSlider
//                 width:          parent.width
//                 from:           5; to: 100; stepSize: 5
//                 value:          _throttle
//                 enabled:        _enabled
//                 onValueChanged: _throttle = value

//                 background: Rectangle {
//                     x:      throttleSlider.leftPadding
//                     y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width:  throttleSlider.availableWidth
//                     height: 4
//                     radius: 2
//                     color:  Qt.rgba(1,1,1,0.12)
//                     Rectangle {
//                         width:  throttleSlider.visualPosition * parent.width
//                         height: parent.height
//                         radius: 2
//                         color:  Qt.rgba(0.0, 0.83, 1.0, 0.80)
//                     }
//                 }
//                 handle: Rectangle {
//                     x:      throttleSlider.leftPadding + throttleSlider.visualPosition * (throttleSlider.availableWidth - width)
//                     y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width:  16; height: 16; radius: 8
//                     color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.30)
//                     border.color: Qt.rgba(1,1,1,0.25)
//                     border.width: 1
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }
//         }

//         // Duration input row
//         Row {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelWidth
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Text {
//                 text:                   qsTr("Runtime (s):")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                 color:                  Qt.rgba(1,1,1,0.70)
//                 anchors.verticalCenter: parent.verticalCenter
//             }

//             Rectangle {
//                 width:        ScreenTools.defaultFontPixelWidth * 7
//                 height:       ScreenTools.defaultFontPixelHeight * 1.7
//                 radius:       5
//                 color:        Qt.rgba(1,1,1,0.06)
//                 border.color: durationInput.activeFocus ? Qt.rgba(0.0,0.83,1.0,0.60) : Qt.rgba(1,1,1,0.20)
//                 border.width: 1
//                 Behavior on border.color { ColorAnimation { duration: 100 } }
//                 anchors.verticalCenter: parent.verticalCenter

//                 TextInput {
//                     id:                  durationInput
//                     anchors.centerIn:    parent
//                     width:               parent.width - 8
//                     text:                _duration.toString()
//                     font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
//                     color:               Qt.rgba(1,1,1,0.90)
//                     horizontalAlignment: TextInput.AlignHCenter
//                     inputMethodHints:    Qt.ImhFormattedNumbersOnly
//                     validator:           RegularExpressionValidator { regularExpression: /^[0-9]{1,3}(\.[0-9]{0,1})?$/ }
//                     selectByMouse:       true
//                     enabled:             _enabled

//                     onEditingFinished: {
//                         var v = parseFloat(text)
//                         if (!isNaN(v) && v > 0) _duration = v
//                         else { _duration = 2; text = "2" }
//                     }
//                 }
//             }

//             Text {
//                 text:                   qsTr("seconds")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.72
//                 color:                  Qt.rgba(1,1,1,0.40)
//                 anchors.verticalCenter: parent.verticalCenter
//             }
//         }

//         // Motor buttons grid
//         Grid {
//             width:   parent.width
//             columns: 3
//             spacing: ScreenTools.defaultFontPixelWidth * 0.6

//             Repeater {
//                 model: _motors
//                 delegate: Rectangle {
//                     width:  (panelCol.width - 2 * ScreenTools.defaultFontPixelWidth * 0.6) / 3
//                     height: ScreenTools.defaultFontPixelHeight * 2.8
//                     radius: 7
//                     color: {
//                         if (!_enabled)                      return Qt.rgba(1,1,1,0.04)
//                         if (_activeMotor === modelData.num) return Qt.rgba(0.0,0.83,1.0,0.25)
//                         return mMa.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.07)
//                     }
//                     border.color: {
//                         if (!_enabled)                      return Qt.rgba(1,1,1,0.08)
//                         if (_activeMotor === modelData.num) return Qt.rgba(0.0,0.83,1.0,0.70)
//                         return Qt.rgba(1,1,1,0.18)
//                     }
//                     border.width: 1
//                     opacity:      _enabled ? 1.0 : 0.4
//                     Behavior on color        { ColorAnimation { duration: 80 } }
//                     Behavior on border.color { ColorAnimation { duration: 80 } }
//                     Behavior on opacity      { NumberAnimation { duration: 120 } }

//                     Column {
//                         anchors.centerIn: parent
//                         spacing:          2
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           "⚙"
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.2
//                             color:          _activeMotor === modelData.num
//                                                 ? Qt.rgba(0.0,0.83,1.0,1.0)
//                                                 : Qt.rgba(1,1,1,0.50)
//                             NumberAnimation on rotation {
//                                 running:  _activeMotor === modelData.num
//                                 from: 0; to: 360; duration: 600
//                                 loops: Animation.Infinite
//                             }
//                         }
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           modelData.label
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                             font.weight:    Font.SemiBold
//                             color:          _activeMotor === modelData.num
//                                                 ? Qt.rgba(0.0,0.83,1.0,0.95)
//                                                 : Qt.rgba(1,1,1,0.80)
//                         }
//                     }

//                     MouseArea {
//                         id:           mMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
//                         enabled:      _enabled && !!root.activeVehicle
//                         onClicked:    root.testMotor(modelData.num)
//                     }
//                 }
//             }
//         }

//         // Stop All button
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.2
//             radius:       7
//             color:        stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
//             border.color: Qt.rgba(1.0,0.22,0.35,0.55)
//             border.width: 1
//             Behavior on color { ColorAnimation { duration: 80 } }

//             Text {
//                 anchors.centerIn: parent
//                 text:             qsTr("Stop All")
//                 font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
//                 font.weight:      Font.SemiBold
//                 color:            Qt.rgba(1.0, 0.35, 0.45, 1.0)
//             }
//             MouseArea {
//                 id:           stopMa
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 cursorShape:  Qt.PointingHandCursor
//                 onClicked:    root.stopAll()
//             }
//         }

//         // No vehicle notice
//         Text {
//             width:               parent.width
//             visible:             !root.activeVehicle
//             text:                qsTr("No vehicle connected")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//             color:               Qt.rgba(1,1,1,0.35)
//             horizontalAlignment: Text.AlignHCenter
//         }
//     }
// }


// // FlyViewMotorTestDropPanel.qml — BonVGroundStation
// // File: src/FlyView/FlyViewMotorTestDropPanel.qml

// import QtQuick
// import QtQuick.Controls
// import Qt5Compat.GraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:     root
//     width:  panelCol.width  + ScreenTools.defaultFontPixelWidth  * 15
//     height: panelCol.height + ScreenTools.defaultFontPixelHeight * 3

//     property var  activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
//     property real _throttle:     10
//     property real _duration:     2
//     property int  _activeMotor:  -1
//     property bool _enabled:      false

//     // Motor count driven by vehicle — -1 means unknown, default to 8
//     readonly property int _motorCount: activeVehicle ? (activeVehicle.motorCount === -1 ? 8 : activeVehicle.motorCount) : 0

//     function motorLabel(index) {
//         // A, B, C, D ... matching MotorComponent's letter style
//         return String.fromCharCode(65 + index)
//     }

//     onActiveVehicleChanged: {
//         if (!activeVehicle) { _enabled = false; _activeMotor = -1 }
//     }

//     function testMotor(motorNum) {
//         if (!activeVehicle || !_enabled) return
//         // Matches MotorComponent: motorTest(motorIndex, throttlePct, timeoutSecs, showError)
//         activeVehicle.motorTest(motorNum, _throttle, _throttle === 0 ? 0 : _duration, true)
//         _activeMotor = motorNum
//         activeTimer.restart()
//     }

//     function stopAll() {
//         if (!activeVehicle) return
//         for (var i = 1; i <= _motorCount; i++) {
//             activeVehicle.motorTest(i, 0, 0, true)
//         }
//         _activeMotor = -1
//     }

//     Timer {
//         id:          activeTimer
//         interval:    _duration * 1000 + 300
//         repeat:      false
//         onTriggered: _activeMotor = -1
//     }

//     Column {
//         id:               panelCol
//         anchors.centerIn: parent
//         spacing:          ScreenTools.defaultFontPixelHeight * 0.75
//         width:            ScreenTools.defaultFontPixelWidth * 80

//         // Header
//         Text {
//             width:               parent.width
//             text:                qsTr("Motor Test")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.92
//             font.weight:         Font.SemiBold
//             color:               Qt.rgba(0.0, 0.83, 1.0, 0.90)
//             horizontalAlignment: Text.AlignHCenter
//         }

//         // DEBUG - remove after confirming correct count
//         Text {
//             width:               parent.width
//             text:                "motorCount: " + (activeVehicle ? activeVehicle.motorCount : "no vehicle")   ///+ "  _motorCount: " + _motorCount
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.65
//             color:               Qt.rgba(1.0, 0.83, 0.0, 0.80)
//             horizontalAlignment: Text.AlignHCenter
//         }

//         // Warning banner
//         Rectangle {
//             width:        parent.width
//             height:       warnText.implicitHeight + ScreenTools.defaultFontPixelHeight * 0.8
//             radius:       6
//             color:        Qt.rgba(1.0, 0.55, 0.10, 0.13)
//             border.color: Qt.rgba(1.0, 0.55, 0.10, 0.40)
//             border.width: 1
//             Text {
//                 id:                  warnText
//                 anchors.centerIn:    parent
//                 width:               parent.width - ScreenTools.defaultFontPixelWidth * 2
//                 text:                qsTr("Remove propellers before testing!")
//                 font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//                 color:               Qt.rgba(1.0, 0.65, 0.20, 1.0)
//                 wrapMode:            Text.WordWrap
//                 horizontalAlignment: Text.AlignHCenter
//             }
//         }

//         // Enable / Disable safety toggle
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.4
//             radius:       7
//             color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.15) : Qt.rgba(1,1,1,0.06)
//             border.color: _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.55) : Qt.rgba(1,1,1,0.18)
//             border.width: 1
//             Behavior on color        { ColorAnimation { duration: 120 } }
//             Behavior on border.color { ColorAnimation { duration: 120 } }

//             Row {
//                 anchors.centerIn: parent
//                 spacing:          ScreenTools.defaultFontPixelWidth * 1.2

//                 Rectangle {
//                     id:     toggleTrack
//                     width:  ScreenTools.defaultFontPixelWidth * 5
//                     height: ScreenTools.defaultFontPixelHeight * 1.1
//                     radius: height / 2
//                     anchors.verticalCenter: parent.verticalCenter
//                     color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.70) : Qt.rgba(1,1,1,0.18)
//                     Behavior on color { ColorAnimation { duration: 120 } }

//                     Rectangle {
//                         width:  parent.height - 4
//                         height: width
//                         radius: width / 2
//                         anchors.verticalCenter: parent.verticalCenter
//                         x:      _enabled ? parent.width - width - 2 : 2
//                         color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.55)
//                         Behavior on x     { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
//                         Behavior on color { ColorAnimation  { duration: 120 } }
//                     }
//                 }

//                 Text {
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:           _enabled ? qsTr("Careful: Motor sliders are enabled")
//                                              : qsTr("Propellers removed - Enable motor test")
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                     font.weight:    Font.Medium
//                     color:          _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.90) : Qt.rgba(1,1,1,0.50)
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }

//             MouseArea {
//                 anchors.fill: parent
//                 cursorShape:  Qt.PointingHandCursor
//                 enabled:      !!root.activeVehicle
//                 onClicked: {
//                     _enabled = !_enabled
//                     if (!_enabled) root.stopAll()
//                 }
//             }
//         }

//         // Throttle slider
//         Column {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelHeight * 0.25
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Row {
//                 width: parent.width
//                 Text {
//                     text:                   qsTr("Throttle")
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     color:                  Qt.rgba(1,1,1,0.70)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Item { width: parent.width - throttleLabel.contentWidth - throttleVal.contentWidth - 8; height: 1 }
//                 Text {
//                     id:                     throttleVal
//                     text:                   Math.round(_throttle) + "%"
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     font.weight:            Font.SemiBold
//                     color:                  Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Text { id: throttleLabel; width: 0 }
//             }

//             Slider {
//                 id:             throttleSlider
//                 width:          parent.width
//                 from:           5; to: 100; stepSize: 5
//                 value:          _throttle
//                 enabled:        _enabled
//                 onValueChanged: _throttle = value

//                 background: Rectangle {
//                     x:      throttleSlider.leftPadding
//                     y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width:  throttleSlider.availableWidth
//                     height: 4
//                     radius: 2
//                     color:  Qt.rgba(1,1,1,0.12)
//                     Rectangle {
//                         width:  throttleSlider.visualPosition * parent.width
//                         height: parent.height
//                         radius: 2
//                         color:  Qt.rgba(0.0, 0.83, 1.0, 0.80)
//                     }
//                 }
//                 handle: Rectangle {
//                     x:      throttleSlider.leftPadding + throttleSlider.visualPosition * (throttleSlider.availableWidth - width)
//                     y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width:  16; height: 16; radius: 8
//                     color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.30)
//                     border.color: Qt.rgba(1,1,1,0.25)
//                     border.width: 1
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }
//         }

//         // Duration input row
//         Row {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelWidth
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Text {
//                 text:                   qsTr("Runtime (s):")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                 color:                  Qt.rgba(1,1,1,0.70)
//                 anchors.verticalCenter: parent.verticalCenter
//             }

//             Rectangle {
//                 width:        ScreenTools.defaultFontPixelWidth * 7
//                 height:       ScreenTools.defaultFontPixelHeight * 1.7
//                 radius:       5
//                 color:        Qt.rgba(1,1,1,0.06)
//                 border.color: durationInput.activeFocus ? Qt.rgba(0.0,0.83,1.0,0.60) : Qt.rgba(1,1,1,0.20)
//                 border.width: 1
//                 Behavior on border.color { ColorAnimation { duration: 100 } }
//                 anchors.verticalCenter: parent.verticalCenter

//                 TextInput {
//                     id:                  durationInput
//                     anchors.centerIn:    parent
//                     width:               parent.width - 8
//                     text:                _duration.toString()
//                     font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
//                     color:               Qt.rgba(1,1,1,0.90)
//                     horizontalAlignment: TextInput.AlignHCenter
//                     inputMethodHints:    Qt.ImhFormattedNumbersOnly
//                     validator:           RegularExpressionValidator { regularExpression: /^[0-9]{1,3}(\.[0-9]{0,1})?$/ }
//                     selectByMouse:       true
//                     enabled:             _enabled

//                     onEditingFinished: {
//                         var v = parseFloat(text)
//                         if (!isNaN(v) && v > 0) _duration = v
//                         else { _duration = 2; text = "2" }
//                     }
//                 }
//             }

//             Text {
//                 text:                   qsTr("seconds")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.72
//                 color:                  Qt.rgba(1,1,1,0.40)
//                 anchors.verticalCenter: parent.verticalCenter
//             }
//         }

//         // Motor buttons grid — columns adapt: 4 max per row
//         Grid {
//             width:   parent.width
//             columns: Math.min(_motorCount, 4)
//             spacing: ScreenTools.defaultFontPixelWidth * 2.5

//             Repeater {
//                 id:    motorRepeater
//                 model: _motorCount
//                 delegate: Rectangle {
//                     readonly property int _cols: Math.min(_motorCount, 4)
//                     width:  (panelCol.width - (_cols - 1) * ScreenTools.defaultFontPixelWidth * 2.5) / _cols
//                     height: ScreenTools.defaultFontPixelHeight * 2.8
//                     radius: 7
//                     color: {
//                         if (!_enabled)                  return Qt.rgba(1,1,1,0.04)
//                         if (_activeMotor === index + 1) return Qt.rgba(0.0,0.83,1.0,0.25)
//                         return mMa.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.07)
//                     }
//                     border.color: {
//                         if (!_enabled)                  return Qt.rgba(1,1,1,0.08)
//                         if (_activeMotor === index + 1) return Qt.rgba(0.0,0.83,1.0,0.70)
//                         return Qt.rgba(1,1,1,0.18)
//                     }
//                     border.width: 1
//                     opacity:      _enabled ? 1.0 : 0.4
//                     Behavior on color        { ColorAnimation { duration: 80 } }
//                     Behavior on border.color { ColorAnimation { duration: 80 } }
//                     Behavior on opacity      { NumberAnimation { duration: 120 } }

//                     Column {
//                         anchors.centerIn: parent
//                         spacing:          2
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           "⚙"
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.3
//                             color:          _activeMotor === index + 1
//                                                 ? Qt.rgba(0.0,0.83,1.0,1.0)
//                                                 : Qt.rgba(1,1,1,0.55)
//                             NumberAnimation on rotation {
//                                 running:  _activeMotor === index + 1
//                                 from: 0; to: 360; duration: 600
//                                 loops: Animation.Infinite
//                             }
//                         }
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           motorLabel(index)
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                             font.weight:    Font.SemiBold
//                             color:          _activeMotor === index + 1
//                                                 ? Qt.rgba(0.0,0.83,1.0,0.95)
//                                                 : Qt.rgba(1,1,1,0.80)
//                         }
//                     }

//                     MouseArea {
//                         id:           mMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
//                         enabled:      _enabled && !!root.activeVehicle
//                         onClicked:    root.testMotor(index + 1)
//                     }
//                 }
//             }
//         }

//         // Stop All button
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.2
//             radius:       7
//             color:        stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
//             border.color: Qt.rgba(1.0,0.22,0.35,0.55)
//             border.width: 1
//             Behavior on color { ColorAnimation { duration: 80 } }

//             Text {
//                 anchors.centerIn: parent
//                 text:             qsTr("Stop All")
//                 font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
//                 font.weight:      Font.SemiBold
//                 color:            Qt.rgba(1.0, 0.35, 0.45, 1.0)
//             }
//             MouseArea {
//                 id:           stopMa
//                 anchors.fill: parent
//                 hoverEnabled: true
//                 cursorShape:  Qt.PointingHandCursor
//                 onClicked:    root.stopAll()
//             }
//         }

//         // No vehicle notice
//         Text {
//             width:               parent.width
//             visible:             !root.activeVehicle
//             text:                qsTr("No vehicle connected")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//             color:               Qt.rgba(1,1,1,0.35)
//             horizontalAlignment: Text.AlignHCenter
//         }
//     }
// }


// // FlyViewMotorTestDropPanel.qml — BonVGroundStation
// // File: src/FlyView/FlyViewMotorTestDropPanel.qml

// import QtQuick
// import QtQuick.Controls
// import Qt5Compat.GraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:     root
//     width:  panelCol.width  + ScreenTools.defaultFontPixelWidth  * 15
//     height: panelCol.height + ScreenTools.defaultFontPixelHeight * 3


//     property var  activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle
//     property real _throttle:        10
//     property real _duration:        2
//     property int  _activeMotor:     -1
//     property bool _enabled:         false
//     property bool _seqRunning:      false   // true while sequential test is in progress
//     property int  _seqCurrentMotor: 0       // which motor is next in sequence (1-based)

//     // Motor count driven by vehicle — -1 means unknown, default to 8
//     readonly property int _motorCount: activeVehicle ? (activeVehicle.motorCount === -1 ? 8 : activeVehicle.motorCount) : 0

//     function motorLabel(index) {
//         return String.fromCharCode(65 + index)
//     }

//     onActiveVehicleChanged: {
//         if (!activeVehicle) { _enabled = false; _activeMotor = -1; _stopSequential() }
//     }

//     function testMotor(motorNum) {
//         if (!activeVehicle || !_enabled) return
//         activeVehicle.motorTest(motorNum, _throttle, _throttle === 0 ? 0 : _duration, true)
//         _activeMotor = motorNum
//         activeTimer.restart()
//     }

//     function testAll() {
//         if (!activeVehicle || !_enabled) return
//         _stopSequential()
//         for (var i = 1; i <= _motorCount; i++) {
//             activeVehicle.motorTest(i, _throttle, _duration, true)
//         }
//         _activeMotor = -1   // no single motor highlighted — all running
//         activeTimer.restart()
//     }

//     function testSequential() {
//         if (!activeVehicle || !_enabled) return
//         _stopSequential()
//         _seqRunning      = true
//         _seqCurrentMotor = 1
//         _runNextSequential()
//     }

//     function _runNextSequential() {
//         if (!_seqRunning || _seqCurrentMotor > _motorCount) {
//             _stopSequential()
//             return
//         }
//         activeVehicle.motorTest(_seqCurrentMotor, _throttle, _duration, true)
//         _activeMotor = _seqCurrentMotor
//         seqTimer.restart()
//     }

//     function _stopSequential() {
//         _seqRunning      = false
//         _seqCurrentMotor = 0
//         seqTimer.stop()
//     }

//     function stopAll() {
//         _stopSequential()
//         if (!activeVehicle) return
//         for (var i = 1; i <= _motorCount; i++) {
//             activeVehicle.motorTest(i, 0, 0, true)
//         }
//         _activeMotor = -1
//     }

//     // Auto-clear single motor highlight after duration
//     Timer {
//         id:          activeTimer
//         interval:    _duration * 1000 + 300
//         repeat:      false
//         onTriggered: { if (!_seqRunning) _activeMotor = -1 }
//     }

//     // Advances sequential test — fires after each motor's duration elapses
//     Timer {
//         id:       seqTimer
//         interval: _duration * 1000 + 200
//         repeat:   false
//         onTriggered: {
//             _seqCurrentMotor++
//             _runNextSequential()
//         }
//     }

//     Column {
//         id:               panelCol
//         anchors.centerIn: parent
//         spacing:          ScreenTools.defaultFontPixelHeight * 0.75
//         width:            ScreenTools.defaultFontPixelWidth * 80

//         // Header
//         Text {
//             width:               parent.width
//             text:                qsTr("Motor Test")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.92
//             font.weight:         Font.SemiBold
//             color:               Qt.rgba(0.0, 0.83, 1.0, 0.90)
//             horizontalAlignment: Text.AlignHCenter
//         }

//         // DEBUG - remove after confirming correct count
//         Text {
//             width:               parent.width
//             text:                "Motor Count: " + (activeVehicle ? activeVehicle.motorCount : "no vehicle")   //+ "  _motorCount: " + _motorCount
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.65
//             color:               Qt.rgba(1.0, 0.83, 0.0, 0.80)
//             horizontalAlignment: Text.AlignHCenter
//         }

//         // Warning banner
//         Rectangle {
//             width:        parent.width
//             height:       warnText.implicitHeight + ScreenTools.defaultFontPixelHeight * 0.8
//             radius:       6
//             color:        Qt.rgba(1.0, 0.55, 0.10, 0.13)
//             border.color: Qt.rgba(1.0, 0.55, 0.10, 0.40)
//             border.width: 1
//             Text {
//                 id:                  warnText
//                 anchors.centerIn:    parent
//                 width:               parent.width - ScreenTools.defaultFontPixelWidth * 2
//                 text:                qsTr("Remove propellers before testing!")
//                 font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//                 color:               Qt.rgba(1.0, 0.65, 0.20, 1.0)
//                 wrapMode:            Text.WordWrap
//                 horizontalAlignment: Text.AlignHCenter
//             }
//         }

//         // Enable / Disable safety toggle
//         Rectangle {
//             width:        parent.width
//             height:       ScreenTools.defaultFontPixelHeight * 2.4
//             radius:       7
//             color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.15) : Qt.rgba(1,1,1,0.06)
//             border.color: _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.55) : Qt.rgba(1,1,1,0.18)
//             border.width: 1
//             Behavior on color        { ColorAnimation { duration: 120 } }
//             Behavior on border.color { ColorAnimation { duration: 120 } }

//             Row {
//                 anchors.centerIn: parent
//                 spacing:          ScreenTools.defaultFontPixelWidth * 1.2

//                 Rectangle {
//                     id:     toggleTrack
//                     width:  ScreenTools.defaultFontPixelWidth * 5
//                     height: ScreenTools.defaultFontPixelHeight * 1.1
//                     radius: height / 2
//                     anchors.verticalCenter: parent.verticalCenter
//                     color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.70) : Qt.rgba(1,1,1,0.18)
//                     Behavior on color { ColorAnimation { duration: 120 } }

//                     Rectangle {
//                         width:  parent.height - 4
//                         height: width
//                         radius: width / 2
//                         anchors.verticalCenter: parent.verticalCenter
//                         x:      _enabled ? parent.width - width - 2 : 2
//                         color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.55)
//                         Behavior on x     { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
//                         Behavior on color { ColorAnimation  { duration: 120 } }
//                     }
//                 }

//                 Text {
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:           _enabled ? qsTr("Careful: Motor sliders are enabled")
//                                              : qsTr("Propellers removed - Enable motor test")
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                     font.weight:    Font.Medium
//                     color:          _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.90) : Qt.rgba(1,1,1,0.50)
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }

//             MouseArea {
//                 anchors.fill: parent
//                 cursorShape:  Qt.PointingHandCursor
//                 enabled:      !!root.activeVehicle
//                 onClicked: {
//                     _enabled = !_enabled
//                     if (!_enabled) root.stopAll()
//                 }
//             }
//         }

//         // Throttle slider
//         Column {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelHeight * 0.25
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Row {
//                 width: parent.width
//                 Text {
//                     text:                   qsTr("Throttle")
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     color:                  Qt.rgba(1,1,1,0.70)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Item { width: parent.width - throttleLabel.contentWidth - throttleVal.contentWidth - 8; height: 1 }
//                 Text {
//                     id:                     throttleVal
//                     text:                   Math.round(_throttle) + "%"
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                     font.weight:            Font.SemiBold
//                     color:                  Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                     anchors.verticalCenter: parent.verticalCenter
//                 }
//                 Text { id: throttleLabel; width: 0 }
//             }

//             Slider {
//                 id:             throttleSlider
//                 width:          parent.width
//                 from:           5; to: 100; stepSize: 1
//                 value:          _throttle
//                 enabled:        _enabled
//                 onValueChanged: _throttle = value

//                 background: Rectangle {
//                     x:      throttleSlider.leftPadding
//                     y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width:  throttleSlider.availableWidth
//                     height: 4
//                     radius: 2
//                     color:  Qt.rgba(1,1,1,0.12)
//                     Rectangle {
//                         width:  throttleSlider.visualPosition * parent.width
//                         height: parent.height
//                         radius: 2
//                         color:  Qt.rgba(0.0, 0.83, 1.0, 0.80)
//                     }
//                 }
//                 handle: Rectangle {
//                     x:      throttleSlider.leftPadding + throttleSlider.visualPosition * (throttleSlider.availableWidth - width)
//                     y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
//                     width:  16; height: 16; radius: 8
//                     color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.30)
//                     border.color: Qt.rgba(1,1,1,0.25)
//                     border.width: 1
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }
//             }
//         }

//         // Duration input row
//         Row {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelWidth
//             opacity: _enabled ? 1.0 : 0.4
//             Behavior on opacity { NumberAnimation { duration: 120 } }

//             Text {
//                 text:                   qsTr("Runtime (s):")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
//                 color:                  Qt.rgba(1,1,1,0.70)
//                 anchors.verticalCenter: parent.verticalCenter
//             }

//             Rectangle {
//                 width:        ScreenTools.defaultFontPixelWidth * 7
//                 height:       ScreenTools.defaultFontPixelHeight * 1.7
//                 radius:       5
//                 color:        Qt.rgba(1,1,1,0.06)
//                 border.color: durationInput.activeFocus ? Qt.rgba(0.0,0.83,1.0,0.60) : Qt.rgba(1,1,1,0.20)
//                 border.width: 1
//                 Behavior on border.color { ColorAnimation { duration: 100 } }
//                 anchors.verticalCenter: parent.verticalCenter

//                 TextInput {
//                     id:                  durationInput
//                     anchors.centerIn:    parent
//                     width:               parent.width - 8
//                     text:                _duration.toString()
//                     font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
//                     color:               Qt.rgba(1,1,1,0.90)
//                     horizontalAlignment: TextInput.AlignHCenter
//                     inputMethodHints:    Qt.ImhFormattedNumbersOnly
//                     validator:           RegularExpressionValidator { regularExpression: /^[0-9]{1,3}(\.[0-9]{0,1})?$/ }
//                     selectByMouse:       true
//                     enabled:             _enabled

//                     onEditingFinished: {
//                         var v = parseFloat(text)
//                         if (!isNaN(v) && v > 0) _duration = v
//                         else { _duration = 2; text = "2" }
//                     }
//                 }
//             }

//             Text {
//                 text:                   qsTr("seconds")
//                 font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.72
//                 color:                  Qt.rgba(1,1,1,0.40)
//                 anchors.verticalCenter: parent.verticalCenter
//             }
//         }

//         // Motor buttons grid — columns adapt: 4 max per row
//         Grid {
//             width:   parent.width
//             columns: Math.min(_motorCount, 4)
//             spacing: ScreenTools.defaultFontPixelWidth * 2.5

//             Repeater {
//                 id:    motorRepeater
//                 model: _motorCount
//                 delegate: Rectangle {
//                     readonly property int _cols: Math.min(_motorCount, 4)
//                     width:  (panelCol.width - (_cols - 1) * ScreenTools.defaultFontPixelWidth * 2.5) / _cols
//                     height: ScreenTools.defaultFontPixelHeight * 2.8
//                     radius: 7
//                     color: {
//                         if (!_enabled)                  return Qt.rgba(1,1,1,0.04)
//                         if (_activeMotor === index + 1) return Qt.rgba(0.0,0.83,1.0,0.25)
//                         return mMa.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.07)
//                     }
//                     border.color: {
//                         if (!_enabled)                  return Qt.rgba(1,1,1,0.08)
//                         if (_activeMotor === index + 1) return Qt.rgba(0.0,0.83,1.0,0.70)
//                         return Qt.rgba(1,1,1,0.18)
//                     }
//                     border.width: 1
//                     opacity:      _enabled ? 1.0 : 0.4
//                     Behavior on color        { ColorAnimation { duration: 80 } }
//                     Behavior on border.color { ColorAnimation { duration: 80 } }
//                     Behavior on opacity      { NumberAnimation { duration: 120 } }

//                     Column {
//                         anchors.centerIn: parent
//                         spacing:          2
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           "⚙"
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.3
//                             color:          _activeMotor === index + 1
//                                                 ? Qt.rgba(0.0,0.83,1.0,1.0)
//                                                 : Qt.rgba(1,1,1,0.55)
//                             NumberAnimation on rotation {
//                                 running:  _activeMotor === index + 1
//                                 from: 0; to: 360; duration: 600
//                                 loops: Animation.Infinite
//                             }
//                         }
//                         Text {
//                             anchors.horizontalCenter: parent.horizontalCenter
//                             text:           motorLabel(index)
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                             font.weight:    Font.SemiBold
//                             color:          _activeMotor === index + 1
//                                                 ? Qt.rgba(0.0,0.83,1.0,0.95)
//                                                 : Qt.rgba(1,1,1,0.80)
//                         }
//                     }

//                     MouseArea {
//                         id:           mMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
//                         enabled:      _enabled && !!root.activeVehicle
//                         onClicked:    root.testMotor(index + 1)
//                     }
//                 }
//             }
//         }

//         // All / Sequential / Stop All row
//         Row {
//             width:   parent.width
//             spacing: ScreenTools.defaultFontPixelWidth * 0.8

//             // All
//             Rectangle {
//                 width:        (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.8) / 3
//                 height:       ScreenTools.defaultFontPixelHeight * 2.2
//                 radius:       7
//                 color:        allMa.containsMouse && _enabled
//                                   ? Qt.rgba(0.0,0.83,1.0,0.22)
//                                   : Qt.rgba(0.0,0.83,1.0,0.10)
//                 border.color: _enabled ? Qt.rgba(0.0,0.83,1.0,0.50) : Qt.rgba(1,1,1,0.12)
//                 border.width: 1
//                 opacity:      _enabled ? 1.0 : 0.4
//                 Behavior on color   { ColorAnimation { duration: 80 } }
//                 Behavior on opacity { NumberAnimation { duration: 120 } }

//                 Text {
//                     anchors.centerIn: parent
//                     text:             qsTr("All")
//                     font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.80
//                     font.weight:      Font.SemiBold
//                     color:            Qt.rgba(0.0, 0.83, 1.0, 0.95)
//                 }
//                 MouseArea {
//                     id:           allMa
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
//                     enabled:      _enabled && !!root.activeVehicle
//                     onClicked:    root.testAll()
//                 }
//             }

//             // Sequential
//             Rectangle {
//                 width:        (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.8) / 3
//                 height:       ScreenTools.defaultFontPixelHeight * 2.2
//                 radius:       7
//                 color:        _seqRunning
//                                   ? Qt.rgba(0.55, 0.20, 1.0, 0.25)
//                                   : seqMa.containsMouse && _enabled
//                                         ? Qt.rgba(0.55,0.20,1.0,0.18)
//                                         : Qt.rgba(0.55,0.20,1.0,0.10)
//                 border.color: _seqRunning
//                                   ? Qt.rgba(0.65, 0.30, 1.0, 0.80)
//                                   : _enabled ? Qt.rgba(0.55,0.20,1.0,0.50) : Qt.rgba(1,1,1,0.12)
//                 border.width: 1
//                 opacity:      _enabled ? 1.0 : 0.4
//                 Behavior on color        { ColorAnimation { duration: 80 } }
//                 Behavior on border.color { ColorAnimation { duration: 80 } }
//                 Behavior on opacity      { NumberAnimation { duration: 120 } }

//                 Row {
//                     anchors.centerIn: parent
//                     spacing:          4
//                     // Pulse dot while running
//                     Rectangle {
//                         visible:              _seqRunning
//                         width:                6; height: 6; radius: 3
//                         anchors.verticalCenter: parent.verticalCenter
//                         color:                Qt.rgba(0.65, 0.30, 1.0, 1.0)
//                         SequentialAnimation on opacity {
//                             running:  _seqRunning
//                             loops:    Animation.Infinite
//                             NumberAnimation { to: 0.2; duration: 400 }
//                             NumberAnimation { to: 1.0; duration: 400 }
//                         }
//                     }
//                     Text {
//                         anchors.verticalCenter: parent.verticalCenter
//                         text:             _seqRunning ? qsTr("Running...") : qsTr("Sequential")
//                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.80
//                         font.weight:      Font.SemiBold
//                         color:            _seqRunning
//                                               ? Qt.rgba(0.75, 0.45, 1.0, 1.0)
//                                               : Qt.rgba(0.65, 0.30, 1.0, 0.95)
//                     }
//                 }
//                 MouseArea {
//                     id:           seqMa
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
//                     enabled:      _enabled && !!root.activeVehicle
//                     onClicked:    _seqRunning ? root.stopAll() : root.testSequential()
//                 }
//             }

//             // Stop All
//             Rectangle {
//                 width:        (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.8) / 3
//                 height:       ScreenTools.defaultFontPixelHeight * 2.2
//                 radius:       7
//                 color:        stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
//                 border.color: Qt.rgba(1.0,0.22,0.35,0.55)
//                 border.width: 1
//                 Behavior on color { ColorAnimation { duration: 80 } }

//                 Text {
//                     anchors.centerIn: parent
//                     text:             qsTr("Stop All")
//                     font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.80
//                     font.weight:      Font.SemiBold
//                     color:            Qt.rgba(1.0, 0.35, 0.45, 1.0)
//                 }
//                 MouseArea {
//                     id:           stopMa
//                     anchors.fill: parent
//                     hoverEnabled: true
//                     cursorShape:  Qt.PointingHandCursor
//                     onClicked:    root.stopAll()
//                 }
//             }
//         }

//         // No vehicle notice
//         Text {
//             width:               parent.width
//             visible:             !root.activeVehicle
//             text:                qsTr("No vehicle connected")
//             font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
//             color:               Qt.rgba(1,1,1,0.35)
//             horizontalAlignment: Text.AlignHCenter
//         }
//     }
// }


// FlyViewMotorTestDropPanel.qml — BonVGroundStation
// File: src/FlyView/FlyViewMotorTestDropPanel.qml

import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import QGroundControl
import QGroundControl.Controls

Item {
    id:     root
    width:  panelCol.width  + ScreenTools.defaultFontPixelWidth  * 15
    height: panelCol.height + ScreenTools.defaultFontPixelHeight * 2

    property var  activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle
    property real _throttle:        10
    property real _duration:        2
    property int  _activeMotor:     -1
    property bool _enabled:         false
    property bool _seqRunning:      false
    property int  _seqCurrentMotor: 0
    property bool _allRunning:      false
    property int  _allSendIndex:    0     // tracks staggered All sends

    readonly property int _motorCount: activeVehicle ? (activeVehicle.motorCount === -1 ? 8 : activeVehicle.motorCount) : 0

    function motorLabel(index) {
        return String.fromCharCode(65 + index)
    }

    onActiveVehicleChanged: {
        if (!activeVehicle) {
            _enabled = false
            _activeMotor = -1
            _allRunning = false
            _stopSequential()
        }
    }

    function testMotor(motorNum) {
        if (!activeVehicle || !_enabled) return
        _stopAll()
        _stopSequential()
        activeVehicle.motorTest(motorNum, _throttle, _duration, true)
        _activeMotor = motorNum
        // Clear icon slightly after FC stops the motor
        activeTimer.interval = _duration * 1000 + 500
        activeTimer.restart()
    }

    // ── All: stagger each command 80 ms apart so FC doesn't drop any ─────────
    function testAll() {
        if (!activeVehicle || !_enabled) return
        _stopSequential()
        _stopAll()
        _allSendIndex = 0
        _allRunning   = true
        allStaggerTimer.restart()
    }

    function _stopAll() {
        _allRunning   = false
        _allSendIndex = 0
        allStaggerTimer.stop()
        allClearTimer.stop()
    }

    // ── Sequential ────────────────────────────────────────────────────────────
    function testSequential() {
        if (!activeVehicle || !_enabled) return
        _stopAll()
        _stopSequential()
        _seqRunning      = true
        _seqCurrentMotor = 1
        _runNextSequential()
    }

    function _runNextSequential() {
        if (!_seqRunning || _seqCurrentMotor > _motorCount) {
            // Sequence done — clear icon AFTER the last motor's run time elapses
            _seqRunning      = false
            _seqCurrentMotor = 0
            seqTimer.stop()
            // Delay clearing the icon so it stays lit until motor actually stops
            seqClearTimer.interval = _duration * 1000 + 500
            seqClearTimer.restart()
            return
        }
        activeVehicle.motorTest(_seqCurrentMotor, _throttle, _duration, true)
        _activeMotor = _seqCurrentMotor
        seqTimer.interval = _duration * 1000 + 200
        seqTimer.restart()
    }

    function _stopSequential() {
        _seqRunning      = false
        _seqCurrentMotor = 0
        _activeMotor     = -1
        seqTimer.stop()
        seqClearTimer.stop()
    }

    function stopAll() {
        _stopAll()
        _stopSequential()
        if (!activeVehicle) return
        for (var i = 1; i <= _motorCount; i++) {
            activeVehicle.motorTest(i, 0, 0, true)
        }
        _activeMotor = -1
    }

    // Clears single-motor icon after individual testMotor()
    Timer {
        id:      activeTimer
        repeat:  false
        onTriggered: _activeMotor = -1
    }

    // Clears last sequential motor icon after it finishes running
    Timer {
        id:      seqClearTimer
        repeat:  false
        onTriggered: _activeMotor = -1
    }

    // Advances sequential — one shot per motor
    Timer {
        id:      seqTimer
        repeat:  false
        onTriggered: {
            _seqCurrentMotor++
            _runNextSequential()
        }
    }

    // Stagger All commands: sends one motor every 80ms
    Timer {
        id:       allStaggerTimer
        interval: 80
        repeat:   true
        onTriggered: {
            if (!_allRunning || _allSendIndex >= _motorCount) {
                allStaggerTimer.stop()
                // All commands sent — now wait for duration then clear icons
                allClearTimer.interval = _duration * 1000 + 500
                allClearTimer.restart()
                return
            }
            activeVehicle.motorTest(_allSendIndex + 1, _throttle, _duration, true)
            _allSendIndex++
        }
    }

    // Clears All running state after duration elapses
    Timer {
        id:      allClearTimer
        repeat:  false
        onTriggered: _allRunning = false
    }

    Column {
        id:               panelCol
        anchors.centerIn: parent
        spacing:          ScreenTools.defaultFontPixelHeight * 0.75
        width:            ScreenTools.defaultFontPixelWidth * 80

        // Header
        Text {
            width:               parent.width
            text:                qsTr("Motor Test")
            font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.92
            font.weight:         Font.SemiBold
            color:               Qt.rgba(0.0, 0.83, 1.0, 0.90)
            horizontalAlignment: Text.AlignHCenter
        }

        // DEBUG - remove after confirming correct count
        Text {
            width:               parent.width
            text:                "Motor Count: " + (activeVehicle ? activeVehicle.motorCount : "no vehicle")   //+ "  _motorCount: " + _motorCount
            font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.65
            color:               Qt.rgba(1.0, 0.83, 0.0, 0.80)
            horizontalAlignment: Text.AlignHCenter
        }

        // Warning banner
        Rectangle {
            width:        parent.width
            height:       warnText.implicitHeight + ScreenTools.defaultFontPixelHeight * 0.8
            radius:       6
            color:        Qt.rgba(1.0, 0.55, 0.10, 0.13)
            border.color: Qt.rgba(1.0, 0.55, 0.10, 0.40)
            border.width: 1
            Text {
                id:                  warnText
                anchors.centerIn:    parent
                width:               parent.width - ScreenTools.defaultFontPixelWidth * 2
                text:                qsTr("Remove propellers before testing!")
                font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
                color:               Qt.rgba(1.0, 0.65, 0.20, 1.0)
                wrapMode:            Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }

        // Enable / Disable safety toggle
        Rectangle {
            width:        parent.width
            height:       ScreenTools.defaultFontPixelHeight * 2.4
            radius:       7
            color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.15) : Qt.rgba(1,1,1,0.06)
            border.color: _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.55) : Qt.rgba(1,1,1,0.18)
            border.width: 1
            Behavior on color        { ColorAnimation { duration: 120 } }
            Behavior on border.color { ColorAnimation { duration: 120 } }

            Row {
                anchors.centerIn: parent
                spacing:          ScreenTools.defaultFontPixelWidth * 1.2

                Rectangle {
                    id:     toggleTrack
                    width:  ScreenTools.defaultFontPixelWidth * 5
                    height: ScreenTools.defaultFontPixelHeight * 1.1
                    radius: height / 2
                    anchors.verticalCenter: parent.verticalCenter
                    color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.70) : Qt.rgba(1,1,1,0.18)
                    Behavior on color { ColorAnimation { duration: 120 } }

                    Rectangle {
                        width:  parent.height - 4
                        height: width
                        radius: width / 2
                        anchors.verticalCenter: parent.verticalCenter
                        x:      _enabled ? parent.width - width - 2 : 2
                        color:  _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.55)
                        Behavior on x     { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                        Behavior on color { ColorAnimation  { duration: 120 } }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:           _enabled ? qsTr("Careful: Motor sliders are enabled")
                                             : qsTr("Propellers removed - Enable motor test")
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
                    font.weight:    Font.Medium
                    color:          _enabled ? Qt.rgba(0.0, 0.83, 1.0, 0.90) : Qt.rgba(1,1,1,0.50)
                    Behavior on color { ColorAnimation { duration: 120 } }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape:  Qt.PointingHandCursor
                enabled:      !!root.activeVehicle
                onClicked: {
                    _enabled = !_enabled
                    if (!_enabled) root.stopAll()
                }
            }
        }

        // Throttle slider
        Column {
            width:   parent.width
            spacing: ScreenTools.defaultFontPixelHeight * 0.25
            opacity: _enabled ? 1.0 : 0.4
            Behavior on opacity { NumberAnimation { duration: 120 } }

            Row {
                width: parent.width
                Text {
                    text:                   qsTr("Throttle")
                    font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
                    color:                  Qt.rgba(1,1,1,0.70)
                    anchors.verticalCenter: parent.verticalCenter
                }
                Item { width: parent.width - throttleLabel.contentWidth - throttleVal.contentWidth - 8; height: 1 }
                Text {
                    id:                     throttleVal
                    text:                   Math.round(_throttle) + "%"
                    font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
                    font.weight:            Font.SemiBold
                    color:                  Qt.rgba(0.0, 0.83, 1.0, 0.90)
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text { id: throttleLabel; width: 0 }
            }

            Slider {
                id:             throttleSlider
                width:          parent.width
                from:           5; to: 20; stepSize: 1
                value:          _throttle
                enabled:        _enabled
                onValueChanged: _throttle = value

                background: Rectangle {
                    x:      throttleSlider.leftPadding
                    y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
                    width:  throttleSlider.availableWidth
                    height: 4
                    radius: 2
                    color:  Qt.rgba(1,1,1,0.12)
                    Rectangle {
                        width:  throttleSlider.visualPosition * parent.width
                        height: parent.height
                        radius: 2
                        color:  Qt.rgba(0.0, 0.83, 1.0, 0.80)
                    }
                }
                handle: Rectangle {
                    x:      throttleSlider.leftPadding + throttleSlider.visualPosition * (throttleSlider.availableWidth - width)
                    y:      throttleSlider.topPadding + throttleSlider.availableHeight / 2 - height / 2
                    width:  16; height: 16; radius: 8
                    color:        _enabled ? Qt.rgba(0.0, 0.83, 1.0, 1.0) : Qt.rgba(1,1,1,0.30)
                    border.color: Qt.rgba(1,1,1,0.25)
                    border.width: 1
                    Behavior on color { ColorAnimation { duration: 120 } }
                }
            }
        }

        // Duration input row
        Row {
            width:   parent.width
            spacing: ScreenTools.defaultFontPixelWidth
            opacity: _enabled ? 1.0 : 0.4
            Behavior on opacity { NumberAnimation { duration: 120 } }

            Text {
                text:                   qsTr("Runtime (s):")
                font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.75
                color:                  Qt.rgba(1,1,1,0.70)
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width:        ScreenTools.defaultFontPixelWidth * 7
                height:       ScreenTools.defaultFontPixelHeight * 1.7
                radius:       5
                color:        Qt.rgba(1,1,1,0.06)
                border.color: durationInput.activeFocus ? Qt.rgba(0.0,0.83,1.0,0.60) : Qt.rgba(1,1,1,0.20)
                border.width: 1
                Behavior on border.color { ColorAnimation { duration: 100 } }
                anchors.verticalCenter: parent.verticalCenter

                TextInput {
                    id:                  durationInput
                    anchors.centerIn:    parent
                    width:               parent.width - 8
                    text:                _duration.toString()
                    font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
                    color:               Qt.rgba(1,1,1,0.90)
                    horizontalAlignment: TextInput.AlignHCenter
                    inputMethodHints:    Qt.ImhFormattedNumbersOnly
                    validator:           RegularExpressionValidator { regularExpression: /^[0-9]{1,3}(\.[0-9]{0,1})?$/ }
                    selectByMouse:       true
                    enabled:             _enabled

                    onEditingFinished: {
                        var v = parseFloat(text)
                        if (!isNaN(v) && v > 0) _duration = v
                        else { _duration = 2; text = "2" }
                    }
                }
            }

            Text {
                text:                   qsTr("seconds")
                font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.72
                color:                  Qt.rgba(1,1,1,0.40)
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Motor buttons grid — columns adapt: 4 max per row
        Grid {
            width:   parent.width
            columns: Math.min(_motorCount, 4)
            spacing: ScreenTools.defaultFontPixelWidth * 2.5

            Repeater {
                id:    motorRepeater
                model: _motorCount
                delegate: Rectangle {
                    readonly property int _cols: Math.min(_motorCount, 4)
                    width:  (panelCol.width - (_cols - 1) * ScreenTools.defaultFontPixelWidth * 2.5) / _cols
                    height: ScreenTools.defaultFontPixelHeight * 2.8
                    radius: 7
                    color: {
                        if (!_enabled)                  return Qt.rgba(1,1,1,0.04)
                        if (_allRunning)                return Qt.rgba(0.0,0.83,1.0,0.25)
                        if (_activeMotor === index + 1) return Qt.rgba(0.0,0.83,1.0,0.25)
                        return mMa.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.07)
                    }
                    border.color: {
                        if (!_enabled)                  return Qt.rgba(1,1,1,0.08)
                        if (_allRunning)                return Qt.rgba(0.0,0.83,1.0,0.70)
                        if (_activeMotor === index + 1) return Qt.rgba(0.0,0.83,1.0,0.70)
                        return Qt.rgba(1,1,1,0.18)
                    }
                    border.width: 1
                    opacity:      _enabled ? 1.0 : 0.4
                    Behavior on color        { ColorAnimation { duration: 80 } }
                    Behavior on border.color { ColorAnimation { duration: 80 } }
                    Behavior on opacity      { NumberAnimation { duration: 120 } }

                    Column {
                        anchors.centerIn: parent
                        spacing:          2
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:           "⚙"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.3
                            color:          (_allRunning || _activeMotor === index + 1)
                                                ? Qt.rgba(0.0,0.83,1.0,1.0)
                                                : Qt.rgba(1,1,1,0.55)
                            NumberAnimation on rotation {
                                running:  _allRunning || _activeMotor === index + 1
                                from: 0; to: 360; duration: 600
                                loops: Animation.Infinite
                            }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:           motorLabel(index)
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
                            font.weight:    Font.SemiBold
                            color:          (_allRunning || _activeMotor === index + 1)
                                                ? Qt.rgba(0.0,0.83,1.0,0.95)
                                                : Qt.rgba(1,1,1,0.80)
                        }
                    }

                    MouseArea {
                        id:           mMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                        enabled:      _enabled && !!root.activeVehicle
                        onClicked:    root.testMotor(index + 1)
                    }
                }
            }
        }

        // All / Sequential / Stop All row
        Row {
            width:   parent.width
            spacing: ScreenTools.defaultFontPixelWidth * 0.8

            // All
            Rectangle {
                width:        (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.8) / 3
                height:       ScreenTools.defaultFontPixelHeight * 2.2
                radius:       7
                color:        allMa.containsMouse && _enabled
                                  ? Qt.rgba(0.0,0.83,1.0,0.22)
                                  : Qt.rgba(0.0,0.83,1.0,0.10)
                border.color: _enabled ? Qt.rgba(0.0,0.83,1.0,0.50) : Qt.rgba(1,1,1,0.12)
                border.width: 1
                opacity:      _enabled ? 1.0 : 0.4
                Behavior on color   { ColorAnimation { duration: 80 } }
                Behavior on opacity { NumberAnimation { duration: 120 } }

                Text {
                    anchors.centerIn: parent
                    text:             qsTr("All")
                    font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.80
                    font.weight:      Font.SemiBold
                    color:            Qt.rgba(0.0, 0.83, 1.0, 0.95)
                }
                MouseArea {
                    id:           allMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                    enabled:      _enabled && !!root.activeVehicle
                    onClicked:    root.testAll()
                }
            }

            // Sequential
            Rectangle {
                width:        (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.8) / 3
                height:       ScreenTools.defaultFontPixelHeight * 2.2
                radius:       7
                color:        _seqRunning
                                  ? Qt.rgba(0.55, 0.20, 1.0, 0.25)
                                  : seqMa.containsMouse && _enabled
                                        ? Qt.rgba(0.55,0.20,1.0,0.18)
                                        : Qt.rgba(0.55,0.20,1.0,0.10)
                border.color: _seqRunning
                                  ? Qt.rgba(0.65, 0.30, 1.0, 0.80)
                                  : _enabled ? Qt.rgba(0.55,0.20,1.0,0.50) : Qt.rgba(1,1,1,0.12)
                border.width: 1
                opacity:      _enabled ? 1.0 : 0.4
                Behavior on color        { ColorAnimation { duration: 80 } }
                Behavior on border.color { ColorAnimation { duration: 80 } }
                Behavior on opacity      { NumberAnimation { duration: 120 } }

                Row {
                    anchors.centerIn: parent
                    spacing:          4
                    // Pulse dot while running
                    Rectangle {
                        visible:              _seqRunning
                        width:                6; height: 6; radius: 3
                        anchors.verticalCenter: parent.verticalCenter
                        color:                Qt.rgba(0.65, 0.30, 1.0, 1.0)
                        SequentialAnimation on opacity {
                            running:  _seqRunning
                            loops:    Animation.Infinite
                            NumberAnimation { to: 0.2; duration: 400 }
                            NumberAnimation { to: 1.0; duration: 400 }
                        }
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text:             _seqRunning ? qsTr("Running...") : qsTr("Sequential")
                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.80
                        font.weight:      Font.SemiBold
                        color:            _seqRunning
                                              ? Qt.rgba(0.75, 0.45, 1.0, 1.0)
                                              : Qt.rgba(0.65, 0.30, 1.0, 0.95)
                    }
                }
                MouseArea {
                    id:           seqMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:  _enabled ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                    enabled:      _enabled && !!root.activeVehicle
                    onClicked:    _seqRunning ? root.stopAll() : root.testSequential()
                }
            }

            // Stop All
            Rectangle {
                width:        (parent.width - 2 * ScreenTools.defaultFontPixelWidth * 0.8) / 3
                height:       ScreenTools.defaultFontPixelHeight * 2.2
                radius:       7
                color:        stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
                border.color: Qt.rgba(1.0,0.22,0.35,0.55)
                border.width: 1
                Behavior on color { ColorAnimation { duration: 80 } }

                Text {
                    anchors.centerIn: parent
                    text:             qsTr("Stop All")
                    font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.80
                    font.weight:      Font.SemiBold
                    color:            Qt.rgba(1.0, 0.35, 0.45, 1.0)
                }
                MouseArea {
                    id:           stopMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape:  Qt.PointingHandCursor
                    onClicked:    root.stopAll()
                }
            }
        }

        // No vehicle notice
        Text {
            width:               parent.width
            visible:             !root.activeVehicle
            text:                qsTr("No vehicle connected")
            font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.72
            color:               Qt.rgba(1,1,1,0.35)
            horizontalAlignment: Text.AlignHCenter
        }
    }
}
