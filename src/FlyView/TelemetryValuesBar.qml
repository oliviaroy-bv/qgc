// // // // ─────────────────────────────────────────────────────────────────────────────
// // // //  TelemetryValuesBar.qml  —  BonVGroundStation
// // // //  File: src/FlyView/TelemetryValuesBar.qml
// // // //
// // // //  COMPLETE REPLACEMENT — self-contained fixed layout
// // // //  • No dependency on HorizontalFactValueGrid / InstrumentValueData / QSettings
// // // //  • Tab strip: Values | Vibration | EKF | AHRS  + gear + collapse
// // // //  • 5×2 fixed telemetry grid, all values bind directly to activeVehicle
// // // //  • Glass background (blur + tint + shimmer + border)
// // // //  • Wire in FlyView.qml: mapSourceItem: flightMap
// // // // ─────────────────────────────────────────────────────────────────────────────

// // // import QtQuick
// // // import QtQuick.Layouts
// // // import Qt5Compat.GraphicalEffects
// // // // Qt5: import QtGraphicalEffects

// // // import QGroundControl
// // // import QGroundControl.Controls

// // // Item {
// // //     id:             control

// // //     // ── Keep these so FlyView.qml callers don't break ────────────────────────
// // //     property var    settingsGroup:          null
// // //     property var    specificVehicleForCard: null
// // //     property real   extraWidth:             0
// // //     property var    mapSourceItem:          null

// // //     // ── Sizing ────────────────────────────────────────────────────────────────
// // //     property real _tabH:   ScreenTools.defaultFontPixelHeight * 2.0
// // //     property real _gridH:  ScreenTools.defaultFontPixelHeight * 5.6
// // //     property real _totalW: Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)

// // //     implicitWidth:  _totalW
// // //     implicitHeight: _collapsed ? _tabH : _tabH + _gridH

// // //     Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

// // //     clip:           true

// // //     // ── Collapse state ────────────────────────────────────────────────────────
// // //     property bool _collapsed: false
// // //     property var _v: QGroundControl.multiVehicleManager.activeVehicle

// // //     // ── GLASS BACKGROUND ──────────────────────────────────────────────────────
// // //     Item {
// // //         id:           glassBg
// // //         anchors.fill: parent

// // //         layer.enabled: true
// // //         layer.effect:  OpacityMask {
// // //             maskSource: Rectangle {
// // //                 width:  glassBg.width
// // //                 height: glassBg.height
// // //                 radius: 10
// // //             }
// // //         }

// // //         ShaderEffectSource {
// // //             id:           blurSource
// // //             anchors.fill: parent
// // //             sourceItem:   control.mapSourceItem
// // //             live:         true
// // //             visible:      false
// // //         }

// // //         FastBlur {
// // //             anchors.fill: parent
// // //             source:       blurSource
// // //             radius:       52
// // //         }

// // //         Rectangle {
// // //             anchors.fill: parent
// // //             color:        Qt.rgba(0.04, 0.05, 0.09, 0.85)
// // //         }

// // //         Rectangle {
// // //             anchors.top:   parent.top
// // //             anchors.left:  parent.left
// // //             anchors.right: parent.right
// // //             height:        parent.height * 0.30
// // //             gradient: Gradient {
// // //                 GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.05) }
// // //                 GradientStop { position: 1.0; color: "transparent" }
// // //             }
// // //         }
// // //     }

// // //     Rectangle {
// // //         anchors.fill:  parent
// // //         color:         "transparent"
// // //         radius:        10
// // //         border.color:  Qt.rgba(1,1,1,0.11)
// // //         border.width:  1
// // //         z:             1
// // //     }

// // //     // Top shimmer — using LinearGradient for Qt6 compatibility
// // //     Item {
// // //         anchors.top:              parent.top
// // //         anchors.topMargin:        1
// // //         anchors.horizontalCenter: parent.horizontalCenter
// // //         width:                    parent.width * 0.55
// // //         height:                   1
// // //         z:                        2

// // //         Rectangle { anchors.fill: parent; color: Qt.rgba(1,1,1,0.32) }

// // //         LinearGradient {
// // //             anchors.fill: parent
// // //             start:        Qt.point(0, 0)
// // //             end:          Qt.point(parent.width, 0)
// // //             gradient: Gradient {
// // //                 GradientStop { position: 0.0; color: "transparent" }
// // //                 GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.32) }
// // //                 GradientStop { position: 1.0; color: "transparent" }
// // //             }
// // //         }
// // //     }

// // //     // ── MAIN LAYOUT ───────────────────────────────────────────────────────────
// // //     Column {
// // //         anchors.fill: parent
// // //         z:            3
// // //         spacing:      0

// // //         // ── TAB STRIP ─────────────────────────────────────────────────────────
// // //         Item {
// // //             width:  parent.width
// // //             height: control._tabH

// // //             Rectangle {
// // //                 anchors.bottom: parent.bottom
// // //                 anchors.left:   parent.left
// // //                 anchors.right:  parent.right
// // //                 height:         1
// // //                 color:          Qt.rgba(1,1,1,0.08)
// // //             }

// // //             Row {
// // //                 id:                     tabRow
// // //                 anchors.left:           parent.left
// // //                 anchors.leftMargin:     8
// // //                 anchors.verticalCenter: parent.verticalCenter
// // //                 spacing:                4
// // //                 property int currentTab: 0

// // //                 component TabBtn: Item {
// // //                     id:             tb
// // //                     property string label:    ""
// // //                     property int    tabIndex: 0
// // //                     property bool   active:   tabRow.currentTab === tabIndex
// // //                     width:  lbl.contentWidth + ScreenTools.defaultFontPixelHeight * 1.8
// // //                     height: control._tabH - 4

// // //                     Rectangle {
// // //                         anchors.fill:  parent
// // //                         radius:        6
// // //                         color:         tb.active ? Qt.rgba(0.0,0.83,1.0,0.16) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
// // //                         border.color:  tb.active ? Qt.rgba(0.0,0.83,1.0,0.36) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.07)
// // //                         border.width:  1
// // //                         Behavior on color        { ColorAnimation { duration: 110 } }
// // //                         Behavior on border.color { ColorAnimation { duration: 110 } }
// // //                         Rectangle {
// // //                             anchors.bottom:       parent.bottom
// // //                             anchors.bottomMargin: -1
// // //                             anchors.left:         parent.left; anchors.leftMargin:  8
// // //                             anchors.right:        parent.right; anchors.rightMargin: 8
// // //                             height:  2; radius: 1
// // //                             visible: tb.active
// // //                             color:   Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         }
// // //                     }
// // //                     Text {
// // //                         id:                 lbl
// // //                         anchors.centerIn:   parent
// // //                         text:               tb.label
// // //                         font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.82
// // //                         font.weight:        tb.active ? Font.SemiBold : Font.Normal
// // //                         font.letterSpacing: 0.3
// // //                         color:              tb.active ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)
// // //                         Behavior on color { ColorAnimation { duration: 110 } }
// // //                     }
// // //                     MouseArea { id: tbMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: tabRow.currentTab = tb.tabIndex }
// // //                 }

// // //                 TabBtn { label: qsTr("Values");    tabIndex: 0 }
// // //                 TabBtn { label: qsTr("Vibration"); tabIndex: 1 }
// // //                 TabBtn { label: qsTr("EKF");       tabIndex: 2 }
// // //                 TabBtn { label: qsTr("AHRS");      tabIndex: 3 }
// // //             }

// // //             Row {
// // //                 anchors.right:          parent.right
// // //                 anchors.rightMargin:    10
// // //                 anchors.verticalCenter: parent.verticalCenter
// // //                 spacing:                6

// // //                 component IconBtn: Rectangle {
// // //                     property string ico: ""
// // //                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
// // //                     color:  ibMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
// // //                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
// // //                     Behavior on color { ColorAnimation { duration: 90 } }
// // //                     Text { anchors.centerIn: parent; text: parent.ico; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82; color: Qt.rgba(1,1,1,0.82) }
// // //                     MouseArea { id: ibMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor }
// // //                 }

// // //                 IconBtn { ico: "⚙" }
// // //                 // Collapse / expand button with animated arrow
// // //                 Rectangle {
// // //                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
// // //                     color:  collapseMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
// // //                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
// // //                     Behavior on color { ColorAnimation { duration: 90 } }

// // //                     Text {
// // //                         anchors.centerIn: parent
// // //                         text:             "⌃"
// // //                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
// // //                         color:            Qt.rgba(1,1,1,0.82)
// // //                         rotation:         control._collapsed ? 180 : 0
// // //                         Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
// // //                     }
// // //                     MouseArea {
// // //                         id:           collapseMa
// // //                         anchors.fill: parent
// // //                         hoverEnabled: true
// // //                         cursorShape:  Qt.PointingHandCursor
// // //                         onClicked:    control._collapsed = !control._collapsed
// // //                     }
// // //                 }
// // //             }
// // //         }

// // //         // ── PAGE AREA ─────────────────────────────────────────────────────────
// // //         Item {
// // //             width:   parent.width
// // //             height:  control._gridH
// // //             visible: !control._collapsed
// // //             clip:    true

// // //             // ── Shared cell component ─────────────────────────────────────────
// // //             component TeleCell: Item {
// // //                 id:             tc
// // //                 property string ico:      "●"
// // //                 property color  icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                 property string val:      "0.0"
// // //                 property string unit:     ""
// // //                 property string lbl:      ""

// // //                 Rectangle {
// // //                     anchors.right:        parent.right
// // //                     anchors.top:          parent.top;    anchors.topMargin:    8
// // //                     anchors.bottom:       parent.bottom; anchors.bottomMargin: 8
// // //                     width: 1; color: Qt.rgba(1,1,1,0.07)
// // //                 }

// // //                 Row {
// // //                     anchors.left:           parent.left
// // //                     anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.9
// // //                     anchors.verticalCenter: parent.verticalCenter
// // //                     spacing:                ScreenTools.defaultFontPixelWidth * 0.7

// // //                     Text {
// // //                         anchors.verticalCenter: parent.verticalCenter
// // //                         text:           tc.ico
// // //                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.30
// // //                         font.weight:    Font.Bold
// // //                         color:          tc.icoColor
// // //                     }

// // //                     Column {
// // //                         anchors.verticalCenter: parent.verticalCenter
// // //                         spacing:               1

// // //                         Row {
// // //                             spacing: 3
// // //                             Text {
// // //                                 id:             valTxt
// // //                                 text:           tc.val
// // //                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22
// // //                                 font.weight:    Font.Medium
// // //                                 color:          Qt.rgba(1,1,1,0.92)
// // //                             }
// // //                             Text {
// // //                                 anchors.bottom:       valTxt.bottom
// // //                                 anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 0.18
// // //                                 text:           tc.unit
// // //                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
// // //                                 font.weight:    Font.Light
// // //                                 color:          Qt.rgba(1,1,1,0.65)
// // //                                 visible:        tc.unit !== ""
// // //                             }
// // //                         }

// // //                         Text {
// // //                             text:           tc.lbl
// // //                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
// // //                             font.weight:    Font.Light
// // //                             color:          Qt.rgba(1,1,1,0.65)
// // //                         }
// // //                     }
// // //                 }
// // //             }

// // //             // ── VALUES PAGE ───────────────────────────────────────────────────
// // //             Item {
// // //                 anchors.fill: parent
// // //                 visible:      tabRow.currentTab === 0

// // //                 // Mid row divider
// // //                 Rectangle {
// // //                     anchors.left:  parent.left;  anchors.leftMargin:  12
// // //                     anchors.right: parent.right; anchors.rightMargin: 12
// // //                     y:             parent.height / 2
// // //                     height:        1
// // //                     color:         Qt.rgba(1,1,1,0.07)
// // //                     z:             10
// // //                 }

// // //                 // Row 1
// // //                 Row {
// // //                     anchors.top:   parent.top
// // //                     anchors.left:  parent.left
// // //                     anchors.right: parent.right
// // //                     height:        parent.height / 2

// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ⬆ "; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         val:  _v ? _v.altitudeRelative.value.toFixed(1) : "0.0"
// // //                         unit: _v ? _v.altitudeRelative.units : "ft"
// // //                         lbl:  qsTr("Alt (Rel)")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ↕ "; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         val:  _v ? _v.climbRate.value.toFixed(1) : "0.0"
// // //                         unit: _v ? _v.climbRate.units : "mph"
// // //                         lbl:  qsTr("Climb Rate")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ⏱ "; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
// // //                         val:  _v ? _v.flightTime : "0:00:00"
// // //                         unit: ""; lbl: qsTr("Flight Time")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ◈ "; icoColor: Qt.rgba(1.0,0.80,0.0,1.0)
// // //                         val:  _v ? _v.heading.value.toFixed(0) : "0"
// // //                         unit: "°"; lbl: qsTr("Heading")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ⚡ "
// // //                         icoColor: {
// // //                             if (!_v) return Qt.rgba(0.0,0.83,1.0,1.0)
// // //                             var p = _v.battery.percentRemaining.value
// // //                             return p < 20 ? Qt.rgba(1.0,0.22,0.35,1.0) : p < 40 ? Qt.rgba(1.0,0.55,0.10,1.0) : Qt.rgba(0.0,1.0,0.55,1.0)
// // //                         }
// // //                         val:  _v ? _v.battery.percentRemaining.value.toFixed(0) : "0"
// // //                         unit: "%"; lbl: qsTr("Battery")
// // //                     }
// // //                 }

// // //                 // Row 2
// // //                 Row {
// // //                     anchors.bottom: parent.bottom
// // //                     anchors.left:   parent.left
// // //                     anchors.right:  parent.right
// // //                     height:         parent.height / 2

// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ⌂ "; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         val:  _v ? _v.distanceToHome.value.toFixed(1) : "0.0"
// // //                         unit: _v ? _v.distanceToHome.units : "ft"
// // //                         lbl:  qsTr("Distance to Home")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ➤ "; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         val:  _v ? _v.groundSpeed.value.toFixed(1) : "0.0"
// // //                         unit: _v ? _v.groundSpeed.units : "mph"
// // //                         lbl:  qsTr("Ground Speed")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ⇌ "; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         val:  _v ? _v.flightDistance.value.toFixed(1) : "0.0"
// // //                         unit: _v ? _v.flightDistance.units : "ft"
// // //                         lbl:  qsTr("Flight Distance")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ◉ "; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
// // //                         val:  _v ? _v.gpsSatelliteCount.value.toFixed(0) : "0"
// // //                         unit: "sat"; lbl: qsTr("GPS Satellites")
// // //                     }
// // //                     TeleCell {
// // //                         width: parent.width/5; height: parent.height
// // //                         ico: " ≋ "; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                         val:  _v ? _v.airSpeed.value.toFixed(1) : "0.0"
// // //                         unit: _v ? _v.airSpeed.units : "mph"
// // //                         lbl:  qsTr("Airspeed")
// // //                     }
// // //                 }
// // //             }

// // //             // ── VIBRATION PAGE ────────────────────────────────────────────────
// // //             Item {
// // //                 anchors.fill: parent
// // //                 visible:      tabRow.currentTab === 1

// // //                 component VibCell: Item {
// // //                     property string lbl: ""; property string val: "0"
// // //                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
// // //                     Column { anchors.centerIn: parent; spacing: 2
// // //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
// // //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
// // //                     }
// // //                 }

// // //                 Row {
// // //                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe X"; val: _v ? _v.vibration.xAxis.value.toFixed(2) : "0" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Y"; val: _v ? _v.vibration.yAxis.value.toFixed(2) : "0" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Z"; val: _v ? _v.vibration.zAxis.value.toFixed(2) : "0" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 0"; val: _v ? _v.vibration.clipCount1.value.toFixed(0) : "0" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 1"; val: _v ? _v.vibration.clipCount2.value.toFixed(0) : "0" }
// // //                 }
// // //                 Row {
// // //                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 2"; val: _v ? _v.vibration.clipCount3.value.toFixed(0) : "0" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// // //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// // //                 }
// // //             }

// // //             // ── EKF PAGE ──────────────────────────────────────────────────────
// // //             Item {
// // //                 anchors.fill: parent
// // //                 visible:      tabRow.currentTab === 2

// // //                 component EkfCell: Item {
// // //                     property string lbl: ""; property string val: "0"; property color vc: Qt.rgba(0.0,0.83,1.0,1.0)
// // //                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
// // //                     Column { anchors.centerIn: parent; spacing: 2
// // //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: parent.parent.vc }
// // //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
// // //                     }
// // //                 }

// // //                 Row {
// // //                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Horiz";  vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.velRatio.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Vert";   vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.posVertRatio.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos Horiz";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizRatio.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Mag Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.magRatio.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Hagl Ratio"; vc: Qt.rgba(1.0,0.80,0.0,1.0); val: _v ? _v.estimatorStatus.haglRatio.value.toFixed(2) : "0" }
// // //                 }
// // //                 Row {
// // //                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Tas Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.tasRatio.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos H Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizAccuracy.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos V Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posVertAccuracy.value.toFixed(2) : "0" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// // //                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// // //                 }
// // //             }

// // //             // ── AHRS PAGE ─────────────────────────────────────────────────────
// // //             Item {
// // //                 anchors.fill: parent
// // //                 visible:      tabRow.currentTab === 3

// // //                 component AhrsCell: Item {
// // //                     property string lbl: ""; property string val: "0"
// // //                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
// // //                     Column { anchors.centerIn: parent; spacing: 2
// // //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
// // //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
// // //                     }
// // //                 }

// // //                 Row {
// // //                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll (°)";   val: _v ? _v.roll.value.toFixed(1)    : "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch (°)";  val: _v ? _v.pitch.value.toFixed(1)   : "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw (°)";    val: _v ? _v.heading.value.toFixed(1) : "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll Rate";  val: _v ? _v.rollRate.value.toFixed(1)  : "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch Rate"; val: _v ? _v.pitchRate.value.toFixed(1) : "0" }
// // //                 }
// // //                 Row {
// // //                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw Rate"; val: _v ? _v.yawRate.value.toFixed(1) : "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel X";  val: "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Y";  val: "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Z";  val: "0" }
// // //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "";         val: "" }
// // //                 }
// // //             }
// // //         }
// // //     }
// // // }


// // // ─────────────────────────────────────────────────────────────────────────────
// // //  TelemetryValuesBar.qml  —  BonVGroundStation
// // //  File: src/FlyView/TelemetryValuesBar.qml
// // //
// // //  COMPLETE REPLACEMENT — self-contained fixed layout
// // //  • No dependency on HorizontalFactValueGrid / InstrumentValueData / QSettings
// // //  • Tab strip: Values | Vibration | EKF | AHRS  + gear + collapse
// // //  • 5×2 fixed telemetry grid, all values bind directly to activeVehicle
// // //  • Glass background (blur + tint + shimmer + border)
// // //  • Wire in FlyView.qml: mapSourceItem: flightMap
// // // ─────────────────────────────────────────────────────────────────────────────
// // import QtQuick
// // import QtQuick.Layouts
// // import Qt5Compat.GraphicalEffects
// // // Qt5: import QtGraphicalEffects

// // import QGroundControl
// // import QGroundControl.Controls

// // Item {
// //     id:             control

// //     // ── Keep these so FlyView.qml callers don't break ────────────────────────
// //     property var    settingsGroup:          null
// //     property var    specificVehicleForCard: null
// //     property real   extraWidth:             0
// //     property var    mapSourceItem:          null

// //     // ── Sizing ────────────────────────────────────────────────────────────────
// //     property real _tabH:   ScreenTools.defaultFontPixelHeight * 2.0
// //     property real _gridH:  ScreenTools.defaultFontPixelHeight * 5.6
// //     property real _totalW: Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)

// //     implicitWidth:  _locked ? _totalW           : _userW
// //     implicitHeight: _collapsed ? _tabH : _tabH + (_locked ? _gridH : _userGridH)

// //     Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
// //     Behavior on implicitWidth  { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

// //     clip:           true

// //     // ── Collapse state ────────────────────────────────────────────────────────
// //     property bool _collapsed:  false

// //     // ── Resize lock state ─────────────────────────────────────────────────────
// //     property bool _locked:     true

// //     // User-adjustable dimensions (start at defaults, clamped)
// //     property real _userW:      Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)
// //     property real _userGridH:  ScreenTools.defaultFontPixelHeight * 5.6

// //     property real _minW:       ScreenTools.defaultFontPixelHeight * 30
// //     property real _maxW:       mainWindow.width * 0.90
// //     property real _minGridH:   ScreenTools.defaultFontPixelHeight * 3.5
// //     property real _maxGridH:   ScreenTools.defaultFontPixelHeight * 12.0

// //     property var _v: QGroundControl.multiVehicleManager.activeVehicle

// //     // ── GLASS BACKGROUND ──────────────────────────────────────────────────────
// //     Item {
// //         id:           glassBg
// //         anchors.fill: parent

// //         layer.enabled: true
// //         layer.effect:  OpacityMask {
// //             maskSource: Rectangle {
// //                 width:  glassBg.width
// //                 height: glassBg.height
// //                 radius: 10
// //             }
// //         }

// //         ShaderEffectSource {
// //             id:           blurSource
// //             anchors.fill: parent
// //             sourceItem:   control.mapSourceItem
// //             live:         true
// //             visible:      false
// //         }

// //         FastBlur {
// //             anchors.fill: parent
// //             source:       blurSource
// //             radius:       52
// //         }

// //         Rectangle {
// //             anchors.fill: parent
// //             color:        Qt.rgba(0.04, 0.05, 0.09, 0.85)
// //         }

// //         Rectangle {
// //             anchors.top:   parent.top
// //             anchors.left:  parent.left
// //             anchors.right: parent.right
// //             height:        parent.height * 0.30
// //             gradient: Gradient {
// //                 GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.05) }
// //                 GradientStop { position: 1.0; color: "transparent" }
// //             }
// //         }
// //     }

// //     Rectangle {
// //         anchors.fill:  parent
// //         color:         "transparent"
// //         radius:        10
// //         border.color:  Qt.rgba(1,1,1,0.11)
// //         border.width:  1
// //         z:             1
// //     }

// //     // Top shimmer — using LinearGradient for Qt6 compatibility
// //     Item {
// //         anchors.top:              parent.top
// //         anchors.topMargin:        1
// //         anchors.horizontalCenter: parent.horizontalCenter
// //         width:                    parent.width * 0.55
// //         height:                   1
// //         z:                        2

// //         Rectangle { anchors.fill: parent; color: Qt.rgba(1,1,1,0.32) }

// //         LinearGradient {
// //             anchors.fill: parent
// //             start:        Qt.point(0, 0)
// //             end:          Qt.point(parent.width, 0)
// //             gradient: Gradient {
// //                 GradientStop { position: 0.0; color: "transparent" }
// //                 GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.32) }
// //                 GradientStop { position: 1.0; color: "transparent" }
// //             }
// //         }
// //     }

// //     // ── MAIN LAYOUT ───────────────────────────────────────────────────────────
// //     Column {
// //         anchors.fill: parent
// //         z:            3
// //         spacing:      0

// //         // ── TAB STRIP ─────────────────────────────────────────────────────────
// //         Item {
// //             width:  parent.width
// //             height: control._tabH

// //             Rectangle {
// //                 anchors.bottom: parent.bottom
// //                 anchors.left:   parent.left
// //                 anchors.right:  parent.right
// //                 height:         1
// //                 color:          Qt.rgba(1,1,1,0.08)
// //             }

// //             Row {
// //                 id:                     tabRow
// //                 anchors.left:           parent.left
// //                 anchors.leftMargin:     8
// //                 anchors.verticalCenter: parent.verticalCenter
// //                 spacing:                4
// //                 property int currentTab: 0

// //                 component TabBtn: Item {
// //                     id:             tb
// //                     property string label:    ""
// //                     property int    tabIndex: 0
// //                     property bool   active:   tabRow.currentTab === tabIndex
// //                     width:  lbl.contentWidth + ScreenTools.defaultFontPixelHeight * 1.8
// //                     height: control._tabH - 4

// //                     Rectangle {
// //                         anchors.fill:  parent
// //                         radius:        6
// //                         color:         tb.active ? Qt.rgba(0.0,0.83,1.0,0.16) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
// //                         border.color:  tb.active ? Qt.rgba(0.0,0.83,1.0,0.36) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.07)
// //                         border.width:  1
// //                         Behavior on color        { ColorAnimation { duration: 110 } }
// //                         Behavior on border.color { ColorAnimation { duration: 110 } }
// //                         Rectangle {
// //                             anchors.bottom:       parent.bottom
// //                             anchors.bottomMargin: -1
// //                             anchors.left:         parent.left; anchors.leftMargin:  8
// //                             anchors.right:        parent.right; anchors.rightMargin: 8
// //                             height:  2; radius: 1
// //                             visible: tb.active
// //                             color:   Qt.rgba(0.0,0.83,1.0,1.0)
// //                         }
// //                     }
// //                     Text {
// //                         id:                 lbl
// //                         anchors.centerIn:   parent
// //                         text:               tb.label
// //                         font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.82
// //                         font.weight:        tb.active ? Font.SemiBold : Font.Normal
// //                         font.letterSpacing: 0.3
// //                         color:              tb.active ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)
// //                         Behavior on color { ColorAnimation { duration: 110 } }
// //                     }
// //                     MouseArea { id: tbMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: tabRow.currentTab = tb.tabIndex }
// //                 }

// //                 TabBtn { label: qsTr("Values");    tabIndex: 0 }
// //                 TabBtn { label: qsTr("Vibration"); tabIndex: 1 }
// //                 TabBtn { label: qsTr("EKF");       tabIndex: 2 }
// //                 TabBtn { label: qsTr("AHRS");      tabIndex: 3 }
// //             }

// //             Row {
// //                 anchors.right:          parent.right
// //                 anchors.rightMargin:    10
// //                 anchors.verticalCenter: parent.verticalCenter
// //                 spacing:                6

// //                 component IconBtn: Rectangle {
// //                     property string ico: ""
// //                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
// //                     color:  ibMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
// //                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
// //                     Behavior on color { ColorAnimation { duration: 90 } }
// //                     Text { anchors.centerIn: parent; text: parent.ico; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82; color: Qt.rgba(1,1,1,0.82) }
// //                     MouseArea { id: ibMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor }
// //                 }

// //                 // ── Lock / Unlock resize button ───────────────────────────────
// //                 Rectangle {
// //                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
// //                     color:  lockMa.containsMouse
// //                                 ? (control._locked ? Qt.rgba(1.0,0.55,0.10,0.18) : Qt.rgba(0.0,0.83,1.0,0.18))
// //                                 : (control._locked ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0.0,0.83,1.0,0.10))
// //                     border.color: control._locked ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0.0,0.83,1.0,0.40)
// //                     border.width: 1
// //                     Behavior on color        { ColorAnimation { duration: 90 } }
// //                     Behavior on border.color { ColorAnimation { duration: 90 } }

// //                     Text {
// //                         anchors.centerIn: parent
// //                         // 🔒 locked  🔓 unlocked
// //                         text:           control._locked ? "🔒" : "🔓"
// //                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78
// //                     }
// //                     MouseArea {
// //                         id:           lockMa
// //                         anchors.fill: parent
// //                         hoverEnabled: true
// //                         cursorShape:  Qt.PointingHandCursor
// //                         onClicked: {
// //                             if (control._locked) {
// //                                 // Unlock — copy current fixed sizes into user vars
// //                                 control._userW     = control.width
// //                                 control._userGridH = control._gridH
// //                             }
// //                             control._locked = !control._locked
// //                         }
// //                     }
// //                 }

// //                 IconBtn { ico: "⚙" }

// //                 // ── Collapse / expand button ──────────────────────────────────
// //                 Rectangle {
// //                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
// //                     color:  collapseMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
// //                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
// //                     Behavior on color { ColorAnimation { duration: 90 } }

