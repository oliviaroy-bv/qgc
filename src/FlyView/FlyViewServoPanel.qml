// // C:\BV_GCS\qgc\src\FlyView\FlyViewServoPanel.qml
// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts

// import QGroundControl
// import QGroundControl.Controls

// Rectangle {
//     width:          mainColumn.width + (ScreenTools.defaultFontPixelWidth * 2)
//     height:         mainColumn.height + (ScreenTools.defaultFontPixelHeight * 2)
//     radius:         ScreenTools.defaultFontPixelHeight * 0.5
//     color:          "#1e1e1e" //"#2b2b2b"
//     border.color:   "#444444"  //"#555555"
//     border.width:   1

//     property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

//     QGCPalette { id: qgcPal; colorGroupEnabled: true }

//     // Column {
//     //     id:                 mainColumn
//     //     anchors.margins:    ScreenTools.defaultFontPixelWidth
//     //     anchors.centerIn:   parent
//     //     spacing:            ScreenTools.defaultFontPixelHeight * 0.3

//     //     // Header Row (Servo 5-14 or customize as needed)
//     //     Row {
//     //         spacing: 2

//     //         Rectangle {
//     //             width:  80
//     //             height: 35
//     //             color:  "transparent"
//     //         }

//     //         Repeater {
//     //             model: ["Low", "Mid", "High", "Toggle", "5", ""]
//     //             Rectangle {
//     //                 width:  model.index === 3 ? 60 : (model.index === 4 ? 30 : 45)
//     //                 height: 35
//     //                 color:  "transparent"
                    
//     //                 Label {
//     //                     anchors.centerIn: parent
//     //                     text: modelData
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 12
//     //                     font.weight: Font.Medium
//     //                 }
//     //             }
//     //         }

//     //         // PWM Value Headers
//     //         Rectangle {
//     //             width:  50
//     //             height: 35
//     //             color:  "transparent"
                
//     //             Label {
//     //                 anchors.centerIn: parent
//     //                 text: "1100"
//     //                 color: "#cccccc"
//     //                 font.pixelSize: 12
//     //             }
//     //         }

//     //         Rectangle {
//     //             width:  50
//     //             height: 35
//     //             color:  "transparent"
                
//     //             Label {
//     //                 anchors.centerIn: parent
//     //                 text: "1900"
//     //                 color: "#cccccc"
//     //                 font.pixelSize: 12
//     //             }
//     //         }
//     //     }

//     //     // Servo Rows 5-14 (or 9-14 as you prefer)
//     //     Repeater {
//     //         model: 6  // Servos 5-14 (or change to 6 for servos 9-14)
            
//     //         delegate: Row {
//     //             spacing: 2
                
//     //             property int servoNumber: 9 + index  // Change to 9 + index for servos 9-14
                
//     //             // Servo Label
//     //             Rectangle {
//     //                 width:  80
//     //                 height: 30
//     //                 color:  "transparent"
                    
//     //                 Label {
//     //                     anchors.left: parent.left
//     //                     anchors.leftMargin: 5
//     //                     anchors.verticalCenter: parent.verticalCenter
//     //                     text: "Low"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                 }
//     //             }
                
//     //             // Low Button
//     //             Rectangle {
//     //                 width:  45
//     //                 height: 30
//     //                 radius: 3
//     //                 color:  lowMouseArea.pressed ? "#4a4a4a" : "#3a3a3a"
//     //                 border.color: "#555555"
//     //                 border.width: 1
                    
//     //                 Label {
//     //                     anchors.centerIn: parent
//     //                     text: "Low"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                 }
                    
//     //                 MouseArea {
//     //                     id: lowMouseArea
//     //                     anchors.fill: parent
//     //                     onClicked: {
//     //                         console.log("Servo", servoNumber, "- Low (1000)")
//     //                         sendServoCommand(servoNumber, 1000)
//     //                     }
//     //                 }
//     //             }
                
//     //             // Mid Button
//     //             Rectangle {
//     //                 width:  45
//     //                 height: 30
//     //                 radius: 3
//     //                 color:  midMouseArea.pressed ? "#4a4a4a" : "#3a3a3a"
//     //                 border.color: "#555555"
//     //                 border.width: 1
                    
//     //                 Label {
//     //                     anchors.centerIn: parent
//     //                     text: "Mid"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                 }
                    
//     //                 MouseArea {
//     //                     id: midMouseArea
//     //                     anchors.fill: parent
//     //                     onClicked: {
//     //                         console.log("Servo", servoNumber, "- Mid (1500)")
//     //                         sendServoCommand(servoNumber, 1500)
//     //                     }
//     //                 }
//     //             }
                
//     //             // High Button
//     //             Rectangle {
//     //                 width:  45
//     //                 height: 30
//     //                 radius: 3
//     //                 color:  highMouseArea.pressed ? "#4a4a4a" : "#3a3a3a"
//     //                 border.color: "#555555"
//     //                 border.width: 1
                    
//     //                 Label {
//     //                     anchors.centerIn: parent
//     //                     text: "High"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                 }
                    
//     //                 MouseArea {
//     //                     id: highMouseArea
//     //                     anchors.fill: parent
//     //                     onClicked: {
//     //                         console.log("Servo", servoNumber, "- High (2000)")
//     //                         sendServoCommand(servoNumber, 2000)
//     //                     }
//     //                 }
//     //             }
                
//     //             // Toggle Button
//     //             Rectangle {
//     //                 width:  60
//     //                 height: 30
//     //                 radius: 3
//     //                 color:  toggleMouseArea.pressed ? "#4a4a4a" : "#3a3a3a"
//     //                 border.color: "#555555"
//     //                 border.width: 1
                    
//     //                 property bool toggleState: false
                    
//     //                 Label {
//     //                     anchors.centerIn: parent
//     //                     text: "Toggle"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                 }
                    
//     //                 MouseArea {
//     //                     id: toggleMouseArea
//     //                     anchors.fill: parent
//     //                     onClicked: {
//     //                         parent.toggleState = !parent.toggleState
//     //                         var value = parent.toggleState ? 2000 : 1000
//     //                         console.log("Servo", servoNumber, "- Toggle", value)
//     //                         sendServoCommand(servoNumber, value)
//     //                     }
//     //                 }
//     //             }
                
