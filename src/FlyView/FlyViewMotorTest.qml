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
    height: panelCol.height + ScreenTools.defaultFontPixelHeight * 3

    property var  activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property real _throttle:     10
    property real _duration:     2
    property int  _activeMotor:  -1
    property bool _enabled:      false

    readonly property var _motors: [
        { num: 1, label: "Motor A" },
        { num: 2, label: "Motor B" },
        { num: 3, label: "Motor C" },
        { num: 4, label: "Motor D" },
        { num: 5, label: "Motor E" },
        { num: 6, label: "Motor F" },
    ]

    onActiveVehicleChanged: {
        if (!activeVehicle) { _enabled = false; _activeMotor = -1 }
    }

    function testMotor(motorNum) {
        if (!activeVehicle || !_enabled) return
        activeVehicle.sendMavCommand(
            activeVehicle.defaultComponentId,
            MavlinkQmlSingleton.MAV_CMD_DO_MOTOR_TEST,
            true,
            motorNum, 1, _throttle, _duration, 0, 0, 0
        )
        _activeMotor = motorNum
        activeTimer.restart()
    }

    function stopAll() {
        if (!activeVehicle) return
        // for (var i = 1; i <= _motors.length; i++) {
        //     activeVehicle.sendMavCommand(
        //         activeVehicle.defaultComponentId,
        //         MavlinkQmlSingleton.MAV_CMD_DO_MOTOR_TEST,
        //         false, i, 1, 0, 0, 0, 0, 0
        //     )
        // }
        for (var motorIndex=0; motorIndex < buttonRepeater.count; motorIndex++) 
        {
            controller.vehicle.motorTest(motorIndex + 1, 0, 0, true)
            }
        _activeMotor = -1
    }

    Timer {
        id:          activeTimer
        interval:    _duration * 1000 + 300
        repeat:      false
        onTriggered: _activeMotor = -1
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
                from:           5; to: 100; stepSize: 5
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

        // Motor buttons grid
        Grid {
            width:   parent.width
            columns: 3
            spacing: ScreenTools.defaultFontPixelWidth * 2.5

            Repeater {
                model: _motors
                delegate: Rectangle {
                    width:  (panelCol.width - 2 * ScreenTools.defaultFontPixelWidth * 0.6) / 4
                    height: ScreenTools.defaultFontPixelHeight * 2.8
                    radius: 7
                    color: {
                        if (!_enabled)                      return Qt.rgba(1,1,1,0.04)
                        if (_activeMotor === modelData.num) return Qt.rgba(0.0,0.83,1.0,0.25)
                        return mMa.containsMouse ? Qt.rgba(1,1,1,0.12) : Qt.rgba(1,1,1,0.07)
                    }
                    border.color: {
                        if (!_enabled)                      return Qt.rgba(1,1,1,0.08)
                        if (_activeMotor === modelData.num) return Qt.rgba(0.0,0.83,1.0,0.70)
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
                            color:          _activeMotor === modelData.num
                                                ? Qt.rgba(0.0,0.83,1.0,1.0)
                                                : Qt.rgba(1,1,1,0.55)
                            NumberAnimation on rotation {
                                running:  _activeMotor === modelData.num
                                from: 0; to: 360; duration: 600
                                loops: Animation.Infinite
                            }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text:           modelData.label
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
                            font.weight:    Font.SemiBold
                            color:          _activeMotor === modelData.num
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
                        onClicked:    root.testMotor(modelData.num)
                    }
                }
            }
        }

        // Stop All button
        Rectangle {
            width:        parent.width
            height:       ScreenTools.defaultFontPixelHeight * 2.2
            radius:       7
            color:        stopMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.30) : Qt.rgba(1.0,0.22,0.35,0.15)
            border.color: Qt.rgba(1.0,0.22,0.35,0.55)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 80 } }

            Text {
                anchors.centerIn: parent
                text:             qsTr("Stop All")
                font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
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
