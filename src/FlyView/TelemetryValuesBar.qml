// Final working-before scroll flickable
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
// Qt5: import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls

Item {
    id:             control

    // ── Keep these so FlyView.qml callers don't break ────────────────────────
    property var    settingsGroup:          null
    property var    specificVehicleForCard: null
    property real   extraWidth:             0
    property var    mapSourceItem:          null

    // ── Sizing ────────────────────────────────────────────────────────────────
    property real _tabH:   ScreenTools.defaultFontPixelHeight * 2.0
    property real _gridH:  ScreenTools.defaultFontPixelHeight * 5.6
    property real _totalW: Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)

    implicitWidth:  _locked ? _totalW           : _userW
    implicitHeight: _collapsed ? _tabH : _tabH + (_locked ? _gridH : _userGridH)

    Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    Behavior on implicitWidth  { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

    clip: true

    // ── Collapse state ────────────────────────────────────────────────────────
    property bool _collapsed: false

    // ── Resize lock state ─────────────────────────────────────────────────────
    property bool _locked:    true

    property real _posX:      -1
    property real _posY:      -1

    signal lockChanged(bool locked)
    signal dragPositionChanged(real px, real py)

    property real _userW:     Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)
    property real _userGridH: ScreenTools.defaultFontPixelHeight * 5.6
    property real _minW:      ScreenTools.defaultFontPixelHeight * 30
    property real _maxW:      mainWindow.width * 0.90
    property real _minGridH:  ScreenTools.defaultFontPixelHeight * 3.5
    property real _maxGridH:  ScreenTools.defaultFontPixelHeight * 12.0

    property var _v: QGroundControl.multiVehicleManager.activeVehicle

    // ── Edit mode ─────────────────────────────────────────────────────────────
    property bool _editMode: false

    // Which of the 10 slots are visible — persisted to QSettings
    // Index order matches the 10 TeleCell items: 0=AltRel 1=ClimbRate 2=FlightTime
    // 3=Heading 4=Battery 5=DistHome 6=GroundSpeed 7=FlightDist 8=GPSSats 9=Airspeed
    property var _slotOn: [true, true, true, true, true, true, true, true, true, true]

    readonly property string _settingsKey: "TelemetryBar/slots/v1"

    function saveSlots() {
        Qt.application.setProperty(_settingsKey, JSON.stringify(_slotOn))
    }

    function loadSlots() {
        var saved = Qt.application.property(_settingsKey)
        if (saved && saved !== "") {
            try {
                var parsed = JSON.parse(saved)
                if (Array.isArray(parsed) && parsed.length === 10) {
                    _slotOn = parsed
                    return
                }
            } catch(e) {}
        }
    }

    function toggleSlot(idx) {
        var arr = _slotOn.slice()
        arr[idx] = !arr[idx]
        _slotOn = arr
        saveSlots()
    }

    Component.onCompleted: loadSlots()

    // ── GLASS BACKGROUND ──────────────────────────────────────────────────────
    Item {
        id:           glassBg
        anchors.fill: parent

        layer.enabled: true
        layer.effect:  OpacityMask {
            maskSource: Rectangle {
                width:  glassBg.width
                height: glassBg.height
                radius: 10
            }
        }

        ShaderEffectSource {
            id:           blurSource
            anchors.fill: parent
            sourceItem:   control.mapSourceItem
            live:         true
            visible:      false
        }

        FastBlur {
            anchors.fill: parent
            source:       blurSource
            radius:       52
        }

        Rectangle {
            anchors.fill: parent
            color:        Qt.rgba(0.04, 0.05, 0.09, 0.85)
        }

        Rectangle {
            anchors.top:   parent.top
            anchors.left:  parent.left
            anchors.right: parent.right
            height:        parent.height * 0.30
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.05) }
                GradientStop { position: 1.0; color: "transparent" }
            }
        }
    }

    Rectangle {
        anchors.fill:  parent
        color:         "transparent"
        radius:        10
        border.color:  Qt.rgba(1,1,1,0.11)
        border.width:  1
        z:             1
    }

    // Top shimmer
    Rectangle {
        anchors.top:              parent.top
        anchors.topMargin:        1
        anchors.horizontalCenter: parent.horizontalCenter
        width:                    parent.width * 0.55
        height:                   1
        z:                        2
        color:                    Qt.rgba(1,1,1,0.22)
    }

    // ── MAIN LAYOUT ───────────────────────────────────────────────────────────
    Column {
        anchors.fill: parent
        z:            3
        spacing:      0

        // ── TAB STRIP ─────────────────────────────────────────────────────────
        Item {
            id:     tabStrip
            width:  parent.width
            height: control._tabH

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.left:   parent.left
                anchors.right:  parent.right
                height:         1
                color:          Qt.rgba(1,1,1,0.08)
            }

            // Drag handle — active only when unlocked
            MouseArea {
                id:           dragHandle
                anchors.fill: parent
                enabled:      !control._locked
                cursorShape:  Qt.SizeAllCursor
                z:            20

                property real _grabX: 0
                property real _grabY: 0

                onPressed: (mouse) => {
                    var p = mapToItem(control.parent, mouse.x, mouse.y)
                    _grabX = p.x - control.x
                    _grabY = p.y - control.y
                }
                onPositionChanged: (mouse) => {
                    if (!pressed) return
                    var p  = mapToItem(control.parent, mouse.x, mouse.y)
                    var nx = Math.max(0, Math.min(control.parent.width  - control.width,  p.x - _grabX))
                    var ny = Math.max(0, Math.min(control.parent.height - control.height, p.y - _grabY))
                    control.dragPositionChanged(nx, ny)
                }
            }

            // Drag hint dots
            Row {
                anchors.centerIn: parent
                spacing:          4
                visible:          !control._locked
                opacity:          0.50
                z:                5
                Repeater {
                    model: 6
                    Rectangle { width: 3; height: 3; radius: 1.5; color: Qt.rgba(0.0,0.83,1.0,1.0) }
                }
            }

            // Tab buttons
            Row {
                id:                     tabRow
                anchors.left:           parent.left
                anchors.leftMargin:     8
                anchors.verticalCenter: parent.verticalCenter
                spacing:                4
                property int currentTab: 0

                component TabBtn: Item {
                    id:             tb
                    property string label:    ""
                    property int    tabIndex: 0
                    property bool   active:   tabRow.currentTab === tabIndex
                    width:  lbl.contentWidth + ScreenTools.defaultFontPixelHeight * 1.8
                    height: control._tabH - 4

                    Rectangle {
                        anchors.fill:  parent
                        radius:        6
                        color:         tb.active ? Qt.rgba(0.0,0.83,1.0,0.16) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
                        border.color:  tb.active ? Qt.rgba(0.0,0.83,1.0,0.36) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.07)
                        border.width:  1
                        Behavior on color        { ColorAnimation { duration: 110 } }
                        Behavior on border.color { ColorAnimation { duration: 110 } }
                        Rectangle {
                            anchors.bottom:       parent.bottom
                            anchors.bottomMargin: -1
                            anchors.left:         parent.left;  anchors.leftMargin:  8
                            anchors.right:        parent.right; anchors.rightMargin: 8
                            height: 2; radius: 1
                            visible: tb.active
                            color:   Qt.rgba(0.0,0.83,1.0,1.0)
                        }
                    }
                    Text {
                        id:                 lbl
                        anchors.centerIn:   parent
                        text:               tb.label
                        font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.82
                        font.weight:        tb.active ? Font.SemiBold : Font.Normal
                        font.letterSpacing: 0.3
                        color:              tb.active ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)
                        Behavior on color { ColorAnimation { duration: 110 } }
                    }
                    MouseArea {
                        id:           tbMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  Qt.PointingHandCursor
                        enabled:      control._locked
                        onClicked:    tabRow.currentTab = tb.tabIndex
                    }
                }

                TabBtn { label: qsTr("Values");    tabIndex: 0 }
                TabBtn { label: qsTr("Vibration"); tabIndex: 1 }
                TabBtn { label: qsTr("EKF");       tabIndex: 2 }
                TabBtn { label: qsTr("AHRS");      tabIndex: 3 }
            }

            // Icon buttons
            Row {
                anchors.right:          parent.right
                anchors.rightMargin:    10
                anchors.verticalCenter: parent.verticalCenter
                spacing:                6
                z:                      25

                component IconBtn: Rectangle {
                    property string ico: ""
                    width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
                    color:  ibMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
                    border.color: Qt.rgba(1,1,1,0.10); border.width: 1
                    Behavior on color { ColorAnimation { duration: 90 } }
                    Text { anchors.centerIn: parent; text: parent.ico; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82; color: Qt.rgba(1,1,1,0.82) }
                    MouseArea { id: ibMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor }
                }

                // 🔒 / 🔓 Lock
                Rectangle {
                    width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
                    color:  lockMa.containsMouse
                                ? (control._locked ? Qt.rgba(1.0,0.55,0.10,0.18) : Qt.rgba(0.0,0.83,1.0,0.18))
                                : (control._locked ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0.0,0.83,1.0,0.10))
                    border.color: control._locked ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0.0,0.83,1.0,0.40)
                    border.width: 1
                    Behavior on color        { ColorAnimation { duration: 90 } }
                    Behavior on border.color { ColorAnimation { duration: 90 } }
                    Text {
                        anchors.centerIn: parent
                        text:             control._locked ? "🔒" : "🔓"
                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.78
                    }
                    MouseArea {
                        id:           lockMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  Qt.PointingHandCursor
                        onClicked: {
                            if (control._locked) {
                                control._userW     = control.width
                                control._userGridH = control._gridH
                            }
                            control._locked = !control._locked
                            control.lockChanged(control._locked)
                        }
                    }
                }

                // ⚙ Settings — toggles edit mode on Values tab
                Rectangle {
                    id:           gearBtn
                    width:        control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
                    color:        control._editMode
                                      ? Qt.rgba(0.0,0.83,1.0,0.18)
                                      : gearMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
                    border.color: control._editMode ? Qt.rgba(0.0,0.83,1.0,0.45) : Qt.rgba(1,1,1,0.10)
                    border.width: 1
                    Behavior on color        { ColorAnimation { duration: 90 } }
                    Behavior on border.color { ColorAnimation { duration: 90 } }
                    Text {
                        anchors.centerIn: parent
                        text:             "⚙"
                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
                        color:            control._editMode ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)
                    }
                    MouseArea {
                        id:           gearMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  Qt.PointingHandCursor
                        onClicked: {
                            if (tabRow.currentTab === 0)
                                control._editMode = !control._editMode
                        }
                    }
                }

                // ⌃ Collapse
                Rectangle {
                    width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
                    color:  collapseMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
                    border.color: Qt.rgba(1,1,1,0.10); border.width: 1
                    Behavior on color { ColorAnimation { duration: 90 } }
                    Text {
                        anchors.centerIn: parent
                        text:             "⌃"
                        font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
                        color:            Qt.rgba(1,1,1,0.82)
                        rotation:         control._collapsed ? 180 : 0
                        Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    }
                    MouseArea {
                        id:           collapseMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  Qt.PointingHandCursor
                        onClicked:    control._collapsed = !control._collapsed
                    }
                }
            }
        }

        // ── PAGE AREA ─────────────────────────────────────────────────────────
        Item {
            id:      pageArea
            width:   parent.width
            height:  control._locked ? control._gridH : control._userGridH
            visible: !control._collapsed
            clip:    true

            // ── Shared cell component ─────────────────────────────────────────
            component TeleCell: Item {
                id:             tc
                property string ico:      "●"
                property color  icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                property string val:      "0.0"
                property string unit:     ""
                property string lbl:      ""

                Rectangle {
                    anchors.right:        parent.right
                    anchors.top:          parent.top;    anchors.topMargin:    8
                    anchors.bottom:       parent.bottom; anchors.bottomMargin: 8
                    width: 1; color: Qt.rgba(1,1,1,0.07)
                }

                Row {
                    anchors.left:           parent.left
                    anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.9
                    anchors.verticalCenter: parent.verticalCenter
                    spacing:                ScreenTools.defaultFontPixelWidth * 0.7

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text:           tc.ico
                        font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.30
                        font.weight:    Font.Bold
                        color:          tc.icoColor
                    }

                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing:               1

                        Row {
                            spacing: 3
                            Text {
                                id:             valTxt
                                text:           tc.val
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22
                                font.weight:    Font.Medium
                                color:          Qt.rgba(1,1,1,0.92)
                            }
                            Text {
                                anchors.bottom:       valTxt.bottom
                                anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 0.18
                                text:           tc.unit
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
                                font.weight:    Font.Light
                                color:          Qt.rgba(1,1,1,0.65)
                                visible:        tc.unit !== ""
                            }
                        }

                        Text {
                            text:           tc.lbl
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
                            font.weight:    Font.Light
                            color:          Qt.rgba(1,1,1,0.65)
                        }
                    }
                }
            }

            // ── VALUES PAGE ───────────────────────────────────────────────────
            Item {
                id:           valuesPage
                anchors.fill: parent
                opacity:      tabRow.currentTab === 0 ? 1 : 0
                enabled:      tabRow.currentTab === 0

                // Mid divider
                Rectangle {
                    anchors.left:  parent.left;  anchors.leftMargin:  12
                    anchors.right: parent.right; anchors.rightMargin: 12
                    y:             parent.height / 2
                    height:        1; color: Qt.rgba(1,1,1,0.07); z: 10
                }

                // Row 1
                Row {
                    id:            row1
                    anchors.top:   parent.top
                    anchors.left:  parent.left
                    anchors.right: parent.right
                    height:        parent.height / 2

                    // Slot 0 — Alt (Rel)
                    Item {
                        width:  row1.width / 5; height: row1.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[0] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "⬆"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                            val:  _v ? _v.altitudeRelative.value.toFixed(1) : "0.0"
                            unit: _v ? _v.altitudeRelative.units : "ft"
                            lbl:  qsTr("Alt (Rel)")
                        }
                        // Edit overlay
                        Rectangle {
                            visible:        control._editMode
                            anchors.fill:   parent; anchors.margins: 3; radius: 6
                            color:          "transparent"
                            border.color:   control._slotOn[0] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5)
                            border.width:   1
                        }
                        Text {
                            visible:        control._editMode
                            anchors.centerIn: parent
                            text:           control._slotOn[0] ? "✕" : "＋"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1
                            font.weight:    Font.Bold
                            color:          control._slotOn[0] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea {
                            anchors.fill: parent
                            enabled:      control._editMode
                            onClicked:    control.toggleSlot(0)
                        }
                    }

                    // Slot 1 — Climb Rate
                    Item {
                        width:  row1.width / 5; height: row1.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[1] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "↕"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                            val:  _v ? _v.climbRate.value.toFixed(1) : "0.0"
                            unit: _v ? _v.climbRate.units : "mph"
                            lbl:  qsTr("Climb Rate")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[1] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[1] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[1] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(1) }
                    }

                    // Slot 2 — Flight Time
                    Item {
                        width:  row1.width / 5; height: row1.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[2] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "⏱"; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
                            val: _v ? _v.flightTime : "0:00:00"; unit: ""; lbl: qsTr("Flight Time")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[2] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[2] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[2] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(2) }
                    }

                    // Slot 3 — Heading
                    Item {
                        width:  row1.width / 5; height: row1.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[3] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "◈"; icoColor: Qt.rgba(1.0,0.80,0.0,1.0)
                            val: _v ? _v.heading.value.toFixed(0) : "0"; unit: "°"; lbl: qsTr("Heading")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[3] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[3] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[3] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(3) }
                    }

                    // Slot 4 — Battery
                    Item {
                        width:  row1.width / 5; height: row1.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[4] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "⚡"
                            icoColor: {
                                if (!_v) return Qt.rgba(0.0,0.83,1.0,1.0)
                                var p = _v.battery.percentRemaining.value
                                return p < 20 ? Qt.rgba(1.0,0.22,0.35,1.0) : p < 40 ? Qt.rgba(1.0,0.55,0.10,1.0) : Qt.rgba(0.0,1.0,0.55,1.0)
                            }
                            val: _v ? _v.battery.percentRemaining.value.toFixed(0) : "0"; unit: "%"; lbl: qsTr("Battery")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[4] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[4] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[4] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(4) }
                    }
                }

                // Row 2
                Row {
                    id:             row2
                    anchors.bottom: parent.bottom
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    height:         parent.height / 2

                    // Slot 5 — Distance to Home
                    Item {
                        width:  row2.width / 5; height: row2.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[5] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "⌂"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                            val:  _v ? _v.distanceToHome.value.toFixed(1) : "0.0"
                            unit: _v ? _v.distanceToHome.units : "ft"; lbl: qsTr("Distance to Home")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[5] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[5] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[5] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(5) }
                    }

                    // Slot 6 — Ground Speed
                    Item {
                        width:  row2.width / 5; height: row2.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[6] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "➤"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                            val:  _v ? _v.groundSpeed.value.toFixed(1) : "0.0"
                            unit: _v ? _v.groundSpeed.units : "mph"; lbl: qsTr("Ground Speed")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[6] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[6] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[6] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(6) }
                    }

                    // Slot 7 — Flight Distance
                    Item {
                        width:  row2.width / 5; height: row2.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[7] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "⇌"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                            val:  _v ? _v.flightDistance.value.toFixed(1) : "0.0"
                            unit: _v ? _v.flightDistance.units : "ft"; lbl: qsTr("Flight Distance")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[7] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[7] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[7] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(7) }
                    }

                    // Slot 8 — GPS Satellites
                    Item {
                        width:  row2.width / 5; height: row2.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[8] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "◉"; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
                            val: _v ? _v.gpsSatelliteCount.value.toFixed(0) : "0"; unit: "sat"; lbl: qsTr("GPS Satellites")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[8] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[8] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[8] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(8) }
                    }

                    // Slot 9 — Airspeed
                    Item {
                        width:  row2.width / 5; height: row2.height
                        TeleCell {
                            anchors.fill: parent
                            opacity: control._slotOn[9] ? 1 : (control._editMode ? 0.25 : 0)
                            ico: "≋"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
                            val:  _v ? _v.airSpeed.value.toFixed(1) : "0.0"
                            unit: _v ? _v.airSpeed.units : "mph"; lbl: qsTr("Airspeed")
                        }
                        Rectangle {
                            visible: control._editMode; anchors.fill: parent; anchors.margins: 3; radius: 6
                            color: "transparent"; border.color: control._slotOn[9] ? Qt.rgba(1,0.2,0.3,0.6) : Qt.rgba(0,0.83,1,0.5); border.width: 1
                        }
                        Text {
                            visible: control._editMode; anchors.centerIn: parent
                            text: control._slotOn[9] ? "✕" : "＋"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1; font.weight: Font.Bold
                            color: control._slotOn[9] ? Qt.rgba(1,0.2,0.3,0.9) : Qt.rgba(0,0.83,1,0.9)
                        }
                        MouseArea { anchors.fill: parent; enabled: control._editMode; onClicked: control.toggleSlot(9) }
                    }
                }
            }

            // ── VIBRATION PAGE ────────────────────────────────────────────────
            Item {
                anchors.fill: parent
                opacity: tabRow.currentTab === 1 ? 1 : 0
                enabled: tabRow.currentTab === 1

                component VibCell: Item {
                    property string lbl: ""; property string val: "0"
                    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
                    Column { anchors.centerIn: parent; spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
                    }
                }

                Row {
                    anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
                    VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe X"; val: _v ? _v.vibration.xAxis.value.toFixed(2) : "0" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Y"; val: _v ? _v.vibration.yAxis.value.toFixed(2) : "0" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Z"; val: _v ? _v.vibration.zAxis.value.toFixed(2) : "0" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 0"; val: _v ? _v.vibration.clipCount1.value.toFixed(0) : "0" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 1"; val: _v ? _v.vibration.clipCount2.value.toFixed(0) : "0" }
                }
                Row {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
                    VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 2"; val: _v ? _v.vibration.clipCount3.value.toFixed(0) : "0" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
                    VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
                }
            }

            // ── EKF PAGE ──────────────────────────────────────────────────────
            Item {
                anchors.fill: parent
                opacity: tabRow.currentTab === 2 ? 1 : 0
                enabled: tabRow.currentTab === 2

                component EkfCell: Item {
                    property string lbl: ""; property string val: "0"; property color vc: Qt.rgba(0.0,0.83,1.0,1.0)
                    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
                    Column { anchors.centerIn: parent; spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: parent.parent.vc }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
                    }
                }

                Row {
                    anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Horiz";  vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.velRatio.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Vert";   vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.posVertRatio.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos Horiz";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizRatio.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Mag Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.magRatio.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Hagl Ratio"; vc: Qt.rgba(1.0,0.80,0.0,1.0); val: _v ? _v.estimatorStatus.haglRatio.value.toFixed(2) : "0" }
                }
                Row {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Tas Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.tasRatio.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos H Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizAccuracy.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos V Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posVertAccuracy.value.toFixed(2) : "0" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
                    EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
                }
            }

            // ── AHRS PAGE ─────────────────────────────────────────────────────
            Item {
                anchors.fill: parent
                opacity: tabRow.currentTab === 3 ? 1 : 0
                enabled: tabRow.currentTab === 3

                component AhrsCell: Item {
                    property string lbl: ""; property string val: "0"
                    Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
                    Column { anchors.centerIn: parent; spacing: 2
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
                    }
                }

                Row {
                    anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll (°)";   val: _v ? _v.roll.value.toFixed(1)    : "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch (°)";  val: _v ? _v.pitch.value.toFixed(1)   : "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw (°)";    val: _v ? _v.heading.value.toFixed(1) : "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll Rate";  val: _v ? _v.rollRate.value.toFixed(1)  : "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch Rate"; val: _v ? _v.pitchRate.value.toFixed(1) : "0" }
                }
                Row {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw Rate"; val: _v ? _v.yawRate.value.toFixed(1) : "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel X";  val: "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Y";  val: "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Z";  val: "0" }
                    AhrsCell { width: parent.width/5; height: parent.height; lbl: "";         val: "" }
                }
            }
        }
    }

    // ── RESIZE HANDLES ────────────────────────────────────────────────────────

    Item {
        id:      rightHandle
        visible: !control._locked && !control._collapsed
        anchors.right:  parent.right
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        width:          12

        Rectangle {
            anchors.centerIn: parent
            width:  4; height: parent.height * 0.35; radius: 2
            color:  rightDrag.containsMouse || rightDrag.pressed ? Qt.rgba(0.0,0.83,1.0,0.90) : Qt.rgba(0.0,0.83,1.0,0.35)
            Behavior on color { ColorAnimation { duration: 80 } }
            Column { anchors.centerIn: parent; spacing: 3
                Repeater { model: 3; Rectangle { width: 4; height: 1; radius: 1; color: Qt.rgba(1,1,1,0.50) } }
            }
        }

        MouseArea {
            id:           rightDrag
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.SizeHorCursor
            property real _startX: 0; property real _startW: 0
            onPressed:       { _startX = mouseX + rightHandle.x; _startW = control._userW }
            onMouseXChanged: { if (pressed) control._userW = Math.max(control._minW, Math.min(control._maxW, _startW + (mouseX + rightHandle.x) - _startX)) }
        }
    }

    Item {
        id:      bottomHandle
        visible: !control._locked && !control._collapsed
        anchors.bottom: parent.bottom
        anchors.left:   parent.left
        anchors.right:  parent.right
        height:         12

        Rectangle {
            anchors.centerIn: parent
            width: parent.width * 0.18; height: 4; radius: 2
            color: bottomDrag.containsMouse || bottomDrag.pressed ? Qt.rgba(0.0,0.83,1.0,0.90) : Qt.rgba(0.0,0.83,1.0,0.35)
            Behavior on color { ColorAnimation { duration: 80 } }
            Row { anchors.centerIn: parent; spacing: 3
                Repeater { model: 3; Rectangle { width: 1; height: 4; radius: 1; color: Qt.rgba(1,1,1,0.50) } }
            }
        }

        MouseArea {
            id:           bottomDrag
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.SizeVerCursor
            property real _startY: 0; property real _startH: 0
            onPressed:       { _startY = mouseY + bottomHandle.y; _startH = control._userGridH }
            onMouseYChanged: { if (pressed) control._userGridH = Math.max(control._minGridH, Math.min(control._maxGridH, _startH + (mouseY + bottomHandle.y) - _startY)) }
        }
    }

    Item {
        id:      cornerHandle
        visible: !control._locked && !control._collapsed
        anchors.right:  parent.right
        anchors.bottom: parent.bottom
        width: 16; height: 16

        Rectangle {
            anchors.fill: parent; radius: 4
            color:        cornerDrag.containsMouse || cornerDrag.pressed ? Qt.rgba(0.0,0.83,1.0,0.25) : Qt.rgba(0.0,0.83,1.0,0.10)
            border.color: Qt.rgba(0.0,0.83,1.0,0.40); border.width: 1
            Behavior on color { ColorAnimation { duration: 80 } }
            Canvas {
                anchors.fill: parent; anchors.margins: 3
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.strokeStyle = Qt.rgba(0.0,0.83,1.0,0.70); ctx.lineWidth = 1.5
                    ctx.beginPath()
                    ctx.moveTo(width,0); ctx.lineTo(width,height); ctx.lineTo(0,height)
                    ctx.moveTo(width,height*0.5); ctx.lineTo(width*0.5,height)
                    ctx.stroke()
                }
            }
        }

        MouseArea {
            id:           cornerDrag
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.SizeFDiagCursor
            property real _startX: 0; property real _startY: 0
            property real _startW: 0; property real _startH: 0
            onPressed: { _startX = mouseX + cornerHandle.x; _startY = mouseY + cornerHandle.y; _startW = control._userW; _startH = control._userGridH }
            onMouseXChanged: { if (pressed) control._userW     = Math.max(control._minW,     Math.min(control._maxW,     _startW + (mouseX + cornerHandle.x) - _startX)) }
            onMouseYChanged: { if (pressed) control._userGridH = Math.max(control._minGridH, Math.min(control._maxGridH, _startH + (mouseY + cornerHandle.y) - _startY)) }
        }
    }
}
