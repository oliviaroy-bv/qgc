// // src/FlyView/FlyView.qml
// import QtQuick
// import QtQuick.Controls
// import QtQuick.Dialogs
// import QtQuick.Layouts
// import QtCore
// import QtMultimedia
// import Qt5Compat.GraphicalEffects

// import QtLocation
// import QtPositioning
// import QtQuick.Window
// import QtQml.Models

// import QGroundControl
// import QGroundControl.Controls
// import QGroundControl.FlyView
// import QGroundControl.FlightMap
// import QGroundControl.Viewer3D

// Item {
//     id: _root

//     // These should only be used by MainRootWindow
//     property var planController:    _planController
//     property var guidedController:  _guidedController

//     PlanMasterController {
//         id:                     _planController
//         flyView:                true
//         Component.onCompleted:  start()
//     }

//     property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
//     property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
//     property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
//     property var    _missionController:     _planController.missionController
//     property var    _geoFenceController:    _planController.geoFenceController
//     property var    _rallyPointController:  _planController.rallyPointController
//     property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
//     property var    _guidedController:      guidedActionsController
//     property var    _guidedValueSlider:     guidedValueSlider
//     property var    _widgetLayer:           widgetLayer
//     property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
//     property rect   _centerViewport:        Qt.rect(0, 0, width, height)
//     property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
//     property var    _mapControl:            mapControl
//     property real   _widgetMargin:          ScreenTools.defaultFontPixelWidth * 0.75

//     property real   _fullItemZorder:    0
//     property real   _pipItemZorder:     QGroundControl.zOrderWidgets

//     // ── Swarm settings — reads same category written by VideoSettings.qml ─────
//     Settings {
//         id:       _swarmSettings
//         category: "SwarmFeeds"
//         property string link0:   ""
//         property string link1:   ""
//         property string link2:   ""
//         property string link3:   ""
//         property bool   active0: false
//         property bool   active1: false
//         property bool   active2: false
//         property bool   active3: false
//     }

//     // Build active feeds list reactively — recalculates whenever settings change
//     readonly property var _swarmFeeds: {
//         var feeds = []
//         var links  = [_swarmSettings.link0,  _swarmSettings.link1,  _swarmSettings.link2,  _swarmSettings.link3]
//         var active = [_swarmSettings.active0, _swarmSettings.active1, _swarmSettings.active2, _swarmSettings.active3]
//         for (var i = 0; i < 4; i++) {
//             if (active[i] && links[i] !== "")
//                 feeds.push({ index: i, label: "Drone " + (i+1), link: links[i] })
//         }
//         return feeds
//     }

//     function _calcCenterViewPort() {
//         var newToolInset = Qt.rect(0, 0, width, height)
//         toolstrip.adjustToolInset(newToolInset)
//     }

//     function dropMainStatusIndicatorTool() {
//         toolbar.dropMainStatusIndicatorTool();
//     }

//     QGCToolInsets {
//         id:                     _toolInsets
//         topEdgeLeftInset:       toolbar.height
//         topEdgeCenterInset:     topEdgeLeftInset
//         topEdgeRightInset:      topEdgeLeftInset
//         leftEdgeBottomInset:    _pipView.leftEdgeBottomInset
//         bottomEdgeLeftInset:    _pipView.bottomEdgeLeftInset
//     }

//     Item {
//         id:                 mapHolder
//         anchors.fill:       parent

//         FlyViewMap {
//             id:                     mapControl
//             planMasterController:   _planController
//             rightPanelWidth:        ScreenTools.defaultFontPixelHeight * 9
//             pipView:                _pipView
//             pipMode:                !_mainWindowIsMap
//             toolInsets:             customOverlay.totalToolInsets
//             mapName:                "FlightDisplayView"
//             enabled:                !viewer3DWindow.isOpen
//         }

//         FlyViewVideo {
//             id:         videoControl
//             pipView:    _pipView
//         }

//         PipView {
//             id:                     _pipView
//             anchors.left:           parent.left
//             anchors.bottom:         parent.bottom
//             anchors.margins:        _toolsMargin
//             item1IsFullSettingsKey: "MainFlyWindowIsMap"
//             item1:                  mapControl
//             item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
//             show:                   QGroundControl.videoManager.hasVideo && !QGroundControl.videoManager.fullScreen &&
//                                         (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
//             z:                      QGroundControl.zOrderWidgets

//             property real leftEdgeBottomInset: visible ? width + anchors.margins : 0
//             property real bottomEdgeLeftInset: visible ? height + anchors.margins : 0
//         }