//     //             // Servo Number Label
//     //             Rectangle {
//     //                 width:  30
//     //                 height: 30
//     //                 color:  "transparent"
                    
//     //                 Label {
//     //                     anchors.centerIn: parent
//     //                     text: servoNumber
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                     font.weight: Font.Medium
//     //                 }
//     //             }
                
//     //             // Empty space
//     //             Rectangle {
//     //                 width:  10
//     //                 height: 30
//     //                 color:  "transparent"
//     //             }
                
//     //             // Low PWM Input
//     //             Rectangle {
//     //                 width:  50
//     //                 height: 30
//     //                 radius: 3
//     //                 color:  "#2a2a2a"
//     //                 border.color: "#555555"
//     //                 border.width: 1
                    
//     //                 TextInput {
//     //                     id: lowPwmInput
//     //                     anchors.fill: parent
//     //                     anchors.margins: 5
//     //                     text: "1100"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                     horizontalAlignment: Text.AlignHCenter
//     //                     verticalAlignment: Text.AlignVCenter
//     //                     validator: IntValidator { bottom: 800; top: 2200 }
                        
//     //                     onEditingFinished: {
//     //                         console.log("Servo", servoNumber, "Low PWM set to:", text)
//     //                     }
//     //                 }
//     //             }
                
//     //             // High PWM Input
//     //             Rectangle {
//     //                 width:  50
//     //                 height: 30
//     //                 radius: 3
//     //                 color:  "#2a2a2a"
//     //                 border.color: "#555555"
//     //                 border.width: 1
                    
//     //                 TextInput {
//     //                     id: highPwmInput
//     //                     anchors.fill: parent
//     //                     anchors.margins: 5
//     //                     text: "1900"
//     //                     color: "#cccccc"
//     //                     font.pixelSize: 11
//     //                     horizontalAlignment: Text.AlignHCenter
//     //                     verticalAlignment: Text.AlignVCenter
//     //                     validator: IntValidator { bottom: 800; top: 2200 }
                        
//     //                     onEditingFinished: {
//     //                         console.log("Servo", servoNumber, "High PWM set to:", text)
//     //                     }
//     //                 }
//     //             }
//     //         }
//     //     }
//     // }

//     // // Function to send servo command via MAVLink
//     // function sendServoCommand(servoNum, pwmValue) {
//     //     if (!_activeVehicle) {
//     //         console.log("No active vehicle")
//     //         return
//     //     }
        
//     //     console.log("Sending MAVLink DO_SET_SERVO:", servoNum, "=", pwmValue)
        
//     //     // Send MAVLink DO_SET_SERVO command
//     //     _activeVehicle.sendMavCommand(
//     //         _activeVehicle.defaultComponentId,
//     //         MAV_CMD_DO_SET_SERVO,       // Command ID
//     //         true,                        // Show error if failed
//     //         servoNum,                    // Param 1: Servo number
//     //         pwmValue,                    // Param 2: PWM value
//     //         0, 0, 0, 0, 0               // Params 3-7: unused
//     //     )
//     // }

//     Column {
//         id:             mainColumn
//         anchors.centerIn: parent
//         spacing:        6

//         // Servo rows 9-14
//         Repeater {
//             model: 6

//             delegate: Rectangle {
//                 width:  row.implicitWidth + 16
//                 height: 36
//                 radius: 6
//                 color:  "#2a2a2a"
//                 border.color: "#3a3a3a"
//                 border.width: 1

//                 property int servoNumber: 9 + index

//                 Row {
//                     id:                 row
//                     anchors.centerIn:   parent
//                     spacing:            6

//                     // Servo number badge
//                     Rectangle {
//                         width:  32
//                         height: 24
//                         radius: 4
//                         color:  "#3d3d3d"

//                         Text {
//                             anchors.centerIn: parent
//                             text:             "S" + servoNumber
//                             color:            "#aaaaaa"
//                             font.pixelSize:   11
//                             font.bold:        true
//                         }
//                     }

//                     // Low button
//                     Rectangle {
//                         id: lowRect
//                         width:  48
//                         height: 24
//                         radius: 4
//                         color:  "#111111"
//                         border.color: lowMouse.activeFocus ? "#6495ED" : "#444444"
//                         border.width: 1

//                         Text {
//                             id:lowButton
//                             anchors.centerIn: parent
//                             text:             "Low"
//                             color:            "white"
//                             font.pixelSize:   11
//                         }

//                         MouseArea {
//                             id:         lowMouse
//                             anchors.fill: parent
//                             onClicked:  sendServoCommand(servoNumber, parseInt(lowPwm.text))
//                         }
//                     }

//                     // Mid button
//                     Rectangle {
//                         width:  48
//                         height: 24
//                         radius: 4
//                         color:  "#111111"
//                         border.color: midMouse.activeFocus ? "#6495ED" : "#444444"
//                         border.width: 1

//                         Text {
//                             id: midButton
//                             anchors.centerIn: parent
//                             text:             "Mid"
//                             color:            "white"
//                             font.pixelSize:   11
//                         }

//                         MouseArea {
//                             id:         midMouse
//                             anchors.fill: parent
//                             onClicked:  sendServoCommand(servoNumber, 1500)
//                         }
//                     }

//                     // High button
//                     Rectangle {
//                         width:  48
//                         height: 24
//                         radius: 4
//                         color:  "#111111"
//                         border.color: highMouse.activeFocus ? "#6495ED" : "#444444"
//                         border.width: 1

//                         Text {
//                             id: highButton
//                             anchors.centerIn: parent
//                             text:             "High"
//                             color:            "white"
//                             font.pixelSize:   11
//                         }

//                         MouseArea {
//                             id:         highMouse
//                             anchors.fill: parent
//                             onClicked:  sendServoCommand(servoNumber, parseInt(highPwm.text))
//                         }
//                     }

//                     // // Toggle button
//                     // Rectangle {
//                     //     id:     toggleRect
//                     //     width:  52
//                     //     height: 24
//                     //     radius: 4
//                     //     color:  toggleState ? "#4a2a7a" : "#2a2a2a"
//                     //     border.color: toggleState ? "#7a4aaa" : "#555555"
//                     //     border.width: 1

