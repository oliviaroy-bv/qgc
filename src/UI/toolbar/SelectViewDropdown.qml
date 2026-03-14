// ─────────────────────────────────────────────────────────────────────────────
//  NavPanel_Option1_FrostedBlur.qml
//  Background: True frosted blur — map renders through the panel
//  + Status pill in header

//  Wire in FlyView.qml:
//      YourNavPanel { mapSourceItem: flightMap }
// ─────────────────────────────────────────────────────────────────────────────
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
// Qt5: import QtGraphicalEffects

import QGroundControl
import QGroundControl.Controls

ToolIndicatorPage {
    id: root

    showExpand: false
    contentComponent: Component {
        Item {
            id:             panelRoot
            implicitWidth:  260
            implicitHeight: Math.max(620, menuColumn.implicitHeight + 260)

            // Wire to your map item in FlyView.qml for real backdrop blur
            property var mapSourceItem: null
            property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

            // ── GLASS BACKGROUND: FROSTED BLUR ───────────────────────────────
            Item {
                id:             glassBackground
                anchors.fill:   parent
                z:              0

                // Clip everything inside to rounded rect
                layer.enabled:  true
                layer.effect:   OpacityMask {
                    maskSource: Rectangle {
                        width:  glassBackground.width
                        height: glassBackground.height
                        radius: 14
                    }
                }

                // 1. Capture the map behind the panel
                ShaderEffectSource {
                    id:             blurSource
                    anchors.fill:   parent
                    sourceItem:     panelRoot.mapSourceItem
                    live:           true
                    visible:        false
                }

                // 2. Frosted blur — increase radius for more blur
                FastBlur {
                    anchors.fill:   parent
                    source:         blurSource
                    radius:         56
                }

                // 3. Semi-transparent dark tint over the blur
                //    Lower opacity = more map visible through glass
                Rectangle {
                    anchors.fill:   parent
                    color:          Qt.rgba(0.04, 0.05, 0.09, 0.41)
                }

                // 4. Upper inner brightness glow
                Rectangle {
                    anchors.top:    parent.top
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    height:         parent.height * 0.28
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.07) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                // 5. Bottom vignette for depth
                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    height:         parent.height * 0.20
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.25) }
                    }
                }
            }

            // Outer border
            Rectangle {
                anchors.fill:   parent
                color:          "transparent"
                radius:         14
                border.color:   Qt.rgba(1, 1, 1, 0.12)
                border.width:   1
                z:              1
            }

            // Top shimmer highlight
            Rectangle {
                anchors.top:                parent.top
                anchors.topMargin:          1
                anchors.horizontalCenter:   parent.horizontalCenter
                width:                      parent.width * 0.60
                height:                     1
                z:                          2
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.50) }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            // ── CONTENT ───────────────────────────────────────────────────────
            Column {
                anchors.fill:   parent
                z:              3

                // ── LOGO + STATUS SECTION ─────────────────────────────────────
                Item {
                    width:  parent.width
                    height: 180

                    Rectangle {
                        anchors.bottom:         parent.bottom
                        anchors.left:           parent.left
                        anchors.right:          parent.right
                        anchors.leftMargin:     20
                        anchors.rightMargin:    20
                        height:                 1
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "transparent" }
                            GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.12) }
                            GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.12) }
                            GradientStop { position: 1.0; color: "transparent" }
                        }
                    }

                    Column {
                        anchors.centerIn:   parent
                        spacing:            8

                        // Logo ring
                        Item {
                            anchors.horizontalCenter:   parent.horizontalCenter
                            width:  78; height: 78

                            Rectangle {
                                anchors.centerIn:   parent
                                width: 78; height: 78; radius: 39
                                color:          "transparent"
                                border.color:   Qt.rgba(0.0, 0.83, 1.0, 0.28)
                                border.width:   1
                            }
                            Rectangle {
                                anchors.centerIn:   parent
                                width: 68; height: 68; radius: 34
                                color:          Qt.rgba(0.0, 0.83, 1.0, 0.10)
                                border.color:   Qt.rgba(0.0, 0.83, 1.0, 0.22)
                                border.width:   1

                                Rectangle {
                                    anchors.top:                parent.top
                                    anchors.topMargin:          1
                                    anchors.horizontalCenter:   parent.horizontalCenter
                                    width: parent.width * 0.5; height: 1
                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop { position: 0.0; color: "transparent" }
                                        GradientStop { position: 0.5; color: Qt.rgba(1, 1, 1, 0.40) }
                                        GradientStop { position: 1.0; color: "transparent" }
                                    }
                                }
                            }
                            Image {
                                anchors.centerIn:   parent
                                source:             "qrc:/res/qgroundcontrol.ico"
                                width: 48; height: 48
                                fillMode:   Image.PreserveAspectFit
                                smooth:     true
                                mipmap:     true
                            }
                        }

                        // App name
                        Text {
                            anchors.horizontalCenter:   parent.horizontalCenter
                            text:           "BonVGroundStation"
                            font.pixelSize: 15
                            font.weight:    Font.DemiBold
                            font.letterSpacing: 0.5
                            color:          Qt.rgba(0.0, 0.83, 1.0, 0.95)
                            layer.enabled: true
                            layer.effect: Glow {
                                radius: 6; samples: 13
                                color: Qt.rgba(0.0, 0.83, 1.0, 0.30)
                                transparentBorder: true
                            }
                        }

                        // ── STATUS PILL ──────────────────────────────────────
                        Rectangle {
                            anchors.horizontalCenter:   parent.horizontalCenter
                            width:                      statusRow.implicitWidth + 20
                            height:                     22
                            radius:                     11
                            color:                      _activeVehicle
                                                            ? Qt.rgba(0.0, 1.0, 0.55, 0.12)
                                                            : Qt.rgba(1.0, 0.20, 0.33, 0.12)
                            border.color:               _activeVehicle
                                                            ? Qt.rgba(0.0, 1.0, 0.55, 0.32)
                                                            : Qt.rgba(1.0, 0.20, 0.33, 0.30)
                            border.width:               1

                            Behavior on color        { ColorAnimation { duration: 400 } }
                            Behavior on border.color { ColorAnimation { duration: 400 } }

                            Row {
                                id:                     statusRow
                                anchors.centerIn:       parent
                                spacing:                6

                                Rectangle {
                                    width: 6; height: 6; radius: 3
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: _activeVehicle ? "#00FF8C" : "#FF3355"
                                    Behavior on color { ColorAnimation { duration: 400 } }

                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        NumberAnimation { to: 0.25; duration: 900; easing.type: Easing.InOutSine }
                                        NumberAnimation { to: 1.0;  duration: 900; easing.type: Easing.InOutSine }
                                    }
                                }

                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    text:           _activeVehicle ? qsTr("Connected") : qsTr("Disconnected")
                                    font.pixelSize: 10
                                    font.weight:    Font.Medium
                                    font.letterSpacing: 0.6
                                    color:          _activeVehicle
                                                        ? Qt.rgba(0.0, 1.0, 0.55, 0.95)
                                                        : Qt.rgba(1.0, 0.20, 0.33, 0.95)
                                    Behavior on color { ColorAnimation { duration: 400 } }
                                }
                            }
                        }
                    }
                }

                // ── NAV ITEMS ─────────────────────────────────────────────────
                Column {
                    id:             menuColumn
                    width:          parent.width
                    spacing:        2
                    topPadding:     8
                    bottomPadding:  8

                    NavItem { itemWidth: parent.width; iconSource: "/qmlimages/Gears.svg";    itemText: qsTr("Configuration"); showArrow: false
                        onNavClicked: { if (mainWindow.allowViewSwitch()) { mainWindow.closeIndicatorDrawer(); mainWindow.showVehicleConfig() } } }
                    NavItem { itemWidth: parent.width; iconSource: "/qmlimages/PaperPlane.svg"; itemText: qsTr("Flight");        showArrow: false; isActive: true
                        onNavClicked: { if (mainWindow.allowViewSwitch()) { mainWindow.closeIndicatorDrawer(); mainWindow.showFlyView() } } }
                    NavItem { itemWidth: parent.width; iconSource: "/qmlimages/Plan.svg";      itemText: qsTr("Planning");      showArrow: false
                        onNavClicked: { if (mainWindow.allowViewSwitch()) { mainWindow.closeIndicatorDrawer(); mainWindow.showPlanView() } } }
                    NavItem { itemWidth: parent.width; iconSource: "/qmlimages/Analyze.svg";   itemText: qsTr("Analyze");       showArrow: true;  visible: QGroundControl.corePlugin.showAdvancedUI
                        onNavClicked: { if (mainWindow.allowViewSwitch()) { mainWindow.closeIndicatorDrawer(); mainWindow.showAnalyzeTool() } } }
                    NavItem { itemWidth: parent.width; iconSource: "/res/QGCLogoWhite.svg";    itemText: qsTr("Settings");      showArrow: true;  visible: !QGroundControl.corePlugin.options.combineSettingsAndSetup
                        onNavClicked: { if (mainWindow.allowViewSwitch()) { mainWindow.closeIndicatorDrawer(); mainWindow.showSettingsTool() } } }
                }

                Item { width: 1; height: 1; Layout.fillHeight: true }
            }

            // ── FOOTER ────────────────────────────────────────────────────────
            Item {
                anchors.bottom: parent.bottom
                anchors.left:   parent.left
                anchors.right:  parent.right
                height:         72
                z:              3

                Rectangle {
                    anchors.top:            parent.top
                    anchors.left:           parent.left; anchors.right: parent.right
                    anchors.leftMargin:     20; anchors.rightMargin: 20
                    height:                 1
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.3; color: Qt.rgba(1, 1, 1, 0.10) }
                        GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.10) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
                Rectangle { anchors.fill: parent; color: Qt.rgba(0, 0, 0, 0.15); radius: 14 }

                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    Text {
                        id: poweredBytext
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "── Powered By ──"; font.pixelSize: 9; font.letterSpacing: 1.2
                        color: Qt.rgba(1, 1, 1, 0.25)
                    }
                    Text {
                        id: companyName
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "BonV Aero"; font.pixelSize: 15; font.weight: Font.Bold; font.letterSpacing: 1.5
                        color: Qt.rgba(0.0, 0.83, 1.0, 0.90)
                        layer.enabled: true
                        layer.effect: Glow { radius: 5; samples: 11; color: Qt.rgba(0.0, 0.83, 1.0, 0.25); transparentBorder: true }
                    }
                    Text {
                        id: versionNumber
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "v1.0.0"; font.pixelSize: 12; font.weight: Font.Bold; font.letterSpacing: 1.5
                        color: Qt.rgba(0.98, 0.98, 0.98, 0.88)
                        layer.enabled: true
                        layer.effect: Glow { radius: 5; samples: 11; color: Qt.rgba(0.46, 0.47, 0.47, 0.25); transparentBorder: true }
                    }
                }
            }

            // ── NAV ITEM COMPONENT ────────────────────────────────────────────
            component NavItem: Item {
                id:             navItem
                property real   itemWidth:  260
                property string iconSource: ""
                property string itemText:   ""
                property bool   showArrow:  false
                property bool   isActive:   false
                signal navClicked
                width: itemWidth; height: 52
                readonly property bool _hov: navMouse.containsMouse
                readonly property bool _prs: navMouse.pressed

                Rectangle {
                    anchors.fill: parent; anchors.leftMargin: 8; anchors.rightMargin: 8; radius: 8
                    color: navItem._prs ? Qt.rgba(0.0,0.83,1.0,0.14) : navItem._hov ? Qt.rgba(1,1,1,0.07) : navItem.isActive ? Qt.rgba(0.0,0.83,1.0,0.10) : "transparent"
                    border.color: (navItem._prs || navItem.isActive) ? Qt.rgba(0.0,0.83,1.0,0.30) : navItem._hov ? Qt.rgba(1,1,1,0.10) : "transparent"
                    border.width: 1
                    Behavior on color        { ColorAnimation { duration: 140 } }
                    Behavior on border.color { ColorAnimation { duration: 140 } }
                }
                Rectangle {
                    anchors.left: parent.left; anchors.leftMargin: 8
                    anchors.top: parent.top; anchors.topMargin: 10
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 10
                    width: 3; radius: 2
                    color: Qt.rgba(0.0, 0.83, 1.0, 1.0)
                    opacity: (navItem._hov || navItem._prs || navItem.isActive) ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    layer.enabled: opacity > 0
                    layer.effect: Glow { radius: 4; samples: 9; color: Qt.rgba(0.0,0.83,1.0,0.60); transparentBorder: true }
                }
                Row {
                    anchors.left: parent.left; anchors.leftMargin: 24
                    anchors.verticalCenter: parent.verticalCenter; spacing: 16
                    QGCColoredImage {
                        width: 22; height: 22; anchors.verticalCenter: parent.verticalCenter
                        source: navItem.iconSource; fillMode: Image.PreserveAspectFit
                        color: (navItem._hov || navItem._prs) ? Qt.rgba(0.0,0.83,1.0,1.0) : navItem.isActive ? Qt.rgba(0.0,0.83,1.0,0.90) : Qt.rgba(1,1,1,0.65)
                        Behavior on color { ColorAnimation { duration: 140 } }
                    }
                    Text {
                        anchors.verticalCenter: parent.verticalCenter; text: navItem.itemText
                        font.pixelSize: 15; font.weight: navItem.isActive ? Font.SemiBold : Font.Normal; font.letterSpacing: 0.3
                        color: (navItem._hov || navItem._prs) ? Qt.rgba(1,1,1,1.0) : navItem.isActive ? Qt.rgba(0.0,0.83,1.0,0.95) : Qt.rgba(1,1,1,0.72)
                        Behavior on color { ColorAnimation { duration: 140 } }
                    }
                }
                Text {
                    anchors.right: parent.right; anchors.rightMargin: 20; anchors.verticalCenter: parent.verticalCenter
                    visible: navItem.showArrow; text: "›"; font.pixelSize: 20
                    color: (navItem._hov || navItem._prs) ? Qt.rgba(0.0,0.83,1.0,0.90) : Qt.rgba(1,1,1,0.30)
                    Behavior on color { ColorAnimation { duration: 140 } }
                }
                Rectangle {
                    anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
                    anchors.leftMargin: 24; anchors.rightMargin: 24; height: 1
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 0.3; color: Qt.rgba(1,1,1,0.06) }
                        GradientStop { position: 0.7; color: Qt.rgba(1,1,1,0.06) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }
                MouseArea { id: navMouse; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: navItem.navClicked() }
                states: [
                    State { name: "pr"; when: navItem._prs; PropertyChanges { target: navItem; scale: 0.97 } },
                    State { name: "no"; when: !navItem._prs; PropertyChanges { target: navItem; scale: 1.0 } }
                ]
                transitions: [
                    Transition { to: "pr"; NumberAnimation { property: "scale"; duration: 80;  easing.type: Easing.OutQuad } },
                    Transition { to: "no"; NumberAnimation { property: "scale"; duration: 160; easing.type: Easing.OutBack; easing.overshoot: 1.2 } }
                ]
            }
        }
    }
}