// //                     Text {
// //                         anchors.centerIn: parent
// //                         text:             "⌃"
// //                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
// //                         color:            Qt.rgba(1,1,1,0.82)
// //                         rotation:         control._collapsed ? 180 : 0
// //                         Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
// //                     }
// //                     MouseArea {
// //                         id:           collapseMa
// //                         anchors.fill: parent
// //                         hoverEnabled: true
// //                         cursorShape:  Qt.PointingHandCursor
// //                         onClicked:    control._collapsed = !control._collapsed
// //                     }
// //                 }
// //             }
// //         }

// //         // ── PAGE AREA ─────────────────────────────────────────────────────────
// //         Item {
// //             width:   parent.width
// //             height:  control._locked ? control._gridH : control._userGridH
// //             visible: !control._collapsed
// //             clip:    true

// //             // ── Shared cell component ─────────────────────────────────────────
// //             component TeleCell: Item {
// //                 id:             tc
// //                 property string ico:      "●"
// //                 property color  icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                 property string val:      "0.0"
// //                 property string unit:     ""
// //                 property string lbl:      ""

// //                 Rectangle {
// //                     anchors.right:        parent.right
// //                     anchors.top:          parent.top;    anchors.topMargin:    8
// //                     anchors.bottom:       parent.bottom; anchors.bottomMargin: 8
// //                     width: 1; color: Qt.rgba(1,1,1,0.07)
// //                 }

// //                 Row {
// //                     anchors.left:           parent.left
// //                     anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.9
// //                     anchors.verticalCenter: parent.verticalCenter
// //                     spacing:                ScreenTools.defaultFontPixelWidth * 0.7

// //                     Text {
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         text:           tc.ico
// //                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.30
// //                         font.weight:    Font.Bold
// //                         color:          tc.icoColor
// //                     }

// //                     Column {
// //                         anchors.verticalCenter: parent.verticalCenter
// //                         spacing:               1

// //                         Row {
// //                             spacing: 3
// //                             Text {
// //                                 id:             valTxt
// //                                 text:           tc.val
// //                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22
// //                                 font.weight:    Font.Medium
// //                                 color:          Qt.rgba(1,1,1,0.92)
// //                             }
// //                             Text {
// //                                 anchors.bottom:       valTxt.bottom
// //                                 anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 0.18
// //                                 text:           tc.unit
// //                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
// //                                 font.weight:    Font.Light
// //                                 color:          Qt.rgba(1,1,1,0.65)
// //                                 visible:        tc.unit !== ""
// //                             }
// //                         }

// //                         Text {
// //                             text:           tc.lbl
// //                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
// //                             font.weight:    Font.Light
// //                             color:          Qt.rgba(1,1,1,0.65)
// //                         }
// //                     }
// //                 }
// //             }

// //             // ── VALUES PAGE ───────────────────────────────────────────────────
// //             Item {
// //                 anchors.fill: parent
// //                 visible:      tabRow.currentTab === 0

// //                 // Mid row divider
// //                 Rectangle {
// //                     anchors.left:  parent.left;  anchors.leftMargin:  12
// //                     anchors.right: parent.right; anchors.rightMargin: 12
// //                     y:             parent.height / 2
// //                     height:        1
// //                     color:         Qt.rgba(1,1,1,0.07)
// //                     z:             10
// //                 }

// //                 // Row 1
// //                 Row {
// //                     anchors.top:   parent.top
// //                     anchors.left:  parent.left
// //                     anchors.right: parent.right
// //                     height:        parent.height / 2

// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "⬆"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                         val:  _v ? _v.altitudeRelative.value.toFixed(1) : "0.0"
// //                         unit: _v ? _v.altitudeRelative.units : "ft"
// //                         lbl:  qsTr("Alt (Rel)")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "↕"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                         val:  _v ? _v.climbRate.value.toFixed(1) : "0.0"
// //                         unit: _v ? _v.climbRate.units : "mph"
// //                         lbl:  qsTr("Climb Rate")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "⏱"; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
// //                         val:  _v ? _v.flightTime : "0:00:00"
// //                         unit: ""; lbl: qsTr("Flight Time")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "◈"; icoColor: Qt.rgba(1.0,0.80,0.0,1.0)
// //                         val:  _v ? _v.heading.value.toFixed(0) : "0"
// //                         unit: "°"; lbl: qsTr("Heading")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "⚡"
// //                         icoColor: {
// //                             if (!_v) return Qt.rgba(0.0,0.83,1.0,1.0)
// //                             var p = _v.battery.percentRemaining.value
// //                             return p < 20 ? Qt.rgba(1.0,0.22,0.35,1.0) : p < 40 ? Qt.rgba(1.0,0.55,0.10,1.0) : Qt.rgba(0.0,1.0,0.55,1.0)
// //                         }
// //                         val:  _v ? _v.battery.percentRemaining.value.toFixed(0) : "0"
// //                         unit: "%"; lbl: qsTr("Battery")
// //                     }
// //                 }

// //                 // Row 2
// //                 Row {
// //                     anchors.bottom: parent.bottom
// //                     anchors.left:   parent.left
// //                     anchors.right:  parent.right
// //                     height:         parent.height / 2

// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "⌂"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                         val:  _v ? _v.distanceToHome.value.toFixed(1) : "0.0"
// //                         unit: _v ? _v.distanceToHome.units : "ft"
// //                         lbl:  qsTr("Distance to Home")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "➤"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                         val:  _v ? _v.groundSpeed.value.toFixed(1) : "0.0"
// //                         unit: _v ? _v.groundSpeed.units : "mph"
// //                         lbl:  qsTr("Ground Speed")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "⇌"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                         val:  _v ? _v.flightDistance.value.toFixed(1) : "0.0"
// //                         unit: _v ? _v.flightDistance.units : "ft"
// //                         lbl:  qsTr("Flight Distance")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "◉"; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
// //                         val:  _v ? _v.gpsSatelliteCount.value.toFixed(0) : "0"
// //                         unit: "sat"; lbl: qsTr("GPS Satellites")
// //                     }
// //                     TeleCell {
// //                         width: parent.width/5; height: parent.height
// //                         ico: "≋"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
// //                         val:  _v ? _v.airSpeed.value.toFixed(1) : "0.0"
// //                         unit: _v ? _v.airSpeed.units : "mph"
// //                         lbl:  qsTr("Airspeed")
// //                     }
// //                 }
// //             }

// //             // ── VIBRATION PAGE ────────────────────────────────────────────────
// //             Item {
// //                 anchors.fill: parent
// //                 visible:      tabRow.currentTab === 1

// //                 component VibCell: Item {
// //                     property string lbl: ""; property string val: "0"
// //                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
// //                     Column { anchors.centerIn: parent; spacing: 2
// //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
// //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
// //                     }
// //                 }

// //                 Row {
// //                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe X"; val: _v ? _v.vibration.xAxis.value.toFixed(2) : "0" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Y"; val: _v ? _v.vibration.yAxis.value.toFixed(2) : "0" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Z"; val: _v ? _v.vibration.zAxis.value.toFixed(2) : "0" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 0"; val: _v ? _v.vibration.clipCount1.value.toFixed(0) : "0" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 1"; val: _v ? _v.vibration.clipCount2.value.toFixed(0) : "0" }
// //                 }
// //                 Row {
// //                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 2"; val: _v ? _v.vibration.clipCount3.value.toFixed(0) : "0" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// //                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// //                 }
// //             }

// //             // ── EKF PAGE ──────────────────────────────────────────────────────
// //             Item {
// //                 anchors.fill: parent
// //                 visible:      tabRow.currentTab === 2

// //                 component EkfCell: Item {
// //                     property string lbl: ""; property string val: "0"; property color vc: Qt.rgba(0.0,0.83,1.0,1.0)
// //                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
// //                     Column { anchors.centerIn: parent; spacing: 2
// //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: parent.parent.vc }
// //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
// //                     }
// //                 }

// //                 Row {
// //                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Horiz";  vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.velRatio.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Vert";   vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.posVertRatio.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos Horiz";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizRatio.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Mag Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.magRatio.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Hagl Ratio"; vc: Qt.rgba(1.0,0.80,0.0,1.0); val: _v ? _v.estimatorStatus.haglRatio.value.toFixed(2) : "0" }
// //                 }
// //                 Row {
// //                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Tas Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.tasRatio.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos H Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizAccuracy.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos V Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posVertAccuracy.value.toFixed(2) : "0" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// //                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
// //                 }
// //             }

// //             // ── AHRS PAGE ─────────────────────────────────────────────────────
// //             Item {
// //                 anchors.fill: parent
// //                 visible:      tabRow.currentTab === 3

// //                 component AhrsCell: Item {
// //                     property string lbl: ""; property string val: "0"
// //                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
// //                     Column { anchors.centerIn: parent; spacing: 2
// //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
// //                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
// //                     }
// //                 }

// //                 Row {
// //                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll (°)";   val: _v ? _v.roll.value.toFixed(1)    : "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch (°)";  val: _v ? _v.pitch.value.toFixed(1)   : "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw (°)";    val: _v ? _v.heading.value.toFixed(1) : "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll Rate";  val: _v ? _v.rollRate.value.toFixed(1)  : "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch Rate"; val: _v ? _v.pitchRate.value.toFixed(1) : "0" }
// //                 }
// //                 Row {
// //                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw Rate"; val: _v ? _v.yawRate.value.toFixed(1) : "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel X";  val: "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Y";  val: "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Z";  val: "0" }
// //                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "";         val: "" }
// //                 }
// //             }
// //         }
// //     }

// //     // ── RESIZE HANDLES (visible only when unlocked) ───────────────────────────

// //     // Right edge — drag to resize width
// //     Item {
// //         id:      rightHandle
// //         visible: !control._locked && !control._collapsed
// //         anchors.right:  parent.right
// //         anchors.top:    parent.top
// //         anchors.bottom: parent.bottom
// //         width:          12

// //         // Visible grip bar
// //         Rectangle {
// //             anchors.centerIn:   parent
// //             width:              4
// //             height:             parent.height * 0.35
// //             radius:             2
// //             color:              rightDrag.containsMouse || rightDrag.drag.active
// //                                     ? Qt.rgba(0.0,0.83,1.0,0.90)
// //                                     : Qt.rgba(0.0,0.83,1.0,0.35)
// //             Behavior on color { ColorAnimation { duration: 80 } }

// //             // Three grip dots
// //             Column {
// //                 anchors.centerIn: parent
// //                 spacing:          3
// //                 Repeater {
// //                     model: 3
// //                     Rectangle { width: 4; height: 1; radius: 1; color: Qt.rgba(1,1,1,0.50) }
// //                 }
// //             }
// //         }

// //         MouseArea {
// //             id:             rightDrag
// //             anchors.fill:   parent
// //             hoverEnabled:   true
// //             cursorShape:    Qt.SizeHorCursor
// //             drag.target:    rightDragProxy
// //             drag.axis:      Drag.XAxis

// //             Item { id: rightDragProxy }

// //             property real _startX: 0
// //             property real _startW: 0

// //             onPressed: {
// //                 _startX = mouseX + rightHandle.x
// //                 _startW = control._userW
// //             }
// //             onMouseXChanged: {
// //                 if (pressed) {
// //                     var delta = (mouseX + rightHandle.x) - _startX
// //                     control._userW = Math.max(control._minW,
// //                                      Math.min(control._maxW, _startW + delta))
// //                 }
// //             }
// //         }
// //     }

// //     // Bottom edge — drag to resize height
// //     Item {
// //         id:      bottomHandle
// //         visible: !control._locked && !control._collapsed
// //         anchors.bottom: parent.bottom
// //         anchors.left:   parent.left
// //         anchors.right:  parent.right
// //         height:         12

// //         Rectangle {
// //             anchors.centerIn: parent
// //             width:            parent.width * 0.18
// //             height:           4
// //             radius:           2
// //             color:            bottomDrag.containsMouse || bottomDrag.pressed
// //                                   ? Qt.rgba(0.0,0.83,1.0,0.90)
// //                                   : Qt.rgba(0.0,0.83,1.0,0.35)
// //             Behavior on color { ColorAnimation { duration: 80 } }

// //             // Three grip dots
// //             Row {
// //                 anchors.centerIn: parent
// //                 spacing:          3
// //                 Repeater {
// //                     model: 3
// //                     Rectangle { width: 1; height: 4; radius: 1; color: Qt.rgba(1,1,1,0.50) }
// //                 }
// //             }
// //         }

// //         MouseArea {
// //             id:           bottomDrag
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             cursorShape:  Qt.SizeVerCursor

// //             property real _startY: 0
// //             property real _startH: 0

// //             onPressed: {
// //                 _startY = mouseY + bottomHandle.y
// //                 _startH = control._userGridH
// //             }
// //             onMouseYChanged: {
// //                 if (pressed) {
// //                     var delta = (mouseY + bottomHandle.y) - _startY
// //                     control._userGridH = Math.max(control._minGridH,
// //                                          Math.min(control._maxGridH, _startH + delta))
// //                 }
// //             }
// //         }
// //     }

// //     // Bottom-right corner — drag both axes simultaneously
// //     Item {
// //         id:      cornerHandle
// //         visible: !control._locked && !control._collapsed
// //         anchors.right:  parent.right
// //         anchors.bottom: parent.bottom
// //         width:   16; height: 16

// //         Rectangle {
// //             anchors.fill:  parent
// //             radius:        4
// //             color:         cornerDrag.containsMouse || cornerDrag.pressed
// //                                ? Qt.rgba(0.0,0.83,1.0,0.25)
// //                                : Qt.rgba(0.0,0.83,1.0,0.10)
// //             border.color:  Qt.rgba(0.0,0.83,1.0,0.40)
// //             border.width:  1
// //             Behavior on color { ColorAnimation { duration: 80 } }

// //             // Corner grip lines
// //             Canvas {
// //                 anchors.fill:    parent
// //                 anchors.margins: 3
// //                 onPaint: {
// //                     var ctx = getContext("2d")
// //                     ctx.strokeStyle = Qt.rgba(0.0,0.83,1.0,0.70)
// //                     ctx.lineWidth   = 1.5
// //                     ctx.beginPath()
// //                     ctx.moveTo(width, 0); ctx.lineTo(width, height); ctx.lineTo(0, height)
// //                     ctx.moveTo(width, height*0.5); ctx.lineTo(width*0.5, height)
// //                     ctx.stroke()
// //                 }
// //             }
// //         }

