import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FactControls

//-------------------------------------------------------------------------
//-- Battery Indicator
Item {
    id:             control
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          batteryIndicatorRow.width

    property bool       showIndicator:      _activeVehicle && _activeVehicle.batteries.count > 0
    property bool       waitForParameters:  true    // UI won't show until parameters are ready
    property Component  expandedPageComponent

    property var    _activeVehicle:     QGroundControl.multiVehicleManager.activeVehicle
    property var    _batterySettings:   QGroundControl.settingsManager.batteryIndicatorSettings
    property Fact   _indicatorDisplay:  _batterySettings.valueDisplay
    property bool   _showPercentage:    _indicatorDisplay.rawValue === 0
    property bool   _showVoltage:       _indicatorDisplay.rawValue === 1
    property bool   _showBoth:          _indicatorDisplay.rawValue === 2
    property int    _lowestBatteryId:   -1      // -1: show all batteries, otherwise show only battery with this id

    // Properties to hold the thresholds
    property int threshold1: _batterySettings.threshold1.rawValue
    property int threshold2: _batterySettings.threshold2.rawValue

    function _recalcLowestBatteryIdFromVoltage() {
        if (_activeVehicle) {
            // If there is only one battery then it is the lowest
            if (_activeVehicle.batteries.count === 1) {
                _lowestBatteryId = _activeVehicle.batteries.get(0).id.rawValue
                return
            }

            // If we have valid voltage for all batteries we use that to determine lowest battery
            let allHaveVoltage = true
            for (var i = 0; i < _activeVehicle.batteries.count; i++) {
                let battery = _activeVehicle.batteries.get(i)
                if (isNaN(battery.voltage.rawValue)) {
                    allHaveVoltage = false
                    break
                }
            }
            if (allHaveVoltage) {
                let lowestBattery = _activeVehicle.batteries.get(0)
                let lowestBatteryId = lowestBattery.id.rawValue
                for (var i = 1; i < _activeVehicle.batteries.count; i++) {
                    let battery = _activeVehicle.batteries.get(i)
                    if (battery.voltage.rawValue < lowestBattery.voltage.rawValue) {
                        lowestBattery = battery
                        lowestBatteryId = battery.id.rawValue
                    }
                }
                _lowestBatteryId = lowestBatteryId
                return
            }
        }

        // Couldn't determine lowest battery, show all
        _lowestBatteryId = -1
    }

    function _recalcLowestBatteryIdFromPercentage() {
        if (_activeVehicle) {
            // If there is only one battery then it is the lowest
            if (_activeVehicle.batteries.count === 1) {
                _lowestBatteryId = _activeVehicle.batteries.get(0).id.rawValue
                return
            }

            // If we have valid percentage for all batteries we use that to determine lowest battery
            let allHavePercentage = true
            for (var i = 0; i < _activeVehicle.batteries.count; i++) {
                let battery = _activeVehicle.batteries.get(i)
                if (isNaN(battery.percentRemaining.rawValue)) {
                    allHavePercentage = false
                    break
                }
            }
            if (allHavePercentage) {
                let lowestBattery = _activeVehicle.batteries.get(0)
                let lowestBatteryId = lowestBattery.id.rawValue
                for (var i = 1; i < _activeVehicle.batteries.count; i++) {
                    let battery = _activeVehicle.batteries.get(i)
                    if (battery.percentRemaining.rawValue < lowestBattery.percentRemaining.rawValue) {
                        lowestBattery = battery
                        lowestBatteryId = battery.id.rawValue
                    }
                }
                _lowestBatteryId = lowestBatteryId
                return
            }
        }

        // Couldn't determine lowest battery, show all
        _lowestBatteryId = -1
    }

    function _recalcLowestBatteryIdFromChargeState() {
        if (_activeVehicle) {
            // If there is only one battery then it is the lowest
            if (_activeVehicle.batteries.count === 1) {
                _lowestBatteryId = _activeVehicle.batteries.get(0).id.rawValue
                return
            }

            // If we have valid chargeState for all batteries we use that to determine lowest battery
            let allHaveChargeState = true
            for (var i = 0; i < _activeVehicle.batteries.count; i++) {
                let battery = _activeVehicle.batteries.get(i)
                if (battery.chargeState.rawValue === MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
                    allHaveChargeState = false
                    break
                }
            }
            if (allHaveChargeState) {
                let lowestBattery = _activeVehicle.batteries.get(0)
                let lowestBatteryId = lowestBattery.id.rawValue
                for (var i = 1; i < _activeVehicle.batteries.count; i++) {
                    let battery = _activeVehicle.batteries.get(i)
                    if (battery.chargeState.rawValue > lowestBattery.chargeState.rawValue) {
                        lowestBattery = battery
                        lowestBatteryId = battery.id.rawValue
                    }
                }
                _lowestBatteryId = lowestBatteryId
                return
            }
        }

        // Couldn't determine lowest battery, show all
        _lowestBatteryId = -1
    }

    function _recalcLowestBatteryId() {
        if (!_activeVehicle || _activeVehicle.batteries.count === 0) {
            _lowestBatteryId = -1
            return
        }
        if (_batterySettings.valueDisplay.rawValue === 0) {
            // User wants percentage display so use that if available
            _recalcLowestBatteryIdFromPercentage()
        } else if (_batterySettings.valueDisplay.rawValue === 1) {
            // User wants voltage display so use that if available
            _recalcLowestBatteryIdFromVoltage()
        }
        // If we still dont have a lowest battery id then try charge state
        if (_lowestBatteryId === -1) {
            _recalcLowestBatteryIdFromChargeState()
        }
    }

    Component.onCompleted: _recalcLowestBatteryId()

    Connections {
        target: _activeVehicle ? _activeVehicle.batteries : null
        function onCountChanged() {_recalcLowestBatteryId() }
    }

    QGCPalette { id: qgcPal }

    RowLayout {
        id:             batteryIndicatorRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth / 2

        Repeater {
            model: _activeVehicle ? _activeVehicle.batteries : 0

            Loader {
                Layout.fillHeight:  true
                sourceComponent:    batteryVisual
                visible:            control._lowestBatteryId === -1 || object.id.rawValue === control._lowestBatteryId || !control._batterySettings.consolidateMultipleBatteries.rawValue

                property var battery: object
            }
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked:      mainWindow.showIndicatorDrawer(batteryPopup, control)
    }

    Component {
        id: batteryPopup

        ToolIndicatorPage {
            showExpand:         expandedComponent ? true : false
            waitForParameters:  control.waitForParameters
            contentComponent:   batteryContentComponent
            expandedComponent:  batteryExpandedComponent
        }
    }

    Component {
        id: batteryVisual

        Row {
            Layout.fillHeight:  true
            spacing:            ScreenTools.defaultFontPixelWidth / 4

            function getBatteryColor() {
                switch (battery.chargeState.rawValue) {
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_OK:
                        if (!isNaN(battery.percentRemaining.rawValue)) {
                            if (battery.percentRemaining.rawValue > threshold1) {
                                return qgcPal.colorGreen
                            } else if (battery.percentRemaining.rawValue > threshold2) {
                                return qgcPal.colorYellowGreen
                            } else {
                                return qgcPal.colorYellow
                            }
                        } else {
                            return qgcPal.text
                        }
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_LOW:
                        return qgcPal.colorOrange
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_CRITICAL:
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_EMERGENCY:
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_FAILED:
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_UNHEALTHY:
                        return qgcPal.colorRed
                    default:
                        return qgcPal.text
                }
            }

            function getBatterySvgSource() {
                switch (battery.chargeState.rawValue) {
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_OK:
                        if (!isNaN(battery.percentRemaining.rawValue)) {
                            if (battery.percentRemaining.rawValue > threshold1) {
                                return "/qmlimages/BatteryGreen.svg"
                            } else if (battery.percentRemaining.rawValue > threshold2) {
                                return "/qmlimages/BatteryYellowGreen.svg"
                            } else {
                                return "/qmlimages/BatteryYellow.svg"
                            }
                        }
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_LOW:
                        return "/qmlimages/BatteryOrange.svg" // Low with orange svg
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_CRITICAL:
                        return "/qmlimages/BatteryCritical.svg" // Critical with red svg
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_EMERGENCY:
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_FAILED:
                    case MAVLink.MAV_BATTERY_CHARGE_STATE_UNHEALTHY:
                        return "/qmlimages/BatteryEMERGENCY.svg" // Exclamation mark
                    default:
                        return "/qmlimages/Battery.svg" // Fallback if percentage is unavailable
                }
            }

            function getBatteryPercentageText() {
                if (!isNaN(battery.percentRemaining.rawValue)) {
                    if (battery.percentRemaining.rawValue > 98.9) {
                        return qsTr("100%")
                    } else {
                        return battery.percentRemaining.valueString + battery.percentRemaining.units
                    }
                } else if (!isNaN(battery.voltage.rawValue)) {
                    return battery.voltage.valueString + battery.voltage.units
                } else if (battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
                    return battery.chargeState.enumStringValue
                }
                return qsTr("n/a")
            }

            function getBatteryVoltageText() {
                if (!isNaN(battery.voltage.rawValue)) {
                    return battery.voltage.valueString + battery.voltage.units
                } else if (battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED) {
                    return battery.chargeState.enumStringValue
                }
                return qsTr("n/a")
            }

            Timer {
                id:         debounceRecalcTimer
                interval:   50
                running:    false
                repeat:     false
                onTriggered: {
                    control._recalcLowestBatteryId()
                }
            }
            Connections {
                target: battery.percentRemaining
                function onRawValueChanged() {
                    debounceRecalcTimer.restart()
                }
            }
            Connections {
                target: battery.voltage
                function onRawValueChanged() {
                    debounceRecalcTimer.restart()
                }
            }
            Connections {
                target: battery.chargeState
                function onRawValueChanged() {
                    debounceRecalcTimer.restart()
                }
            }

            QGCColoredImage {
                anchors.top:        parent.top
                anchors.bottom:     parent.bottom
                width:              height
                sourceSize.width:   width
                source:             getBatterySvgSource()
                fillMode:           Image.PreserveAspectFit
                color:              getBatteryColor()
            }

           ColumnLayout {
                id:                     batteryInfoColumn
                anchors.top:            parent.top
                anchors.bottom:         parent.bottom
                spacing:                0

                QGCLabel {
                    Layout.alignment:       Qt.AlignHCenter
                    verticalAlignment:      Text.AlignVCenter
                    color:                  qgcPal.windowTransparentText
                    text:                   getBatteryPercentageText()
                    font.pointSize:         _showBoth ? ScreenTools.defaultFontPointSize : ScreenTools.mediumFontPointSize
                    visible:                _showBoth || _showPercentage
                }

                QGCLabel {
                    Layout.alignment:       Qt.AlignHCenter
                    font.pointSize:         _showBoth ? ScreenTools.defaultFontPointSize : ScreenTools.mediumFontPointSize
                    color:                  qgcPal.windowTransparentText
                    text:                   getBatteryVoltageText()
                    visible:                _showBoth || _showVoltage
                }
            }
        }
    }

    Component {
        id: batteryContentComponent

        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            Component {
                id: batteryValuesAvailableComponent

                QtObject {
                    property bool functionAvailable:         battery.function.rawValue !== MAVLink.MAV_BATTERY_FUNCTION_UNKNOWN
                    property bool showFunction:              functionAvailable && battery.function.rawValue != MAVLink.MAV_BATTERY_FUNCTION_ALL
                    property bool temperatureAvailable:      !isNaN(battery.temperature.rawValue)
                    property bool currentAvailable:          !isNaN(battery.current.rawValue)
                    property bool mahConsumedAvailable:      !isNaN(battery.mahConsumed.rawValue)
                    property bool timeRemainingAvailable:    !isNaN(battery.timeRemaining.rawValue)
                    property bool percentRemainingAvailable: !isNaN(battery.percentRemaining.rawValue)
                    property bool chargeStateAvailable:      battery.chargeState.rawValue !== MAVLink.MAV_BATTERY_CHARGE_STATE_UNDEFINED
                }
            }

            Repeater {
                model: _activeVehicle ? _activeVehicle.batteries : 0

                SettingsGroupLayout {
                    heading:        qsTr("Battery %1").arg(_activeVehicle.batteries.length === 1 ? qsTr("Status") : object.id.rawValue)
                    contentSpacing: 0
                    showDividers:   false

                    property var batteryValuesAvailable: batteryValuesAvailableLoader.item

                    Loader {
                        id:                 batteryValuesAvailableLoader
                        sourceComponent:    batteryValuesAvailableComponent

                        property var battery: object
                    }

                    LabelledLabel {
                        label:  qsTr("Charge State")
                        labelText:  object.chargeState.enumStringValue
                        visible:    batteryValuesAvailable.chargeStateAvailable
                    }

                    LabelledLabel {
                        label:      qsTr("Remaining")
                        labelText:  object.timeRemainingStr.value
                        visible:    batteryValuesAvailable.timeRemainingAvailable
                    }

                    LabelledLabel {
                        label:      qsTr("Remaining")
                        labelText:  object.percentRemaining.valueString + " " + object.percentRemaining.units
                        visible:    batteryValuesAvailable.percentRemainingAvailable
                    }

                    LabelledLabel {
                        label:      qsTr("Voltage")
                        labelText:  object.voltage.valueString + " " + object.voltage.units
                    }

                    LabelledLabel {
                        label:      qsTr("Consumed")
                        labelText:  object.mahConsumed.valueString + " " + object.mahConsumed.units
                        visible:    batteryValuesAvailable.mahConsumedAvailable
                    }

                    LabelledLabel {
                        label:      qsTr("Temperature")
                        labelText:  object.temperature.valueString + " " + object.temperature.units
                        visible:    batteryValuesAvailable.temperatureAvailable
                    }

                    LabelledLabel {
                        label:      qsTr("Function")
                        labelText:  object.function.enumStringValue
                        visible:    batteryValuesAvailable.showFunction
                    }
                }
            }
        }
    }

    Component {
        id: batteryExpandedComponent

        ColumnLayout {
            spacing: ScreenTools.defaultFontPixelHeight / 2

            property real batteryIconHeight: ScreenTools.defaultFontPixelWidth * 3

            FactPanelController { id: controller }

            SettingsGroupLayout {
                heading:            qsTr("Battery Display")
                Layout.fillWidth:   true

                FactCheckBoxSlider {
                    Layout.fillWidth:   true
                    fact:               _batterySettings.consolidateMultipleBatteries
                    text:               qsTr("Only show battery with lowest charge")
                    visible:            fact.visible
                }

                LabelledFactComboBox {
                    label:      qsTr("Value")
                    fact:       _batterySettings.valueDisplay
                    visible:    fact.visible
                }

                ColumnLayout {
                    QGCLabel { text: qsTr("Coloring") }

                    RowLayout {
                        spacing: ScreenTools.defaultFontPixelWidth

                        // Battery 100%
                        RowLayout {
                            spacing: ScreenTools.defaultFontPixelWidth * 0.05  // Tighter spacing for icon and label
                            QGCColoredImage {
                                source: "/qmlimages/BatteryGreen.svg"
                                width: height
                                height: batteryIconHeight
                                fillMode: Image.PreserveAspectFit
                                color: qgcPal.colorGreen
                            }
                            QGCLabel { text: qsTr("100%") }
                        }

                        // Threshold 1
                        RowLayout {
                            spacing: ScreenTools.defaultFontPixelWidth * 0.05  // Tighter spacing for icon and field
                            QGCColoredImage {
                                source: "/qmlimages/BatteryYellowGreen.svg"
                                width: height
                                height: batteryIconHeight
                                fillMode: Image.PreserveAspectFit
                                color: qgcPal.colorYellowGreen
                            }
                            FactTextField {
                                id: threshold1Field
                                fact: _batterySettings.threshold1
                                implicitWidth: ScreenTools.defaultFontPixelWidth * 6
                                height: ScreenTools.defaultFontPixelHeight * 1.5
                                enabled: fact.visible
                                onEditingFinished: {
                                    // Validate and set the new threshold value
                                    _batterySettings.setThreshold1(parseInt(text));
                                }
                            }
                        }

                        // Threshold 2
                        RowLayout {
                            spacing: ScreenTools.defaultFontPixelWidth * 0.05  // Tighter spacing for icon and field
                            QGCColoredImage {
                                source: "/qmlimages/BatteryYellow.svg"
                                width: height
                                height: batteryIconHeight
                                fillMode: Image.PreserveAspectFit
                                color: qgcPal.colorYellow
                            }
                            FactTextField {
                                fact: _batterySettings.threshold2
                                implicitWidth: ScreenTools.defaultFontPixelWidth * 6
                                height: ScreenTools.defaultFontPixelHeight * 1.5
                                enabled: fact.visible
                                onEditingFinished: {
                                    // Validate and set the new threshold value
                                    _batterySettings.setThreshold2(parseInt(text));
                                }
                            }
                        }

                        // Low state
                        RowLayout {
                            spacing: ScreenTools.defaultFontPixelWidth * 0.05  // Tighter spacing for icon and label
                            QGCColoredImage {
                                source: "/qmlimages/BatteryOrange.svg"
                                width: height
                                height: batteryIconHeight
                                fillMode: Image.PreserveAspectFit
                                color: qgcPal.colorOrange
                            }
                            QGCLabel { text: qsTr("Low") }
                        }

                        // Critical state
                        RowLayout {
                            spacing: ScreenTools.defaultFontPixelWidth * 0.05  // Tighter spacing for icon and label
                            QGCColoredImage {
                                source: "/qmlimages/BatteryCritical.svg"
                                width: height
                                height: batteryIconHeight
                                fillMode: Image.PreserveAspectFit
                                color: qgcPal.colorRed
                            }
                            QGCLabel { text: qsTr("Critical") }
                        }
                    }
                }
            }

            Loader {
                Layout.fillWidth:   true
                source:             _activeVehicle.expandedToolbarIndicatorSource("Battery")
            }

            SettingsGroupLayout {
                visible: _activeVehicle.autopilotPlugin.knownVehicleComponentAvailable(AutoPilotPlugin.KnownPowerVehicleComponent) &&
                            QGroundControl.corePlugin.showAdvancedUI

                LabelledButton {
                    label:      qsTr("Vehicle Power")
                    buttonText: qsTr("Configure")

                    onClicked: {
                        mainWindow.showKnownVehicleComponentConfigPage(AutoPilotPlugin.KnownPowerVehicleComponent)
                        mainWindow.closeIndicatorDrawer()
                    }
                }
            }
        }
    }
}


