// 1st iteration
// import QtQuick
// import QtQuick.Layouts

// import QGroundControl
// import QGroundControl.Controls

// RowLayout {
//     id:         control
//     spacing:    ScreenTools.defaultFontPixelWidth

//     property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
//     property bool   _armed:             _activeVehicle ? _activeVehicle.armed : false
//     property real   _margins:           ScreenTools.defaultFontPixelWidth
//     property real   _spacing:           ScreenTools.defaultFontPixelWidth / 2
//     property bool   _allowForceArm:      false
//     property bool   _healthAndArmingChecksSupported: _activeVehicle ? _activeVehicle.healthAndArmingCheckReport.supported : false
//     property bool   _vehicleFlies:      _activeVehicle ? _activeVehicle.airShip || _activeVehicle.fixedWing || _activeVehicle.vtol || _activeVehicle.multiRotor : false
//     property var    _vehicleInAir:      _activeVehicle ? _activeVehicle.flying || _activeVehicle.landing : false
//     property bool   _vtolInFWDFlight:   _activeVehicle ? _activeVehicle.vtolInFwdFlight : false
//     property bool   _communicationLost: _activeVehicle ? _activeVehicle.connectionLost : false

//     function dropMainStatusIndicator() {
//         let overallStatusComponent = _activeVehicle ? overallStatusIndicatorPage : overallStatusOfflineIndicatorPage
//         mainWindow.showIndicatorDrawer(overallStatusComponent, control)
//     }

//     QGCPalette { id: qgcPal }

//     // Main Status Label - Shows vehicle status or "Disconnected"
//     QGCLabel {
//         id:                 mainStatusLabel
//         Layout.fillHeight:  true
//         verticalAlignment:  Text.AlignVCenter
//         text:               mainStatusText()
//         color:              getStatusColor()
//         font.pointSize:     ScreenTools.largeFontPointSize
//         visible:            true

//         function mainStatusText() {
//             if (!_activeVehicle) {
//                 return qsTr("Disconnected")
//             }

//             if (_communicationLost) {
//                 return qsTr("Communication Lost")
//             }

//             if (_activeVehicle.armed) {
//                 if (_activeVehicle.flying) {
//                     return qsTr("Flying")
//                 } else if (_activeVehicle.landing) {
//                     return qsTr("Landing")
//                 } else {
//                     return qsTr("Armed")
//                 }
//             } else {
//                 // Check if ready to fly
//                 if (_healthAndArmingChecksSupported) {
//                     if (_activeVehicle.healthAndArmingCheckReport.canArm) {
//                         if (_activeVehicle.healthAndArmingCheckReport.hasWarningsOrErrors) {
//                             return qsTr("Ready To Fly")  // With warnings
//                         } else {
//                             return qsTr("Ready To Fly")
//                         }
//                     } else {
//                         return qsTr("Not Ready")
//                     }
//                 } else if (_activeVehicle.readyToFlyAvailable) {
//                     if (_activeVehicle.readyToFly) {
//                         return qsTr("Ready To Fly")
//                     } else {
//                         return qsTr("Not Ready")
//                     }
//                 } else {
//                     if (_activeVehicle.allSensorsHealthy && _activeVehicle.autopilotPlugin.setupComplete) {
//                         return qsTr("Ready To Fly")
//                     } else {
//                         return qsTr("Not Ready")
//                     }
//                 }
//             }
//         }

//         function getStatusColor() {
//             if (!_activeVehicle) {
//                 return qgcPal.windowTransparentText  // Gray/purple for disconnected
//             }

//             if (_communicationLost) {
//                 return qgcPal.colorRed  // Red for comm lost
//             }

//             if (_activeVehicle.armed) {
//                 if (_activeVehicle.flying || _activeVehicle.landing) {
//                     return qgcPal.colorOrange  // Orange for flying/landing
//                 } else {
//                     return qgcPal.colorOrange  // Orange for armed
//                 }
//             } else {
//                 // Ready to fly status
//                 if (_healthAndArmingChecksSupported) {
//                     if (_activeVehicle.healthAndArmingCheckReport.canArm) {
//                         if (_activeVehicle.healthAndArmingCheckReport.hasWarningsOrErrors) {
//                             return qgcPal.colorOrange  // Orange with warnings
//                         } else {
//                             return qgcPal.colorGreen  // Green - ready
//                         }
//                     } else {
//                         return qgcPal.colorRed  // Red - not ready
//                     }
//                 } else if (_activeVehicle.readyToFlyAvailable) {
//                     if (_activeVehicle.readyToFly) {
//                         return qgcPal.colorGreen  // Green - ready
//                     } else {
//                         return qgcPal.colorOrange  // Orange - not ready
//                     }
//                 } else {
//                     if (_activeVehicle.allSensorsHealthy && _activeVehicle.autopilotPlugin.setupComplete) {
//                         return qgcPal.colorGreen  // Green - ready
//                     } else {
//                         return qgcPal.colorOrange  // Orange - not ready
//                     }
//                 }
//             }
//         }

//         QGCMouseArea {
//             anchors.fill:   parent
//             onClicked:      dropMainStatusIndicator()
//         }
//     }

//     // VTOL Mode Label
//     QGCLabel {
//         id:                 vtolModeLabel
//         Layout.fillHeight:  true
//         verticalAlignment:  Text.AlignVCenter
//         text:               _vtolInFWDFlight ? qsTr("FW(vtol)") : qsTr("MR(vtol)")
//         color:              qgcPal.windowTransparentText
//         font.pointSize:     _vehicleInAir ? ScreenTools.largeFontPointSize : ScreenTools.defaultFontPointSize
//         visible:            _activeVehicle && _activeVehicle.vtol

//         QGCMouseArea {
//             anchors.fill: parent
//             onClicked: {
//                 if (_vehicleInAir) {
//                     mainWindow.showIndicatorDrawer(vtolTransitionIndicatorPage)
//                 }
//             }
//         }
//     }

//     Component {
//         id: overallStatusOfflineIndicatorPage

//         MainStatusIndicatorOfflinePage { }
//     }

//     Component {
//         id: overallStatusIndicatorPage

//         ToolIndicatorPage {
//             showExpand:         true
//             waitForParameters:  true
//             contentComponent:   mainStatusContentComponent
//             expandedComponent:  mainStatusExpandedComponent
//         }
//     }