//         // ── Swarm PIP boxes — stacked above the existing _pipView ─────────────
//         // Each active feed gets its own MediaPlayer + VideoOutput, matching the
//         // same left-margin placement as the existing QGC PIP video box.
//         Column {
//             id:                  _swarmPipColumn
//             anchors.left:        parent.left
//             anchors.bottom:      _pipView.visible ? _pipView.top : parent.bottom
//             anchors.margins:     _toolsMargin
//             anchors.bottomMargin: _toolsMargin
//             spacing:             _toolsMargin
//             z:                   QGroundControl.zOrderWidgets
//             visible:             _root._swarmFeeds.length > 0 && !QGroundControl.videoManager.fullScreen

//             Repeater {
//                 id:    _swarmRepeater
//                 model: _root._swarmFeeds

//                 delegate: SwarmPIPBox {
//                     droneLabel: modelData.label
//                     rtspLink:   modelData.link
//                     boxWidth:   _pipView.visible ? _pipView.width : ScreenTools.defaultFontPixelWidth * 18
//                 }
//             }
//         }

//         FlyViewWidgetLayer {
//             id:                     widgetLayer
//             anchors.top:            parent.top
//             anchors.bottom:         parent.bottom
//             anchors.left:           parent.left
//             anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
//             anchors.margins:        _widgetMargin
//             anchors.topMargin:      toolbar.height + _widgetMargin
//             z:                      _fullItemZorder + 2 // we need to add one extra layer for map 3d viewer (normally was 1)
//             parentToolInsets:       _toolInsets
//             mapControl:             _mapControl
//             visible:                !QGroundControl.videoManager.fullScreen
//             isViewer3DOpen:         viewer3DWindow.isOpen
//         }

//         FlyViewCustomLayer {
//             id:                 customOverlay
//             anchors.fill:       widgetLayer
//             z:                  _fullItemZorder + 2
//             parentToolInsets:   widgetLayer.totalToolInsets
//             mapControl:         _mapControl
//             visible:            !QGroundControl.videoManager.fullScreen
//         }

//         // Development tool for visualizing the insets for a paticular layer, show if needed
//         FlyViewInsetViewer {
//             id:                     widgetLayerInsetViewer
//             anchors.top:            parent.top
//             anchors.bottom:         parent.bottom
//             anchors.left:           parent.left
//             anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
//             z:                      widgetLayer.z + 1
//             insetsToView:           widgetLayer.totalToolInsets
//             visible:                false
//         }

//         GuidedActionsController {
//             id:                 guidedActionsController
//             missionController:  _missionController
//             guidedValueSlider:     _guidedValueSlider
//         }

//         //-- Guided value slider (e.g. altitude)
//         GuidedValueSlider {
//             id:                 guidedValueSlider
//             anchors.right:      parent.right
//             anchors.top:        parent.top
//             anchors.bottom:     parent.bottom
//             anchors.topMargin:  toolbar.height
//             z:                  QGroundControl.zOrderTopMost
//             visible:            false
//         }

//         Viewer3D {
//             id: viewer3DWindow
//             anchors.fill: parent
//         }
//     }

//     FlyViewToolBar {
//         id:                 toolbar
//         guidedValueSlider:  _guidedValueSlider
//         visible:            !QGroundControl.videoManager.fullScreen
//     }

//     TelemetryValuesBar {
//         id: bottomCenterTelemetryBar

//         // ── Default position (anchored to bottom-centre) ──────────────────────────
//         // These are overridden to absolute x/y when unlocked and dragged.
//         anchors.bottom:           parent.bottom
//         anchors.horizontalCenter: parent.horizontalCenter
//         anchors.bottomMargin:     7

//         z:             QGroundControl.zOrderWidgets
//         mapSourceItem: _mapControl //flightMap          // ← use your actual map item id
//         visible:       !QGroundControl.videoManager.fullScreen

//         // ── Handle unlock → clear anchors so x/y can be set freely ──────────────
//         onLockChanged: function(locked) {
//             if (!locked) {
//                 // Snapshot current screen position BEFORE clearing anchors
//                 var absX = bottomCenterTelemetryBar.x
//                 var absY = bottomCenterTelemetryBar.y

//                 // Clear all anchors — otherwise Qt ignores x/y assignments
//                 bottomCenterTelemetryBar.anchors.bottom           = undefined
//                 bottomCenterTelemetryBar.anchors.horizontalCenter = undefined
//                 bottomCenterTelemetryBar.anchors.bottomMargin     = 0

//                 // Place bar at exact same pixel position it was at
//                 bottomCenterTelemetryBar.x = absX
//                 bottomCenterTelemetryBar.y = absY