//                     //     property bool toggleState: false

//                     //     Behavior on color { ColorAnimation { duration: 150 } }

//                     //     Text {
//                     //         anchors.centerIn: parent
//                     //         text:             "Toggle"
//                     //         color:            toggleRect.toggleState ? "#bb88ff" : "#888888"
//                     //         font.pixelSize:   11
//                     //     }

//                     //     MouseArea {
//                     //         anchors.fill: parent
//                     //         onClicked: {
//                     //             toggleRect.toggleState = !toggleRect.toggleState
//                     //             sendServoCommand(servoNumber, toggleRect.toggleState ? parseInt(highPwm.text) : parseInt(lowPwm.text))
//                     //         }
//                     //     }
//                     // }

//                     // Divider
//                     Rectangle {
//                         width:  1
//                         height: 20
//                         color:  "#444444"
//                     }

//                     // Low PWM input
//                     Rectangle {
//                         width:  48
//                         height: 24
//                         radius: 4
//                         color:  "#111111"
//                         border.color: lowPwm.activeFocus ? "#6495ED" : "#444444"
//                         border.width: 1

//                         TextInput {
//                             id:                  lowPwm
//                             anchors.fill:        parent
//                             anchors.margins:     4
//                             text:                "1000"
//                             color:               "#cccccc"
//                             font.pixelSize:      11
//                             horizontalAlignment: Text.AlignHCenter
//                             verticalAlignment:   Text.AlignVCenter
//                             validator:           IntValidator { bottom: 800; top: 2200 }
//                         }
//                     }

//                     // High PWM input
//                     Rectangle {
//                         width:  48
//                         height: 24
//                         radius: 4
//                         color:  "#111111"
//                         border.color: highPwm.activeFocus ? "#6495ED" : "#444444"
//                         border.width: 1

//                         TextInput {
//                             id:                  highPwm
//                             anchors.fill:        parent
//                             anchors.margins:     4
//                             text:                "2000"
//                             color:               "#cccccc"
//                             font.pixelSize:      11
//                             horizontalAlignment: Text.AlignHCenter
//                             verticalAlignment:   Text.AlignVCenter
//                             validator:           IntValidator { bottom: 800; top: 2200 }
//                         }
//                     }
//                 }
//             }
//         }
//     }

//     function sendServoCommand(servoNum, pwmValue) {
//         if (!_activeVehicle) {
//             console.log("No active vehicle")
//             return
//         }
//         console.log("Servo", servoNum, "→", pwmValue)
//         _activeVehicle.sendMavCommand(
//             _activeVehicle.defaultComponentId,
//             MAV_CMD_DO_SET_SERVO,
//             true,
//             servoNum,
//             pwmValue,
//             0, 0, 0, 0, 0
//         )
//     }
// }

// 2nd iteration
// C:\BV_GCS\qgc\src\FlyView\FlyViewServoPanel.qml
// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects
// // Qt5: import QtGraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:     root
//     width:  panelColumn.width  + (ScreenTools.defaultFontPixelWidth  * 2.4)
//     height: panelColumn.height + (ScreenTools.defaultFontPixelHeight * 2.0)

//     property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

//     // ── Sizing tokens (scale with screen DPI) ────────────────────────────────
//     readonly property real _pad:        ScreenTools.defaultFontPixelWidth  * 0.6
//     readonly property real _rowH:       ScreenTools.defaultFontPixelHeight * 2.0
//     readonly property real _badgeW:     ScreenTools.defaultFontPixelWidth  * 3.2
//     readonly property real _btnW:       ScreenTools.defaultFontPixelWidth  * 5.0
//     readonly property real _pwmW:       ScreenTools.defaultFontPixelWidth  * 5.2
//     readonly property real _radius:     ScreenTools.defaultFontPixelWidth  * 0.55
//     readonly property real _panelR:     ScreenTools.defaultFontPixelWidth  * 1.3
//     readonly property real _colSpacing: ScreenTools.defaultFontPixelWidth  * 0.55
//     readonly property real _rowSpacing: ScreenTools.defaultFontPixelWidth  * 0.5

//     QGCPalette { id: qgcPal; colorGroupEnabled: true }

//     // ── GLASS PANEL BACKGROUND ───────────────────────────────────────────────
//     Item {
//         id:             glassBackground
//         anchors.fill:   parent
//         z:              0

//         layer.enabled:  true
//         layer.effect:   OpacityMask {
//             maskSource: Rectangle {
//                 width:  glassBackground.width
//                 height: glassBackground.height
//                 radius: _panelR
//             }
//         }

//         // Dark tint — panel has no map directly behind it so we use solid glass
//         Rectangle {
//             anchors.fill:   parent
//             color:          Qt.rgba(0.04, 0.047, 0.09, 0.88)
//         }

//         // Upper inner brightness glow
//         Rectangle {
//             anchors.top:    parent.top
//             anchors.left:   parent.left
//             anchors.right:  parent.right
//             height:         parent.height * 0.25
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }

//     // Outer border
//     Rectangle {
//         anchors.fill:   parent
//         color:          "transparent"
//         radius:         _panelR
//         border.color:   Qt.rgba(1, 1, 1, 0.10)
//         border.width:   1
//         z:              1
//     }

//     // Top shimmer
//     Rectangle {
//         anchors.top:                parent.top
//         anchors.topMargin:          1
//         anchors.horizontalCenter:   parent.horizontalCenter
//         width:                      parent.width * 0.55
//         height:                     1
//         z:                          2
//         gradient: Gradient {
//             orientation: Gradient.Horizontal
//             GradientStop { position: 0.0; color: "transparent" }
//             GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.35) }
//             GradientStop { position: 1.0; color: "transparent" }
//         }
//     }

//     // ── HEADER ROW ───────────────────────────────────────────────────────────
//     Row {
//         id:                         headerRow
//         anchors.top:                parent.top
//         anchors.topMargin:          ScreenTools.defaultFontPixelHeight * 0.7
//         anchors.horizontalCenter:   parent.horizontalCenter
//         spacing:                    _colSpacing
//         z:                          3