//     Component {
//         id: mainStatusContentComponent

//         ColumnLayout {
//             id:         mainLayout
//             spacing:    _spacing

//             RowLayout {
//                 spacing: ScreenTools.defaultFontPixelWidth

//                 QGCDelayButton {
//                     enabled:    _armed || !_healthAndArmingChecksSupported || _activeVehicle.healthAndArmingCheckReport.canArm
//                     text:       _armed ? qsTr("Disarm") : (control._allowForceArm ? qsTr("Force Arm") : qsTr("Arm"))

//                     onActivated: {
//                         if (_armed) {
//                             _activeVehicle.armed = false
//                         } else {
//                             if (_allowForceArm) {
//                                 _allowForceArm = false
//                                 _activeVehicle.forceArm()
//                             } else {
//                                 _activeVehicle.armed = true
//                             }
//                         }
//                         mainWindow.closeIndicatorDrawer()
//                     }
//                 }

//                 LabelledComboBox {
//                     id:                 primaryLinkCombo
//                     Layout.alignment:   Qt.AlignTop
//                     label:              qsTr("Primary Link")
//                     alternateText:      _primaryLinkName
//                     visible:            _activeVehicle && _activeVehicle.vehicleLinkManager.linkNames.length > 1

//                     property var    _rgLinkNames:       _activeVehicle ? _activeVehicle.vehicleLinkManager.linkNames : [ ]
//                     property var    _rgLinkStatus:      _activeVehicle ? _activeVehicle.vehicleLinkManager.linkStatuses : [ ]
//                     property string _primaryLinkName:   _activeVehicle ? _activeVehicle.vehicleLinkManager.primaryLinkName : ""

//                     function updateComboModel() {
//                         let linkModel = []
//                         for (let i = 0; i < _rgLinkNames.length; i++) {
//                             let linkStatus = _rgLinkStatus[i]
//                             linkModel.push(_rgLinkNames[i] + (linkStatus === "" ? "" : " " + _rgLinkStatus[i]))
//                         }
//                         primaryLinkCombo.model = linkModel
//                         primaryLinkCombo.currentIndex = -1
//                     }

//                     Component.onCompleted:  updateComboModel()
//                     on_RgLinkNamesChanged:  updateComboModel()
//                     on_RgLinkStatusChanged: updateComboModel()

//                     onActivated:    (index) => {
//                         _activeVehicle.vehicleLinkManager.primaryLinkName = _rgLinkNames[index]; currentIndex = -1
//                         mainWindow.closeIndicatorDrawer()
//                     }
//                 }
//             }

//             SettingsGroupLayout {
//                 heading:            qsTr("Vehicle Messages")
//                 visible:            !vehicleMessageList.noMessages

//                 VehicleMessageList {
//                     id: vehicleMessageList
//                 }
//             }

//             SettingsGroupLayout {
//                 heading:            qsTr("Sensor Status")
//                 visible:            !_healthAndArmingChecksSupported

//                 GridLayout {
//                     rowSpacing:     _spacing
//                     columnSpacing:  _spacing
//                     rows:           _activeVehicle.sysStatusSensorInfo.sensorNames.length
//                     flow:           GridLayout.TopToBottom

//                     Repeater {
//                         model: _activeVehicle.sysStatusSensorInfo.sensorNames
//                         QGCLabel { text: modelData }
//                     }

//                     Repeater {
//                         model: _activeVehicle.sysStatusSensorInfo.sensorStatus
//                         QGCLabel { text: modelData }
//                     }
//                 }
//             }

//             SettingsGroupLayout {
//                 heading:            qsTr("Overall Status")
//                 visible:            _healthAndArmingChecksSupported && _activeVehicle.healthAndArmingCheckReport.problemsForCurrentMode.count > 0

//                 Repeater {
//                     model:      _activeVehicle ? _activeVehicle.healthAndArmingCheckReport.problemsForCurrentMode : null
//                     delegate:   listdelegate
//                 }
//             }

//             Component {
//                 id: listdelegate

//                 Column {
//                     Row {
//                         spacing: ScreenTools.defaultFontPixelHeight

//                         QGCLabel {
//                             id:           message
//                             text:         object.message
//                             textFormat:   TextEdit.RichText
//                             color:        object.severity == 'error' ? qgcPal.colorRed : object.severity == 'warning' ? qgcPal.colorOrange : qgcPal.text
//                             MouseArea {
//                                 anchors.fill: parent
//                                 onClicked: {
//                                     if (object.description != "")
//                                         object.expanded = !object.expanded
//                                 }
//                             }
//                         }

//                         QGCColoredImage {
//                             id:                     arrowDownIndicator
//                             anchors.verticalCenter: parent.verticalCenter
//                             height:                 1.5 * ScreenTools.defaultFontPixelWidth
//                             width:                  height
//                             source:                 "/qmlimages/arrow-down.png"
//                             color:                  qgcPal.text
//                             visible:                object.description != ""
//                             MouseArea {
//                                 anchors.fill:       parent
//                                 onClicked:          object.expanded = !object.expanded
//                             }
//                         }
//                     }

//                     QGCLabel {
//                         id:                 description
//                         text:               object.description
//                         textFormat:         TextEdit.RichText
//                         clip:               true
//                         visible:            object.expanded

//                         property var fact:  null

//                         onLinkActivated: (link) => {
//                             if (link.startsWith('param://')) {
//                                 var paramName = link.substr(8);
//                                 fact = controller.getParameterFact(-1, paramName, true)
//                                 if (fact != null) {
//                                     paramEditorDialogComponent.createObject(mainWindow).open()
//                                 }
//                             } else {
//                                 Qt.openUrlExternally(link);
//                             }
//                         }

//                         FactPanelController {
//                             id: controller
//                         }

//                         Component {
//                             id: paramEditorDialogComponent

//                             ParameterEditorDialog {
//                                 title:          qsTr("Edit Parameter")
//                                 fact:           description.fact
//                                 destroyOnClose: true
//                             }
//                         }
//                     }
//                 }
//             }
//         }
//     }

//     Component {
//         id: mainStatusExpandedComponent

//         ColumnLayout {
//             Layout.preferredWidth:  ScreenTools.defaultFontPixelWidth * 60
//             spacing:                margins / 2

//             property real margins: ScreenTools.defaultFontPixelHeight