//             } else {
//                 // Re-lock: keep x/y as-is (anchors stay cleared so bar stays put)
//                 // Anchors are NOT restored — bar just sits at its current x/y.
//                 // To restore to bottom-centre on lock, uncomment the 3 lines below:
//                 // bottomCenterTelemetryBar.anchors.bottom           = parent.bottom
//                 // bottomCenterTelemetryBar.anchors.horizontalCenter = parent.horizontalCenter
//                 // bottomCenterTelemetryBar.anchors.bottomMargin     = 7
//             }
//         }

//         // ── Apply x/y from drag ───────────────────────────────────────────────────
//         onDragPositionChanged: function(px, py) {
//             bottomCenterTelemetryBar.x = px
//             bottomCenterTelemetryBar.y = py
//         }
//     }
    
    
//     // Gimbal Control Widget - Bottom Right
//     Loader {
//         id:                     gimbalControlLoader
//         anchors.right:          parent.right
//         anchors.bottom:         parent.bottom
//         // anchors.rightMargin:    20
//         // anchors.bottomMargin:   100
//         anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 2
//         anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight * 10
//         source:                 "qrc:/qml/GimbalControl.qml"
//         visible:                true
//         z:                      QGroundControl.zOrderWidgets
//     }

//     // ── Swarm fullscreen expanded overlay ─────────────────────────────────────
//     // When user taps a PIP box it expands to cover the full FlyView.
//     // Sits above everything including the toolbar.
//     Item {
//         id:      _swarmFullscreen
//         anchors.fill: parent
//         visible: _swarmFullscreen._expandedLink !== ""
//         z:       QGroundControl.zOrderTopMost + 1

//         property string _expandedLabel: ""
//         property string _expandedLink:  ""

//         // Start/stop player reactively when link is set/cleared
//         // onExpandedLinkChanged: {
//         //     if (_expandedLink !== "")
//         //         _fsPlayer.play()
//         //     else
//         //         _fsPlayer.stop()
//         // }

//         // Dark backdrop
//         Rectangle {
//             anchors.fill: parent
//             color:        Qt.rgba(0, 0, 0, 0.92)
//         }

//         MediaPlayer {
//             id:          _fsPlayer
//             source:      _swarmFullscreen._expandedLink
//             videoOutput: _fsVideo
//             onPlaybackStateChanged: {
//                 if (playbackState === MediaPlayer.StoppedState && _swarmFullscreen._expandedLink !== "")
//                     play()
//             }
//         }

//         VideoOutput {
//             id:           _fsVideo
//             anchors.fill: parent
//             fillMode:     VideoOutput.PreserveAspectFit
//         }

//         // No signal placeholder
//         Column {
//             anchors.centerIn: parent
//             spacing:          ScreenTools.defaultFontPixelHeight * 0.6
//             visible:          _fsPlayer.playbackState !== MediaPlayer.PlayingState

//             Text {
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 text:           "📡"
//                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 3
//             }
//             Text {
//                 anchors.horizontalCenter: parent.horizontalCenter
//                 text:           qsTr("Connecting to %1...").arg(_swarmFullscreen._expandedLabel)
//                 font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
//                 color:          Qt.rgba(1,1,1,0.45)
//             }
//         }

//         // Top bar with label + collapse button
//         Rectangle {
//             anchors.top:   parent.top
//             anchors.left:  parent.left
//             anchors.right: parent.right
//             height:        ScreenTools.toolbarHeight
//             color:         Qt.rgba(0, 0, 0, 0.70)

//             Row {
//                 anchors.fill:        parent
//                 anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 2
//                 anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
//                 spacing:             ScreenTools.defaultFontPixelWidth

//                 Text {
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:           _swarmFullscreen._expandedLabel
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.92
//                     font.weight:    Font.SemiBold
//                     color:          Qt.rgba(0, 0.83, 1, 0.95)
//                     width:          parent.width - _collapseBtn.width - parent.spacing
//                     elide:          Text.ElideRight
//                 }

//                 // Collapse button — same glass style as existing QGC buttons
//                 Rectangle {
//                     id:                     _collapseBtn
//                     anchors.verticalCenter: parent.verticalCenter
//                     width:                  ScreenTools.defaultFontPixelWidth * 11
//                     height:                 ScreenTools.defaultFontPixelHeight * 2.2
//                     radius:                 6
//                     color:                  _collapseMa.containsMouse
//                                                 ? Qt.rgba(1,1,1,0.15)
//                                                 : Qt.rgba(1,1,1,0.07)
//                     border.color:           Qt.rgba(1,1,1,0.22)
//                     border.width:           1
//                     Behavior on color { ColorAnimation { duration: 80 } }