// //         MouseArea {
// //             id:           cornerDrag
// //             anchors.fill: parent
// //             hoverEnabled: true
// //             cursorShape:  Qt.SizeFDiagCursor

// //             property real _startX: 0; property real _startY: 0
// //             property real _startW: 0; property real _startH: 0

// //             onPressed: {
// //                 _startX = mouseX + cornerHandle.x
// //                 _startY = mouseY + cornerHandle.y
// //                 _startW = control._userW
// //                 _startH = control._userGridH
// //             }
// //             onMouseXChanged: {
// //                 if (pressed) {
// //                     var dx = (mouseX + cornerHandle.x) - _startX
// //                     control._userW = Math.max(control._minW, Math.min(control._maxW, _startW + dx))
// //                 }
// //             }
// //             onMouseYChanged: {
// //                 if (pressed) {
// //                     var dy = (mouseY + cornerHandle.y) - _startY
// //                     control._userGridH = Math.max(control._minGridH, Math.min(control._maxGridH, _startH + dy))
// //                 }
// //             }
// //         }
// //     }
// // }


// ─────────────────────────────────────────────────────────────────────────────
//  TelemetryValuesBar.qml  —  BonVGroundStation
//  File: src/FlyView/TelemetryValuesBar.qml
//
//  COMPLETE REPLACEMENT — self-contained fixed layout
//  • No dependency on HorizontalFactValueGrid / InstrumentValueData / QSettings
//  • Tab strip: Values | Vibration | EKF | AHRS  + gear + collapse
//  • 5×2 fixed telemetry grid, all values bind directly to activeVehicle
//  • Glass background (blur + tint + shimmer + border)
//  • Wire in FlyView.qml: mapSourceItem: flightMap
// ─────────────────────────────────────────────────────────────────────────────
// import QtQuick
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects
// // Qt5: import QtGraphicalEffects

// import QGroundControl
// import QGroundControl.Controls


// Item {
//     id:             control

//     // ── Keep these so FlyView.qml callers don't break ────────────────────────
//     property var    settingsGroup:          null
//     property var    specificVehicleForCard: null
//     property real   extraWidth:             0
//     property var    mapSourceItem:          null

//     // ── Sizing ────────────────────────────────────────────────────────────────
//     property real _tabH:   ScreenTools.defaultFontPixelHeight * 2.0
//     property real _gridH:  ScreenTools.defaultFontPixelHeight * 5.6
//     property real _totalW: Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)

//     implicitWidth:  _locked ? _totalW           : _userW
//     implicitHeight: _collapsed ? _tabH : _tabH + (_locked ? _gridH : _userGridH)

//     Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
//     Behavior on implicitWidth  { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

//     clip:           true

//     // ── Collapse state ────────────────────────────────────────────────────────
//     property bool _collapsed:  false

//     // ── Resize lock state ─────────────────────────────────────────────────────
//     property bool _locked:     true

//     // Drag position — stored when locked so bar stays put
//     property real _posX:       -1   // -1 = not yet set, use parent anchors
//     property real _posY:       -1

//     // Signal emitted when lock toggles so FlyView.qml can clear/restore anchors
//     signal lockChanged(bool locked)
//     signal dragPositionChanged(real px, real py)

//     // User-adjustable dimensions (start at defaults, clamped)
//     property real _userW:      Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)
//     property real _userGridH:  ScreenTools.defaultFontPixelHeight * 5.6

//     property real _minW:       ScreenTools.defaultFontPixelHeight * 30
//     property real _maxW:       mainWindow.width * 0.90
//     property real _minGridH:   ScreenTools.defaultFontPixelHeight * 3.5
//     property real _maxGridH:   ScreenTools.defaultFontPixelHeight * 12.0

//     property var _v: QGroundControl.multiVehicleManager.activeVehicle

//     // ── GLASS BACKGROUND ──────────────────────────────────────────────────────
//     Item {
//         id:           glassBg
//         anchors.fill: parent

//         layer.enabled: true
//         layer.effect:  OpacityMask {
//             maskSource: Rectangle {
//                 width:  glassBg.width
//                 height: glassBg.height
//                 radius: 10
//             }
//         }

//         ShaderEffectSource {
//             id:           blurSource
//             anchors.fill: parent
//             sourceItem:   control.mapSourceItem
//             live:         true
//             visible:      false
//         }

//         FastBlur {
//             anchors.fill: parent
//             source:       blurSource
//             radius:       52
//         }

//         Rectangle {
//             anchors.fill: parent
//             color:        Qt.rgba(0.04, 0.05, 0.09, 0.85)
//         }

//         Rectangle {
//             anchors.top:   parent.top
//             anchors.left:  parent.left
//             anchors.right: parent.right
//             height:        parent.height * 0.30
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.05) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }

//     Rectangle {
//         anchors.fill:  parent
//         color:         "transparent"
//         radius:        10
//         border.color:  Qt.rgba(1,1,1,0.11)
//         border.width:  1
//         z:             1
//     }

//     // Top shimmer — using LinearGradient for Qt6 compatibility
//     Item {
//         anchors.top:              parent.top
//         anchors.topMargin:        1
//         anchors.horizontalCenter: parent.horizontalCenter
//         width:                    parent.width * 0.55
//         height:                   1
//         z:                        2

//         Rectangle { anchors.fill: parent; color: Qt.rgba(1,1,1,0.32) }

//         LinearGradient {
//             anchors.fill: parent
//             start:        Qt.point(0, 0)
//             end:          Qt.point(parent.width, 0)
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: "transparent" }
//                 GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.32) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }

//     // ── MAIN LAYOUT ───────────────────────────────────────────────────────────
//     Column {
//         anchors.fill: parent
//         z:            3
//         spacing:      0

//         // ── TAB STRIP ─────────────────────────────────────────────────────────
//         Item {
//             id:     tabStrip
//             width:  parent.width
//             height: control._tabH

//             // Bottom separator line
//             Rectangle {
//                 anchors.bottom: parent.bottom
//                 anchors.left:   parent.left
//                 anchors.right:  parent.right
//                 height:         1
//                 color:          Qt.rgba(1,1,1,0.08)
//             }

//             // ── Drag handle (whole tab strip, only active when unlocked) ───────
//             MouseArea {
//                 id:           dragHandle
//                 anchors.fill: parent
//                 enabled:      !control._locked
//                 cursorShape:  Qt.SizeAllCursor
//                 z:            20

//                 property real _grabX: 0
//                 property real _grabY: 0

//                 onPressed: (mouse) => {
//                     var p = mapToItem(control.parent, mouse.x, mouse.y)
//                     _grabX = p.x - control.x
//                     _grabY = p.y - control.y
//                 }
//                 onPositionChanged: (mouse) => {
//                     if (!pressed) return
//                     var p  = mapToItem(control.parent, mouse.x, mouse.y)
//                     var nx = Math.max(0, Math.min(control.parent.width  - control.width,  p.x - _grabX))
//                     var ny = Math.max(0, Math.min(control.parent.height - control.height, p.y - _grabY))
//                     control.dragPositionChanged(nx, ny)
//                 }
//             }

//             // Drag hint — 6 cyan dots centred, only when unlocked
//             Row {
//                 anchors.centerIn: parent
//                 spacing:          4
//                 visible:          !control._locked
//                 opacity:          0.50
//                 z:                5
//                 Repeater {
//                     model: 6
//                     Rectangle { width: 3; height: 3; radius: 1.5; color: Qt.rgba(0.0,0.83,1.0,1.0) }
//                 }
//             }

//             // ── Tab buttons (left side) ────────────────────────────────────────
//             Row {
//                 id:                     tabRow
//                 anchors.left:           parent.left
//                 anchors.leftMargin:     8
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing:                4
//                 property int currentTab: 0

//                 component TabBtn: Item {
//                     id:             tb
//                     property string label:    ""
//                     property int    tabIndex: 0
//                     property bool   active:   tabRow.currentTab === tabIndex
//                     width:  lbl.contentWidth + ScreenTools.defaultFontPixelHeight * 1.8
//                     height: control._tabH - 4

//                     Rectangle {
//                         anchors.fill:  parent
//                         radius:        6
//                         color:         tb.active ? Qt.rgba(0.0,0.83,1.0,0.16) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
//                         border.color:  tb.active ? Qt.rgba(0.0,0.83,1.0,0.36) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.07)
//                         border.width:  1
//                         Behavior on color        { ColorAnimation { duration: 110 } }
//                         Behavior on border.color { ColorAnimation { duration: 110 } }
//                         // Active underline
//                         Rectangle {
//                             anchors.bottom:       parent.bottom
//                             anchors.bottomMargin: -1
//                             anchors.left:         parent.left;  anchors.leftMargin:  8
//                             anchors.right:        parent.right; anchors.rightMargin: 8
//                             height: 2; radius: 1
//                             visible: tb.active
//                             color:   Qt.rgba(0.0,0.83,1.0,1.0)
//                         }
//                     }
//                     Text {
//                         id:                 lbl
//                         anchors.centerIn:   parent
//                         text:               tb.label
//                         font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.82
//                         font.weight:        tb.active ? Font.SemiBold : Font.Normal
//                         font.letterSpacing: 0.3
//                         color:              tb.active ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)
//                         Behavior on color { ColorAnimation { duration: 110 } }
//                     }
//                     MouseArea {
//                         id:           tbMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         // Only intercept clicks when locked; drag handle takes over when unlocked
//                         enabled:      control._locked
//                         onClicked:    tabRow.currentTab = tb.tabIndex
//                     }
//                 }

//                 TabBtn { label: qsTr("Values");    tabIndex: 0 }
//                 TabBtn { label: qsTr("Vibration"); tabIndex: 1 }
//                 TabBtn { label: qsTr("EKF");       tabIndex: 2 }
//                 TabBtn { label: qsTr("AHRS");      tabIndex: 3 }
//             }

//             // ── Icon buttons (right side) ──────────────────────────────────────
//             Row {
//                 anchors.right:          parent.right
//                 anchors.rightMargin:    10
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing:                6
//                 z:                      25   // above drag handle so they stay clickable

//                 component IconBtn: Rectangle {
//                     property string ico: ""
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  ibMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
//                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
//                     Behavior on color { ColorAnimation { duration: 90 } }
//                     Text { anchors.centerIn: parent; text: parent.ico; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82; color: Qt.rgba(1,1,1,0.82) }
//                     MouseArea { id: ibMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor }
//                 }

//                 // 🔒 / 🔓 Lock button
//                 Rectangle {
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  lockMa.containsMouse
//                                 ? (control._locked ? Qt.rgba(1.0,0.55,0.10,0.18) : Qt.rgba(0.0,0.83,1.0,0.18))
//                                 : (control._locked ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0.0,0.83,1.0,0.10))
//                     border.color: control._locked ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0.0,0.83,1.0,0.40)
//                     border.width: 1
//                     Behavior on color        { ColorAnimation { duration: 90 } }
//                     Behavior on border.color { ColorAnimation { duration: 90 } }
//                     Text {
//                         anchors.centerIn: parent
//                         text:             control._locked ? "🔒" : "🔓"
//                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.78
//                     }
//                     MouseArea {
//                         id:           lockMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         onClicked: {
//                             if (control._locked) {
//                                 // About to unlock — snapshot current size
//                                 control._userW     = control.width
//                                 control._userGridH = control._gridH
//                             }
//                             control._locked = !control._locked
//                             control.lockChanged(control._locked)
//                         }
//                     }
//                 }

//                 // ⚙ Settings
//                 IconBtn { ico: "⚙" }

//                 // ⌃ Collapse / expand
//                 Rectangle {
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  collapseMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
//                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
//                     Behavior on color { ColorAnimation { duration: 90 } }
//                     Text {
//                         anchors.centerIn: parent
//                         text:             "⌃"
//                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
//                         color:            Qt.rgba(1,1,1,0.82)
//                         rotation:         control._collapsed ? 180 : 0
//                         Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
//                     }
//                     MouseArea {
//                         id:           collapseMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         onClicked:    control._collapsed = !control._collapsed
//                     }
//                 }
//             }
//         }

//         // ── PAGE AREA ─────────────────────────────────────────────────────────
//         Item {
//             width:   parent.width
//             height:  control._locked ? control._gridH : control._userGridH
//             visible: !control._collapsed
//             clip:    true

//             // ── Shared cell component ─────────────────────────────────────────
//             component TeleCell: Item {
//                 id:             tc
//                 property string ico:      "●"
//                 property color  icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                 property string val:      "0.0"
//                 property string unit:     ""
//                 property string lbl:      ""

//                 Rectangle {
//                     anchors.right:        parent.right
//                     anchors.top:          parent.top;    anchors.topMargin:    8
//                     anchors.bottom:       parent.bottom; anchors.bottomMargin: 8
//                     width: 1; color: Qt.rgba(1,1,1,0.07)
//                 }

//                 Row {
//                     anchors.left:           parent.left
//                     anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.9
//                     anchors.verticalCenter: parent.verticalCenter
//                     spacing:                ScreenTools.defaultFontPixelWidth * 0.7

//                     Text {
//                         anchors.verticalCenter: parent.verticalCenter
//                         text:           tc.ico
//                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.30
//                         font.weight:    Font.Bold
//                         color:          tc.icoColor
//                     }

//                     Column {
//                         anchors.verticalCenter: parent.verticalCenter
//                         spacing:               1

//                         Row {
//                             spacing: 3
//                             Text {
//                                 id:             valTxt
//                                 text:           tc.val
//                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22
//                                 font.weight:    Font.Medium
//                                 color:          Qt.rgba(1,1,1,0.92)
//                             }
//                             Text {
//                                 anchors.bottom:       valTxt.bottom
//                                 anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 0.18
//                                 text:           tc.unit
//                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
//                                 font.weight:    Font.Light
//                                 color:          Qt.rgba(1,1,1,0.65)
//                                 visible:        tc.unit !== ""
//                             }
//                         }