//         // Badge column header (blank — aligns with S-badge)
//         Item { width: _badgeW; height: _rowH * 0.7 }

//         // Button column headers
//         Repeater {
//             model: ["Low", "Mid", "High"]
//             Item {
//                 width:  _btnW
//                 height: _rowH * 0.7
//                 Text {
//                     anchors.centerIn:   parent
//                     text:               modelData
//                     color:              Qt.rgba(1, 1, 1, 0.35)
//                     font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.0
//                     font.letterSpacing: 0.8
//                 }
//             }
//         }

//         // Divider spacer
//         Item { width: 1; height: _rowH * 0.7 }

//         // PWM column headers
//         Repeater {
//             model: ["PWM Lo", "PWM Hi"]
//             Item {
//                 width:  _pwmW
//                 height: _rowH * 0.7
//                 Text {
//                     anchors.centerIn:   parent
//                     text:               modelData
//                     color:              Qt.rgba(0.0, 0.83, 1.0, 0.45)
//                     font.pixelSize:     ScreenTools.defaultFontPixelWidth * 0.9
//                     font.letterSpacing: 0.5
//                 }
//             }
//         }
//     }

//     // Thin header separator
//     Rectangle {
//         id:                         headerSep
//         anchors.top:                headerRow.bottom
//         anchors.topMargin:          ScreenTools.defaultFontPixelWidth * 0.3
//         anchors.horizontalCenter:   parent.horizontalCenter
//         width:                      parent.width * 0.88
//         height:                     1
//         z:                          3
//         gradient: Gradient {
//             orientation: Gradient.Horizontal
//             GradientStop { position: 0.0; color: "transparent" }
//             GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.08) }
//             GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.08) }
//             GradientStop { position: 1.0; color: "transparent" }
//         }
//     }

//     // ── SERVO ROWS ────────────────────────────────────────────────────────────
//     Column {
//         id:                         panelColumn
//         anchors.top:                headerSep.bottom
//         anchors.topMargin:          ScreenTools.defaultFontPixelWidth * 0.5
//         anchors.horizontalCenter:   parent.horizontalCenter
//         spacing:                    _rowSpacing
//         z:                          3

//         Repeater {
//             model: 6   // Servos S9 – S14

//             delegate: Item {
//                 id:     servoRow
//                 width:  rowContent.implicitWidth
//                 height: _rowH

//                 property int    servoNumber:    9 + index
//                 property bool   _rowHovered:    lowMouse.containsMouse ||
//                                                 midMouse.containsMouse ||
//                                                 highMouse.containsMouse

//                 // Row hover highlight
//                 Rectangle {
//                     anchors.fill:   parent
//                     radius:         _radius
//                     color:          servoRow._rowHovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }

//                 Row {
//                     id:                 rowContent
//                     anchors.centerIn:   parent
//                     spacing:            _colSpacing

//                     // ── S-badge ──────────────────────────────────────────────
//                     Rectangle {
//                         width:              _badgeW
//                         height:             _rowH * 0.72
//                         radius:             _radius
//                         color:              Qt.rgba(0.0, 0.83, 1.0, 0.10)
//                         border.color:       Qt.rgba(0.0, 0.83, 1.0, 0.22)
//                         border.width:       1
//                         anchors.verticalCenter: parent.verticalCenter

//                         Text {
//                             anchors.centerIn:   parent
//                             text:               "S" + servoNumber
//                             color:              Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                             font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.15
//                             font.bold:          true
//                             font.letterSpacing: 0.5
//                         }
//                     }

//                     // ── Low button ───────────────────────────────────────────
//                     ServoButton {
//                         id:         lowBtn
//                         btnLabel:   "Low"
//                         mouseId:    lowMouse
//                         btnW:       _btnW
//                         btnH:       _rowH * 0.72
//                         btnRadius:  _radius
//                         accentColor: Qt.rgba(0.0, 1.0, 0.55, 1)   // green — low = safe

//                         MouseArea {
//                             id:             lowMouse
//                             anchors.fill:   parent
//                             hoverEnabled:   true
//                             onClicked:      sendServoCommand(servoNumber, parseInt(lowPwm.text))
//                         }
//                     }

//                     // ── Mid button ───────────────────────────────────────────
//                     ServoButton {
//                         btnLabel:   "Mid"
//                         mouseId:    midMouse
//                         btnW:       _btnW
//                         btnH:       _rowH * 0.72
//                         btnRadius:  _radius
//                         accentColor: Qt.rgba(0.0, 0.83, 1.0, 1)   // cyan — neutral

//                         MouseArea {
//                             id:             midMouse
//                             anchors.fill:   parent
//                             hoverEnabled:   true
//                             onClicked:      sendServoCommand(servoNumber, 1500)
//                         }
//                     }

//                     // ── High button ──────────────────────────────────────────
//                     ServoButton {
//                         btnLabel:   "High"
//                         mouseId:    highMouse
//                         btnW:       _btnW
//                         btnH:       _rowH * 0.72
//                         btnRadius:  _radius
//                         accentColor: Qt.rgba(1.0, 0.55, 0.10, 1)  // orange — high = caution

//                         MouseArea {
//                             id:             highMouse
//                             anchors.fill:   parent
//                             hoverEnabled:   true
//                             onClicked:      sendServoCommand(servoNumber, parseInt(highPwm.text))
//                         }
//                     }

//                     // ── Divider ──────────────────────────────────────────────
//                     Rectangle {
//                         width:                  1
//                         height:                 _rowH * 0.55
//                         anchors.verticalCenter: parent.verticalCenter
//                         gradient: Gradient {
//                             GradientStop { position: 0.0; color: "transparent" }
//                             GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.10) }
//                             GradientStop { position: 1.0; color: "transparent" }
//                         }
//                     }

//                     // ── Low PWM input ────────────────────────────────────────
//                     PwmInput {
//                         id:         lowPwm
//                         pwmW:       _pwmW
//                         pwmH:       _rowH * 0.72
//                         pwmRadius:  _radius
//                         initText:   "1000"
//                     }