//                     Row {
//                         anchors.centerIn: parent
//                         spacing:          6
//                         Text { anchors.verticalCenter: parent.verticalCenter; text: "⊠"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85; color: Qt.rgba(1,1,1,0.80) }
//                         Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Collapse"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78; color: Qt.rgba(1,1,1,0.80) }
//                     }
//                     MouseArea {
//                         id:           _collapseMa
//                         anchors.fill: parent
//                         hoverEnabled: true
//                         cursorShape:  Qt.PointingHandCursor
//                         onClicked: {
//                             _fsPlayer.stop()
//                             _swarmFullscreen._expandedLink  = ""
//                             _swarmFullscreen._expandedLabel = ""
//                         }
//                     }
//                 }
//             }
//         }

//         // RTSP URL watermark at bottom
//         Text {
//             anchors.bottom:           parent.bottom
//             anchors.bottomMargin:     ScreenTools.defaultFontPixelHeight * 0.6
//             anchors.horizontalCenter: parent.horizontalCenter
//             text:           _swarmFullscreen._expandedLink
//             font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.62
//             color:          Qt.rgba(1,1,1,0.20)
//             elide:          Text.ElideMiddle
//             width:          parent.width * 0.7
//             horizontalAlignment: Text.AlignHCenter
//         }
//     }

//     // // Start/stop fullscreen player when link changes
//     // Connections {
//     //     target: _swarmFullscreen
//     //     function onExpandedLinkChanged() {
//     //         if (_swarmFullscreen._expandedLink !== "")
//     //             _fsPlayer.play()
//     //         else
//     //             _fsPlayer.stop()
//     //     }
//     // }

//     // ── SwarmPIPBox — one PIP box per active drone ────────────────────────────
//     component SwarmPIPBox: Item {
//         id:              _pipBox
//         property string  droneLabel: ""
//         property string  rtspLink:   ""
//         property real    boxWidth:   ScreenTools.defaultFontPixelWidth * 6

//         width:  boxWidth
//         height: boxWidth * 9 / 16   // 16:9 aspect ratio

//         // Rounded clip mask
//         layer.enabled: true
//         layer.effect: OpacityMask {
//             maskSource: Rectangle {
//                 width:  _pipBox.width
//                 height: _pipBox.height
//                 radius: 6
//             }
//         }

//         // Video player
//         MediaPlayer {
//             id:          _pipPlayer
//             source:      rtspLink
//             videoOutput: _pipVideo
//             onPlaybackStateChanged: {
//                 if (playbackState === MediaPlayer.StoppedState && rtspLink !== "")
//                     play()
//             }
//         }

//         VideoOutput {
//             id:           _pipVideo
//             anchors.fill: parent
//             fillMode:     VideoOutput.PreserveAspectCrop
//         }

//         // No signal overlay
//         Rectangle {
//             anchors.fill: parent
//             color:        Qt.rgba(0.06, 0.07, 0.10, 0.90)
//             visible:      _pipPlayer.playbackState !== MediaPlayer.PlayingState

//             Column {
//                 anchors.centerIn: parent
//                 spacing:          4
//                 Text { anchors.horizontalCenter: parent.horizontalCenter; text: "📡"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.5 }
//                 Text {
//                     anchors.horizontalCenter: parent.horizontalCenter
//                     text:           qsTr("No Signal")
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
//                     color:          Qt.rgba(1,1,1,0.40)
//                 }
//             }
//         }

//         // Glass border — highlights on hover
//         Rectangle {
//             anchors.fill:  parent
//             radius:        6
//             color:         "transparent"
//             border.color:  _pipMa.containsMouse ? Qt.rgba(0,0.83,1,0.80) : Qt.rgba(1,1,1,0.30)
//             border.width:  1
//             Behavior on border.color { ColorAnimation { duration: 120 } }
//         }

//         // Label strip at bottom — same style as QGC PIP label
//         Rectangle {
//             anchors.bottom: parent.bottom
//             anchors.left:   parent.left
//             anchors.right:  parent.right
//             height:         ScreenTools.defaultFontPixelHeight * 1.8
//             color:          Qt.rgba(0, 0, 0, 0.65)

//             Row {
//                 anchors.fill:        parent
//                 anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 0.6
//                 anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 0.6
//                 spacing:             4

//                 // Live dot
//                 Rectangle {
//                     width:  6; height: 6; radius: 3
//                     anchors.verticalCenter: parent.verticalCenter
//                     color: _pipPlayer.playbackState === MediaPlayer.PlayingState
//                                ? Qt.rgba(0,1,0.55,1) : Qt.rgba(1,1,1,0.25)
//                     SequentialAnimation on opacity {
//                         running: _pipPlayer.playbackState === MediaPlayer.PlayingState
//                         loops:   Animation.Infinite
//                         NumberAnimation { to: 0.3; duration: 800 }
//                         NumberAnimation { to: 1.0; duration: 800 }
//                     }
//                 }