//                         Text {
//                             text:           tc.lbl
//                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
//                             font.weight:    Font.Light
//                             color:          Qt.rgba(1,1,1,0.65)
//                         }
//                     }
//                 }
//             }

//             // ── VALUES PAGE ───────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 0

//                 // Mid row divider
//                 Rectangle {
//                     anchors.left:  parent.left;  anchors.leftMargin:  12
//                     anchors.right: parent.right; anchors.rightMargin: 12
//                     y:             parent.height / 2
//                     height:        1
//                     color:         Qt.rgba(1,1,1,0.07)
//                     z:             10
//                 }

//                 // Row 1
//                 Row {
//                     anchors.top:   parent.top
//                     anchors.left:  parent.left
//                     anchors.right: parent.right
//                     height:        parent.height / 2

//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "⬆"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                         val:  _v ? _v.altitudeRelative.value.toFixed(1) : "0.0"
//                         unit: _v ? _v.altitudeRelative.units : "ft"
//                         lbl:  qsTr("Alt (Rel)")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "↕"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                         val:  _v ? _v.climbRate.value.toFixed(1) : "0.0"
//                         unit: _v ? _v.climbRate.units : "mph"
//                         lbl:  qsTr("Climb Rate")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "⏱"; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
//                         val:  _v ? _v.flightTime : "0:00:00"
//                         unit: ""; lbl: qsTr("Flight Time")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "◈"; icoColor: Qt.rgba(1.0,0.80,0.0,1.0)
//                         val:  _v ? _v.heading.value.toFixed(0) : "0"
//                         unit: "°"; lbl: qsTr("Heading")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "⚡"
//                         icoColor: {
//                             if (!_v) return Qt.rgba(0.0,0.83,1.0,1.0)
//                             var p = _v.battery.percentRemaining.value
//                             return p < 20 ? Qt.rgba(1.0,0.22,0.35,1.0) : p < 40 ? Qt.rgba(1.0,0.55,0.10,1.0) : Qt.rgba(0.0,1.0,0.55,1.0)
//                         }
//                         val:  _v ? _v.battery.percentRemaining.value.toFixed(0) : "0"
//                         unit: "%"; lbl: qsTr("Battery")
//                     }
//                 }

//                 // Row 2
//                 Row {
//                     anchors.bottom: parent.bottom
//                     anchors.left:   parent.left
//                     anchors.right:  parent.right
//                     height:         parent.height / 2

//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "⌂"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                         val:  _v ? _v.distanceToHome.value.toFixed(1) : "0.0"
//                         unit: _v ? _v.distanceToHome.units : "ft"
//                         lbl:  qsTr("Distance to Home")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "➤"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                         val:  _v ? _v.groundSpeed.value.toFixed(1) : "0.0"
//                         unit: _v ? _v.groundSpeed.units : "mph"
//                         lbl:  qsTr("Ground Speed")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "⇌"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                         val:  _v ? _v.flightDistance.value.toFixed(1) : "0.0"
//                         unit: _v ? _v.flightDistance.units : "ft"
//                         lbl:  qsTr("Flight Distance")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "◉"; icoColor: Qt.rgba(0.0,1.0,0.55,1.0)
//                         val:  _v ? _v.gpsSatelliteCount.value.toFixed(0) : "0"
//                         unit: "sat"; lbl: qsTr("GPS Satellites")
//                     }
//                     TeleCell {
//                         width: parent.width/5; height: parent.height
//                         ico: "≋"; icoColor: Qt.rgba(0.0,0.83,1.0,1.0)
//                         val:  _v ? _v.airSpeed.value.toFixed(1) : "0.0"
//                         unit: _v ? _v.airSpeed.units : "mph"
//                         lbl:  qsTr("Airspeed")
//                     }
//                 }
//             }

//             // ── VIBRATION PAGE ────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 1

//                 component VibCell: Item {
//                     property string lbl: ""; property string val: "0"
//                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
//                     Column { anchors.centerIn: parent; spacing: 2
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
//                     }
//                 }

//                 Row {
//                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe X"; val: _v ? _v.vibration.xAxis.value.toFixed(2) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Y"; val: _v ? _v.vibration.yAxis.value.toFixed(2) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Z"; val: _v ? _v.vibration.zAxis.value.toFixed(2) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 0"; val: _v ? _v.vibration.clipCount1.value.toFixed(0) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 1"; val: _v ? _v.vibration.clipCount2.value.toFixed(0) : "0" }
//                 }
//                 Row {
//                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 2"; val: _v ? _v.vibration.clipCount3.value.toFixed(0) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                 }
//             }

//             // ── EKF PAGE ──────────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 2

//                 component EkfCell: Item {
//                     property string lbl: ""; property string val: "0"; property color vc: Qt.rgba(0.0,0.83,1.0,1.0)
//                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
//                     Column { anchors.centerIn: parent; spacing: 2
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: parent.parent.vc }
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
//                     }
//                 }

//                 Row {
//                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Horiz";  vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.velRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Vert";   vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.posVertRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos Horiz";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Mag Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.magRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Hagl Ratio"; vc: Qt.rgba(1.0,0.80,0.0,1.0); val: _v ? _v.estimatorStatus.haglRatio.value.toFixed(2) : "0" }
//                 }
//                 Row {
//                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Tas Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.tasRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos H Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizAccuracy.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos V Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posVertAccuracy.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                 }
//             }

//             // ── AHRS PAGE ─────────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 3

//                 component AhrsCell: Item {
//                     property string lbl: ""; property string val: "0"
//                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
//                     Column { anchors.centerIn: parent; spacing: 2
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
//                     }
//                 }

//                 Row {
//                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll (°)";   val: _v ? _v.roll.value.toFixed(1)    : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch (°)";  val: _v ? _v.pitch.value.toFixed(1)   : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw (°)";    val: _v ? _v.heading.value.toFixed(1) : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll Rate";  val: _v ? _v.rollRate.value.toFixed(1)  : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch Rate"; val: _v ? _v.pitchRate.value.toFixed(1) : "0" }
//                 }
//                 Row {
//                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw Rate"; val: _v ? _v.yawRate.value.toFixed(1) : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel X";  val: "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Y";  val: "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Z";  val: "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "";         val: "" }
//                 }
//             }
//         }
//     }

//     // ── RESIZE HANDLES (visible only when unlocked) ───────────────────────────

//     // Right edge — drag to resize width
//     Item {
//         id:      rightHandle
//         visible: !control._locked && !control._collapsed
//         anchors.right:  parent.right
//         anchors.top:    parent.top
//         anchors.bottom: parent.bottom
//         width:          12

//         // Visible grip bar
//         Rectangle {
//             anchors.centerIn:   parent
//             width:              4
//             height:             parent.height * 0.35
//             radius:             2
//             color:              rightDrag.containsMouse || rightDrag.drag.active
//                                     ? Qt.rgba(0.0,0.83,1.0,0.90)
//                                     : Qt.rgba(0.0,0.83,1.0,0.35)
//             Behavior on color { ColorAnimation { duration: 80 } }

//             // Three grip dots
//             Column {
//                 anchors.centerIn: parent
//                 spacing:          3
//                 Repeater {
//                     model: 3
//                     Rectangle { width: 4; height: 1; radius: 1; color: Qt.rgba(1,1,1,0.50) }
//                 }
//             }
//         }

//         MouseArea {
//             id:             rightDrag
//             anchors.fill:   parent
//             hoverEnabled:   true
//             cursorShape:    Qt.SizeHorCursor
//             drag.target:    rightDragProxy
//             drag.axis:      Drag.XAxis

//             Item { id: rightDragProxy }

//             property real _startX: 0
//             property real _startW: 0

//             onPressed: {
//                 _startX = mouseX + rightHandle.x
//                 _startW = control._userW
//             }
//             onMouseXChanged: {
//                 if (pressed) {
//                     var delta = (mouseX + rightHandle.x) - _startX
//                     control._userW = Math.max(control._minW,
//                                      Math.min(control._maxW, _startW + delta))
//                 }
//             }
//         }
//     }

//     // Bottom edge — drag to resize height
//     Item {
//         id:      bottomHandle
//         visible: !control._locked && !control._collapsed
//         anchors.bottom: parent.bottom
//         anchors.left:   parent.left
//         anchors.right:  parent.right
//         height:         12

//         Rectangle {
//             anchors.centerIn: parent
//             width:            parent.width * 0.18
//             height:           4
//             radius:           2
//             color:            bottomDrag.containsMouse || bottomDrag.pressed
//                                   ? Qt.rgba(0.0,0.83,1.0,0.90)
//                                   : Qt.rgba(0.0,0.83,1.0,0.35)
//             Behavior on color { ColorAnimation { duration: 80 } }

//             // Three grip dots
//             Row {
//                 anchors.centerIn: parent
//                 spacing:          3
//                 Repeater {
//                     model: 3
//                     Rectangle { width: 1; height: 4; radius: 1; color: Qt.rgba(1,1,1,0.50) }
//                 }
//             }
//         }

//         MouseArea {
//             id:           bottomDrag
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape:  Qt.SizeVerCursor

//             property real _startY: 0
//             property real _startH: 0

//             onPressed: {
//                 _startY = mouseY + bottomHandle.y
//                 _startH = control._userGridH
//             }
//             onMouseYChanged: {
//                 if (pressed) {
//                     var delta = (mouseY + bottomHandle.y) - _startY
//                     control._userGridH = Math.max(control._minGridH,
//                                          Math.min(control._maxGridH, _startH + delta))
//                 }
//             }
//         }
//     }

//     // Bottom-right corner — drag both axes simultaneously
//     Item {
//         id:      cornerHandle
//         visible: !control._locked && !control._collapsed
//         anchors.right:  parent.right
//         anchors.bottom: parent.bottom
//         width:   16; height: 16

//         Rectangle {
//             anchors.fill:  parent
//             radius:        4
//             color:         cornerDrag.containsMouse || cornerDrag.pressed
//                                ? Qt.rgba(0.0,0.83,1.0,0.25)
//                                : Qt.rgba(0.0,0.83,1.0,0.10)
//             border.color:  Qt.rgba(0.0,0.83,1.0,0.40)
//             border.width:  1
//             Behavior on color { ColorAnimation { duration: 80 } }

//             // Corner grip lines
//             Canvas {
//                 anchors.fill:    parent
//                 anchors.margins: 3
//                 onPaint: {
//                     var ctx = getContext("2d")
//                     ctx.strokeStyle = Qt.rgba(0.0,0.83,1.0,0.70)
//                     ctx.lineWidth   = 1.5
//                     ctx.beginPath()
//                     ctx.moveTo(width, 0); ctx.lineTo(width, height); ctx.lineTo(0, height)
//                     ctx.moveTo(width, height*0.5); ctx.lineTo(width*0.5, height)
//                     ctx.stroke()
//                 }
//             }
//         }

//         MouseArea {
//             id:           cornerDrag
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape:  Qt.SizeFDiagCursor

//             property real _startX: 0; property real _startY: 0
//             property real _startW: 0; property real _startH: 0

//             onPressed: {
//                 _startX = mouseX + cornerHandle.x
//                 _startY = mouseY + cornerHandle.y
//                 _startW = control._userW
//                 _startH = control._userGridH
//             }
//             onMouseXChanged: {
//                 if (pressed) {
//                     var dx = (mouseX + cornerHandle.x) - _startX
//                     control._userW = Math.max(control._minW, Math.min(control._maxW, _startW + dx))
//                 }
//             }
//             onMouseYChanged: {
//                 if (pressed) {
//                     var dy = (mouseY + cornerHandle.y) - _startY
//                     control._userGridH = Math.max(control._minGridH, Math.min(control._maxGridH, _startH + dy))
//                 }
//             }
//         }
//     }
// }






// // ADDED GEAR CODE ****************************
// //                 ****************************
// //                 ****************************
// //                 ****************************
// // ─────────────────────────────────────────────────────────────────────────────
// //  TelemetryValuesBar.qml  —  BonVGroundStation
// //  File: src/FlyView/TelemetryValuesBar.qml
// //
// //  COMPLETE REPLACEMENT — self-contained fixed layout
// //  • No dependency on HorizontalFactValueGrid / InstrumentValueData / QSettings
// //  • Tab strip: Values | Vibration | EKF | AHRS  + gear + collapse
// //  • 5×2 fixed telemetry grid, all values bind directly to activeVehicle
// //  • Glass background (blur + tint + shimmer + border)
// //  • Wire in FlyView.qml: mapSourceItem: flightMap
// // ─────────────────────────────────────────────────────────────────────────────

// import QtQuick
// import QtQuick.Layouts
// import Qt5Compat.GraphicalEffects

// import QGroundControl
// import QGroundControl.Controls

// Item {
//     id:             control

//     // ── Keep these so FlyView.qml callers don't break ────────────────────────
//     property var    settingsGroup:          null
//     property var    specificVehicleForCard: null
//     property real   extraWidth:             0
//     property var    mapSourceItem:          null

//     // ── Sizing ────────────────────────────────────────────────────────────────
//     property real _tabH:   ScreenTools.defaultFontPixelHeight * 2.0
//     property real _gridH:  ScreenTools.defaultFontPixelHeight * 5.6
//     property real _totalW: Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)

//     implicitWidth:  _locked ? _totalW           : _userW
//     implicitHeight: _collapsed ? _tabH : _tabH + (_locked ? _gridH : _userGridH)

//     Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
//     Behavior on implicitWidth  { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }

//     clip:           true

//     // ── Collapse state ────────────────────────────────────────────────────────
//     property bool _collapsed:  false

//     // ── Resize lock state ─────────────────────────────────────────────────────
//     property bool _locked:     true

//     // Drag position — stored when locked so bar stays put
//     property real _posX:       -1   // -1 = not yet set, use parent anchors
//     property real _posY:       -1

//     // Signal emitted when lock toggles so FlyView.qml can clear/restore anchors
//     signal lockChanged(bool locked)
//     signal dragPositionChanged(real px, real py)

//     // User-adjustable dimensions (start at defaults, clamped)
//     property real _userW:      Math.min(mainWindow.width * 0.52, ScreenTools.defaultFontPixelHeight * 60)
//     property real _userGridH:  ScreenTools.defaultFontPixelHeight * 5.6

