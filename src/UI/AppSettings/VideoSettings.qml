// src/UI/AppSettings/VideoSettings.qml
import QtQuick
import QtCore
import QtQuick.Controls
import QtQuick.Layouts

import QGroundControl
import QGroundControl.FactControls
import QGroundControl.Controls

SettingsPage {
    property var    _settingsManager:            QGroundControl.settingsManager
    property var    _videoManager:              QGroundControl.videoManager
    property var    _videoSettings:             _settingsManager.videoSettings
    property string _videoSource:               _videoSettings.videoSource.rawValue
    property bool   _isGST:                     _videoManager.gstreamerEnabled
    property bool   _isStreamSource:            _videoManager.isStreamSource
    property bool   _isUDP264:                  _isStreamSource && (_videoSource === _videoSettings.udp264VideoSource)
    property bool   _isUDP265:                  _isStreamSource && (_videoSource === _videoSettings.udp265VideoSource)
    property bool   _isRTSP:                    _isStreamSource && (_videoSource === _videoSettings.rtspVideoSource)
    property bool   _isTCP:                     _isStreamSource && (_videoSource === _videoSettings.tcpVideoSource)
    property bool   _isMPEGTS:                  _isStreamSource && (_videoSource === _videoSettings.mpegtsVideoSource)
    property bool   _videoAutoStreamConfig:     _videoManager.autoStreamConfigured
    property bool   _videoSourceDisabled:       _videoSource === _videoSettings.disabledVideoSource
    property real   _urlFieldWidth:             ScreenTools.defaultFontPixelWidth * 40
    property bool   _requiresUDPUrl:            _isUDP264 || _isUDP265 || _isMPEGTS

    // ── Swarm feeds — all state lives in mainWindow.swarmState ─────────────────
    function _setLink(i, val)   { if (mainWindow.swarmState) mainWindow.swarmState.setLink(i, val) }
    function _setActive(i, val) { if (mainWindow.swarmState) mainWindow.swarmState.setActive(i, val) }
    function _setAllActive(val) { if (mainWindow.swarmState) mainWindow.swarmState.setAllActive(val) }

    // ── Video Source ──────────────────────────────────────────────────────────
    SettingsGroupLayout {
        Layout.fillWidth:   true
        heading:            qsTr("Video Source")
        headingDescription: _videoAutoStreamConfig ? qsTr("Mavlink camera stream is automatically configured") : ""
        enabled:            !_videoAutoStreamConfig

        LabelledFactComboBox {
            Layout.fillWidth:   true
            label:              qsTr("Source")
            indexModel:         false
            fact:               _videoSettings.videoSource
            visible:            fact.visible
        }
    }

    // ── Connection ────────────────────────────────────────────────────────────
    SettingsGroupLayout {
        Layout.fillWidth:   true
        heading:            qsTr("Connection")
        visible:            !_videoSourceDisabled && !_videoAutoStreamConfig && (_isTCP || _isRTSP | _requiresUDPUrl)

        LabelledFactTextField {
            Layout.fillWidth:           true
            textFieldPreferredWidth:    _urlFieldWidth
            label:                      qsTr("RTSP URL")
            fact:                       _videoSettings.rtspUrl
            visible:                    _isRTSP && _videoSettings.rtspUrl.visible
        }

        LabelledFactTextField {
            Layout.fillWidth:           true
            label:                      qsTr("TCP URL")
            textFieldPreferredWidth:    _urlFieldWidth
            fact:                       _videoSettings.tcpUrl
            visible:                    _isTCP && _videoSettings.tcpUrl.visible
        }

        LabelledFactTextField {
            Layout.fillWidth:           true
            textFieldPreferredWidth:    _urlFieldWidth
            label:                      qsTr("UDP URL")
            fact:                       _videoSettings.udpUrl
            visible:                    _requiresUDPUrl && _videoSettings.udpUrl.visible
        }
    }

    // ── Swarm feed persistence ────────────────────────────────────────────────
    Settings {
        id:       swarmSettings
        category: "SwarmFeeds"
        property string link0:   ""
        property string link1:   ""
        property string link2:   ""
        property string link3:   ""
        property bool   active0: false
        property bool   active1: false
        property bool   active2: false
        property bool   active3: false
    }

    // Expose as a list so FlyView can bind to it via SwarmManager or direct access
    // These properties are readable by any QML that has access to this page,
    // but more importantly swarmSettings persists them — FlyView reads swarmSettings directly.
    readonly property var _swarmLinks:  [swarmSettings.link0,  swarmSettings.link1,  swarmSettings.link2,  swarmSettings.link3]
    readonly property var _swarmActive: [swarmSettings.active0, swarmSettings.active1, swarmSettings.active2, swarmSettings.active3]


    // SettingsGroupLayout {
    //     Layout.fillWidth:   true
    //     heading:            qsTr("Video Source")
    //     headingDescription: _videoAutoStreamConfig ? qsTr("Mavlink camera stream is automatically configured") : ""
    //     enabled:            !_videoAutoStreamConfig

    //     LabelledFactComboBox {
    //         Layout.fillWidth:   true
    //         label:              qsTr("Source")
    //         indexModel:         false
    //         fact:               _videoSettings.videoSource
    //         visible:            fact.visible
    //     }
    // }

    // SettingsGroupLayout {
    //     Layout.fillWidth:   true
    //     heading:            qsTr("Connection")
    //     visible:            !_videoSourceDisabled && !_videoAutoStreamConfig && (_isTCP || _isRTSP | _requiresUDPUrl)

    //     LabelledFactTextField {
    //         Layout.fillWidth:           true
    //         textFieldPreferredWidth:    _urlFieldWidth
    //         label:                      qsTr("RTSP URL")
    //         fact:                       _videoSettings.rtspUrl
    //         visible:                    _isRTSP && _videoSettings.rtspUrl.visible
    //     }

    //     LabelledFactTextField {
    //         Layout.fillWidth:           true
    //         label:                      qsTr("TCP URL")
    //         textFieldPreferredWidth:    _urlFieldWidth
    //         fact:                       _videoSettings.tcpUrl
    //         visible:                    _isTCP && _videoSettings.tcpUrl.visible
    //     }

    //     LabelledFactTextField {
    //         Layout.fillWidth:           true
    //         textFieldPreferredWidth:    _urlFieldWidth
    //         label:                      qsTr("UDP URL")
    //         fact:                       _videoSettings.udpUrl
    //         visible:                    _requiresUDPUrl && _videoSettings.udpUrl.visible
    //     }
    // }

    // ── Swarm Video Feeds ─────────────────────────────────────────────────────
    SettingsGroupLayout {
        Layout.fillWidth: true
        heading:          qsTr("Swarm Video Feeds")
        headingDescription: qsTr("Add RTSP streams for additional drones. Active feeds appear as PIP boxes in FlyView.")

        // All ON / All OFF row
        RowLayout {
            Layout.fillWidth: true
            spacing:          ScreenTools.defaultFontPixelWidth

            QGCLabel {
                text:  qsTr("Activate all feeds:")
                color: qgcPal.text
            }

            Item { Layout.fillWidth: true }

            QGCButton {
                text:      qsTr("All ON")
                onClicked: _setAllActive(true)
            }

            QGCButton {
                text:      qsTr("All OFF")
                onClicked: _setAllActive(false)
            }
        }

        // // Divider
        // Rectangle {
        //     Layout.fillWidth: true
        //     height:           1
        //     color:            qgcPal.text
        //     opacity:          0.10
        // }

        // Drone 1
        SwarmFeedRow {
            Layout.fillWidth: true
            droneNumber:      1
            linkValue:        mainWindow.swarmState.link0
            activeValue:      mainWindow.swarmState.active0
            onLinkChanged:    function(v) { _setLink(0, v) }
            onActiveChanged:  function(v) { _setActive(0, v) }
        }

        // Drone 2
        SwarmFeedRow {
            Layout.fillWidth: true
            droneNumber:      2
            linkValue:        mainWindow.swarmState.link1
            activeValue:      mainWindow.swarmState.active1
            onLinkChanged:    function(v) { _setLink(1, v) }
            onActiveChanged:  function(v) { _setActive(1, v) }
        }

        // Drone 3
        SwarmFeedRow {
            Layout.fillWidth: true
            droneNumber:      3
            linkValue:        mainWindow.swarmState.link2
            activeValue:      mainWindow.swarmState.active2
            onLinkChanged:    function(v) { _setLink(2, v) }
            onActiveChanged:  function(v) { _setActive(2, v) }
        }

        // Drone 4
        SwarmFeedRow {
            Layout.fillWidth: true
            droneNumber:      4
            linkValue:        mainWindow.swarmState.link3
            activeValue:      mainWindow.swarmState.active3
            onLinkChanged:    function(v) { _setLink(3, v) }
            onActiveChanged:  function(v) { _setActive(3, v) }
        }
    }

    SettingsGroupLayout {
        Layout.fillWidth:   true
        heading:            qsTr("Settings")
        visible:            !_videoSourceDisabled

        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              qsTr("Aspect Ratio")
            fact:               _videoSettings.aspectRatio
            visible:            !_videoAutoStreamConfig && _isStreamSource && _videoSettings.aspectRatio.visible
        }

        FactCheckBoxSlider {
            Layout.fillWidth:   true
            text:               qsTr("Stop recording when disarmed")
            fact:               _videoSettings.disableWhenDisarmed
            visible:            !_videoAutoStreamConfig && _isStreamSource && fact.visible
        }

        FactCheckBoxSlider {
            Layout.fillWidth:   true
            text:               qsTr("Low Latency Mode")
            fact:               _videoSettings.lowLatencyMode
            visible:            !_videoAutoStreamConfig && _isStreamSource && fact.visible && _isGST
        }

        LabelledFactComboBox {
            Layout.fillWidth:   true
            label:              fact.shortDescription
            fact:               _videoSettings.forceVideoDecoder
            visible:            fact.visible
            indexModel:         false
        }
    }

    SettingsGroupLayout {
        Layout.fillWidth: true
        heading:            qsTr("Local Video Storage")

        LabelledFactComboBox {
            Layout.fillWidth:   true
            label:              qsTr("Record File Format")
            fact:               _videoSettings.recordingFormat
            visible:            _videoSettings.recordingFormat.visible
        }

        FactCheckBoxSlider {
            Layout.fillWidth:   true
            text:               qsTr("Auto-Delete Saved Recordings")
            fact:               _videoSettings.enableStorageLimit
            visible:            fact.visible
        }

        LabelledFactTextField {
            Layout.fillWidth:   true
            label:              qsTr("Max Storage Usage")
            fact:               _videoSettings.maxVideoSize
            visible:            fact.visible
            enabled:            _videoSettings.enableStorageLimit.rawValue
        }
    }

    // ── SwarmFeedRow component ────────────────────────────────────────────────
    // One row per drone: label | RTSP field | active toggle
    component SwarmFeedRow: RowLayout {
        property int    droneNumber:  1
        property string linkValue:    ""
        property bool   activeValue:  false
        signal linkChanged(string newValue)
        signal activeChanged(bool newValue)

        spacing: ScreenTools.defaultFontPixelWidth

        // Drone label
        QGCLabel {
            text:              qsTr("URL %1").arg(droneNumber)
            Layout.minimumWidth: ScreenTools.defaultFontPixelWidth * 8
        }

        // RTSP URL text field — matches style of existing LabelledFactTextField
        QGCTextField {
            id:                  _linkField
            Layout.fillWidth:    true
            placeholderText:     qsTr("rtsp://")
            text:                linkValue
            inputMethodHints:    Qt.ImhUrlCharactersOnly
            onEditingFinished: {
                var url = text.trim()
                if (url !== "" && !url.startsWith("rtsp://") &&
                    !url.startsWith("udp://") && !url.startsWith("tcp://"))
                    url = "rtsp://" + url
                linkChanged(url)
            }
        }

        // Active checkbox slider — same style as FactCheckBoxSlider
        QGCCheckBoxSlider {
            id:       _activeSlider
            checked:  activeValue
            enabled:  linkValue !== ""
            opacity:  linkValue !== "" ? 1.0 : 0.4
            onClicked: activeChanged(checked)
        }

        // Status label next to slider
        QGCLabel {
            text:              activeValue ? qsTr("Active") : qsTr("Off")
            color:             activeValue ? "#00FF8C" : qgcPal.colorGrey
            Layout.minimumWidth: ScreenTools.defaultFontPixelWidth * 5
            font.pointSize:    ScreenTools.smallFontPointSize
        }
    }
}