//             Loader {
//                 Layout.fillWidth:   true
//                 source:             _activeVehicle.expandedToolbarIndicatorSource("MainStatus")
//             }

//             SettingsGroupLayout {
//                 Layout.fillWidth:   true
//                 heading:            qsTr("Force Arm")
//                 headingDescription: qsTr("Force arming bypasses pre-arm checks. Use with caution.")
//                 visible:            _activeVehicle && !_armed

//                 QGCCheckBoxSlider {
//                     Layout.fillWidth:   true
//                     text:               qsTr("Allow Force Arm")
//                     checked:            false
//                     onClicked:          _allowForceArm = true
//                 }
//             }

//             SettingsGroupLayout {
//                 Layout.fillWidth:   true
//                 visible:            QGroundControl.corePlugin.showAdvancedUI

//                 GridLayout {
//                     columns:            2
//                     rowSpacing:         ScreenTools.defaultFontPixelHeight / 2
//                     columnSpacing:      ScreenTools.defaultFontPixelWidth *2
//                     Layout.fillWidth:   true

//                     QGCLabel { Layout.fillWidth: true; text: qsTr("Vehicle Parameters") }
//                     QGCButton {
//                         text: qsTr("Configure")
//                         onClicked: {
//                             mainWindow.showVehicleConfigParametersPage()
//                             mainWindow.closeIndicatorDrawer()
//                         }
//                     }

//                     QGCLabel { Layout.fillWidth: true; text: qsTr("Vehicle Configuration") }
//                     QGCButton {
//                         text: qsTr("Configure")
//                         onClicked: {
//                             mainWindow.showVehicleConfig()
//                             mainWindow.closeIndicatorDrawer()
//                         }
//                     }
//                 }
//             }
//         }
//     }
// }



// 2nd iteration
// // ===========================================================
// // ===========================================================

// // MainStatusIndicator.qml
// // Full liquid glass rewrite of QGC MainStatusIndicator
// //
// // Required sibling files (place in same QML directory):
// //   LiquidGlassPill.qml
// //   LiquidGlassDrawer.qml
// //   LiquidGlassCard.qml
// //   LiquidGlassButton.qml
// //   LiquidGlassChip.qml

// import QtQuick
// import QtQuick.Layouts
// import QtQuick.Effects

// import QGroundControl
// import QGroundControl.Controls

// RowLayout {
//     id:      control
//     spacing: ScreenTools.defaultFontPixelWidth

//     // ── Vehicle state aliases ────────────────────────────────────────────
//     property var  _av:          QGroundControl.multiVehicleManager.activeVehicle
//     property bool _armed:       _av ? _av.armed : false
//     property bool _harc:        _av ? _av.healthAndArmingCheckReport.supported : false
//     property bool _vehicleFlies:_av ? _av.airShip || _av.fixedWing || _av.vtol || _av.multiRotor : false
//     property var  _inAir:       _av ? _av.flying || _av.landing : false
//     property bool _vtolFwd:     _av ? _av.vtolInFwdFlight : false
//     property bool _commLost:    _av ? _av.connectionLost : false
//     property bool _allowForceArm: false

//     // Glass color tokens
//     readonly property color _green:  "#30D158"
//     readonly property color _red:    "#FF453A"
//     readonly property color _orange: "#FF9F0A"
//     readonly property color _blue:   "#0A84FF"
//     readonly property color _gray:   "#888888"

//     QGCPalette { id: qgcPal }

//     // ── Helpers ───────────────────────────────────────────────────────────
//     function _statusText() {
//         if (!_av)             return qsTr("Disconnected")
//         if (_commLost)        return qsTr("Comm Lost")
//         if (_av.armed) {
//             if (_av.flying)   return qsTr("Flying")
//             if (_av.landing)  return qsTr("Landing")
//             return qsTr("Armed")
//         }
//         if (_harc) return _av.healthAndArmingCheckReport.canArm ? qsTr("Ready") : qsTr("Not Ready")
//         if (_av.readyToFlyAvailable) return _av.readyToFly ? qsTr("Ready") : qsTr("Not Ready")
//         return (_av.allSensorsHealthy && _av.autopilotPlugin.setupComplete) ? qsTr("Ready") : qsTr("Not Ready")
//     }

//     function _statusColor() {
//         if (!_av)          return _gray
//         if (_commLost)     return _red
//         if (_av.armed)     return (_av.flying || _av.landing) ? _orange : _orange
//         if (_harc) {
//             if (!_av.healthAndArmingCheckReport.canArm) return _red
//             return _av.healthAndArmingCheckReport.hasWarningsOrErrors ? _orange : _green
//         }
//         if (_av.readyToFlyAvailable) return _av.readyToFly ? _green : _orange
//         return (_av.allSensorsHealthy && _av.autopilotPlugin.setupComplete) ? _green : _orange
//     }

//     function _dotAnimating() {
//         if (!_av) return false
//         if (_commLost) return true
//         if (!_av.armed) return true
//         return _av.flying || _av.landing
//     }

//     function _chipColor(status) {
//         switch (status) {
//             case "Normal":   return _green
//             case "Error":    return _red
//             case "Disabled": return _gray
//             default:         return _orange
//         }
//     }

//     function _msgColor(severity) {
//         if (severity === "error")   return _red
//         if (severity === "warning") return _orange
//         return Qt.rgba(1,1,1,0.65)
//     }

//     // ════════════════════════════════════════════════════════════════════
//     // 1. TOP BAR: Liquid Glass Status Pill
//     // ════════════════════════════════════════════════════════════════════
//     LiquidGlassPill {
//         id:            _pill
//         statusText:    control._statusText()
//         accentColor:   control._statusColor()
//         dotAnimating:  control._dotAnimating()
//         vtolText:      (_av && _av.vtol) ? (_vtolFwd ? qsTr("FW (vtol)") : qsTr("MR (vtol)")) : ""

//         onClicked: {
//             let page = _av ? _overallStatusPage : _offlinePage
//             mainWindow.showIndicatorDrawer(page, _pill)
//         }
//     }

//     // ════════════════════════════════════════════════════════════════════
//     // 2. OFFLINE PAGE (no vehicle)
//     // ════════════════════════════════════════════════════════════════════
//     Component {
//         id: _offlinePage
//         MainStatusIndicatorOfflinePage { }
//     }