//                     // ── High PWM input ───────────────────────────────────────
//                     PwmInput {
//                         id:         highPwm
//                         pwmW:       _pwmW
//                         pwmH:       _rowH * 0.72
//                         pwmRadius:  _radius
//                         initText:   "2000"
//                     }
//                 }

//                 // Bottom row separator (skip last row)
//                 Rectangle {
//                     visible:                index < 5
//                     anchors.bottom:         parent.bottom
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     width:                  parent.width * 0.92
//                     height:                 1
//                     gradient: Gradient {
//                         orientation: Gradient.Horizontal
//                         GradientStop { position: 0.0; color: "transparent" }
//                         GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.05) }
//                         GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.05) }
//                         GradientStop { position: 1.0; color: "transparent" }
//                     }
//                 }
//             }
//         }
//     }

//     // ── INTERNAL COMPONENT: ServoButton ──────────────────────────────────────
//     component ServoButton: Item {
//         id:             sBtn
//         property real   btnW:       48
//         property real   btnH:       24
//         property real   btnRadius:  4
//         property string btnLabel:   ""
//         property color  accentColor: Qt.rgba(0.0, 0.83, 1.0, 1)
//         property var    mouseId:    null

//         width:  btnW
//         height: btnH
//         anchors.verticalCenter: parent.verticalCenter

//         // Resolve hover/press from the externally-supplied MouseArea
//         readonly property bool _hov: mouseId ? mouseId.containsMouse : false
//         readonly property bool _prs: mouseId ? mouseId.pressed       : false

//         // Glass button background
//         Rectangle {
//             anchors.fill:   parent
//             radius:         sBtn.btnRadius
//             color: {
//                 if (sBtn._prs) return Qt.rgba(
//                     sBtn.accentColor.r,
//                     sBtn.accentColor.g,
//                     sBtn.accentColor.b, 0.22)
//                 if (sBtn._hov) return Qt.rgba(1, 1, 1, 0.09)
//                 return Qt.rgba(1, 1, 1, 0.04)
//             }
//             border.color: {
//                 if (sBtn._prs || sBtn._hov) return Qt.rgba(
//                     sBtn.accentColor.r,
//                     sBtn.accentColor.g,
//                     sBtn.accentColor.b, sBtn._prs ? 0.60 : 0.30)
//                 return Qt.rgba(1, 1, 1, 0.10)
//             }
//             border.width:   1

//             Behavior on color        { ColorAnimation { duration: 130 } }
//             Behavior on border.color { ColorAnimation { duration: 130 } }

//             // Top micro-shimmer
//             Rectangle {
//                 anchors.top:                parent.top
//                 anchors.topMargin:          1
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 width:                      parent.width * 0.5
//                 height:                     1
//                 gradient: Gradient {
//                     orientation: Gradient.Horizontal
//                     GradientStop { position: 0.0; color: "transparent" }
//                     GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, sBtn._hov ? 0.28 : 0.12) }
//                     GradientStop { position: 1.0; color: "transparent" }
//                 }
//                 Behavior on color { ColorAnimation { duration: 130 } }
//             }
//         }

//         // Label
//         Text {
//             anchors.centerIn:   parent
//             text:               sBtn.btnLabel
//             font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.05
//             font.letterSpacing: 0.4
//             color: {
//                 if (sBtn._prs || sBtn._hov) return Qt.rgba(
//                     sBtn.accentColor.r,
//                     sBtn.accentColor.g,
//                     sBtn.accentColor.b, 1.0)
//                 return Qt.rgba(1, 1, 1, 0.70)
//             }
//             Behavior on color { ColorAnimation { duration: 130 } }
//         }

//         // Press scale
//         states: [
//             State { name: "pr"; when: sBtn._prs; PropertyChanges { target: sBtn; scale: 0.92 } },
//             State { name: "no"; when: !sBtn._prs; PropertyChanges { target: sBtn; scale: 1.0 } }
//         ]
//         transitions: [
//             Transition { to: "pr"; NumberAnimation { property: "scale"; duration: 70;  easing.type: Easing.OutQuad } },
//             Transition { to: "no"; NumberAnimation { property: "scale"; duration: 160; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
//         ]
//     }

//     // ── INTERNAL COMPONENT: PwmInput ─────────────────────────────────────────
//     component PwmInput: Item {
//         id:             pwmItem
//         property real   pwmW:       48
//         property real   pwmH:       24
//         property real   pwmRadius:  4
//         property string initText:   "1000"

//         width:  pwmW
//         height: pwmH
//         anchors.verticalCenter: parent.verticalCenter

//         // Expose text to outside via alias
//         property alias text: pwmField.text

//         Rectangle {
//             anchors.fill:   parent
//             radius:         pwmItem.pwmRadius
//             color:          pwmField.activeFocus
//                                 ? Qt.rgba(0.0, 0.83, 1.0, 0.08)
//                                 : Qt.rgba(0, 0, 0, 0.30)
//             border.color:   pwmField.activeFocus
//                                 ? Qt.rgba(0.0, 0.83, 1.0, 0.45)
//                                 : Qt.rgba(1, 1, 1, 0.10)
//             border.width:   1

//             Behavior on color        { ColorAnimation { duration: 150 } }
//             Behavior on border.color { ColorAnimation { duration: 150 } }

//             // Focus shimmer
//             Rectangle {
//                 visible:                    pwmField.activeFocus
//                 anchors.top:                parent.top
//                 anchors.topMargin:          1
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 width:                      parent.width * 0.5
//                 height:                     1
//                 gradient: Gradient {
//                     orientation: Gradient.Horizontal
//                     GradientStop { position: 0.0; color: "transparent" }
//                     GradientStop { position: 0.5; color: Qt.rgba(0.0, 0.83, 1.0, 0.40) }
//                     GradientStop { position: 1.0; color: "transparent" }
//                 }
//             }
//         }

//         TextInput {
//             id:                     pwmField
//             anchors.fill:           parent
//             anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.4
//             anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 0.4
//             text:                   pwmItem.initText
//             color:                  activeFocus
//                                         ? Qt.rgba(0.0, 0.83, 1.0, 1.0)
//                                         : Qt.rgba(1, 1, 1, 0.65)
//             font.pixelSize:         ScreenTools.defaultFontPixelWidth * 1.0
//             horizontalAlignment:    Text.AlignHCenter
//             verticalAlignment:      Text.AlignVCenter
//             validator:              IntValidator { bottom: 800; top: 2200 }
//             selectionColor:         Qt.rgba(0.0, 0.83, 1.0, 0.35)
//             selectedTextColor:      "white"