// // Modern glass battery status panel
// Rectangle {
//     width: 280
//     height: contentCol.height + 32
//     radius: 12
//     color: "transparent"
    
//     // Glass background
//     Item {
//         id: glassBack
//         anchors.fill: parent
//         z: 0
        
//         layer.enabled: true
//         layer.effect: OpacityMask {
//             maskSource: Rectangle {
//                 width: glassBack.width
//                 height: glassBack.height
//                 radius: 12
//             }
//         }
        
//         Rectangle {
//             anchors.fill: parent
//             color: Qt.rgba(0.02, 0.024, 0.045, 0.88)
//         }
        
//         Rectangle {
//             anchors.top: parent.top
//             anchors.left: parent.left
//             anchors.right: parent.right
//             height: parent.height * 0.25
//             gradient: Gradient {
//                 GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.06) }
//                 GradientStop { position: 1.0; color: "transparent" }
//             }
//         }
//     }
    
//     // Border
//     Rectangle {
//         anchors.fill: parent
//         color: "transparent"
//         radius: 12
//         border.color: Qt.rgba(1, 1, 1, 0.12)
//         border.width: 1
//         z: 1
//     }
    
//     Column {
//         id: contentCol
//         anchors.centerIn: parent
//         width: parent.width - 32
//         spacing: 16
//         z: 2
        