//                 Text {
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:           droneLabel
//                     font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.65
//                     font.weight:    Font.Medium
//                     color:          Qt.rgba(1,1,1,0.88)
//                     elide:          Text.ElideRight
//                     width:          parent.width - _expandHint.width - 10
//                 }

//                 Text {
//                     id:                     _expandHint
//                     anchors.verticalCenter: parent.verticalCenter
//                     text:                   "⤢"
//                     font.pixelSize:         ScreenTools.defaultFontPixelHeight * 0.70
//                     color:                  _pipMa.containsMouse ? Qt.rgba(0,0.83,1,1) : Qt.rgba(1,1,1,0.35)
//                     Behavior on color { ColorAnimation { duration: 100 } }
//                 }
//             }
//         }

//         // Tap to expand fullscreen
//         MouseArea {
//             id:           _pipMa
//             anchors.fill: parent
//             hoverEnabled: true
//             cursorShape:  Qt.PointingHandCursor
//             onClicked: {
//                 _swarmFullscreen._expandedLabel = droneLabel
//                 _swarmFullscreen._expandedLink  = rtspLink
//             }
//         }

//         Component.onCompleted:  _pipPlayer.play()
//         Component.onDestruction: _pipPlayer.stop()
//     }
// }


// src/FlyView/FlyView.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import QtCore
import QtMultimedia
import Qt5Compat.GraphicalEffects

import QtLocation
import QtPositioning
import QtQuick.Window
import QtQml.Models

import QGroundControl
import QGroundControl.Controls
import QGroundControl.FlyView
import QGroundControl.FlightMap
import QGroundControl.Viewer3D