//             Behavior on color { ColorAnimation { duration: 150 } }
//         }
//     }

//     // ── MAVLink command sender (unchanged logic) ──────────────────────────────
//     function sendServoCommand(servoNum, pwmValue) {
//         if (!_activeVehicle) {
//             console.log("No active vehicle")
//             return
//         }
//         console.log("Servo", servoNum, "→", pwmValue)
//         _activeVehicle.sendMavCommand(
//             _activeVehicle.defaultComponentId,
//             MAV_CMD_DO_SET_SERVO,
//             true,
//             servoNum,
//             pwmValue,
//             0, 0, 0, 0, 0
//         )
//     }
// }

// // C:\BV_GCS\qgc\src\FlyView\FlyViewServoPanel.qml
// import QtQuick
// import QtQuick.Controls
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects
// // Qt5: import QtGraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:     root
//     width:  panelColumn.width  + (ScreenTools.defaultFontPixelWidth  * 4.0)
//     height: panelColumn.height + (ScreenTools.defaultFontPixelHeight * 1.5)

//     property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

//     // ── Sizing tokens (scale with screen DPI) ────────────────────────────────
//     readonly property real _pad:        ScreenTools.defaultFontPixelWidth  * 1.2
//     readonly property real _rowH:       ScreenTools.defaultFontPixelHeight * 3.2
//     readonly property real _badgeW:     ScreenTools.defaultFontPixelWidth  * 5.5
//     readonly property real _btnW:       ScreenTools.defaultFontPixelWidth  * 8.0
//     readonly property real _pwmW:       ScreenTools.defaultFontPixelWidth  * 8.0
//     readonly property real _radius:     ScreenTools.defaultFontPixelWidth  * 0.7
//     readonly property real _panelR:     ScreenTools.defaultFontPixelWidth  * 1.6
//     readonly property real _colSpacing: ScreenTools.defaultFontPixelWidth  * 1.2
//     readonly property real _rowSpacing: ScreenTools.defaultFontPixelWidth  * 0.9

//     QGCPalette { id: qgcPal; colorGroupEnabled: true }

//     // ── GLASS PANEL BACKGROUND ───────────────────────────────────────────────
//     Item {
//         id:             glassBackground
//         anchors.fill:   parent
//         z:              0

//         layer.enabled:  true
//         layer.effect:   OpacityMask {
//             maskSource: Rectangle {
//                 width:  glassBackground.width
//                 height: glassBackground.height
//                 radius: _panelR
//             }
//         }

//         // Dark tint — panel has no map directly behind it so we use solid glass
//         Rectangle {
//             anchors.fill:   parent
//             color:          Qt.rgba(0.04, 0.047, 0.09, 0.68)
//         }

//         // Upper inner brightness glow
//         Rectangle {
//             anchors.top:    parent.top
//             anchors.left:   parent.left
//             anchors.right:  parent.right
//             height:         parent.height * 0.25
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }

//     // Outer border
//     Rectangle {
//         anchors.fill:   parent
//         color:          "transparent"
//         radius:         _panelR
//         border.color:   Qt.rgba(1, 1, 1, 0.10)
//         border.width:   1
//         z:              1
//     }

//     // Top shimmer
//     Rectangle {
//         anchors.top:                parent.top
//         anchors.topMargin:          1
//         anchors.horizontalCenter:   parent.horizontalCenter
//         width:                      parent.width * 0.55
//         height:                     1
//         z:                          2
//         gradient: Gradient {
//             orientation: Gradient.Horizontal
//             GradientStop { position: 0.0; color: "transparent" }
//             GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.35) }
//             GradientStop { position: 1.0; color: "transparent" }
//         }
//     }

//     // // ── HEADER ROW ───────────────────────────────────────────────────────────
//     // Row {
//     //     id:                         headerRow
//     //     anchors.top:                parent.top
//     //     anchors.topMargin:          ScreenTools.defaultFontPixelHeight * 0.7
//     //     anchors.horizontalCenter:   parent.horizontalCenter
//     //     spacing:                    _colSpacing
//     //     z:                          3

//     //     // Badge column header (blank — aligns with S-badge)
//     //     Item { width: _badgeW; height: _rowH * 0.7 }

//     //     // Button column headers
//     //     Repeater {
//     //         model: ["Low", "Mid", "High"]
//     //         Item {
//     //             width:  _btnW
//     //             height: _rowH * 0.7
//     //             Text {
//     //                 anchors.centerIn:   parent
//     //                 text:               modelData
//     //                 color:              Qt.rgba(1, 1, 1, 0.35)
//     //                 font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.3
//     //                 font.letterSpacing: 0.8
//     //             }
//     //         }
//     //     }

//     //     // Divider spacer
//     //     Item { width: 1; height: _rowH * 0.7 }

//     //     // PWM column headers
//     //     Repeater {
//     //         model: ["PWM Lo", "PWM Hi"]
//     //         Item {
//     //             width:  _pwmW
//     //             height: _rowH * 0.7
//     //             Text {
//     //                 anchors.centerIn:   parent
//     //                 text:               modelData
//     //                 color:              Qt.rgba(0.0, 0.83, 1.0, 0.45)
//     //                 font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.15
//     //                 font.letterSpacing: 0.5
//     //             }
//     //         }
//     //     }
//     // }

//     // Thin header separator
//     // Rectangle {
//     //     id:                         headerSep
//     //     anchors.top:                headerRow.bottom
//     //     anchors.topMargin:          ScreenTools.defaultFontPixelWidth * 0.3
//     //     anchors.horizontalCenter:   parent.horizontalCenter
//     //     width:                      parent.width * 0.88
//     //     height:                     1
//     //     z:                          3
//     //     gradient: Gradient {
//     //         orientation: Gradient.Horizontal
//     //         GradientStop { position: 0.0; color: "transparent" }
//     //         GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.08) }
//     //         GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.08) }
//     //         GradientStop { position: 1.0; color: "transparent" }
//     //     }
//     // }