//         // Header with icon
//         Row {
//             width: parent.width
//             spacing: 12
            
//             // Battery icon with glow
//             Item {
//                 width: 32
//                 height: 32
                
//                 Rectangle {
//                     anchors.centerIn: parent
//                     width: 28
//                     height: 18
//                     radius: 3
//                     color: "transparent"
//                     border.color: batteryColor
//                     border.width: 2
                    
//                     property color batteryColor: {
//                         var percent = _activeVehicle ? _activeVehicle.battery.percentRemaining.value : 100
//                         if (percent > 50) return "#4caf50"
//                         if (percent > 20) return "#ff9800"
//                         return "#f44336"
//                     }
                    
//                     Rectangle {
//                         anchors.right: parent.right
//                         anchors.rightMargin: -4
//                         anchors.verticalCenter: parent.verticalCenter
//                         width: 3
//                         height: 8
//                         radius: 1.5
//                         color: parent.batteryColor
//                     }
                    
//                     Rectangle {
//                         anchors.left: parent.left
//                         anchors.leftMargin: 2
//                         anchors.verticalCenter: parent.verticalCenter
//                         anchors.top: parent.top
//                         anchors.topMargin: 2
//                         anchors.bottom: parent.bottom
//                         anchors.bottomMargin: 2
//                         width: (parent.width - 6) * (_activeVehicle ? _activeVehicle.battery.percentRemaining.value / 100 : 1.0)
//                         radius: 2
//                         color: parent.batteryColor
                        