Item {
    id: _root

    // These should only be used by MainRootWindow
    property var planController:    _planController
    property var guidedController:  _guidedController

    PlanMasterController {
        id:                     _planController
        flyView:                true
        Component.onCompleted:  start()
    }

    property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _missionController:     _planController.missionController
    property var    _geoFenceController:    _planController.geoFenceController
    property var    _rallyPointController:  _planController.rallyPointController
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property var    _guidedController:      guidedActionsController
    property var    _guidedValueSlider:     guidedValueSlider
    property var    _widgetLayer:           widgetLayer
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property var    _mapControl:            mapControl
    property real   _widgetMargin:          ScreenTools.defaultFontPixelWidth * 0.75

    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets

    // ── Swarm settings — reads same category written by VideoSettings.qml ─────
    Settings {
        id:       _swarmSettings
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

    // ── Swarm feeds ListModel — rebuilt whenever any setting changes ──────────
    // Using ListModel instead of a computed var array because QML Repeater
// only reacts to ListModel changes, not var array reassignment.
    ListModel {
        id: _swarmFeedsModel
    }

    function _rebuildSwarmFeeds() {
        if (!mainWindow.swarmState) return
        _swarmFeedsModel.clear()
        var links  = [mainWindow.swarmState.link0,  mainWindow.swarmState.link1,  mainWindow.swarmState.link2,  mainWindow.swarmState.link3]
        var active = [mainWindow.swarmState.active0, mainWindow.swarmState.active1, mainWindow.swarmState.active2, mainWindow.swarmState.active3]
        var labels = [mainWindow.swarmState.label0,  mainWindow.swarmState.label1,  mainWindow.swarmState.label2,  mainWindow.swarmState.label3]
        for (var i = 0; i < 4; i++) {
            if (active[i] && links[i] !== "")
                _swarmFeedsModel.append({ droneIndex: i, droneLabel: labels[i], droneLink: links[i] })
        }
    }

    // Watch every individual settings property — any change triggers a rebuild
    Connections {
        target: mainWindow.swarmState ? mainWindow.swarmState : null
        ignoreUnknownSignals: true
        function onLink0Changed()   { _rebuildSwarmFeeds() }
        function onLink1Changed()   { _rebuildSwarmFeeds() }
        function onLink2Changed()   { _rebuildSwarmFeeds() }
        function onLink3Changed()   { _rebuildSwarmFeeds() }
        function onActive0Changed() { _rebuildSwarmFeeds() }
        function onActive1Changed() { _rebuildSwarmFeeds() }
        function onActive2Changed() { _rebuildSwarmFeeds() }
        function onActive3Changed() { _rebuildSwarmFeeds() }
    }

    Component.onCompleted: Qt.callLater(_rebuildSwarmFeeds)

    function _calcCenterViewPort() {
        var newToolInset = Qt.rect(0, 0, width, height)
        toolstrip.adjustToolInset(newToolInset)
    }

    function dropMainStatusIndicatorTool() {
        toolbar.dropMainStatusIndicatorTool();
    }

    QGCToolInsets {
        id:                     _toolInsets
        topEdgeLeftInset:       toolbar.height
        topEdgeCenterInset:     topEdgeLeftInset
        topEdgeRightInset:      topEdgeLeftInset
        leftEdgeBottomInset:    _pipView.leftEdgeBottomInset
        bottomEdgeLeftInset:    _pipView.bottomEdgeLeftInset
    }

    Item {
        id:                 mapHolder
        anchors.fill:       parent

        FlyViewMap {
            id:                     mapControl
            planMasterController:   _planController
            rightPanelWidth:        ScreenTools.defaultFontHeight * 9
            pipView:                _pipView
            pipMode:                !_mainWindowIsMap
            toolInsets:             customOverlay.totalToolInsets
            mapName:                "FlightDisplayView"
            enabled:                !viewer3DWindow.isOpen
        }

        FlyViewVideo {
            id:         videoControl
            pipView:    _pipView
        }

        PipView {
            id:                     _pipView
            anchors.left:           parent.left
            anchors.bottom:         parent.bottom
            anchors.margins:        _toolsMargin
            item1IsFullSettingsKey: "MainFlyWindowIsMap"
            item1:                  mapControl
            item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
            show:                   QGroundControl.videoManager.hasVideo && !QGroundControl.videoManager.fullScreen &&
                                        (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
            z:                      QGroundControl.zOrderWidgets
            visible: _swarmFeedsModel.count > 0 ? false : true

            property real leftEdgeBottomInset: visible ? width + anchors.margins : 0
            property real bottomEdgeLeftInset: visible ? height + anchors.margins : 0
        }

        // ── Swarm PIP boxes — stacked above the existing _pipView ─────────────
        // Each active feed gets its own MediaPlayer + VideoOutput, matching the
        // same left-margin placement as the existing QGC PIP video box.
        Column {
            id:                  _swarmPipColumn
            anchors.left:        parent.left
            anchors.bottom:      parent.bottom
            anchors.margins:     _toolsMargin
            anchors.bottomMargin: _toolsMargin
            spacing:             _toolsMargin
            z:                   QGroundControl.zOrderWidgets
            visible:             _swarmFeedsModel.count > 0 && !QGroundControl.videoManager.fullScreen

            Repeater {
                id:    _swarmRepeater
                model: _swarmFeedsModel

                delegate: SwarmPIPBox {
                    droneLabel: model.droneLabel
                    rtspLink:   model.droneLink
                    boxWidth:   ScreenTools.defaultFontPixelWidth * 34
                    // Divide available vertical space evenly across 4 slots
                    // _root and toolbar are in scope here (delegate level), not inside component
                    boxHeight:  (_root.height - toolbar.height - (7 * _toolsMargin)) / 5
                }
            }
        }

        FlyViewWidgetLayer {
            id:                     widgetLayer
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
            anchors.margins:        _widgetMargin
            anchors.topMargin:      toolbar.height + _widgetMargin
            z:                      _fullItemZorder + 2
            parentToolInsets:       _toolInsets
            mapControl:             _mapControl
            visible:                !QGroundControl.videoManager.fullScreen
            isViewer3DOpen:         viewer3DWindow.isOpen
        }

        FlyViewCustomLayer {
            id:                 customOverlay
            anchors.fill:       widgetLayer
            z:                  _fullItemZorder + 2
            parentToolInsets:   widgetLayer.totalToolInsets
            mapControl:         _mapControl
            visible:            !QGroundControl.videoManager.fullScreen
        }

        FlyViewInsetViewer {
            id:                     widgetLayerInsetViewer
            anchors.top:            parent.top
            anchors.bottom:         parent.bottom
            anchors.left:           parent.left
            anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
            z:                      widgetLayer.z + 1
            insetsToView:           widgetLayer.totalToolInsets
            visible:                false
        }

        GuidedActionsController {
            id:                 guidedActionsController
            missionController:  _missionController
            guidedValueSlider:  _guidedValueSlider
        }

        GuidedValueSlider {
            id:                 guidedValueSlider
            anchors.right:      parent.right
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            anchors.topMargin:  toolbar.height
            z:                  QGroundControl.zOrderTopMost
            visible:            false
        }

        Viewer3D {
            id: viewer3DWindow
            anchors.fill: parent
        }
    }

    FlyViewToolBar {
        id:                 toolbar
        guidedValueSlider:  _guidedValueSlider
        visible:            !QGroundControl.videoManager.fullScreen
    }

    TelemetryValuesBar {
        id: bottomCenterTelemetryBar

        anchors.bottom:           parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin:     7

        z:             QGroundControl.zOrderWidgets
        mapSourceItem: mapControl
        visible:       !QGroundControl.videoManager.fullScreen

        onLockChanged: function(locked) {
            if (!locked) {
                var absX = bottomCenterTelemetryBar.x
                var absY = bottomCenterTelemetryBar.y
                bottomCenterTelemetryBar.anchors.bottom           = undefined
                bottomCenterTelemetryBar.anchors.horizontalCenter = undefined
                bottomCenterTelemetryBar.anchors.bottomMargin     = 0
                bottomCenterTelemetryBar.x = absX
                bottomCenterTelemetryBar.y = absY
            }
        }

        onDragPositionChanged: function(px, py) {
            bottomCenterTelemetryBar.x = px
            bottomCenterTelemetryBar.y = py
        }
    }

    Loader {
        id:                     gimbalControlLoader
        anchors.right:          parent.right
        anchors.bottom:         parent.bottom
        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth * 2
        anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight * 10
        source:                 "qrc:/qml/GimbalControl.qml"
        visible:                true
        z:                      QGroundControl.zOrderWidgets
    }

    // ── Swarm fullscreen expanded overlay ─────────────────────────────────────
    // When user taps a PIP box it expands to cover the full FlyView.
    // Sits above everything including the toolbar.
    Item {
        id:      _swarmFullscreen
        anchors.fill: parent
        visible: _swarmFullscreen.expandedLink !== ""
        z:       QGroundControl.zOrderTopMost + 1

        property string expandedLabel: ""
        property string expandedLink:  ""

        // Start/stop player reactively when link is set/cleared
        onExpandedLinkChanged: {
            if (expandedLink !== "")
                _fsPlayer.play()
            else
                _fsPlayer.stop()
        }

        // Dark backdrop
        Rectangle {
            anchors.fill: parent
            color:        Qt.rgba(0, 0, 0, 0.92)
        }

        MediaPlayer {
            id:          _fsPlayer
            source:      _swarmFullscreen.expandedLink
            videoOutput: _fsVideo
            onPlaybackStateChanged: {
                if (playbackState === MediaPlayer.StoppedState && _swarmFullscreen.expandedLink !== "")
                    play()
            }
        }

        VideoOutput {
            id:           _fsVideo
            anchors.fill: parent
            fillMode:     VideoOutput.PreserveAspectFit
        }

        // No signal placeholder
        Column {
            anchors.centerIn: parent
            spacing:          ScreenTools.defaultFontPixelHeight * 0.6
            visible:          _fsPlayer.playbackState !== MediaPlayer.PlayingState

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           "📡"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 3
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text:           qsTr("Connecting to %1...").arg(_swarmFullscreen.expandedLabel)
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.85
                color:          Qt.rgba(1,1,1,0.45)
            }
        }

        // Top bar with label + collapse button
        Rectangle {
            anchors.top:   parent.top
            anchors.left:  parent.left
            anchors.right: parent.right
            height:        ScreenTools.toolbarHeight
            color:         Qt.rgba(0, 0, 0, 0.70)

            Row {
                anchors.fill:        parent
                anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 2
                anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 2
                spacing:             ScreenTools.defaultFontPixelWidth

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:           _swarmFullscreen.expandedLabel
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.92
                    font.weight:    Font.SemiBold
                    color:          Qt.rgba(0, 0.83, 1, 0.95)
                    width:          parent.width - _collapseBtn.width - parent.spacing
                    elide:          Text.ElideRight
                }

                // Collapse button — same glass style as existing QGC buttons
                Rectangle {
                    id:                     _collapseBtn
                    anchors.verticalCenter: parent.verticalCenter
                    width:                  ScreenTools.defaultFontPixelWidth * 14
                    height:                 ScreenTools.defaultFontPixelHeight * 2.2
                    radius:                 6
                    color:                  _collapseMa.containsMouse
                                                ? Qt.rgba(1,1,1,0.15)
                                                : Qt.rgba(1,1,1,0.07)
                    border.color:           Qt.rgba(1,1,1,0.22)
                    border.width:           1
                    Behavior on color { ColorAnimation { duration: 80 } }

                    Row {
                        anchors.centerIn: parent
                        spacing:          6
                        Text { anchors.verticalCenter: parent.verticalCenter; text: "⊠"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.9; color: Qt.rgba(1,1,1,0.80) }
                        Text { anchors.verticalCenter: parent.verticalCenter; text: qsTr("Collapse"); font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.78; color: Qt.rgba(1,1,1,0.80) }
                    }
                    MouseArea {
                        id:           _collapseMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape:  Qt.PointingHandCursor
                        onClicked: {
                            _fsPlayer.stop()
                            _swarmFullscreen.expandedLink  = ""
                            _swarmFullscreen.expandedLabel = ""
                        }
                    }
                }
            }
        }

        // RTSP URL watermark at bottom
        Text {
            anchors.bottom:           parent.bottom
            anchors.bottomMargin:     ScreenTools.defaultFontPixelHeight * 0.6
            anchors.horizontalCenter: parent.horizontalCenter
            text:           _swarmFullscreen.expandedLink
            font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.62
            color:          Qt.rgba(1,1,1,0.20)
            elide:          Text.ElideMiddle
            width:          parent.width * 0.7
            horizontalAlignment: Text.AlignHCenter
        }
    }

    // ── SwarmPIPBox — one PIP box per active drone ────────────────────────────
    component SwarmPIPBox: Item {
        id:              _pipBox
        property string  droneLabel: ""
        property string  rtspLink:   ""
        property real    boxWidth:   100
        property real    boxHeight:  56

        width:  boxWidth
        height: boxHeight

        // Rounded clip mask
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width:  _pipBox.width
                height: _pipBox.height
                radius: 6
            }
        }

        // Video player
        MediaPlayer {
            id:          _pipPlayer
            source:      rtspLink
            videoOutput: _pipVideo
            onPlaybackStateChanged: {
                if (playbackState === MediaPlayer.StoppedState && rtspLink !== "")
                    play()
            }
        }

        VideoOutput {
            id:           _pipVideo
            anchors.fill: parent
            fillMode:     VideoOutput.PreserveAspectCrop
        }

        // No signal overlay
        Rectangle {
            anchors.fill: parent
            color:        Qt.rgba(0.06, 0.07, 0.10, 0.90)
            visible:      _pipPlayer.playbackState !== MediaPlayer.PlayingState

            Column {
                anchors.centerIn: parent
                spacing:          4
                Text { anchors.horizontalCenter: parent.horizontalCenter; text: "📡"; font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.5 }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text:           qsTr("No Signal")
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.68
                    color:          Qt.rgba(1,1,1,0.40)
                }
            }
        }

        // Glass border — highlights on hover
        Rectangle {
            anchors.fill:  parent
            radius:        6
            color:         "transparent"
            border.color:  _pipMa.containsMouse ? Qt.rgba(0,0.83,1,0.80) : Qt.rgba(1,1,1,0.30)
            border.width:  1
            Behavior on border.color { ColorAnimation { duration: 120 } }
        }

        // Label strip at bottom — same style as QGC PIP label
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left:   parent.left
            anchors.right:  parent.right
            height:         ScreenTools.defaultFontPixelHeight * 1.8
            color:          Qt.rgba(0, 0, 0, 0.65)

            Row {
                anchors.fill:        parent
                anchors.leftMargin:  ScreenTools.defaultFontPixelWidth * 0.6
                anchors.rightMargin: ScreenTools.defaultFontPixelWidth * 0.6
                spacing:             4

                // Live dot
                Rectangle {
                    width:  6; height: 6; radius: 3
                    anchors.verticalCenter: parent.verticalCenter
                    color: _pipPlayer.playbackState === MediaPlayer.PlayingState
                               ? Qt.rgba(0,1,0.55,1) : Qt.rgba(1,1,1,0.25)
                    SequentialAnimation on opacity {
                        running: _pipPlayer.playbackState === MediaPlayer.PlayingState
                        loops:   Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 800 }
                        NumberAnimation { to: 1.0; duration: 800 }
                    }
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text:           droneLabel
                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 0.65
                    font.weight:    Font.Medium
                    color:          Qt.rgba(1,1,1,0.88)
                    elide:          Text.ElideRight
                    width:          parent.width - _expandHint.width - 10
                }

                Text {
                    id:                     _expandHint
                    anchors.verticalCenter: parent.verticalCenter
                    text:                   "⤢"
                    font.pixelSize:         ScreenTools.defaultFontPixelHeight * 1.8
                    color:                  _pipMa.containsMouse ? Qt.rgba(0,0.83,1,1) : Qt.rgba(1,1,1,0.35)
                    Behavior on color { ColorAnimation { duration: 100 } }
                }
            }
        }

        // Tap to expand fullscreen
        MouseArea {
            id:           _pipMa
            anchors.fill: parent
            hoverEnabled: true
            cursorShape:  Qt.PointingHandCursor
            onClicked: {
                _swarmFullscreen.expandedLabel = droneLabel
                _swarmFullscreen.expandedLink  = rtspLink
            }
        }

        Component.onCompleted:  _pipPlayer.play()
        Component.onDestruction: _pipPlayer.stop()
    }
}