//     property real _minW:       ScreenTools.defaultFontPixelHeight * 30
//     property real _maxW:       mainWindow.width * 0.90
//     property real _minGridH:   ScreenTools.defaultFontPixelHeight * 3.5
//     property real _maxGridH:   ScreenTools.defaultFontPixelHeight * 12.0

//     property var _v: QGroundControl.multiVehicleManager.activeVehicle

//     // ── GLASS BACKGROUND ──────────────────────────────────────────────────────
//     Item {
//         id:           glassBg
//         anchors.fill: parent

//         layer.enabled: true
//         layer.effect:  OpacityMask {
//             maskSource: Rectangle {
//                 width:  glassBg.width
//                 height: glassBg.height
//                 radius: 10
//             }
//         }

//         ShaderEffectSource {
//             id:           blurSource
//             anchors.fill: parent
//             sourceItem:   control.mapSourceItem
//             live:         true
//             visible:      false
//         }

//         FastBlur {
//             anchors.fill: parent
//             source:       blurSource
//             radius:       52
//         }

//         Rectangle {
//             anchors.fill: parent
//             color:        Qt.rgba(0.04, 0.05, 0.09, 0.85)
//         }

//         Rectangle {
//             anchors.top:   parent.top
//             anchors.left:  parent.left
//             anchors.right: parent.right
//             height:        parent.height * 0.30
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.05) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }

//     Rectangle {
//         anchors.fill:  parent
//         color:         "transparent"
//         radius:        10
//         border.color:  Qt.rgba(1,1,1,0.11)
//         border.width:  1
//         z:             1
//     }

//     // Top shimmer — using LinearGradient for Qt6 compatibility
//     Item {
//         anchors.top:              parent.top
//         anchors.topMargin:        1
//         anchors.horizontalCenter: parent.horizontalCenter
//         width:                    parent.width * 0.55
//         height:                   1
//         z:                        2

//         Rectangle { anchors.fill: parent; color: Qt.rgba(1,1,1,0.32) }

//         LinearGradient {
//             anchors.fill: parent
//             start:        Qt.point(0, 0)
//             end:          Qt.point(parent.width, 0)
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: "transparent" }
//                 GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.32) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }

//     // ── MAIN LAYOUT ───────────────────────────────────────────────────────────
//     Column {
//         anchors.fill: parent
//         z:            3
//         spacing:      0

//         // ── TAB STRIP ─────────────────────────────────────────────────────────
//         Item {
//             id:     tabStrip
//             width:  parent.width
//             height: control._tabH

//             // Bottom separator line
//             Rectangle {
//                 anchors.bottom: parent.bottom
//                 anchors.left:   parent.left
//                 anchors.right:  parent.right
//                 height:         1
//                 color:          Qt.rgba(1,1,1,0.08)
//             }

//             // ── Drag handle (whole tab strip, only active when unlocked) ───────
//             MouseArea {
//                 id:           dragHandle
//                 anchors.fill: parent
//                 enabled:      !control._locked
//                 cursorShape:  Qt.SizeAllCursor
//                 z:            20

//                 property real _grabX: 0
//                 property real _grabY: 0

//                 onPressed: (mouse) => {
//                     var p = mapToItem(control.parent, mouse.x, mouse.y)
//                     _grabX = p.x - control.x
//                     _grabY = p.y - control.y
//                 }
//                 onPositionChanged: (mouse) => {
//                     if (!pressed) return
//                     var p  = mapToItem(control.parent, mouse.x, mouse.y)
//                     var nx = Math.max(0, Math.min(control.parent.width  - control.width,  p.x - _grabX))
//                     var ny = Math.max(0, Math.min(control.parent.height - control.height, p.y - _grabY))
//                     control.dragPositionChanged(nx, ny)
//                 }
//             }

//             // Drag hint — 6 cyan dots centred, only when unlocked
//             Row {
//                 anchors.centerIn: parent
//                 spacing:          4
//                 visible:          !control._locked
//                 opacity:          0.50
//                 z:                5
//                 Repeater {
//                     model: 6
//                     Rectangle { width: 3; height: 3; radius: 1.5; color: Qt.rgba(0.0,0.83,1.0,1.0) }
//                 }
//             }

//             // ── Tab buttons (left side) ────────────────────────────────────────
//             Row {
//                 id:                     tabRow
//                 anchors.left:           parent.left
//                 anchors.leftMargin:     8
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing:                4
//                 property int currentTab: 0

//                 component TabBtn: Item {
//                     id:             tb
//                     property string label:    ""
//                     property int    tabIndex: 0
//                     property bool   active:   tabRow.currentTab === tabIndex
//                     width:  lbl.contentWidth + ScreenTools.defaultFontPixelHeight * 1.8
//                     height: control._tabH - 4

//                     Rectangle {
//                         anchors.fill:  parent
//                         radius:        6
//                         color:         tb.active ? Qt.rgba(0.0,0.83,1.0,0.16) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.06) : "transparent"
//                         border.color:  tb.active ? Qt.rgba(0.0,0.83,1.0,0.36) : tbMa.containsMouse ? Qt.rgba(1,1,1,0.10) : Qt.rgba(1,1,1,0.07)
//                         border.width:  1
//                         Behavior on color        { ColorAnimation { duration: 110 } }
//                         Behavior on border.color { ColorAnimation { duration: 110 } }
//                         // Active underline
//                         Rectangle {
//                             anchors.bottom:       parent.bottom
//                             anchors.bottomMargin: -1
//                             anchors.left:         parent.left;  anchors.leftMargin:  8
//                             anchors.right:        parent.right; anchors.rightMargin: 8
//                             height: 2; radius: 1
//                             visible: tb.active
//                             color:   Qt.rgba(0.0,0.83,1.0,1.0)
//                         }
//                     }
//                     Text {
//                         id:                 lbl
//                         anchors.centerIn:   parent
//                         text:               tb.label
//                         font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.82
//                         font.weight:        tb.active ? Font.SemiBold : Font.Normal
//                         font.letterSpacing: 0.3
//                         color:              tb.active ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)
//                         Behavior on color { ColorAnimation { duration: 110 } }
//                     }
//                     MouseArea { id: tbMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
//                         // Only intercept clicks when locked; drag handle takes over when unlocked
//                         enabled:      control._locked
//                         onClicked: {
//                             tabRow.currentTab = tb.tabIndex
//                             if (tb.tabIndex !== 0) pageArea._editMode = false
//                         }
//                     }
//                 }

//                 TabBtn { label: qsTr("Values");    tabIndex: 0 }
//                 TabBtn { label: qsTr("Vibration"); tabIndex: 1 }
//                 TabBtn { label: qsTr("EKF");       tabIndex: 2 }
//                 TabBtn { label: qsTr("AHRS");      tabIndex: 3 }
//             }

//             // ── Icon buttons (right side) ──────────────────────────────────────
//             Row {
//                 anchors.right:          parent.right
//                 anchors.rightMargin:    10
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing:                6
//                 z:                      25   // above drag handle so they stay clickable

//                 component IconBtn: Rectangle {
//                     property string ico: ""
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  ibMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
//                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
//                     Behavior on color { ColorAnimation { duration: 90 } }
//                     Text { anchors.centerIn: parent; text: parent.ico; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82; color: Qt.rgba(1,1,1,0.82) }
//                     MouseArea { id: ibMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor }
//                 }

//                 // 🔒 / 🔓 Lock button
//                 Rectangle {
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  lockMa.containsMouse
//                                 ? (control._locked ? Qt.rgba(1.0,0.55,0.10,0.18) : Qt.rgba(0.0,0.83,1.0,0.18))
//                                 : (control._locked ? Qt.rgba(1,1,1,0.04) : Qt.rgba(0.0,0.83,1.0,0.10))
//                     border.color: control._locked ? Qt.rgba(1,1,1,0.10) : Qt.rgba(0.0,0.83,1.0,0.40)
//                     border.width: 1
//                     Behavior on color        { ColorAnimation { duration: 90 } }
//                     Behavior on border.color { ColorAnimation { duration: 90 } }
//                     Text {
//                         anchors.centerIn: parent
//                         text:             control._locked ? "🔒" : "🔓"
//                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.78
//                     }
//                     MouseArea {
//                         id:           lockMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         onClicked: {
//                             if (control._locked) {
//                                 // About to unlock — snapshot current size
//                                 control._userW     = control.width
//                                 control._userGridH = control._gridH
//                             }
//                             control._locked = !control._locked
//                             control.lockChanged(control._locked)
//                         }
//                     }
//                 }

//                 // ⚙ Settings / Edit mode toggle
//                 Rectangle {
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  pageArea._editMode
//                                 ? Qt.rgba(0.0,0.83,1.0,0.18)
//                                 : gearMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
//                     border.color: pageArea._editMode ? Qt.rgba(0.0,0.83,1.0,0.45) : Qt.rgba(1,1,1,0.10)
//                     border.width: 1
//                     Behavior on color        { ColorAnimation { duration: 90 } }
//                     Behavior on border.color { ColorAnimation { duration: 90 } }

//                     Text {
//                         id:             gearIcon
//                         anchors.centerIn: parent
//                         text:           "⚙"
//                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82
//                         color:          pageArea._editMode ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.82)

//                         NumberAnimation on rotation {
//                             running:  pageArea._editMode
//                             from:     0; to: 360
//                             duration: 4000
//                             loops:    Animation.Infinite
//                         }
//                     }
//                     MouseArea {
//                         id:           gearMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         onClicked: {
//                             // Only editable on Values tab
//                             if (tabRow.currentTab === 0)
//                                 pageArea._editMode = !pageArea._editMode
//                         }
//                     }
//                 }

//                 // ⌃ Collapse / expand
//                 Rectangle {
//                     width:  control._tabH * 0.82; height: control._tabH * 0.82; radius: 6
//                     color:  collapseMa.containsMouse ? Qt.rgba(1,1,1,0.09) : Qt.rgba(1,1,1,0.04)
//                     border.color: Qt.rgba(1,1,1,0.10); border.width: 1
//                     Behavior on color { ColorAnimation { duration: 90 } }
//                     Text {
//                         anchors.centerIn: parent
//                         text:             "⌃"
//                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.82
//                         color:            Qt.rgba(1,1,1,0.82)
//                         rotation:         control._collapsed ? 180 : 0
//                         Behavior on rotation { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
//                     }
//                     MouseArea {
//                         id:           collapseMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         onClicked:    control._collapsed = !control._collapsed
//                     }
//                 }
//             }
//         }

//         // ── PAGE AREA ─────────────────────────────────────────────────────────
//         Item {
//             id:      pageArea
//             width:   parent.width
//             height:  control._locked ? control._gridH : control._userGridH
//             visible: !control._collapsed
//             clip:    true

//             property bool _editMode: false

//             // ── Cell layout model — ListModel so Repeater reacts to changes ──
//             ListModel {
//                 id: cellsModel
//             }

//             // ── All available facts ───────────────────────────────────────────
//             readonly property var _allFacts: [
//                 { key:"altRel",      group:"Altitude",   ico:"⬆", icoColorStr:"#00D4FF", lbl:"Alt (Rel)",      unit:"",    isTime:false, isBattery:false },
//                 { key:"altAbsMsl",   group:"Altitude",   ico:"⬆", icoColorStr:"#00D4FF", lbl:"Alt (MSL)",      unit:"",    isTime:false, isBattery:false },
//                 { key:"altAmsl",     group:"Altitude",   ico:"⬆", icoColorStr:"#00D4FF", lbl:"Alt (AMSL)",     unit:"",    isTime:false, isBattery:false },
//                 { key:"groundSpeed", group:"Speed",      ico:"➤", icoColorStr:"#00D4FF", lbl:"Ground Speed",   unit:"",    isTime:false, isBattery:false },
//                 { key:"airSpeed",    group:"Speed",      ico:"≋", icoColorStr:"#00D4FF", lbl:"Airspeed",       unit:"",    isTime:false, isBattery:false },
//                 { key:"climbRate",   group:"Speed",      ico:"↕", icoColorStr:"#00D4FF", lbl:"Climb Rate",     unit:"",    isTime:false, isBattery:false },
//                 { key:"heading",     group:"Navigation", ico:"◈", icoColorStr:"#FFCC00", lbl:"Heading",        unit:"°",   isTime:false, isBattery:false },
//                 { key:"distHome",    group:"Navigation", ico:"⌂", icoColorStr:"#00D4FF", lbl:"Dist to Home",   unit:"",    isTime:false, isBattery:false },
//                 { key:"flightDist",  group:"Navigation", ico:"⇌", icoColorStr:"#00D4FF", lbl:"Flight Dist",    unit:"",    isTime:false, isBattery:false },
//                 { key:"flightTime",  group:"Time",       ico:"⏱", icoColorStr:"#00FF8C", lbl:"Flight Time",    unit:"",    isTime:true,  isBattery:false },
//                 { key:"battery",     group:"Battery",    ico:"⚡", icoColorStr:"#00FF8C", lbl:"Battery",        unit:"%",   isTime:false, isBattery:true  },
//                 { key:"battVoltage", group:"Battery",    ico:"⚡", icoColorStr:"#00D4FF", lbl:"Voltage",        unit:"V",   isTime:false, isBattery:false },
//                 { key:"battCurrent", group:"Battery",    ico:"⚡", icoColorStr:"#00D4FF", lbl:"Current",        unit:"A",   isTime:false, isBattery:false },
//                 { key:"gpsSats",     group:"GPS",        ico:"◉", icoColorStr:"#00FF8C", lbl:"GPS Satellites", unit:"sat", isTime:false, isBattery:false },
//                 { key:"gpsHdop",     group:"GPS",        ico:"◎", icoColorStr:"#00D4FF", lbl:"GPS HDOP",       unit:"",    isTime:false, isBattery:false },
//                 { key:"gpsVdop",     group:"GPS",        ico:"◎", icoColorStr:"#00D4FF", lbl:"GPS VDOP",       unit:"",    isTime:false, isBattery:false },
//                 { key:"roll",        group:"Attitude",   ico:"↻", icoColorStr:"#00D4FF", lbl:"Roll",           unit:"°",   isTime:false, isBattery:false },
//                 { key:"pitch",       group:"Attitude",   ico:"↑", icoColorStr:"#00D4FF", lbl:"Pitch",          unit:"°",   isTime:false, isBattery:false },
//                 { key:"yaw",         group:"Attitude",   ico:"↺", icoColorStr:"#00D4FF", lbl:"Yaw",            unit:"°",   isTime:false, isBattery:false },
//             ]