//     // ── SERVO ROWS ────────────────────────────────────────────────────────────
//     Column {
//         id:                         panelColumn
//         anchors.top:                parent.top + 5
//         anchors.topMargin:          ScreenTools.defaultFontPixelWidth * 0.5
//         anchors.horizontalCenter:   parent.horizontalCenter
//         spacing:                    _rowSpacing
//         z:                          3

//         Repeater {
//             model: 6   // Servos S9 – S14

//             delegate: Item {
//                 id:     servoRow
//                 width:  rowContent.implicitWidth
//                 height: _rowH

//                 property int    servoNumber:    9 + index
//                 property bool   _rowHovered:    lowMouse.containsMouse ||
//                                                 midMouse.containsMouse ||
//                                                 highMouse.containsMouse

//                 // Row hover highlight
//                 Rectangle {
//                     anchors.fill:   parent
//                     radius:         _radius
//                     color:          servoRow._rowHovered ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
//                     Behavior on color { ColorAnimation { duration: 120 } }
//                 }

//                 Row {
//                     id:                 rowContent
//                     anchors.centerIn:   parent
//                     spacing:            _colSpacing

//                     // ── S-badge ──────────────────────────────────────────────
//                     Rectangle {
//                         width:              _badgeW
//                         height:             _rowH * 0.72
//                         radius:             _radius
//                         color:              Qt.rgba(0.0, 0.83, 1.0, 0.10)
//                         border.color:       Qt.rgba(0.0, 0.83, 1.0, 0.22)
//                         border.width:       1
//                         anchors.verticalCenter: parent.verticalCenter

//                         Text {
//                             anchors.centerIn:   parent
//                             text:               "S" + servoNumber
//                             color:              Qt.rgba(0.0, 0.83, 1.0, 0.90)
//                             font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.5
//                             font.bold:          true
//                             font.letterSpacing: 0.5
//                         }
//                     }

//                     // ── Low button ───────────────────────────────────────────
//                     ServoButton {
//                         id:         lowBtn
//                         btnLabel:   "Low"
//                         mouseId:    lowMouse
//                         btnW:       _btnW
//                         btnH:       _rowH * 0.72
//                         btnRadius:  _radius
//                         accentColor: Qt.rgba(0.0, 1.0, 0.55, 1)   // green — low = safe

//                         MouseArea {
//                             id:             lowMouse
//                             anchors.fill:   parent
//                             hoverEnabled:   true
//                             onClicked:      sendServoCommand(servoNumber, parseInt(lowPwm.text))
//                         }
//                     }

//                     // ── Mid button ───────────────────────────────────────────
//                     ServoButton {
//                         btnLabel:   "Mid"
//                         mouseId:    midMouse
//                         btnW:       _btnW
//                         btnH:       _rowH * 0.72
//                         btnRadius:  _radius
//                         accentColor: Qt.rgba(0.0, 0.83, 1.0, 1)   // cyan — neutral

//                         MouseArea {
//                             id:             midMouse
//                             anchors.fill:   parent
//                             hoverEnabled:   true
//                             onClicked:      sendServoCommand(servoNumber, 1500)
//                         }
//                     }

//                     // ── High button ──────────────────────────────────────────
//                     ServoButton {
//                         btnLabel:   "High"
//                         mouseId:    highMouse
//                         btnW:       _btnW
//                         btnH:       _rowH * 0.72
//                         btnRadius:  _radius
//                         accentColor: Qt.rgba(1.0, 0.55, 0.10, 1)  // orange — high = caution

//                         MouseArea {
//                             id:             highMouse
//                             anchors.fill:   parent
//                             hoverEnabled:   true
//                             onClicked:      sendServoCommand(servoNumber, parseInt(highPwm.text))
//                         }
//                     }

//                     // ── Divider ──────────────────────────────────────────────
//                     Rectangle {
//                         width:                  1
//                         height:                 _rowH * 0.55
//                         anchors.verticalCenter: parent.verticalCenter
//                         gradient: Gradient {
//                             GradientStop { position: 0.0; color: "transparent" }
//                             GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.10) }
//                             GradientStop { position: 1.0; color: "transparent" }
//                         }
//                     }

//                     // ── Low PWM input ────────────────────────────────────────
//                     PwmInput {
//                         id:         lowPwm
//                         pwmW:       _pwmW
//                         pwmH:       _rowH * 0.72
//                         pwmRadius:  _radius
//                         initText:   "1000"
//                     }

//                     // ── High PWM input ───────────────────────────────────────
//                     PwmInput {
//                         id:         highPwm
//                         pwmW:       _pwmW
//                         pwmH:       _rowH * 0.72
//                         pwmRadius:  _radius
//                         initText:   "2000"
//                     }
//                 }

//                 // Bottom row separator (skip last row)
//                 Rectangle {
//                     visible:                index < 5
//                     anchors.bottom:         parent.bottom
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     width:                  parent.width * 0.92
//                     height:                 1
//                     gradient: Gradient {
//                         orientation: Gradient.Horizontal
//                         GradientStop { position: 0.0; color: "transparent" }
//                         GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.05) }
//                         GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.05) }
//                         GradientStop { position: 1.0; color: "transparent" }
//                     }
//                 }
//             }
//         }
//     }

//     // ── INTERNAL COMPONENT: ServoButton ──────────────────────────────────────
//     component ServoButton: Item {
//         id:             sBtn
//         property real   btnW:       48
//         property real   btnH:       24
//         property real   btnRadius:  4
//         property string btnLabel:   ""
//         property color  accentColor: Qt.rgba(0.0, 0.83, 1.0, 1)
//         property var    mouseId:    null

//         width:  btnW
//         height: btnH
//         anchors.verticalCenter: parent.verticalCenter

//         // Resolve hover/press from the externally-supplied MouseArea
//         readonly property bool _hov: mouseId ? mouseId.containsMouse : false
//         readonly property bool _prs: mouseId ? mouseId.pressed       : false