//                         Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
//                         Behavior on color { ColorAnimation { duration: 300 } }
//                     }
                    
//                     layer.enabled: true
//                     layer.effect: Glow {
//                         radius: 8
//                         samples: 17
//                         color: parent.batteryColor
//                         transparentBorder: true
//                     }
//                 }
//             }
            
//             Column {
//                 anchors.verticalCenter: parent.verticalCenter
//                 spacing: 2
                
//                 Text {
//                     text: "Battery " + (_activeVehicle ? _activeVehicle.id : "0")
//                     font.pixelSize: 13
//                     font.weight: Font.SemiBold
//                     color: "#00d4ff"
//                 }
                
//                 Text {
//                     text: _activeVehicle ? _activeVehicle.battery.percentRemaining.value.toFixed(0) + "%" : "100%"
//                     font.pixelSize: 22
//                     font.weight: Font.Bold
//                     color: "#ffffff"
//                 }
//             }
//         }
        
//         // Divider
//         Rectangle {
//             width: parent.width
//             height: 1
//             color: Qt.rgba(1, 1, 1, 0.08)
//         }
        
//         // Stats grid
//         Grid {
//             width: parent.width
//             columns: 2
//             rowSpacing: 12
//             columnSpacing: 20
            
//             // Charge State
//             Column {
//                 spacing: 4
//                 Text {
//                     text: "Charge State"
//                     font.pixelSize: 10
//                     font.letterSpacing: 0.5
//                     color: Qt.rgba(1, 1, 1, 0.5)
//                 }
//                 Text {
//                     text: _activeVehicle && _activeVehicle.battery.chargeState.value !== 0 ? "Charging" : "Ok"
//                     font.pixelSize: 13
//                     font.weight: Font.Medium
//                     color: "#4caf50"
//                 }
//             }
            