//             readonly property var _defaultKeys: [
//                 "altRel", "climbRate", "flightTime", "heading", "battery",
//                 "distHome", "groundSpeed", "flightDist", "gpsSats", "airSpeed"
//             ]

//             readonly property string _settingsKey: "TelemetryBar/cells/v1"

//             function saveLayout() {
//                 var arr = []
//                 for (var i = 0; i < cellsModel.count; i++)
//                     arr.push(cellsModel.get(i).cellKey)
//                 Qt.application.setProperty(_settingsKey, JSON.stringify(arr))
//             }

//             function loadLayout() {
//                 var keys = _defaultKeys.slice()
//                 var saved = Qt.application.property(_settingsKey)
//                 if (saved && saved !== "") {
//                     try {
//                         var parsed = JSON.parse(saved)
//                         if (Array.isArray(parsed) && parsed.length === 10)
//                             keys = parsed
//                     } catch(e) {}
//                 }
//                 cellsModel.clear()
//                 for (var i = 0; i < keys.length; i++)
//                     cellsModel.append({ cellKey: keys[i] })
//             }

//             function setCell(index, key) {
//                 cellsModel.set(index, { cellKey: key })
//                 saveLayout()
//             }

//             function clearCell(index) {
//                 cellsModel.set(index, { cellKey: "" })
//                 saveLayout()
//             }

//             function factByKey(key) {
//                 for (var i = 0; i < _allFacts.length; i++)
//                     if (_allFacts[i].key === key) return _allFacts[i]
//                 return null
//             }

//             function factValue(key) {
//                 if (!_v) return "0"
//                 switch(key) {
//                     case "altRel":      return _v.altitudeRelative.value.toFixed(1)
//                     case "altAbsMsl":   return _v.altitudeAMSL.value.toFixed(1)
//                     case "altAmsl":     return _v.altitudeAMSL.value.toFixed(1)
//                     case "groundSpeed": return _v.groundSpeed.value.toFixed(1)
//                     case "airSpeed":    return _v.airSpeed.value.toFixed(1)
//                     case "climbRate":   return _v.climbRate.value.toFixed(1)
//                     case "heading":     return _v.heading.value.toFixed(0)
//                     case "distHome":    return _v.distanceToHome.value.toFixed(1)
//                     case "flightDist":  return _v.flightDistance.value.toFixed(1)
//                     case "flightTime":  return _v.flightTime
//                     case "battery":     return _v.battery.percentRemaining.value.toFixed(0)
//                     case "battVoltage": return _v.battery.voltage.value.toFixed(2)
//                     case "battCurrent": return _v.battery.current.value.toFixed(1)
//                     case "gpsSats":     return _v.gpsSatelliteCount.value.toFixed(0)
//                     case "gpsHdop":     return _v.gpsInfo.hdop.value.toFixed(2)
//                     case "gpsVdop":     return _v.gpsInfo.vdop.value.toFixed(2)
//                     case "roll":        return _v.roll.value.toFixed(1)
//                     case "pitch":       return _v.pitch.value.toFixed(1)
//                     case "yaw":         return _v.heading.value.toFixed(1)
//                     default:            return "0"
//                 }
//             }

//             function factUnit(key) {
//                 if (!_v) return ""
//                 switch(key) {
//                     case "altRel":
//                     case "altAbsMsl":
//                     case "altAmsl":     return _v.altitudeRelative.units
//                     case "groundSpeed": return _v.groundSpeed.units
//                     case "airSpeed":    return _v.airSpeed.units
//                     case "climbRate":   return _v.climbRate.units
//                     case "distHome":    return _v.distanceToHome.units
//                     case "flightDist":  return _v.flightDistance.units
//                     default:
//                         var f = factByKey(key)
//                         return f ? f.unit : ""
//                 }
//             }

//             function batteryColor() {
//                 if (!_v) return Qt.rgba(0.0,0.83,1.0,1.0)
//                 var p = _v.battery.percentRemaining.value
//                 return p < 20 ? Qt.rgba(1.0,0.22,0.35,1.0)
//                      : p < 40 ? Qt.rgba(1.0,0.55,0.10,1.0)
//                               : Qt.rgba(0.0,1.0,0.55,1.0)
//             }

//             // Check if a key is already used in any slot
//             function keyInUse(key) {
//                 for (var i = 0; i < cellsModel.count; i++)
//                     if (cellsModel.get(i).cellKey === key) return true
//                 return false
//             }

//             Component.onCompleted: loadLayout()

//             // ── VALUES PAGE ───────────────────────────────────────────────────
//             Item {
//                 id:           valuesPage
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 0

//                 // Mid row divider
//                 Rectangle {
//                     anchors.left:  parent.left;  anchors.leftMargin:  12
//                     anchors.right: parent.right; anchors.rightMargin: 12
//                     y:             parent.height / 2
//                     height:        1; color: Qt.rgba(1,1,1,0.07); z: 10
//                 }

//                 // Edit mode top banner
//                 Rectangle {
//                     anchors.top:   parent.top
//                     anchors.left:  parent.left
//                     anchors.right: parent.right
//                     height:        visible ? ScreenTools.defaultFontPixelHeight * 1.4 : 0
//                     visible:       pageArea._editMode
//                     color:         Qt.rgba(0.0,0.83,1.0,0.12)
//                     border.color:  Qt.rgba(0.0,0.83,1.0,0.25); border.width: 1
//                     Text {
//                         anchors.centerIn: parent
//                         text:     qsTr("Edit Mode  —  tap ✕ to remove  •  tap ＋ to add")
//                         color:    Qt.rgba(0.0,0.83,1.0,0.85)
//                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.72
//                         font.weight:    Font.Medium
//                     }
//                 }

//                 // 5×2 grid driven by cellsModel
//                 Grid {
//                     anchors.fill: parent
//                     columns:      5
//                     rows:         2

//                     Repeater {
//                         model: cellsModel

//                         delegate: Item {
//                             id:       cellRoot
//                             width:    valuesPage.width / 5
//                             height:   valuesPage.height / 2

//                             property string _key:   model.cellKey || ""
//                             property var    _fact:  _key !== "" ? pageArea.factByKey(_key) : null
//                             property bool   _empty: _key === "" || _fact === null
//                             property bool   _edit:  pageArea._editMode

//                             // Vertical divider
//                             Rectangle {
//                                 anchors.right:        parent.right
//                                 anchors.top:          parent.top;    anchors.topMargin:    8
//                                 anchors.bottom:       parent.bottom; anchors.bottomMargin: 8
//                                 width: 1
//                                 color: Qt.rgba(1,1,1,0.07)
//                             }

//                             // Edit mode highlight
//                             Rectangle {
//                                 anchors.fill:   parent
//                                 anchors.margins: 2
//                                 radius:          6
//                                 color:           "transparent"
//                                 border.color:    cellRoot._edit
//                                                      ? (cellRoot._empty ? Qt.rgba(0.0,0.83,1.0,0.30) : Qt.rgba(1,1,1,0.18))
//                                                      : "transparent"
//                                 border.width:    1
//                                 Behavior on border.color { ColorAnimation { duration: 120 } }
//                             }

//                             // ── EMPTY SLOT — Add button ───────────────────────
//                             Item {
//                                 anchors.fill: parent
//                                 visible:      cellRoot._empty

//                                 Text {
//                                     anchors.centerIn: parent
//                                     text:             cellRoot._edit ? "＋" : ""
//                                     font.pixelSize:   ScreenTools.defaultFontPixelHeight * 1.6
//                                     color:            Qt.rgba(0.0,0.83,1.0,0.55)
//                                     Behavior on opacity { NumberAnimation { duration: 150 } }
//                                 }

//                                 MouseArea {
//                                     anchors.fill:  parent
//                                     enabled:       cellRoot._edit
//                                     cursorShape:   Qt.PointingHandCursor
//                                     onClicked: {
//                                         picker._targetIndex = index
//                                         picker.visible = true
//                                     }
//                                 }
//                             }

//                             // ── FILLED SLOT — Telemetry display ──────────────
//                             Item {
//                                 anchors.fill: parent
//                                 visible:      !cellRoot._empty

//                                 Row {
//                                     anchors.left:           parent.left
//                                     anchors.leftMargin:     ScreenTools.defaultFontPixelWidth * 0.9
//                                     anchors.verticalCenter: parent.verticalCenter
//                                     spacing:                ScreenTools.defaultFontPixelWidth * 0.7

//                                     Text {
//                                         anchors.verticalCenter: parent.verticalCenter
//                                         text:           cellRoot._fact ? cellRoot._fact.ico : ""
//                                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.30
//                                         font.weight:    Font.Bold
//                                         color: {
//                                             if (!cellRoot._fact) return Qt.rgba(0,0.83,1,1)
//                                             if (cellRoot._fact.isBattery) return pageArea.batteryColor()
//                                             return cellRoot._fact.icoColorStr
//                                         }
//                                     }

//                                     Column {
//                                         anchors.verticalCenter: parent.verticalCenter
//                                         spacing:               1

//                                         Row {
//                                             spacing: 3
//                                             Text {
//                                                 id:             vTxt
//                                                 text:           cellRoot._fact ? pageArea.factValue(cellRoot._key) : "0"
//                                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22
//                                                 font.weight:    Font.Medium
//                                                 color:          Qt.rgba(1,1,1,0.92)
//                                             }
//                                             Text {
//                                                 anchors.bottom:       vTxt.bottom
//                                                 anchors.bottomMargin: ScreenTools.defaultFontPixelHeight * 0.18
//                                                 text:           cellRoot._fact ? pageArea.factUnit(cellRoot._key) : ""
//                                                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
//                                                 font.weight:    Font.Light
//                                                 color:          Qt.rgba(1,1,1,0.65)
//                                                 visible:        text !== ""
//                                             }
//                                         }

//                                         Text {
//                                             text:           cellRoot._fact ? cellRoot._fact.lbl : ""
//                                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
//                                             font.weight:    Font.Light
//                                             color:          Qt.rgba(1,1,1,0.65)
//                                         }
//                                     }
//                                 }

//                                 // ── ✕ Remove badge (edit mode only) ──────────
//                                 Rectangle {
//                                     id:             removeBadge
//                                     visible:        cellRoot._edit
//                                     anchors.top:    parent.top;   anchors.topMargin:   4
//                                     anchors.right:  parent.right; anchors.rightMargin: 4
//                                     width:          ScreenTools.defaultFontPixelHeight * 1.1
//                                     height:         width; radius: width / 2
//                                     color:          rmMa.containsMouse ? Qt.rgba(1.0,0.22,0.35,0.85) : Qt.rgba(0.15,0.05,0.08,0.80)
//                                     border.color:   Qt.rgba(1.0,0.22,0.35,0.60); border.width: 1
//                                     Behavior on color { ColorAnimation { duration: 80 } }

//                                     Text {
//                                         anchors.centerIn: parent
//                                         text:             "✕"
//                                         font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.60
//                                         font.weight:      Font.Bold
//                                         color:            Qt.rgba(1,1,1,0.90)
//                                     }

//                                     MouseArea {
//                                         id:           rmMa
//                                         anchors.fill: parent
//                                         hoverEnabled: true
//                                         cursorShape:  Qt.PointingHandCursor
//                                         onClicked:    pageArea.clearCell(index)
//                                     }
//                                 }
//                             }
//                         }
//                     }
//                 }

//                 // ── FACT PICKER POPUP ─────────────────────────────────────────
//                 Item {
//                     id:            picker
//                     visible:       false
//                     anchors.fill:  parent
//                     z:             100

//                     property int _targetIndex: -1

//                     // Dim backdrop
//                     Rectangle {
//                         anchors.fill: parent
//                         color:        Qt.rgba(0,0,0,0.55)
//                         MouseArea { anchors.fill: parent; onClicked: picker.visible = false }
//                     }

//                     // Picker panel
//                     Rectangle {
//                         id:                     pickerPanel
//                         anchors.centerIn:       parent
//                         width:                  Math.min(parent.width * 0.88, ScreenTools.defaultFontPixelHeight * 50)
//                         height:                 Math.min(parent.height * 0.90, ScreenTools.defaultFontPixelHeight * 28)
//                         radius:                 10
//                         color:                  Qt.rgba(0.06, 0.07, 0.12, 0.97)
//                         border.color:           Qt.rgba(1,1,1,0.12); border.width: 1

//                         // Header
//                         Item {
//                             id:     pickerHeader
//                             anchors.top:   parent.top
//                             anchors.left:  parent.left
//                             anchors.right: parent.right
//                             height:        ScreenTools.defaultFontPixelHeight * 2.4

//                             Rectangle {
//                                 anchors.fill:  parent
//                                 color:         Qt.rgba(0.0,0.83,1.0,0.10)
//                                 radius:        10
//                                 // Only round top corners
//                                 Rectangle { anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: 10; color: parent.color }
//                             }

//                             Text {
//                                 anchors.centerIn: parent
//                                 text:             qsTr("Choose a value for this slot")
//                                 font.pixelSize:   ScreenTools.defaultFontPixelHeight * 0.88
//                                 font.weight:      Font.SemiBold
//                                 color:            Qt.rgba(0.0,0.83,1.0,0.90)
//                             }

//                             // Close ✕
//                             Rectangle {
//                                 anchors.right:          parent.right
//                                 anchors.rightMargin:    10
//                                 anchors.verticalCenter: parent.verticalCenter
//                                 width: ScreenTools.defaultFontPixelHeight * 1.4; height: width; radius: width/2
//                                 color: closeMa.containsMouse ? Qt.rgba(1,1,1,0.12) : "transparent"
//                                 Behavior on color { ColorAnimation { duration: 80 } }
//                                 Text { anchors.centerIn: parent; text: "✕"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78; color: Qt.rgba(1,1,1,0.65) }
//                                 MouseArea { id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: picker.visible = false }
//                             }
//                         }