//     // ════════════════════════════════════════════════════════════════════
//     // 3. MAIN INDICATOR PAGE
//     // ════════════════════════════════════════════════════════════════════
//     Component {
//         id: _overallStatusPage

//         ToolIndicatorPage {
//             showExpand:        true
//             waitForParameters: true
//             contentComponent:  _contentComp
//             expandedComponent: _expandedComp
//         }
//     }

//     // ════════════════════════════════════════════════════════════════════
//     // 4. DRAWER CONTENT — all wrapped in liquid glass shell
//     // ════════════════════════════════════════════════════════════════════
//     Component {
//         id: _contentComp

//         // The entire content sits inside the LiquidGlassDrawer shell
//         LiquidGlassDrawer {
//             id:            _drawerShell
//             implicitWidth: ScreenTools.defaultFontPixelWidth * 44

//             ColumnLayout {
//                 anchors.left:   parent.left
//                 anchors.right:  parent.right
//                 anchors.top:    parent.top
//                 spacing:        0

//                 // ── ARM / DISARM BUTTON ──────────────────────────────────
//                 Item {
//                     Layout.fillWidth: true
//                     implicitHeight:   54
//                     Layout.topMargin: 4

//                     RowLayout {
//                         anchors.fill:        parent
//                         anchors.leftMargin:  14
//                         anchors.rightMargin: 14
//                         spacing:             10

//                         // Arm button
//                         LiquidGlassButton {
//                             id:             _armBtn
//                             Layout.fillWidth: true
//                             implicitHeight: 46
//                             enabled:        _armed
//                                             || !_harc
//                                             || (_av && _av.healthAndArmingCheckReport.canArm)
//                             text:           _armed
//                                             ? qsTr("Disarm")
//                                             : (_allowForceArm ? qsTr("Force Arm") : qsTr("Arm"))
//                             accentColor:    _armed ? control._red : control._green
//                             filled:         true

//                             onClicked: {
//                                 if (_armed) {
//                                     _av.armed = false
//                                 } else {
//                                     if (_allowForceArm) {
//                                         control._allowForceArm = false
//                                         _av.forceArm()
//                                     } else {
//                                         _av.armed = true
//                                     }
//                                 }
//                                 mainWindow.closeIndicatorDrawer()
//                             }
//                         }

//                         // Primary link selector (if multiple links)
//                         LiquidGlassButton {
//                             id:              _linkBtn
//                             visible:         _av && _av.vehicleLinkManager.linkNames.length > 1
//                             text:            qsTr("Link")
//                             accentColor:     control._blue
//                             filled:          false
//                             implicitHeight:  46

//                             property var    _names:   _av ? _av.vehicleLinkManager.linkNames    : []
//                             property var    _status:  _av ? _av.vehicleLinkManager.linkStatuses : []
//                             property string _primary: _av ? _av.vehicleLinkManager.primaryLinkName : ""

//                             // Show a small popup / combo on click
//                             onClicked: {
//                                 // Standard QGC combo handling wired externally
//                             }
//                         }
//                     }
//                 }

//                 // Divider
//                 Rectangle {
//                     Layout.fillWidth:    true
//                     Layout.leftMargin:   14
//                     Layout.rightMargin:  14
//                     height:              1
//                     gradient: Gradient {
//                         orientation: Gradient.Horizontal
//                         GradientStop { position: 0.0; color: "transparent" }
//                         GradientStop { position: 0.3; color: Qt.rgba(1,1,1,0.10) }
//                         GradientStop { position: 0.7; color: Qt.rgba(1,1,1,0.10) }
//                         GradientStop { position: 1.0; color: "transparent" }
//                     }
//                 }

//                 // ── VEHICLE MESSAGES CARD ────────────────────────────────
//                 LiquidGlassCard {
//                     Layout.fillWidth:    true
//                     Layout.topMargin:    10
//                     Layout.leftMargin:   12
//                     Layout.rightMargin:  12
//                     visible:             !_msgList.noMessages
//                     heading:             qsTr("Vehicle Messages")
//                     recessed:            true

//                     VehicleMessageList {
//                         id:     _msgList
//                         width:  parent ? parent.width : 0

//                         // Style overrides injected via delegates in VehicleMessageList
//                         // if VehicleMessageList supports a delegate property,
//                         // use the _msgDelegate below; otherwise style via subclass.
//                     }
//                 }

//                 // ── SENSOR STATUS CARD ───────────────────────────────────
//                 LiquidGlassCard {
//                     Layout.fillWidth:    true
//                     Layout.topMargin:    8
//                     Layout.leftMargin:   12
//                     Layout.rightMargin:  12
//                     Layout.bottomMargin: 12
//                     visible:             !_harc
//                     heading:             qsTr("Sensor Status")
//                     recessed:            true

//                     // Sensor name + chip grid
//                     GridLayout {
//                         width:          parent ? parent.width : 0
//                         rowSpacing:     0
//                         columnSpacing:  0
//                         rows:           _av ? _av.sysStatusSensorInfo.sensorNames.length : 0
//                         flow:           GridLayout.TopToBottom

//                         // Names column
//                         Repeater {
//                             model: _av ? _av.sysStatusSensorInfo.sensorNames : null

//                             Item {
//                                 Layout.fillWidth: true
//                                 implicitHeight:   32

//                                 Text {
//                                     anchors.left:           parent.left
//                                     anchors.leftMargin:     2
//                                     anchors.verticalCenter: parent.verticalCenter
//                                     text:                   modelData
//                                     color:                  Qt.rgba(1,1,1,0.55)
//                                     font.pointSize:         ScreenTools.defaultFontPointSize * 0.9
//                                 }

//                                 Rectangle {
//                                     anchors.bottom: parent.bottom
//                                     width: parent.width; height: 1
//                                     color: Qt.rgba(1,1,1,0.04)
//                                 }
//                             }
//                         }

//                         // Status chips column
//                         Repeater {
//                             model: _av ? _av.sysStatusSensorInfo.sensorStatus : null

//                             Item {
//                                 implicitHeight: 32
//                                 implicitWidth:  _chip.implicitWidth + 8

//                                 LiquidGlassChip {
//                                     id:               _chip
//                                     anchors.right:    parent.right
//                                     anchors.rightMargin: 0
//                                     anchors.verticalCenter: parent.verticalCenter
//                                     chipText:         modelData
//                                     chipColor:        control._chipColor(modelData)
//                                 }

