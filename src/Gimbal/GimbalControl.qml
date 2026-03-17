//GimbalControl.qml
import QtQuick
import QtQuick.Controls

import QGroundControl
import QGroundControl.Controls
import QGroundControl.Gimbal 1.0

Item {
    id: root
    width:  170
    height: 210  // Increased to accommodate toggle button

    property string cameraIP:   "192.168.144.108"
    property int    cameraPort: 5000
    property bool   gimbalEnabled: false  // Default: OFF

    // ── Sync cameraIP from swarmState whenever selection changes ─────────────
    // If no drone selected, fall back to the hardcoded default IP
    Connections {
        target: mainWindow.swarmState ? mainWindow.swarmState : null
        ignoreUnknownSignals: true
        function onSelectedDroneIPChanged() {
            var ip = mainWindow.swarmState.selectedDroneIP
            if (ip && ip !== "") {
                udpSender.cameraIP = ip
            } else {
                udpSender.cameraIP = "192.168.144.108"  // fallback to default
            }
        }
    }

    //Toggle Button
    Rectangle {
        id:                 toggleContainer
        anchors.right:      parent.right
        anchors.top:        parent.top
        anchors.topMargin:  5
        width:              50
        height:             20
        radius:             10
        color:              Qt.rgba(0, 0, 0, 0.6)
        border.color:       Qt.rgba(1, 1, 1, 0.2)
        border.width:       1

        // Track background
        Rectangle {
            anchors.fill:   parent
            radius:         10
            color:          gimbalEnabled ? Qt.rgba(0.3, 0.7, 0.3, 0.4) : Qt.rgba(0.3, 0.3, 0.3, 0.3)
            
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // Sliding knob
        Rectangle {
            id:             toggleKnob
            width:          16
            height:         16
            radius:         8
            x:              gimbalEnabled ? parent.width - width - 2 : 2
            y:              2
            color:          gimbalEnabled ? "#4CAF50" : Qt.rgba(0.5, 0.5, 0.5, 0.8)
            border.color:   Qt.rgba(1, 1, 1, 0.3)
            border.width:   1

            Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.InOutQuad } }
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        MouseArea {
            anchors.fill:   parent
            cursorShape:    Qt.PointingHandCursor
            onClicked: {
                gimbalEnabled = !gimbalEnabled
                
                if (gimbalEnabled) {
                    console.log("Gimbal enabled - will send UDP commands to camera")
                    // tcpSender.connectToCamera()
                } else {
                    console.log("Gimbal disabled - stopping gimbal movement")
                    udpSender.sendGimbalCommand("CENTER")
                    // tcpSender.disconnectFromCamera()
                }
            }
        }
    }

    // ── Active drone indicator — shows which drone is being controlled ────────
    Rectangle {
        id:                     droneIndicator
        anchors.left:           parent.left
        anchors.top:            parent.top
        anchors.topMargin:      5
        height:                 20
        width:                  labelText.implicitWidth + 12
        radius:                 4
        visible:                mainWindow.swarmState && mainWindow.swarmState.selectedDroneIndex >= 0
        color:                  Qt.rgba(1.0, 0.55, 0.10, 0.25)
        border.color:           Qt.rgba(1.0, 0.65, 0.10, 0.70)
        border.width:           1

        Text {
            id:               labelText
            anchors.centerIn: parent
            text:             mainWindow.swarmState ? mainWindow.swarmState.selectedDroneLabel : ""
            font.pixelSize:   9
            font.weight:      Font.Medium
            color:            Qt.rgba(1.0, 0.80, 0.30, 1.0)
        }
    }

    // No drone selected warning
    Text {
        anchors.left:           parent.left
        anchors.top:            parent.top
        anchors.topMargin:      5
        visible:                mainWindow.swarmState && mainWindow.swarmState.selectedDroneIndex < 0
        text:                   "No drone\nselected"
        font.pixelSize:         8
        color:                  Qt.rgba(1,1,1,0.35)
        lineHeight:             1.2
    }

    //Direct Pitch UP - Above Gimbal Circle
    Item {
        id:                         pitchUpBtn
        anchors.top:                toggleContainer.bottom
        anchors.topMargin:          4
        anchors.horizontalCenter:   gimbalControl.horizontalCenter
        width:                      60
        height:                     24

        Rectangle {
            anchors.fill:   parent
            radius:         6
            color:          pitchUpMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0, 0, 0, 0.4)
            border.color:   Qt.rgba(1, 1, 1, 0.25)
            border.width:   1
        }

        Text {
            anchors.centerIn:   parent
            text:               "▲▲"
            font.pixelSize:     11
            color:              pitchUpMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.8)
        }

        MouseArea {
            id:             pitchUpMouse
            anchors.fill:   parent
            cursorShape:    Qt.PointingHandCursor
            onClicked:      gimbalControl.sendGimbalCommand("PITCH_UP")
        }
    }

    //Gimbal Circle
    Rectangle {
        id:             gimbalControl
        width:          180
        height:         180
        radius:         90
        anchors.top:    pitchUpBtn.bottom
        anchors.topMargin: 6
        anchors.right: parent.right
        anchors.rightMargin: 20
        color:          Qt.rgba(0, 0, 0, 0.4)
        border.color:   "white"
        border.width:   1

        // property string tcpHost: "192.168.144.108"
        // property int    tcpPort: 5000

        // TCP Sender instance
        // GimbalTCPSender {
        //     id: tcpSender
        //     cameraIP: root.cameraIP
        //     cameraPort: root.cameraPort
            
        //     Component.onCompleted: {
        //         console.log("GimbalTCPSender created, connecting...")
        //         // connectToHost()
        //     }
            
        //     onConnectedChanged: {
        //         console.log("TCP Connection status:", connected)
        //         // statusIndicator.color = connected ? "green" : "red"
        //     }
            
        //     onCommandSent: function(cmd) {
        //         console.log("✓ Command sent via TCP:", cmd)
        //     }
            
        //     onErrorOccurred: function(error) {
        //         console.log("TCP Error:", error)
        //     }

        //     onResponseReceived: function(r) { 
        //         console.log("C20 response:", r) 
        //     }
        // }

        GimbalUDPSender {
            id: udpSender
            cameraIP:   mainWindow.swarmState && mainWindow.swarmState.selectedDroneIP !== ""
                            ? mainWindow.swarmState.selectedDroneIP
                            : "192.168.144.108"
            cameraPort: 5000
        }

        // Component.onCompleted: {
        //     console.log("✓✓✓ Gimbal Control initialized ✓✓✓")
        //     console.log("  Camera IP:", tcpSender.cameraIP)
        //     console.log("  Camera Port:", tcpSender.cameraPort)
        // }

        Component.onCompleted: {
            console.log("✓✓✓ Gimbal Control initialized ✓✓✓")
            console.log("  Camera IP:", udpSender.cameraIP)
            console.log("  Camera Port:", udpSender.cameraPort)
        }

        function sendGimbalCommand(command) {
            console.log("========================================")
            console.log("GIMBAL COMMAND:", command, "→", udpSender.cameraIP)
            console.log("========================================")
            // tcpSender.sendCommand(command)
            if (gimbalEnabled) {
                udpSender.sendGimbalCommand(command)
            }

            // if (gimbalEnabled && tcpSender.connected) {
            //     tcpSender.sendCommand(command)
            //     console.log("CMD:", command)
            // } else {
            //     console.log("⚠ Disabled or not connected")
            // }
        }

        // Center circle
        Rectangle {
            id:                 centerCircle
            anchors.centerIn:   parent
            width:              50
            height:             50
            radius:             25
            color:              centerMouseArea.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.3)
            // color:              centerMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.6) : Qt.rgba(1, 1, 1, 0.15)
            border.color:       "white"
            border.width:       1

            Text {
                anchors.centerIn:   parent
                // text:               "●"
                font.pointSize:     24
                color:              "white"
            }

            MouseArea {
                id:             centerMouseArea
                anchors.fill:   parent
                onClicked:      gimbalControl.sendGimbalCommand("CENTER")
            }
        }

        // UP Button
        Rectangle {
            id:             upButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top:    parent.top
            anchors.topMargin: 12
            width:          45
            height:         30
            radius:         6
            color:          "transparent"   //upMouseArea.pressed ? "#6495ED" : Qt.rgba(0.2, 0.2, 0.2, 0.8)
            // color:          upMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.6) : Qt.rgba(1, 1, 1, 0.12)
            border.color:   "transparent"
            border.width:   1

            Text {
                anchors.centerIn:   parent
                text:               "▲"
                font.pointSize:     16
                color:              upMouseArea.pressed ? "#6495ED" : "white"
            }

            MouseArea {
                id:             upMouseArea
                anchors.fill:   parent
                onClicked:      gimbalControl.sendGimbalCommand("UP")
            }
        }

        // DOWN Button
        Rectangle {
            id:             downButton
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            width:          45
            height:         30
            radius:         6
            color:          "transparent" //downMouseArea.pressed ? "#6495ED" : Qt.rgba(0.2, 0.2, 0.2, 0.8)
            // color:          downMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.6) : Qt.rgba(1, 1, 1, 0.12)
            border.color:   "transparent" //"white"
            border.width:   1

            Text {
                anchors.centerIn:   parent
                text:               "▼"
                font.pointSize:     16
                color:              downMouseArea.pressed ? "#6495ED" : "white"
            }

            MouseArea {
                id:             downMouseArea
                anchors.fill:   parent
                onClicked:      gimbalControl.sendGimbalCommand("DOWN")
            }
        }

        // LEFT Button
        Rectangle {
            id:             leftButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.left:   parent.left
            anchors.leftMargin: 12
            width:          30
            height:         45
            radius:         6
            color:          "transparent" //leftMouseArea.pressed ? "#6495ED" : Qt.rgba(0.2, 0.2, 0.2, 0.8)
            // color:          leftMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.6) : Qt.rgba(1, 1, 1, 0.12)
            border.color:   "transparent" //"white"
            border.width:   1

            Text {
                anchors.centerIn:   parent
                text:               "◀"
                font.pointSize:     16
                color:              leftMouseArea.pressed ? "#6495ED" : "white"
            }

            MouseArea {
                id:             leftMouseArea
                anchors.fill:   parent
                onClicked:      gimbalControl.sendGimbalCommand("LEFT")
            }
        }

        // RIGHT Button
        Rectangle {
            id:             rightButton
            anchors.verticalCenter: parent.verticalCenter
            anchors.right:  parent.right
            anchors.rightMargin: 12
            width:          30
            height:         45
            radius:         6
            color:          "transparent" //rightMouseArea.pressed ? "#6495ED" : Qt.rgba(0.2, 0.2, 0.2, 0.8)
            border.color:   "transparent" //"white"
            border.width:   1

            Text {
                anchors.centerIn:   parent
                text:               "▶"
                font.pointSize:     16
                color:              rightMouseArea.pressed ? "#6495ED" : "white"
            }

            MouseArea {
                id:             rightMouseArea
                anchors.fill:   parent
                onClicked:      gimbalControl.sendGimbalCommand("RIGHT")
            }
        }

        // // Connection status indicator (top-right corner)
        // Rectangle {
        //     anchors.top:        parent.top
        //     anchors.right:      parent.right
        //     anchors.margins:    8
        //     width:              12
        //     height:             12
        //     radius:             6
        //     color:              "gray"
        //     border.color:       "white"
        //     border.width:       1
        // }

        // Rectangle {
        //     id:                 statusIndicator
        //     anchors.top:        parent.top
        //     anchors.right:      parent.right
        //     anchors.margins:    8
        //     width:              12
        //     height:             12
        //     radius:             6
        //     color:              "red"  // Will turn green when connected
        //     border.color:       "white"
        //     border.width:       1
            
        //     SequentialAnimation on opacity {
        //         running: tcpSender.connected
        //         loops: Animation.Infinite
        //         NumberAnimation { to: 0.3; duration: 1000 }
        //         NumberAnimation { to: 1.0; duration: 1000 }
        //     }
        // }
    }

    //Direct Pitch DOWN - Below Gimbal Circle
    Item {
        id:                         pitchDownBtn
        anchors.top:                gimbalControl.bottom
        anchors.topMargin:          6
        anchors.horizontalCenter:   gimbalControl.horizontalCenter
        width:                      60
        height:                     24

        Rectangle {
            anchors.fill:   parent
            radius:         6
            color:          pitchDownMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0, 0, 0, 0.4)
            border.color:   Qt.rgba(1, 1, 1, 0.25)
            border.width:   1
        }

        Text {
            anchors.centerIn:   parent
            text:               "▼▼"
            font.pixelSize:     11
            color:              pitchDownMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.8)
        }

        MouseArea {
            id:             pitchDownMouse
            anchors.fill:   parent
            cursorShape:    Qt.PointingHandCursor
            onClicked:      gimbalControl.sendGimbalCommand("PITCH_DOWN")
        }
    }

    // Direct Pitch LEFT - Left of gimbal circle
    Item {
        id:                         pitchLeftBtn
        anchors.verticalCenter:     gimbalControl.verticalCenter
        anchors.right:              gimbalControl.left
        anchors.rightMargin:        6
        width:                      24
        height:                     60

        Rectangle {
            anchors.fill:   parent
            radius:         6
            color:          pitchLeftMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0, 0, 0, 0.4)
            border.color:   Qt.rgba(1, 1, 1, 0.25)
            border.width:   1
        }

        Text {
            anchors.centerIn:   parent
            text:               "◀◀"
            font.pixelSize:     9
            color:              pitchLeftMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.8)
        }

        MouseArea {
            id:             pitchLeftMouse
            anchors.fill:   parent
            cursorShape:    Qt.PointingHandCursor
            onClicked:      gimbalControl.sendGimbalCommand("PITCH_LEFT")
        }
    }

    // Direct Pitch RIGHT - Right of gimbal circle
    Item {
        id:                         pitchRightBtn
        anchors.verticalCenter:     gimbalControl.verticalCenter
        anchors.left:               gimbalControl.right
        anchors.leftMargin:         6
        width:                      24
        height:                     60

        Rectangle {
            anchors.fill:   parent
            radius:         6
            color:          pitchRightMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0, 0, 0, 0.4)
            border.color:   Qt.rgba(1, 1, 1, 0.25)
            border.width:   1
        }

        Text {
            anchors.centerIn:   parent
            text:               "▶▶"
            font.pixelSize:     9
            color:              pitchRightMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.8)
        }

        MouseArea {
            id:             pitchRightMouse
            anchors.fill:   parent
            cursorShape:    Qt.PointingHandCursor
            onClicked:      gimbalControl.sendGimbalCommand("PITCH_RIGHT")
        }
    }

    // ================================================================
    // BOTTOM CONTROLS - Zoom + Day/IR
    // ================================================================
    Rectangle {
        id:                         bottomControls
        anchors.top:                pitchDownBtn.bottom
        anchors.topMargin:          8
        anchors.horizontalCenter:   parent.horizontalCenter
        width:                      240
        height:                     70
        radius:                     10
        color:                      Qt.rgba(0, 0, 0, 0.4)
        border.color:               Qt.rgba(1, 1, 1, 0.15)
        border.width:               1

        Column {
            anchors.centerIn:   parent
            spacing:            6

            // Zoom row
            Row {
                spacing:            6
                anchors.horizontalCenter: parent.horizontalCenter

                // Optical Zoom Out
                Rectangle {
                    width: 48; height: 24; radius: 6
                    color: ozOutMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0.15, 0.15, 0.15, 0.8)
                    border.color: Qt.rgba(1, 1, 1, 0.2); border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "O−"
                        font.pixelSize: 12
                        color: ozOutMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.85)
                    }
                    MouseArea {
                        id: ozOutMouse; anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gimbalControl.sendGimbalCommand("OPT_ZOOM_OUT")
                    }
                }

                // Optical Zoom In
                Rectangle {
                    width: 48; height: 24; radius: 6
                    color: ozInMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0.15, 0.15, 0.15, 0.8)
                    border.color: Qt.rgba(1, 1, 1, 0.2); border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "O+"
                        font.pixelSize: 12
                        color: ozInMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.85)
                    }
                    MouseArea {
                        id: ozInMouse; anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gimbalControl.sendGimbalCommand("OPT_ZOOM_IN")
                    }
                }

                // Digital Zoom Out
                Rectangle {
                    width: 48; height: 24; radius: 6
                    color: dzOutMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0.15, 0.15, 0.15, 0.8)
                    border.color: Qt.rgba(1, 1, 1, 0.2); border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "D−"
                        font.pixelSize: 12
                        color: dzOutMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.85)
                    }
                    MouseArea {
                        id: dzOutMouse; anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gimbalControl.sendGimbalCommand("DIG_ZOOM_OUT")
                    }
                }

                // Digital Zoom In
                Rectangle {
                    width: 48; height: 24; radius: 6
                    color: dzInMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) : Qt.rgba(0.15, 0.15, 0.15, 0.8)
                    border.color: Qt.rgba(1, 1, 1, 0.2); border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "D+"
                        font.pixelSize: 12
                        color: dzInMouse.pressed ? "#6495ED" : Qt.rgba(1, 1, 1, 0.85)
                    }
                    MouseArea {
                        id: dzInMouse; anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: gimbalControl.sendGimbalCommand("DIG_ZOOM_IN")
                    }
                }
            }

            // Day / IR Row
            Row {
                spacing:            6
                anchors.horizontalCenter: parent.horizontalCenter

                // DAY button
                Rectangle {
                    width: 102; height: 24; radius: 6
                    color: dayMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) :
                           !irMode ? Qt.rgba(0.2, 0.5, 0.8, 0.5) : Qt.rgba(0.15, 0.15, 0.15, 0.8)
                    border.color: !irMode ? "#6495ED" : Qt.rgba(1, 1, 1, 0.2)
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "☀ DAY"
                        font.pixelSize: 12
                        color: !irMode ? "white" : Qt.rgba(1, 1, 1, 0.6)
                    }
                    MouseArea {
                        id: dayMouse; anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            irMode = false
                            gimbalControl.sendGimbalCommand("MODE_DAY")
                        }
                    }
                }

                // IR button
                Rectangle {
                    width: 102; height: 24; radius: 6
                    color: irMouse.pressed ? Qt.rgba(0.4, 0.6, 1, 0.3) :
                           irMode ? Qt.rgba(0.8, 0.4, 0.1, 0.5) : Qt.rgba(0.15, 0.15, 0.15, 0.8)
                    border.color: irMode ? "#E07020" : Qt.rgba(1, 1, 1, 0.2)
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 150 } }

                    Text {
                        anchors.centerIn: parent
                        text: "⬡ IR"
                        font.pixelSize: 12
                        color: irMode ? "white" : Qt.rgba(1, 1, 1, 0.6)
                    }
                    MouseArea {
                        id: irMouse; anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            irMode = true
                            gimbalControl.sendGimbalCommand("MODE_IR")
                        }
                    }
                }
            }
        }
    }

    // irMode state
    property bool irMode: false
}