//                         // Fact list grouped by category
//                         ListView {
//                             id:                  factList
//                             anchors.top:         pickerHeader.bottom
//                             anchors.left:        parent.left
//                             anchors.right:       parent.right
//                             anchors.bottom:      parent.bottom
//                             anchors.margins:     8
//                             clip:                true
//                             spacing:             2

//                             // Build section model: group headers + items interleaved
//                             model: {
//                                 var out   = []
//                                 var group = ""
//                                 var facts = pageArea._allFacts

//                                 // Get unique groups in order
//                                 var groups = []
//                                 for (var i = 0; i < facts.length; i++) {
//                                     if (groups.indexOf(facts[i].group) === -1)
//                                         groups.push(facts[i].group)
//                                 }

//                                 for (var g = 0; g < groups.length; g++) {
//                                     out.push({ isHeader: true,  label: groups[g] })
//                                     for (var j = 0; j < facts.length; j++) {
//                                         if (facts[j].group === groups[g])
//                                             out.push({ isHeader: false, fact: facts[j] })
//                                     }
//                                 }
//                                 return out
//                             }

//                             delegate: Item {
//                                 width:  factList.width
//                                 height: modelData.isHeader
//                                             ? ScreenTools.defaultFontPixelHeight * 1.6
//                                             : ScreenTools.defaultFontPixelHeight * 2.4

//                                 // ── Group header ──────────────────────────────
//                                 Text {
//                                     visible:        modelData.isHeader
//                                     anchors.left:   parent.left; anchors.leftMargin: 8
//                                     anchors.bottom: parent.bottom; anchors.bottomMargin: 2
//                                     text:           modelData.isHeader ? modelData.label : ""
//                                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
//                                     font.weight:    Font.SemiBold
//                                     font.letterSpacing: 1.2
//                                     color:          Qt.rgba(0.0,0.83,1.0,0.60)
//                                 }

//                                 // ── Fact row ──────────────────────────────────
//                                 Rectangle {
//                                     visible:        !modelData.isHeader
//                                     anchors.fill:   parent
//                                     anchors.leftMargin:  4; anchors.rightMargin: 4
//                                     radius:         6
//                                     color: {
//                                         if (modelData.isHeader) return "transparent"
//                                         return pageArea.keyInUse(modelData.fact ? modelData.fact.key : "")
//                                             ? Qt.rgba(0.0,0.83,1.0,0.10)
//                                             : (rowMa.containsMouse ? Qt.rgba(1,1,1,0.07) : "transparent")
//                                     }
//                                     border.color: {
//                                         if (modelData.isHeader) return "transparent"
//                                         return pageArea.keyInUse(modelData.fact ? modelData.fact.key : "")
//                                             ? Qt.rgba(0.0,0.83,1.0,0.30) : "transparent"
//                                     }
//                                     border.width: 1
//                                     Behavior on color { ColorAnimation { duration: 80 } }

//                                     Row {
//                                         anchors.left:           parent.left; anchors.leftMargin: 12
//                                         anchors.verticalCenter: parent.verticalCenter
//                                         spacing:                10
//                                         visible:                !modelData.isHeader

//                                         Text {
//                                             text:           modelData.fact ? modelData.fact.ico : ""
//                                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.1
//                                             font.weight:    Font.Bold
//                                             color:          modelData.fact ? modelData.fact.icoColorStr : "white"
//                                         }
//                                         Text {
//                                             text:           modelData.fact ? modelData.fact.lbl : ""
//                                             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
//                                             color:          Qt.rgba(1,1,1,0.88)
//                                         }
//                                     }

//                                     // Already-active tick
//                                     Text {
//                                         anchors.right:          parent.right; anchors.rightMargin: 12
//                                         anchors.verticalCenter: parent.verticalCenter
//                                         visible: !modelData.isHeader && pageArea.keyInUse(modelData.fact ? modelData.fact.key : "")
//                                         text:    "✓"
//                                         font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.82
//                                         color:   Qt.rgba(0.0,0.83,1.0,0.70)
//                                     }

//                                     MouseArea {
//                                         id:           rowMa
//                                         anchors.fill: parent
//                                         enabled:      !modelData.isHeader
//                                         hoverEnabled: true
//                                         cursorShape:  Qt.PointingHandCursor
//                                         onClicked: {
//                                             if (modelData.isHeader) return
//                                             pageArea.setCell(picker._targetIndex, modelData.fact.key)
//                                             picker.visible = false
//                                         }
//                                     }
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }

//             // ── VIBRATION PAGE ────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 1

//                 component VibCell: Item {
//                     property string lbl: ""; property string val: "0"
//                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
//                     Column { anchors.centerIn: parent; spacing: 2
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
//                     }
//                 }

//                 Row {
//                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe X"; val: _v ? _v.vibration.xAxis.value.toFixed(2) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Y"; val: _v ? _v.vibration.yAxis.value.toFixed(2) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Vibe Z"; val: _v ? _v.vibration.zAxis.value.toFixed(2) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 0"; val: _v ? _v.vibration.clipCount1.value.toFixed(0) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 1"; val: _v ? _v.vibration.clipCount2.value.toFixed(0) : "0" }
//                 }
//                 Row {
//                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     VibCell { width: parent.width/5; height: parent.height; lbl: "Clip 2"; val: _v ? _v.vibration.clipCount3.value.toFixed(0) : "0" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     VibCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                 }
//             }

//             // ── EKF PAGE ──────────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 2

//                 component EkfCell: Item {
//                     property string lbl: ""; property string val: "0"; property color vc: Qt.rgba(0.0,0.83,1.0,1.0)
//                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
//                     Column { anchors.centerIn: parent; spacing: 2
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: parent.parent.vc }
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
//                     }
//                 }

//                 Row {
//                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Horiz";  vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.velRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Vel Vert";   vc: Qt.rgba(0.0,1.0,0.55,1.0); val: _v ? _v.estimatorStatus.posVertRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos Horiz";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Mag Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.magRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Hagl Ratio"; vc: Qt.rgba(1.0,0.80,0.0,1.0); val: _v ? _v.estimatorStatus.haglRatio.value.toFixed(2) : "0" }
//                 }
//                 Row {
//                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Tas Ratio";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.tasRatio.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos H Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posHorizAccuracy.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: "Pos V Acc";  vc: Qt.rgba(0.0,0.83,1.0,1.0); val: _v ? _v.estimatorStatus.posVertAccuracy.value.toFixed(2) : "0" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                     EkfCell { width: parent.width/5; height: parent.height; lbl: ""; val: "" }
//                 }
//             }

//             // ── AHRS PAGE ─────────────────────────────────────────────────────
//             Item {
//                 anchors.fill: parent
//                 visible:      tabRow.currentTab === 3

//                 component AhrsCell: Item {
//                     property string lbl: ""; property string val: "0"
//                     Rectangle { anchors.right: parent.right; anchors.top: parent.top; anchors.topMargin: 8; anchors.bottom: parent.bottom; anchors.bottomMargin: 8; width: 1; color: Qt.rgba(1,1,1,0.07) }
//                     Column { anchors.centerIn: parent; spacing: 2
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.val; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.22; font.weight: Font.Medium; color: Qt.rgba(1,1,1,0.90) }
//                         Text { anchors.horizontalCenter: parent.horizontalCenter; text: parent.parent.lbl; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68; color: Qt.rgba(1,1,1,0.65) }
//                     }
//                 }

//                 Row {
//                     anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll (°)";   val: _v ? _v.roll.value.toFixed(1)    : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch (°)";  val: _v ? _v.pitch.value.toFixed(1)   : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw (°)";    val: _v ? _v.heading.value.toFixed(1) : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Roll Rate";  val: _v ? _v.rollRate.value.toFixed(1)  : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Pitch Rate"; val: _v ? _v.pitchRate.value.toFixed(1) : "0" }
//                 }
//                 Row {
//                     anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right; height: parent.height/2
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Yaw Rate"; val: _v ? _v.yawRate.value.toFixed(1) : "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel X";  val: "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Y";  val: "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "Accel Z";  val: "0" }
//                     AhrsCell { width: parent.width/5; height: parent.height; lbl: "";         val: "" }
//                 }
//             }
//         }
//     }

//     // ── RESIZE HANDLES (visible only when unlocked) ───────────────────────────

//     // Right edge — drag to resize width
//     Item {
//         id:      rightHandle
//         visible: !control._locked && !control._collapsed
//         anchors.right:  parent.right
//         anchors.top:    parent.top
//         anchors.bottom: parent.bottom
//         width:          12

//         // Visible grip bar
//         Rectangle {
//             anchors.centerIn:   parent
//             width:              4
//             height:             parent.height * 0.35
//             radius:             2
//             color:              rightDrag.containsMouse || rightDrag.drag.active
//                                     ? Qt.rgba(0.0,0.83,1.0,0.90)
//                                     : Qt.rgba(0.0,0.83,1.0,0.35)
//             Behavior on color { ColorAnimation { duration: 80 } }

//             // Three grip dots
//             Column {
//                 anchors.centerIn: parent
//                 spacing:          3
//                 Repeater {
//                     model: 3
//                     Rectangle { width: 4; height: 1; radius: 1; color: Qt.rgba(1,1,1,0.50) }
//                 }
//             }
//         }

//         MouseArea {
//             id:             rightDrag
//             anchors.fill:   parent
//             hoverEnabled:   true
//             cursorShape:    Qt.SizeHorCursor
//             drag.target:    rightDragProxy
//             drag.axis:      Drag.XAxis

//             Item { id: rightDragProxy }

//             property real _startX: 0
//             property real _startW: 0

//             onPressed: {
//                 _startX = mouseX + rightHandle.x
//                 _startW = control._userW
//             }
//             onMouseXChanged: {
//                 if (pressed) {
//                     var delta = (mouseX + rightHandle.x) - _startX
//                     control._userW = Math.max(control._minW,
//                                      Math.min(control._maxW, _startW + delta))
//                 }
//             }
//         }
//     }

//     // Bottom edge — drag to resize height
//     Item {
//         id:      bottomHandle
//         visible: !control._locked && !control._collapsed
//         anchors.bottom: parent.bottom
//         anchors.left:   parent.left
//         anchors.right:  parent.right
//         height:         12

//         Rectangle {
//             anchors.centerIn: parent
//             width:            parent.width * 0.18
//             height:           4
//             radius:           2
//             color:            bottomDrag.containsMouse || bottomDrag.pressed
//                                   ? Qt.rgba(0.0,0.83,1.0,0.90)
//                                   : Qt.rgba(0.0,0.83,1.0,0.35)
//             Behavior on color { ColorAnimation { duration: 80 } }

//             // Three grip dots
//             Row {
//                 anchors.centerIn: parent
//                 spacing:          3
//                 Repeater {
//                     model: 3
//                     Rectangle { width: 1; height: 4; radius: 1; color: Qt.rgba(1,1,1,0.50) }
//                 }
//             }
//         }

//         MouseArea {
//             id:           bottomDrag
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape:  Qt.SizeVerCursor

//             property real _startY: 0
//             property real _startH: 0

//             onPressed: {
//                 _startY = mouseY + bottomHandle.y
//                 _startH = control._userGridH
//             }
//             onMouseYChanged: {
//                 if (pressed) {
//                     var delta = (mouseY + bottomHandle.y) - _startY
//                     control._userGridH = Math.max(control._minGridH,
//                                          Math.min(control._maxGridH, _startH + delta))
//                 }
//             }
//         }
//     }

//     // Bottom-right corner — drag both axes simultaneously
//     Item {
//         id:      cornerHandle
//         visible: !control._locked && !control._collapsed
//         anchors.right:  parent.right
//         anchors.bottom: parent.bottom
//         width:   16; height: 16

//         Rectangle {
//             anchors.fill:  parent
//             radius:        4
//             color:         cornerDrag.containsMouse || cornerDrag.pressed
//                                ? Qt.rgba(0.0,0.83,1.0,0.25)
//                                : Qt.rgba(0.0,0.83,1.0,0.10)
//             border.color:  Qt.rgba(0.0,0.83,1.0,0.40)
//             border.width:  1
//             Behavior on color { ColorAnimation { duration: 80 } }

//             // Corner grip lines
//             Canvas {
//                 anchors.fill:    parent
//                 anchors.margins: 3
//                 onPaint: {
//                     var ctx = getContext("2d")
//                     ctx.strokeStyle = Qt.rgba(0.0,0.83,1.0,0.70)
//                     ctx.lineWidth   = 1.5
//                     ctx.beginPath()
//                     ctx.moveTo(width, 0); ctx.lineTo(width, height); ctx.lineTo(0, height)
//                     ctx.moveTo(width, height*0.5); ctx.lineTo(width*0.5, height)
//                     ctx.stroke()
//                 }
//             }
//         }

//         MouseArea {
//             id:           cornerDrag
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape:  Qt.SizeFDiagCursor

//             property real _startX: 0; property real _startY: 0
//             property real _startW: 0; property real _startH: 0

//             onPressed: {
//                 _startX = mouseX + cornerHandle.x
//                 _startY = mouseY + cornerHandle.y
//                 _startW = control._userW
//                 _startH = control._userGridH
//             }
//             onMouseXChanged: {
//                 if (pressed) {
//                     var dx = (mouseX + cornerHandle.x) - _startX
//                     control._userW = Math.max(control._minW, Math.min(control._maxW, _startW + dx))
//                 }
//             }
//             onMouseYChanged: {
//                 if (pressed) {
//                     var dy = (mouseY + cornerHandle.y) - _startY
//                     control._userGridH = Math.max(control._minGridH, Math.min(control._maxGridH, _startH + dy))
//                 }
//             }
//         }
//     }
// }





// Final working-before scroll flickable
// ─────────────────────────────────────────────────────────────────────────────
//  TelemetryValuesBar.qml  —  BonVGroundStation
//  File: src/FlyView/TelemetryValuesBar.qml
// ─────────────────────────────────────────────────────────────────────────────
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