//                                 Rectangle {
//                                     anchors.bottom: parent.bottom
//                                     width: parent.width; height: 1
//                                     color: Qt.rgba(1,1,1,0.04)
//                                 }
//                             }
//                         }
//                     }
//                 }

//                 // ── OVERALL STATUS (health checks) ───────────────────────
//                 LiquidGlassCard {
//                     Layout.fillWidth:    true
//                     Layout.topMargin:    8
//                     Layout.leftMargin:   12
//                     Layout.rightMargin:  12
//                     Layout.bottomMargin: 12
//                     visible:             _harc
//                                          && _av
//                                          && _av.healthAndArmingCheckReport.problemsForCurrentMode.count > 0
//                     heading:             qsTr("Overall Status")
//                     recessed:            true

//                     Repeater {
//                         model: _av ? _av.healthAndArmingCheckReport.problemsForCurrentMode : null
//                         delegate: _problemDelegate
//                     }
//                 }

//             }
//         }
//     }

//     // ── Problem list delegate ────────────────────────────────────────────
//     Component {
//         id: _problemDelegate

//         Column {
//             width: parent ? parent.width : 0
//             spacing: 0

//             // Message row
//             RowLayout {
//                 width:   parent.width
//                 spacing: 8

//                 // Severity stripe
//                 Rectangle {
//                     width:   3; height: _msgTxt.implicitHeight + 10
//                     radius:  2
//                     color:   control._msgColor(object.severity)
//                     opacity: 0.9
//                 }

//                 Text {
//                     id:               _msgTxt
//                     Layout.fillWidth: true
//                     text:             object.message
//                     textFormat:       TextEdit.RichText
//                     color:            control._msgColor(object.severity)
//                     font.pointSize:   ScreenTools.defaultFontPointSize * 0.9
//                     wrapMode:         Text.WordWrap

//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked:    if (object.description !== "") object.expanded = !object.expanded
//                     }
//                 }

//                 // Expand arrow
//                 QGCColoredImage {
//                     visible:                object.description !== ""
//                     height:                 ScreenTools.defaultFontPixelWidth * 1.3
//                     width:                  height
//                     source:                 "/qmlimages/arrow-down.png"
//                     color:                  Qt.rgba(1,1,1,0.35)
//                     rotation:               object.expanded ? 180 : 0
//                     Behavior on rotation    { NumberAnimation { duration: 160 } }

//                     MouseArea {
//                         anchors.fill: parent
//                         onClicked:    object.expanded = !object.expanded
//                     }
//                 }
//             }

//             // Expanded description
//             Text {
//                 id:              _desc
//                 width:           parent.width
//                 leftPadding:     11
//                 text:            object.description
//                 textFormat:      TextEdit.RichText
//                 visible:         object.expanded
//                 color:           Qt.rgba(1,1,1,0.48)
//                 font.pointSize:  ScreenTools.smallFontPointSize
//                 wrapMode:        Text.WordWrap

//                 property var fact: null

//                 onLinkActivated: (link) => {
//                     if (link.startsWith("param://")) {
//                         fact = _paramCtrl.getParameterFact(-1, link.substr(8), true)
//                         if (fact) _paramDlg.createObject(mainWindow).open()
//                     } else {
//                         Qt.openUrlExternally(link)
//                     }
//                 }

//                 FactPanelController { id: _paramCtrl }

//                 Component {
//                     id: _paramDlg
//                     ParameterEditorDialog {
//                         title:          qsTr("Edit Parameter")
//                         fact:           _desc.fact
//                         destroyOnClose: true
//                     }
//                 }
//             }

//             // Row separator
//             Rectangle {
//                 width: parent.width; height: 1
//                 color: Qt.rgba(1,1,1,0.05)
//             }
//         }
//     }

//     // ════════════════════════════════════════════════════════════════════
//     // 5. EXPANDED PANEL — force arm + advanced config
//     // ════════════════════════════════════════════════════════════════════
//     Component {
//         id: _expandedComp

//         LiquidGlassDrawer {
//             implicitWidth: ScreenTools.defaultFontPixelWidth * 60
//             showHandle:    false

//             ColumnLayout {
//                 anchors.fill:        parent
//                 anchors.margins:     14
//                 spacing:             10

//                 Loader {
//                     Layout.fillWidth: true
//                     source:           _av.expandedToolbarIndicatorSource("MainStatus")
//                 }

//                 // Force Arm card
//                 LiquidGlassCard {
//                     Layout.fillWidth:   true
//                     visible:            _av && !_armed
//                     heading:            qsTr("Force Arm")
//                     recessed:           false   // raised card in expanded section

//                     ColumnLayout {
//                         width: parent ? parent.width : 0
//                         spacing: 6

//                         Text {
//                             Layout.fillWidth: true
//                             text:    qsTr("Force arming bypasses pre-arm checks. Use with extreme caution.")
//                             color:   Qt.rgba(1,1,1,0.40)
//                             font.pointSize: ScreenTools.smallFontPointSize
//                             wrapMode: Text.WordWrap
//                         }

//                         QGCCheckBoxSlider {
//                             Layout.fillWidth: true
//                             text:    qsTr("Allow Force Arm")
//                             checked: false
//                             onClicked: control._allowForceArm = true
//                         }
//                     }
//                 }

//                 // Advanced / developer options
//                 LiquidGlassCard {
//                     Layout.fillWidth: true
//                     visible:          QGroundControl.corePlugin.showAdvancedUI
//                     recessed:         false

//                     GridLayout {
//                         width:         parent ? parent.width : 0
//                         columns:       2
//                         rowSpacing:    8
//                         columnSpacing: 12

//                         Text {
//                             Layout.fillWidth: true
//                             text:  qsTr("Vehicle Parameters")
//                             color: Qt.rgba(1,1,1,0.55)
//                             font.pointSize: ScreenTools.defaultFontPointSize * 0.9
//                         }
//                         LiquidGlassButton {
//                             text:           qsTr("Configure")
//                             accentColor:    control._blue
//                             filled:         false
//                             implicitHeight: 34
//                             onClicked: {
//                                 mainWindow.showVehicleConfigParametersPage()
//                                 mainWindow.closeIndicatorDrawer()
//                             }
//                         }

