// AdminControlPage.qml — BonVGroundStation
// Standalone full-screen admin control page.
// Opens on top of everything as a Window sibling to mainWindow.
//
// Usage in SelectViewDropdown.qml:
//
//   AdminControlPage {
//       id: _adminControlPage
//   }
//
//   // Then to open:
//   _adminControlPage.openPage()

import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.settings 1.0

import QGroundControl
import QGroundControl.Controls
import QGroundControl.ScreenTools

Item {
    id: root

    // ── Public API ────────────────────────────────────────────────────────────
    function openPage() {
        _overlay.visible = true
        _sidebarIndex    = 0        // always start on first section
    }

    function closePage() {
        _overlay.visible = false
    }

    // ── Internal nav state ────────────────────────────────────────────────────
    property int _sidebarIndex: 0

    readonly property var _sections: [
        { icon: "📡", title: qsTr("Network")       },
        { icon: "📷", title: qsTr("Camera & Gimbal") },
        { icon: "✈",  title: qsTr("Flight Limits")  },
        { icon: "⚙",  title: qsTr("Developer")      },
    ]

    // ── Persistent settings ───────────────────────────────────────────────────
    Settings {
        id:       adminSettings
        category: "AdminSettings"

        property string groundStationIP:   "192.168.1.100"
        property int    telemetryPort:     14550
        property int    videoPort:         5600
        property bool   enableRTSP:        false

        property string cameraIP:          "192.168.144.108"
        property int    cameraPort:        5000
        property bool   enableGimbalDebug: false

        property int    maxAltitudeM:      120
        property int    maxDistanceM:      500
        property int    maxSpeedMS:        15
        property bool   enforceLimits:     false

        property bool   enableDevMode:     false
        property bool   enableVerboseLog:  false
        property string vehicleIdOverride: ""
    }

    // ── Full-screen overlay ───────────────────────────────────────────────────
    // Reparent to mainWindow so it covers the entire app including toolbar
    parent:       mainWindow
    anchors.fill: parent
    z:            9999
    visible:      false

    // Alias for open/close
    property alias _overlay: root

    // ── Backdrop ──────────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color:        Qt.rgba(0.02, 0.03, 0.06, 0.97)
    }

    // ── TOP TOOLBAR — reuses FlyViewToolBar directly ─────────────────────────
    // guidedValueSlider is now optional (null by default) so no stub needed.
    // The logo button inside FlyViewToolBar calls mainWindow.showToolSelectDialog()
    // which opens SelectViewDropdown — navigation works identically to FlyView.
    FlyViewToolBar {
        id:     toolbar
        width:  parent.width
        // guidedValueSlider intentionally omitted — defaults to null
    }

    // Back + Lock buttons — overlay on toolbar right side, z above toolbar content
    Row {
        anchors.right:          toolbar.right
        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 1.5
        anchors.verticalCenter: toolbar.verticalCenter
        spacing:                ScreenTools.defaultFontPixelWidth * 1.0
        z:                      20

        // Back
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width:        ScreenTools.defaultFontPixelWidth * 7
            height:       ScreenTools.defaultFontPixelHeight * 2.0
            radius:       6
            color:        _backMa.containsMouse ? Qt.rgba(1,1,1,0.14) : Qt.rgba(1,1,1,0.07)
            border.color: Qt.rgba(1,1,1,0.22)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 80 } }
            Row {
                anchors.centerIn: parent; spacing: 4
                Text { anchors.verticalCenter: parent.verticalCenter; text: "‹"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; color: Qt.rgba(1,1,1,0.85) }
                Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Back"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78; color: Qt.rgba(1,1,1,0.85) }
            }
            MouseArea { id: _backMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.closePage() }
        }

        // Lock
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width:        ScreenTools.defaultFontPixelWidth * 7
            height:       ScreenTools.defaultFontPixelHeight * 2.0
            radius:       6
            color:        _lockMa.containsMouse ? Qt.rgba(1,0.22,0.35,0.30) : Qt.rgba(1,0.22,0.35,0.14)
            border.color: Qt.rgba(1,0.22,0.35,0.55)
            border.width: 1
            Behavior on color { ColorAnimation { duration: 80 } }
            Row {
                anchors.centerIn: parent; spacing: 4
                Text { anchors.verticalCenter: parent.verticalCenter; text: "🔒"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72 }
                Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Lock"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78; color: Qt.rgba(1,0.40,0.50,1) }
            }
            MouseArea { id: _lockMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: { root.closePage(); root.adminLocked() } }
        }
    }

    signal adminLocked()

    // ── BODY: sidebar + content ───────────────────────────────────────────────
    Row {
        anchors.top:    toolbar.bottom
        anchors.bottom: parent.bottom
        anchors.left:   parent.left
        anchors.right:  parent.right

        // ── LEFT SIDEBAR ──────────────────────────────────────────────────────
        Rectangle {
            id:     sidebar
            width:  ScreenTools.defaultFontPixelWidth * 22
            height: parent.height
            color:  Qt.rgba(0.03, 0.04, 0.08, 0.80)

            // Right border
            Rectangle {
                anchors.right:  parent.right
                anchors.top:    parent.top
                anchors.bottom: parent.bottom
                width:          1
                color:          Qt.rgba(1,1,1,0.07)
            }

            Column {
                anchors.top:        parent.top
                anchors.topMargin:  ScreenTools.defaultFontPixelHeight * 1.2
                anchors.left:       parent.left
                anchors.right:      parent.right
                spacing:            4

                // Section header
                Text {
                    anchors.left:        parent.left
                    anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 1.5
                    text:           qsTr("SETTINGS")
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.62
                    font.weight:    Font.Bold
                    font.letterSpacing: 1.5
                    color:          Qt.rgba(1,1,1,0.25)
                    bottomPadding:  4
                }

                Repeater {
                    model: root._sections

                    delegate: Item {
                        width:  sidebar.width
                        height: ScreenTools.defaultFontPixelHeight * 2.8

                        readonly property bool _active: root._sidebarIndex === index
                        readonly property bool _hov:    _sidebarMa.containsMouse

                        // Active indicator bar
                        Rectangle {
                            anchors.left:           parent.left
                            anchors.leftMargin:     0
                            anchors.top:            parent.top
                            anchors.topMargin:      6
                            anchors.bottom:         parent.bottom
                            anchors.bottomMargin:   6
                            width:                  3
                            radius:                 2
                            color:                  Qt.rgba(1.0,0.55,0.10,1.0)
                            opacity:                _active ? 1.0 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        // Row background
                        Rectangle {
                            anchors.fill:        parent
                            anchors.leftMargin:  6
                            anchors.rightMargin: 6
                            radius:              7
                            color:               _active
                                                     ? Qt.rgba(1.0,0.55,0.10,0.15)
                                                     : _hov
                                                           ? Qt.rgba(1,1,1,0.07)
                                                           : "transparent"
                            Behavior on color { ColorAnimation { duration: 120 } }
                        }

                        Row {
                            anchors.left:           parent.left
                            anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 1.8
                            anchors.verticalCenter: parent.verticalCenter
                            spacing:                ScreenTools.defaultFontPixelWidth * 1.0

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text:           modelData.icon
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                            }
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text:           modelData.title
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.80
                                font.weight:    _active ? Font.SemiBold : Font.Normal
                                color:          _active
                                                    ? Qt.rgba(1.0,0.70,0.20,1.0)
                                                    : _hov
                                                          ? Qt.rgba(1,1,1,0.90)
                                                          : Qt.rgba(1,1,1,0.60)
                                Behavior on color { ColorAnimation { duration: 120 } }
                            }
                        }

                        MouseArea {
                            id:           _sidebarMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape:  Qt.PointingHandCursor
                            onClicked:    root._sidebarIndex = index
                        }
                    }
                }
            }
        }

        // ── RIGHT CONTENT AREA ────────────────────────────────────────────────
        Item {
            width:  parent.width - sidebar.width
            height: parent.height

            // Section 0: Network
            AdminContentArea {
                visible: root._sidebarIndex === 0
                title:   qsTr("Network Configuration")

                Column {
                    width:   parent.width
                    spacing: ScreenTools.defaultFontPixelHeight * 0.5

                    AdminField { label: qsTr("Ground Station IP");  value: adminSettings.groundStationIP;  placeholder: "192.168.1.100"
                        onCommit: function(v) { adminSettings.groundStationIP = v } }
                    AdminIntField { label: qsTr("Telemetry Port");  value: adminSettings.telemetryPort;  min: 1024; max: 65535
                        onCommit: function(v) { adminSettings.telemetryPort = v } }
                    AdminIntField { label: qsTr("Video Port");      value: adminSettings.videoPort;      min: 1024; max: 65535
                        onCommit: function(v) { adminSettings.videoPort = v } }
                    AdminToggleRow { label: qsTr("Enable RTSP Stream"); value: adminSettings.enableRTSP
                        onToggle: function(v) { adminSettings.enableRTSP = v } }
                }
            }

            // Section 1: Camera & Gimbal
            AdminContentArea {
                visible: root._sidebarIndex === 1
                title:   qsTr("Camera & Gimbal")

                Column {
                    width:   parent.width
                    spacing: ScreenTools.defaultFontPixelHeight * 0.5

                    AdminField   { label: qsTr("Camera IP");       value: adminSettings.cameraIP;   placeholder: "192.168.144.108"
                        onCommit: function(v) { adminSettings.cameraIP = v } }
                    AdminIntField { label: qsTr("Camera UDP Port"); value: adminSettings.cameraPort; min: 1024; max: 65535
                        onCommit: function(v) { adminSettings.cameraPort = v } }
                    AdminToggleRow { label: qsTr("Verbose Gimbal Debug Logging"); value: adminSettings.enableGimbalDebug
                        warning: qsTr("Generates large log files")
                        onToggle: function(v) { adminSettings.enableGimbalDebug = v } }
                }
            }

            // Section 2: Flight Limits
            AdminContentArea {
                visible: root._sidebarIndex === 2
                title:   qsTr("Flight Limits")

                Column {
                    width:   parent.width
                    spacing: ScreenTools.defaultFontPixelHeight * 0.5

                    AdminIntField { label: qsTr("Max Altitude (m)");            value: adminSettings.maxAltitudeM; min: 10;  max: 500
                        onCommit: function(v) { adminSettings.maxAltitudeM = v } }
                    AdminIntField { label: qsTr("Max Distance from Home (m)");  value: adminSettings.maxDistanceM; min: 50;  max: 5000
                        onCommit: function(v) { adminSettings.maxDistanceM = v } }
                    AdminIntField { label: qsTr("Max Speed (m/s)");             value: adminSettings.maxSpeedMS;   min: 1;   max: 30
                        onCommit: function(v) { adminSettings.maxSpeedMS = v } }
                    AdminToggleRow {
                        label:   qsTr("Enforce Limits via GCS")
                        value:   adminSettings.enforceLimits
                        warning: qsTr("Overrides vehicle parameters — use with caution")
                        onToggle: function(v) { adminSettings.enforceLimits = v }
                    }
                }
            }

            // Section 3: Developer
            AdminContentArea {
                visible: root._sidebarIndex === 3
                title:   qsTr("Developer")
                danger:  true

                Column {
                    width:   parent.width
                    spacing: ScreenTools.defaultFontPixelHeight * 0.5

                    AdminToggleRow {
                        label:   qsTr("Enable Developer Mode")
                        value:   adminSettings.enableDevMode
                        warning: qsTr("Disables safety checks and exposes raw MAVLink inspector")
                        onToggle: function(v) { adminSettings.enableDevMode = v }
                    }
                    AdminToggleRow {
                        label:   qsTr("Verbose Console Logging")
                        value:   adminSettings.enableVerboseLog
                        onToggle: function(v) { adminSettings.enableVerboseLog = v }
                    }
                    AdminField {
                        label:       qsTr("Vehicle ID Override")
                        value:       adminSettings.vehicleIdOverride
                        placeholder: qsTr("Leave blank for auto-detect")
                        onCommit: function(v) { adminSettings.vehicleIdOverride = v }
                    }

                    // Spacer
                    Item { width: 1; height: ScreenTools.defaultFontPixelHeight * 0.8 }

                    // Reset to defaults
                    Rectangle {
                        width:        parent.width * 0.55
                        height:       ScreenTools.defaultFontPixelHeight * 2.2
                        radius:       7
                        color:        _resetMa.containsMouse ? Qt.rgba(1,0.22,0.35,0.25) : Qt.rgba(1,0.22,0.35,0.10)
                        border.color: Qt.rgba(1,0.22,0.35,0.50)
                        border.width: 1
                        Behavior on color { ColorAnimation { duration: 80 } }
                        Text {
                            anchors.centerIn: parent
                            text:           qsTr("Reset All to Defaults")
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78
                            font.weight:    Font.SemiBold
                            color:          Qt.rgba(1,0.35,0.45,1)
                        }
                        MouseArea {
                            id: _resetMa; anchors.fill: parent; hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked:   _resetConfirmOverlay.visible = true
                        }
                    }
                }
            }
        }
    }

    // ── RESET CONFIRM OVERLAY ─────────────────────────────────────────────────
    Rectangle {
        id:           _resetConfirmOverlay
        anchors.fill: parent
        visible:      false
        color:        Qt.rgba(0,0,0,0.75)
        z:            200

        Rectangle {
            width:            ScreenTools.defaultFontPixelWidth * 36
            height:           _rcCol.implicitHeight + ScreenTools.defaultFontPixelHeight * 3
            anchors.centerIn: parent
            radius:           12
            color:            Qt.rgba(0.06,0.07,0.12,0.98)
            border.color:     Qt.rgba(1,0.22,0.35,0.45)
            border.width:     1

            Column {
                id:               _rcCol
                anchors.centerIn: parent
                width:            parent.width - ScreenTools.defaultFontPixelWidth * 4
                spacing:          ScreenTools.defaultFontPixelHeight * 0.8

                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "⚠"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.8 }
                Text { anchors.horizontalCenter: parent.horizontalCenter; text: qsTr("Reset Admin Settings?"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.92; font.weight: Font.SemiBold; color: Qt.rgba(1,1,1,0.92) }
                Text { width: parent.width; text: qsTr("All admin settings will be reset to factory defaults. This cannot be undone."); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72; color: Qt.rgba(1,1,1,0.50); wrapMode: Text.WordWrap; horizontalAlignment: Text.AlignHCenter }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: ScreenTools.defaultFontPixelWidth * 1.5

                    Rectangle {
                        width: ScreenTools.defaultFontPixelWidth * 11; height: ScreenTools.defaultFontPixelHeight * 2.2
                        radius: 7; color: _rcCanMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.05)
                        border.color: Qt.rgba(1,1,1,0.20); border.width: 1
                        Behavior on color { ColorAnimation { duration: 80 } }
                        Text { anchors.centerIn: parent; text: qsTr("Cancel"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.80; color: Qt.rgba(1,1,1,0.60) }
                        MouseArea { id: _rcCanMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: _resetConfirmOverlay.visible = false }
                    }
                    Rectangle {
                        width: ScreenTools.defaultFontPixelWidth * 11; height: ScreenTools.defaultFontPixelHeight * 2.2
                        radius: 7; color: _rcOkMa.containsMouse ? Qt.rgba(1,0.22,0.35,0.35) : Qt.rgba(1,0.22,0.35,0.18)
                        border.color: Qt.rgba(1,0.22,0.35,0.60); border.width: 1
                        Behavior on color { ColorAnimation { duration: 80 } }
                        Text { anchors.centerIn: parent; text: qsTr("Reset"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.80; font.weight: Font.SemiBold; color: Qt.rgba(1,0.35,0.45,1) }
                        MouseArea {
                            id: _rcOkMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                adminSettings.groundStationIP   = "192.168.1.100"
                                adminSettings.telemetryPort     = 14550
                                adminSettings.videoPort         = 5600
                                adminSettings.enableRTSP        = false
                                adminSettings.cameraIP          = "192.168.144.108"
                                adminSettings.cameraPort        = 5000
                                adminSettings.enableGimbalDebug = false
                                adminSettings.maxAltitudeM      = 120
                                adminSettings.maxDistanceM      = 500
                                adminSettings.maxSpeedMS        = 15
                                adminSettings.enforceLimits     = false
                                adminSettings.enableDevMode     = false
                                adminSettings.enableVerboseLog  = false
                                adminSettings.vehicleIdOverride = ""
                                _resetConfirmOverlay.visible    = false
                            }
                        }
                    }
                }
            }
        }
    }

    // ── REUSABLE INNER COMPONENTS ─────────────────────────────────────────────

    component AdminContentArea: Item {
        id:              _aca
        property string  title:  ""
        property bool    danger: false
        default property alias contentChildren: _acaInner.data

        anchors.fill:        parent
        anchors.margins:     ScreenTools.defaultFontPixelWidth * 2.5
        anchors.topMargin:   ScreenTools.defaultFontPixelHeight * 1.5

        Column {
            anchors.fill: parent
            spacing:      ScreenTools.defaultFontPixelHeight * 1.0

            // Section title
            Column {
                width:   parent.width
                spacing: ScreenTools.defaultFontPixelHeight * 0.4

                Text {
                    text:           _aca.title
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.05
                    font.weight:    Font.SemiBold
                    color:          _aca.danger
                                        ? Qt.rgba(1.0,0.55,0.10,0.90)
                                        : Qt.rgba(1.0,0.70,0.20,0.90)
                }
                Rectangle {
                    width:  parent.width
                    height: 1
                    color:  Qt.rgba(1,1,1,0.08)
                }
            }

            // Scrollable content
            Flickable {
                width:              parent.width
                height:             parent.height - ScreenTools.defaultFontPixelHeight * 2.5
                contentHeight:      _acaInner.implicitHeight
                flickableDirection: Flickable.VerticalFlick
                clip:               true

                Item {
                    id:     _acaInner
                    width:  parent.width
                    height: childrenRect.height
                }
            }
        }
    }

    component AdminField: Item {
        property string label:       ""
        property string value:       ""
        property string placeholder: ""
        signal commit(string v)

        width:  parent ? parent.width : 0
        height: ScreenTools.defaultFontPixelHeight * 2.8

        Row {
            anchors.fill:           parent
            anchors.leftMargin:     2
            spacing:                ScreenTools.defaultFontPixelWidth

            Text {
                width:                  parent.width * 0.45
                anchors.verticalCenter: parent.verticalCenter
                text:                   label
                font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.78
                color:                  Qt.rgba(1,1,1,0.65)
                elide:                  Text.ElideRight
            }
            Rectangle {
                width:                  parent.width * 0.55 - parent.spacing
                height:                 ScreenTools.defaultFontPixelHeight * 2.1
                anchors.verticalCenter: parent.verticalCenter
                radius:                 6
                color:                  Qt.rgba(1,1,1,0.06)
                border.color:           _aField.activeFocus ? Qt.rgba(0,0.83,1,0.65) : Qt.rgba(1,1,1,0.18)
                border.width:           1
                Behavior on border.color { ColorAnimation { duration: 100 } }
                TextInput {
                    id:                  _aField
                    anchors.fill:        parent
                    anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 0.8
                    anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 0.8
                    text:                value
                    font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
                    color:               Qt.rgba(1,1,1,0.90)
                    verticalAlignment:   TextInput.AlignVCenter
                    selectByMouse:       true
                    onEditingFinished:   commit(text)
                }
            }
        }
    }

    component AdminIntField: Item {
        property string label: ""
        property int    value: 0
        property int    min:   0
        property int    max:   9999
        signal commit(int v)

        width:  parent ? parent.width : 0
        height: ScreenTools.defaultFontPixelHeight * 2.8

        Row {
            anchors.fill:       parent
            anchors.leftMargin: 2
            spacing:            ScreenTools.defaultFontPixelWidth

            Text {
                width:                  parent.width * 0.65
                anchors.verticalCenter: parent.verticalCenter
                text:                   label
                font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.78
                color:                  Qt.rgba(1,1,1,0.65)
                elide:                  Text.ElideRight
            }
            Rectangle {
                width:                  parent.width * 0.35 - parent.spacing
                height:                 ScreenTools.defaultFontPixelHeight * 2.1
                anchors.verticalCenter: parent.verticalCenter
                radius:                 6
                color:                  Qt.rgba(1,1,1,0.06)
                border.color:           _aiField.activeFocus ? Qt.rgba(0,0.83,1,0.65) : Qt.rgba(1,1,1,0.18)
                border.width:           1
                Behavior on border.color { ColorAnimation { duration: 100 } }
                TextInput {
                    id:                  _aiField
                    anchors.fill:        parent
                    anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 0.8
                    text:                value.toString()
                    font.pixelSize:      ScreenTools.defaultFontPixelHeight * 0.80
                    color:               Qt.rgba(1,1,1,0.90)
                    verticalAlignment:   TextInput.AlignVCenter
                    inputMethodHints:    Qt.ImhDigitsOnly
                    validator:           IntValidator { bottom: min; top: max }
                    selectByMouse:       true
                    onEditingFinished: {
                        var n = parseInt(text)
                        if (!isNaN(n)) commit(n)
                        else text = value.toString()
                    }
                }
            }
        }
    }

    component AdminToggleRow: Item {
        property string label:   ""
        property bool   value:   false
        property string warning: ""
        signal toggle(bool v)

        width:  parent ? parent.width : 0
        height: warning !== ""
                    ? ScreenTools.defaultFontPixelHeight * 3.4
                    : ScreenTools.defaultFontPixelHeight * 2.8

        Row {
            anchors.fill:       parent
            anchors.leftMargin: 2
            spacing:            ScreenTools.defaultFontPixelWidth

            Column {
                width:                  parent.width - _aTrack.width - parent.spacing
                anchors.verticalCenter: parent.verticalCenter
                spacing:                2

                Text {
                    text:           label
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78
                    color:          Qt.rgba(1,1,1,0.80)
                }
                Text {
                    visible:        warning !== ""
                    text:           warning
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.65
                    color:          Qt.rgba(1.0,0.65,0.20,0.80)
                    width:          parent.width
                    wrapMode:       Text.WordWrap
                }
            }

            Rectangle {
                id:                     _aTrack
                width:                  ScreenTools.defaultFontPixelWidth * 5
                height:                 ScreenTools.defaultFontPixelHeight * 1.1
                radius:                 height / 2
                anchors.verticalCenter: parent.verticalCenter
                color:                  value ? Qt.rgba(0,0.83,1,0.70) : Qt.rgba(1,1,1,0.18)
                Behavior on color { ColorAnimation { duration: 120 } }

                Rectangle {
                    width:  parent.height - 4; height: width; radius: width / 2
                    anchors.verticalCenter: parent.verticalCenter
                    x:      value ? parent.width - width - 2 : 2
                    color:  value ? Qt.rgba(0,0.83,1,1) : Qt.rgba(1,1,1,0.55)
                    Behavior on x     { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
                    Behavior on color { ColorAnimation  { duration: 120 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape:  Qt.PointingHandCursor
                    onClicked:    toggle(!value)
                }
            }
        }
    }
}