//             // Remaining
//             Column {
//                 spacing: 4
//                 Text {
//                     text: "Remaining"
//                     font.pixelSize: 10
//                     font.letterSpacing: 0.5
//                     color: Qt.rgba(1, 1, 1, 0.5)
//                 }
//                 Text {
//                     text: _activeVehicle ? _activeVehicle.battery.percentRemaining.value.toFixed(0) + " %" : "100 %"
//                     font.pixelSize: 13
//                     font.weight: Font.Medium
//                     color: "#00d4ff"
//                 }
//             }
            
//             // Voltage
//             Column {
//                 spacing: 4
//                 Text {
//                     text: "Voltage"
//                     font.pixelSize: 10
//                     font.letterSpacing: 0.5
//                     color: Qt.rgba(1, 1, 1, 0.5)
//                 }
//                 Text {
//                     text: _activeVehicle ? _activeVehicle.battery.voltage.valueString + " V" : "12.60 V"
//                     font.pixelSize: 13
//                     font.weight: Font.Medium
//                     color: "#ffffff"
//                 }
//             }
            
//             // Consumed
//             Column {
//                 spacing: 4
//                 Text {
//                     text: "Consumed"
//                     font.pixelSize: 10
//                     font.letterSpacing: 0.5
//                     color: Qt.rgba(1, 1, 1, 0.5)
//                 }
//                 Text {
//                     text: _activeVehicle ? _activeVehicle.battery.mahConsumed.valueString + " mAh" : "0 mAh"
//                     font.pixelSize: 13
//                     font.weight: Font.Medium
//                     color: "#ffffff"
//                 }
//             }
//         }
//     }
// }