//                         Text {
//                             Layout.fillWidth: true
//                             text:  qsTr("Vehicle Configuration")
//                             color: Qt.rgba(1,1,1,0.55)
//                             font.pointSize: ScreenTools.defaultFontPointSize * 0.9
//                         }
//                         LiquidGlassButton {
//                             text:           qsTr("Configure")
//                             accentColor:    control._blue
//                             filled:         false
//                             implicitHeight: 34
//                             onClicked: {
//                                 mainWindow.showVehicleConfig()
//                                 mainWindow.closeIndicatorDrawer()
//                             }
//                         }
//                     }
//                 }

//                 Item { implicitHeight: 8 }
//             }
//         }
//     }
// }

// 3rd iteration
// MainStatusIndicator.qml
// Strategy: Keep ALL original QGC data bindings and component structure 100% intact.
// Glass effect = decorative Rectangle layers painted behind content only.
// SettingsGroupLayout, VehicleMessageList, GridLayout sensor grid are untouched.

import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

RowLayout {
    id:      control
    spacing: ScreenTools.defaultFontPixelWidth

    // ── Original QGC properties ──────────────────────────────────────────
    property var    _activeVehicle:              QGroundControl.multiVehicleManager.activeVehicle
    property bool   _armed:                      _activeVehicle ? _activeVehicle.armed : false
    property real   _margins:                    ScreenTools.defaultFontPixelWidth
    property real   _spacing:                    ScreenTools.defaultFontPixelWidth / 2
    property bool   _allowForceArm:              false
    property bool   _healthAndArmingChecksSupported: _activeVehicle ? _activeVehicle.healthAndArmingCheckReport.supported : false
    property bool   _vehicleFlies:               _activeVehicle ? _activeVehicle.airShip || _activeVehicle.fixedWing || _activeVehicle.vtol || _activeVehicle.multiRotor : false
    property var    _vehicleInAir:               _activeVehicle ? _activeVehicle.flying || _activeVehicle.landing : false
    property bool   _vtolInFWDFlight:            _activeVehicle ? _activeVehicle.vtolInFwdFlight : false
    property bool   _communicationLost:          _activeVehicle ? _activeVehicle.connectionLost : false

    // ── Glass color tokens ───────────────────────────────────────────────
    readonly property color _glassGreen:  "#30D158"
    readonly property color _glassRed:    "#FF453A"
    readonly property color _glassOrange: "#FF9F0A"
    readonly property color _glassBlue:   "#0A84FF"
    readonly property color _glassGray:   "#888888"

    function dropMainStatusIndicator() {
        let overallStatusComponent = _activeVehicle ? overallStatusIndicatorPage : overallStatusOfflineIndicatorPage
        mainWindow.showIndicatorDrawer(overallStatusComponent, control)
    }

    QGCPalette { id: qgcPal }

    // ── Original status text logic ───────────────────────────────────────
    function mainStatusText() {
        if (!_activeVehicle) {
            return qsTr("Disconnected")
        }
        if (_communicationLost) {
            return qsTr("Communication Lost")
        }
        if (_activeVehicle.armed) {
            if (_activeVehicle.flying) {
                return qsTr("Flying")
            } else if (_activeVehicle.landing) {
                return qsTr("Landing")
            } else {
                return qsTr("Armed")
            }
        } else {
            if (_healthAndArmingChecksSupported) {
                if (_activeVehicle.healthAndArmingCheckReport.canArm) {
                    return qsTr("Ready To Fly")
                } else {
                    return qsTr("Not Ready")
                }
            } else if (_activeVehicle.readyToFlyAvailable) {
                if (_activeVehicle.readyToFly) {
                    return qsTr("Ready To Fly")
                } else {
                    return qsTr("Not Ready")
                }
            } else {
                if (_activeVehicle.allSensorsHealthy && _activeVehicle.autopilotPlugin.setupComplete) {
                    return qsTr("Ready To Fly")
                } else {
                    return qsTr("Not Ready")
                }
            }
        }
    }

    // ── Original color logic ─────────────────────────────────────────────
    function getStatusColor() {
        if (!_activeVehicle) {
            return _glassGray
        }
        if (_communicationLost) {
            return _glassRed
        }
        if (_activeVehicle.armed) {
            return _glassOrange
        } else {
            if (_healthAndArmingChecksSupported) {
                if (_activeVehicle.healthAndArmingCheckReport.canArm) {
                    if (_activeVehicle.healthAndArmingCheckReport.hasWarningsOrErrors) {
                        return _glassOrange
                    } else {
                        return _glassGreen
                    }
                } else {
                    return _glassRed
                }
            } else if (_activeVehicle.readyToFlyAvailable) {
                if (_activeVehicle.readyToFly) {
                    return _glassGreen
                } else {
                    return _glassOrange
                }
            } else {
                if (_activeVehicle.allSensorsHealthy && _activeVehicle.autopilotPlugin.setupComplete) {
                    return _glassGreen
                } else {
                    return _glassOrange
                }
            }
        }
    }

    function chipColor(status) {
        switch (status) {
            case "Normal":   return _glassGreen
            case "Error":    return _glassRed
            case "Disabled": return _glassGray
            default:         return _glassOrange
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // TOP BAR: Liquid Glass Pill (replaces plain QGCLabel)
    // ════════════════════════════════════════════════════════════════════
    LiquidGlassPill {
        id:           _pill
        statusText:   control.mainStatusText()
        accentColor:  control.getStatusColor()
        dotAnimating: {
            if (!_activeVehicle) return false
            if (_communicationLost) return true
            if (!_activeVehicle.armed) return true
            return _activeVehicle.flying || _activeVehicle.landing
        }
        vtolText: (_activeVehicle && _activeVehicle.vtol)
                      ? (_vtolInFWDFlight ? qsTr("FW(vtol)") : qsTr("MR(vtol)"))
                      : ""
        onClicked: control.dropMainStatusIndicator()
    }

    // ════════════════════════════════════════════════════════════════════
    // ORIGINAL PAGES — structure kept exactly, glass added as z:-1 underlay
    // ════════════════════════════════════════════════════════════════════
    Component {
        id: overallStatusOfflineIndicatorPage
        MainStatusIndicatorOfflinePage { }
    }

    Component {
        id: overallStatusIndicatorPage
        ToolIndicatorPage {
            showExpand:        true
            waitForParameters: true
            contentComponent:  mainStatusContentComponent
            expandedComponent: mainStatusExpandedComponent
        }
    }

    // ════════════════════════════════════════════════════════════════════
    // DRAWER CONTENT
    // All original QGC components kept intact.
    // Glass underlay painted as sibling Rectangle at z:-1 behind content.
    // ════════════════════════════════════════════════════════════════════
    Component {
        id: mainStatusContentComponent

        // Outermost Item provides a clipping/sizing root for the glass layers
        Item {
            id:             _contentRoot
            implicitWidth:  _mainLayout.implicitWidth
            implicitHeight: _mainLayout.implicitHeight + 24

            // ── Glass background layers (z: -1, behind all content) ──────

            // Gradient border
            Rectangle {
                z:               -1
                anchors.fill:    parent
                anchors.margins: -1
                radius:          20
                gradient: Gradient {
                    orientation: Gradient.Diagonal
                    GradientStop { position: 0.00; color: Qt.rgba(1,1,1,0.52) }
                    GradientStop { position: 0.20; color: Qt.rgba(1,1,1,0.18) }
                    GradientStop { position: 0.50; color: Qt.rgba(1,1,1,0.05) }
                    GradientStop { position: 0.80; color: Qt.rgba(1,1,1,0.15) }
                    GradientStop { position: 1.00; color: Qt.rgba(1,1,1,0.40) }
                }
            }

            // Glass body
            Rectangle {
                z:            -1
                anchors.fill: parent
                radius:       20
                color:        Qt.rgba(1, 1, 1, 0.09)
            }

            // Top specular band
            Rectangle {
                z:                   -1
                anchors.top:         parent.top
                anchors.topMargin:   1
                anchors.left:        parent.left
                anchors.leftMargin:  parent.width * 0.04
                anchors.right:       parent.right
                anchors.rightMargin: parent.width * 0.04
                height:              parent.height * 0.28
                radius:              20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.20) }
                    GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.04) }
                    GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
                }
            }

            // Bottom inner shadow
            Rectangle {
                z:                    -1
                anchors.bottom:       parent.bottom
                anchors.bottomMargin: 1
                anchors.left:         parent.left
                anchors.leftMargin:   parent.width * 0.05
                anchors.right:        parent.right
                anchors.rightMargin:  parent.width * 0.05
                height:               parent.height * 0.18
                radius:               20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0.00) }
                    GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.14) }
                }
            }

            // Drag handle
            Rectangle {
                z:                        1
                anchors.top:              parent.top
                anchors.topMargin:        10
                anchors.horizontalCenter: parent.horizontalCenter
                width: 36; height: 4; radius: 2
                color: Qt.rgba(1,1,1,0.22)
            }

            // ── ORIGINAL QGC CONTENT — completely unchanged ──────────────
            ColumnLayout {
                id:                  _mainLayout
                anchors.top:         parent.top
                anchors.topMargin:   24
                anchors.left:        parent.left
                anchors.right:       parent.right
                spacing:             _spacing

                // Arm + Link row (original)
                RowLayout {
                    spacing: ScreenTools.defaultFontPixelWidth

                    QGCDelayButton {
                        enabled:    _armed || !_healthAndArmingChecksSupported || _activeVehicle.healthAndArmingCheckReport.canArm
                        text:       _armed ? qsTr("Disarm") : (control._allowForceArm ? qsTr("Force Arm") : qsTr("Arm"))

                        onActivated: {
                            if (_armed) {
                                _activeVehicle.armed = false
                            } else {
                                if (_allowForceArm) {
                                    _allowForceArm = false
                                    _activeVehicle.forceArm()
                                } else {
                                    _activeVehicle.armed = true
                                }
                            }
                            mainWindow.closeIndicatorDrawer()
                        }
                    }

                    LabelledComboBox {
                        id:                 primaryLinkCombo
                        Layout.alignment:   Qt.AlignTop
                        label:              qsTr("Primary Link")
                        alternateText:      _primaryLinkName
                        visible:            _activeVehicle && _activeVehicle.vehicleLinkManager.linkNames.length > 1

                        property var    _rgLinkNames:       _activeVehicle ? _activeVehicle.vehicleLinkManager.linkNames : []
                        property var    _rgLinkStatus:      _activeVehicle ? _activeVehicle.vehicleLinkManager.linkStatuses : []
                        property string _primaryLinkName:   _activeVehicle ? _activeVehicle.vehicleLinkManager.primaryLinkName : ""

                        function updateComboModel() {
                            let linkModel = []
                            for (let i = 0; i < _rgLinkNames.length; i++) {
                                let linkStatus = _rgLinkStatus[i]
                                linkModel.push(_rgLinkNames[i] + (linkStatus === "" ? "" : " " + _rgLinkStatus[i]))
                            }
                            primaryLinkCombo.model = linkModel
                            primaryLinkCombo.currentIndex = -1
                        }

                        Component.onCompleted:  updateComboModel()
                        on_RgLinkNamesChanged:  updateComboModel()
                        on_RgLinkStatusChanged: updateComboModel()

                        onActivated: (index) => {
                            _activeVehicle.vehicleLinkManager.primaryLinkName = _rgLinkNames[index]
                            currentIndex = -1
                            mainWindow.closeIndicatorDrawer()
                        }
                    }
                }

                // Vehicle Messages (original SettingsGroupLayout — untouched)
                SettingsGroupLayout {
                    heading: qsTr("Vehicle Messages")
                    visible: !vehicleMessageList.noMessages

                    VehicleMessageList {
                        id: vehicleMessageList
                    }
                }

                // Sensor Status (original — untouched)
                SettingsGroupLayout {
                    heading: qsTr("Sensor Status")
                    visible: !_healthAndArmingChecksSupported

                    GridLayout {
                        rowSpacing:     _spacing
                        columnSpacing:  _spacing
                        rows:           _activeVehicle.sysStatusSensorInfo.sensorNames.length
                        flow:           GridLayout.TopToBottom

                        Repeater {
                            model: _activeVehicle.sysStatusSensorInfo.sensorNames
                            QGCLabel { text: modelData }
                        }

                        // Status column: QGCLabel replaced with LiquidGlassChip
                        Repeater {
                            model: _activeVehicle.sysStatusSensorInfo.sensorStatus

                            LiquidGlassChip {
                                chipText:  modelData
                                chipColor: control.chipColor(modelData)
                            }
                        }
                    }
                }

                // Overall Status / health checks (original — untouched)
                SettingsGroupLayout {
                    heading: qsTr("Overall Status")
                    visible: _healthAndArmingChecksSupported && _activeVehicle.healthAndArmingCheckReport.problemsForCurrentMode.count > 0

                    Repeater {
                        model:    _activeVehicle ? _activeVehicle.healthAndArmingCheckReport.problemsForCurrentMode : null
                        delegate: listdelegate
                    }
                }

                Component {
                    id: listdelegate
                    Column {
                        Row {
                            spacing: ScreenTools.defaultFontPixelHeight

                            QGCLabel {
                                id:           message
                                text:         object.message
                                textFormat:   TextEdit.RichText
                                color:        object.severity == 'error' ? qgcPal.colorRed : object.severity == 'warning' ? qgcPal.colorOrange : qgcPal.text
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (object.description != "")
                                            object.expanded = !object.expanded
                                    }
                                }
                            }

                            QGCColoredImage {
                                id:                     arrowDownIndicator
                                anchors.verticalCenter: parent.verticalCenter
                                height:                 1.5 * ScreenTools.defaultFontPixelWidth
                                width:                  height
                                source:                 "/qmlimages/arrow-down.png"
                                color:                  qgcPal.text
                                visible:                object.description != ""
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked:    object.expanded = !object.expanded
                                }
                            }
                        }

                        QGCLabel {
                            id:         description
                            text:       object.description
                            textFormat: TextEdit.RichText
                            clip:       true
                            visible:    object.expanded

                            property var fact: null

                            onLinkActivated: (link) => {
                                if (link.startsWith('param://')) {
                                    var paramName = link.substr(8)
                                    fact = controller.getParameterFact(-1, paramName, true)
                                    if (fact != null) {
                                        paramEditorDialogComponent.createObject(mainWindow).open()
                                    }
                                } else {
                                    Qt.openUrlExternally(link)
                                }
                            }

                            FactPanelController { id: controller }

                            Component {
                                id: paramEditorDialogComponent
                                ParameterEditorDialog {
                                    title:          qsTr("Edit Parameter")
                                    fact:           description.fact
                                    destroyOnClose: true
                                }
                            }
                        }
                    }
                }

            } // ColumnLayout _mainLayout
        } // Item _contentRoot
    } // Component mainStatusContentComponent

    // ════════════════════════════════════════════════════════════════════
    // EXPANDED PANEL — original content, glass underlay added
    // ════════════════════════════════════════════════════════════════════
    Component {
        id: mainStatusExpandedComponent

        Item {
            implicitWidth:  ScreenTools.defaultFontPixelWidth * 60
            implicitHeight: _expandLayout.implicitHeight + 24

            // Glass underlay
            Rectangle {
                z:               -1
                anchors.fill:    parent; anchors.margins: -1
                radius:          20
                gradient: Gradient {
                    orientation: Gradient.Diagonal
                    GradientStop { position: 0.00; color: Qt.rgba(1,1,1,0.52) }
                    GradientStop { position: 0.25; color: Qt.rgba(1,1,1,0.16) }
                    GradientStop { position: 0.55; color: Qt.rgba(1,1,1,0.04) }
                    GradientStop { position: 0.80; color: Qt.rgba(1,1,1,0.14) }
                    GradientStop { position: 1.00; color: Qt.rgba(1,1,1,0.40) }
                }
            }
            Rectangle {
                z:            -1
                anchors.fill: parent; radius: 20
                color:        Qt.rgba(1,1,1,0.09)
            }
            Rectangle {
                z:                   -1
                anchors.top:         parent.top; anchors.topMargin: 1
                anchors.left:        parent.left; anchors.leftMargin: parent.width * 0.04
                anchors.right:       parent.right; anchors.rightMargin: parent.width * 0.04
                height:              parent.height * 0.25; radius: 20
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(1,1,1,0.18) }
                    GradientStop { position: 1.0; color: Qt.rgba(1,1,1,0.00) }
                }
            }

            // Original expanded content — untouched
            ColumnLayout {
                id:                  _expandLayout
                anchors.top:         parent.top
                anchors.topMargin:   16
                anchors.left:        parent.left
                anchors.right:       parent.right
                anchors.margins:     ScreenTools.defaultFontPixelHeight
                spacing:             _margins / 2

                property real margins: ScreenTools.defaultFontPixelHeight

                Loader {
                    Layout.fillWidth: true
                    source:           _activeVehicle.expandedToolbarIndicatorSource("MainStatus")
                }

                SettingsGroupLayout {
                    Layout.fillWidth:   true
                    heading:            qsTr("Force Arm")
                    headingDescription: qsTr("Force arming bypasses pre-arm checks. Use with caution.")
                    visible:            _activeVehicle && !_armed

                    QGCCheckBoxSlider {
                        Layout.fillWidth: true
                        text:             qsTr("Allow Force Arm")
                        checked:          false
                        onClicked:        _allowForceArm = true
                    }
                }

                SettingsGroupLayout {
                    Layout.fillWidth: true
                    visible:          QGroundControl.corePlugin.showAdvancedUI

                    GridLayout {
                        columns:          2
                        rowSpacing:       ScreenTools.defaultFontPixelHeight / 2
                        columnSpacing:    ScreenTools.defaultFontPixelWidth * 2
                        Layout.fillWidth: true

                        QGCLabel { Layout.fillWidth: true; text: qsTr("Vehicle Parameters") }
                        QGCButton {
                            text: qsTr("Configure")
                            onClicked: {
                                mainWindow.showVehicleConfigParametersPage()
                                mainWindow.closeIndicatorDrawer()
                            }
                        }

                        QGCLabel { Layout.fillWidth: true; text: qsTr("Vehicle Configuration") }
                        QGCButton {
                            text: qsTr("Configure")
                            onClicked: {
                                mainWindow.showVehicleConfig()
                                mainWindow.closeIndicatorDrawer()
                            }
                        }
                    }
                }
            } // ColumnLayout _expandLayout
        } // Item expanded root
    } // Component mainStatusExpandedComponent

} // RowLayout