//         // Glass button background
//         Rectangle {
//             anchors.fill:   parent
//             radius:         sBtn.btnRadius
//             color: {
//                 if (sBtn._prs) return Qt.rgba(
//                     sBtn.accentColor.r,
//                     sBtn.accentColor.g,
//                     sBtn.accentColor.b, 0.22)
//                 if (sBtn._hov) return Qt.rgba(1, 1, 1, 0.09)
//                 return Qt.rgba(1, 1, 1, 0.04)
//             }
//             border.color: {
//                 if (sBtn._prs || sBtn._hov) return Qt.rgba(
//                     sBtn.accentColor.r,
//                     sBtn.accentColor.g,
//                     sBtn.accentColor.b, sBtn._prs ? 0.60 : 0.30)
//                 return Qt.rgba(1, 1, 1, 0.10)
//             }
//             border.width:   1

//             Behavior on color        { ColorAnimation { duration: 130 } }
//             Behavior on border.color { ColorAnimation { duration: 130 } }

//             // Top micro-shimmer
//             Rectangle {
//                 anchors.top:                parent.top
//                 anchors.topMargin:          1
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 width:                      parent.width * 0.5
//                 height:                     1
//                 gradient: Gradient {
//                     orientation: Gradient.Horizontal
//                     GradientStop { position: 0.0; color: "transparent" }
//                     GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, sBtn._hov ? 0.28 : 0.12) }
//                     GradientStop { position: 1.0; color: "transparent" }
//                 }
//                 Behavior on color { ColorAnimation { duration: 130 } }
//             }
//         }

//         // Label
//         Text {
//             anchors.centerIn:   parent
//             text:               sBtn.btnLabel
//             font.pixelSize:     ScreenTools.defaultFontPixelWidth * 1.35
//             font.letterSpacing: 0.4
//             color: {
//                 if (sBtn._prs || sBtn._hov) return Qt.rgba(
//                     sBtn.accentColor.r,
//                     sBtn.accentColor.g,
//                     sBtn.accentColor.b, 1.0)
//                 return Qt.rgba(1, 1, 1, 0.70)
//             }
//             Behavior on color { ColorAnimation { duration: 130 } }
//         }

//         // Press scale
//         states: [
//             State { name: "pr"; when: sBtn._prs; PropertyChanges { target: sBtn; scale: 0.92 } },
//             State { name: "no"; when: !sBtn._prs; PropertyChanges { target: sBtn; scale: 1.0 } }
//         ]
//         transitions: [
//             Transition { to: "pr"; NumberAnimation { property: "scale"; duration: 70;  easing.type: Easing.OutQuad } },
//             Transition { to: "no"; NumberAnimation { property: "scale"; duration: 160; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
//         ]
//     }

//     // ── INTERNAL COMPONENT: PwmInput ─────────────────────────────────────────
//     component PwmInput: Item {
//         id:             pwmItem
//         property real   pwmW:       48
//         property real   pwmH:       24
//         property real   pwmRadius:  4
//         property string initText:   "1000"

//         width:  pwmW
//         height: pwmH
//         anchors.verticalCenter: parent.verticalCenter

//         // Expose text to outside via alias
//         property alias text: pwmField.text

//         Rectangle {
//             anchors.fill:   parent
//             radius:         pwmItem.pwmRadius
//             color:          pwmField.activeFocus
//                                 ? Qt.rgba(0.0, 0.83, 1.0, 0.08)
//                                 : Qt.rgba(0, 0, 0, 0.30)
//             border.color:   pwmField.activeFocus
//                                 ? Qt.rgba(0.0, 0.83, 1.0, 0.45)
//                                 : Qt.rgba(1, 1, 1, 0.10)
//             border.width:   1

//             Behavior on color        { ColorAnimation { duration: 150 } }
//             Behavior on border.color { ColorAnimation { duration: 150 } }

//             // Focus shimmer
//             Rectangle {
//                 visible:                    pwmField.activeFocus
//                 anchors.top:                parent.top
//                 anchors.topMargin:          1
//                 anchors.horizontalCenter:   parent.horizontalCenter
//                 width:                      parent.width * 0.5
//                 height:                     1
//                 gradient: Gradient {
//                     orientation: Gradient.Horizontal
//                     GradientStop { position: 0.0; color: "transparent" }
//                     GradientStop { position: 0.5; color: Qt.rgba(0.0, 0.83, 1.0, 0.40) }
//                     GradientStop { position: 1.0; color: "transparent" }
//                 }
//             }
//         }

//         TextInput {
//             id:                     pwmField
//             anchors.fill:           parent
//             anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.4
//             anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 0.4
//             text:                   pwmItem.initText
//             color:                  activeFocus
//                                         ? Qt.rgba(0.0, 0.83, 1.0, 1.0)
//                                         : Qt.rgba(1, 1, 1, 0.65)
//             font.pixelSize:         ScreenTools.defaultFontPixelWidth * 1.3
//             horizontalAlignment:    Text.AlignHCenter
//             verticalAlignment:      Text.AlignVCenter
//             validator:              IntValidator { bottom: 800; top: 2200 }
//             selectionColor:         Qt.rgba(0.0, 0.83, 1.0, 0.35)
//             selectedTextColor:      "white"

//             Behavior on color { ColorAnimation { duration: 150 } }
//         }
//     }

//     // ── MAVLink command sender (unchanged logic) ──────────────────────────────
//     function sendServoCommand(servoNum, pwmValue) {
//         if (!_activeVehicle) {
//             console.log("No active vehicle")
//             return
//         }
//         console.log("Servo", servoNum, "→", pwmValue)
//         _activeVehicle.sendMavCommand(
//             _activeVehicle.defaultComponentId,
//             MAV_CMD_DO_SET_SERVO,
//             true,
//             servoNum,
//             pwmValue,
//             0, 0, 0, 0, 0
//         )
//     }
// }

// C:\BV_GCS\qgc\src\FlyView\FlyViewServoPanel.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
// Qt5: import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls

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
                            onClicked:      sendServoCommand(servoNumber, 1500)
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
            MAV_CMD_DO_SET_SERVO,
            true,
            servoNum,
            pwmValue,
            0, 0, 0, 0, 0
        )
    }
}
