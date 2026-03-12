// // // src/QmlControls/HorizontalFactValueGrid.qml
// // import QtQuick
// // import QtQuick.Layouts
// // import QtQuick.Controls
// // import QtQml

// // import QGroundControl.Controls
// // import QGroundControl.FlightMap
// // import QGroundControl

// // HorizontalFactValueGridTemplate {
// //     id:                     _root
// //     Layout.preferredWidth:  topLayout.width
// //     Layout.preferredHeight: topLayout.height

// //     property bool   settingsUnlocked:       false

// //     property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
// //     property int    _rowMax:                2
// //     property real   _rowButtonWidth:        ScreenTools.minTouchPixels
// //     property real   _rowButtonHeight:       ScreenTools.minTouchPixels / 2
// //     property real   _editButtonSpacing:     2

// //     QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

// //     ColumnLayout {
// //         id:         topLayout
// //         spacing:    ScreenTools.defaultFontPixelWidth

// //         RowLayout {
// //             spacing: parent.spacing
// //             RowLayout {
// //                 id:         labelValueColumnLayout
// //                 spacing:    ScreenTools.defaultFontPixelWidth * 1.25

// //                 Repeater {
// //                     model: _root.columns

// //                     GridLayout {
// //                         rows:           object.count
// //                         columns:        2
// //                         rowSpacing:     0
// //                         columnSpacing:  ScreenTools.defaultFontPixelWidth / 4
// //                         flow:           GridLayout.TopToBottom

// //                         Repeater {
// //                             id:     labelRepeater
// //                             model:  object

// //                             InstrumentValueLabel {
// //                                 Layout.fillHeight:      true
// //                                 Layout.alignment:       Qt.AlignRight
// //                                 instrumentValueData:    object
// //                             }
// //                         }

// //                         Repeater {
// //                             id:     valueRepeater
// //                             model:  object

// //                             property real   _index:     index
// //                             property real   maxWidth:   0
// //                             property var    lastCheck:  new Date().getTime()

// //                             function recalcWidth() {
// //                                 var newMaxWidth = 0
// //                                 for (var i=0; i<valueRepeater.count; i++) {
// //                                     newMaxWidth = Math.max(newMaxWidth, valueRepeater.itemAt(i).contentWidth)
// //                                 }
// //                                 maxWidth = Math.min(maxWidth, newMaxWidth)
// //                             }

// //                             InstrumentValueValue {
// //                                 Layout.fillHeight:      true
// //                                 Layout.alignment:       Qt.AlignLeft
// //                                 Layout.preferredWidth:  valueRepeater.maxWidth
// //                                 instrumentValueData:    object

// //                                 property real lastContentWidth

// //                                 Component.onCompleted:  {
// //                                     valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
// //                                     lastContentWidth = contentWidth
// //                                 }

// //                                 onContentWidthChanged: {
// //                                     valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
// //                                     lastContentWidth = contentWidth
// //                                     var currentTime = new Date().getTime()
// //                                     if (currentTime - valueRepeater.lastCheck > 30 * 1000) {
// //                                         valueRepeater.lastCheck = currentTime
// //                                         valueRepeater.recalcWidth()
// //                                     }
// //                                 }
// //                             }
// //                         }
// //                     }
// //                 }
// //             }

// //             ColumnLayout {
// //                 spacing: 1
// //                 visible: settingsUnlocked

// //                 QGCButton {
// //                     Layout.preferredWidth:  ScreenTools.minTouchPixels
// //                     Layout.fillHeight:      true
// //                     topPadding:             0
// //                     bottomPadding:          0
// //                     leftPadding:            0
// //                     rightPadding:           0
// //                     text:                   qsTr("+")
// //                     enabled:                (_root.width + (2 * (_rowButtonWidth + _margins))) < screen.width
// //                     onClicked:              appendColumn()
// //                 }

// //                 QGCButton {
// //                     Layout.preferredWidth:  ScreenTools.minTouchPixels
// //                     Layout.fillHeight:      true
// //                     topPadding:             0
// //                     bottomPadding:          0
// //                     leftPadding:            0
// //                     rightPadding:           0
// //                     text:                   qsTr("-")
// //                     enabled:                _root.columns.count > 1
// //                     onClicked:              deleteLastColumn()
// //                 }
// //             }
// //         }

// //         RowLayout {
// //             Layout.fillWidth:   true
// //             spacing:            1
// //             visible:            settingsUnlocked

// //             QGCButton {
// //                 Layout.fillWidth:       true
// //                 Layout.preferredHeight: ScreenTools.minTouchPixels
// //                 topPadding:             0
// //                 bottomPadding:          0
// //                 leftPadding:            0
// //                 rightPadding:           0
// //                 text:                   qsTr("+")
// //                 enabled:                (_root.height + (2 * (_rowButtonHeight + _margins))) < (screen.height - ScreenTools.toolbarHeight)
// //                 onClicked:              appendRow()
// //             }

// //             QGCButton {
// //                 Layout.fillWidth:       true
// //                 Layout.preferredHeight: parent.height
// //                 topPadding:             0
// //                 bottomPadding:          0
// //                 leftPadding:            0
// //                 rightPadding:           0
// //                 text:                   qsTr("-")
// //                 enabled:                _root.rowCount > 1
// //                 onClicked:              deleteLastRow()
// //             }
// //         }
// //     }

// //     QGCMouseArea {
// //         x:          labelValueColumnLayout.x
// //         y:          labelValueColumnLayout.y
// //         width:      labelValueColumnLayout.width
// //         height:     labelValueColumnLayout.height
// //         visible:    settingsUnlocked
// //         cursorShape:Qt.PointingHandCursor

// //         property var mappedLabelValueColumnLayoutPosition: _root.mapFromItem(labelValueColumnLayout, labelValueColumnLayout.x, labelValueColumnLayout.y)

// //         onClicked: (mouse) => {
// //             var columnGridLayoutItem = labelValueColumnLayout.childAt(mouse.x, mouse.y)
// //             //console.log(mouse.x, mouse.y, columnGridLayoutItem)
// //             var mappedMouse = labelValueColumnLayout.mapToItem(columnGridLayoutItem, mouse.x, mouse.y)
// //             var labelOrDataItem = columnGridLayoutItem.childAt(mappedMouse.x, mappedMouse.y)
// //             //console.log(mappedMouse.x, mappedMouse.y, labelOrDataItem, labelOrDataItem ? labelOrDataItem.instrumentValueData : "null", labelOrDataItem && labelOrDataItem.parent ? labelOrDataItem.parent.instrumentValueData : "null")
// //             if (labelOrDataItem && labelOrDataItem.instrumentValueData !== undefined) {
// //                 valueEditDialog.createObject(mainWindow, { instrumentValueData: labelOrDataItem.instrumentValueData }).open()
// //             }
// //         }
// //     }

// //     Component {
// //         id: valueEditDialog

// //         InstrumentValueEditDialog { }
// //     }
// // }



// // ─────────────────────────────────────────────────────────────────────────────
// //  HorizontalFactValueGrid.qml  —  BonVGroundStation
// //  File: src/QmlControls/HorizontalFactValueGrid.qml
// //
// //  Changes from stock:
// //    • InstrumentValueLabel / InstrumentValueValue colours updated to match
// //      glass design tokens (cyan labels, bright white values)
// //    • +/- edit buttons replaced with glass-styled equivalents
// //    • All logic (repeaters, width recalc, mouse area, edit dialog) unchanged
// // ─────────────────────────────────────────────────────────────────────────────
// import QtQuick
// import QtQuick.Layouts
// import QtQuick.Controls
// import QtQml

// import QGroundControl.Controls
// import QGroundControl.FlightMap
// import QGroundControl

// HorizontalFactValueGridTemplate {
//     id:                     _root
//     Layout.preferredWidth:  topLayout.width
//     Layout.preferredHeight: topLayout.height

//     property bool   settingsUnlocked:       false

//     property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
//     property int    _rowMax:                2
//     property real   _rowButtonWidth:        ScreenTools.minTouchPixels
//     property real   _rowButtonHeight:       ScreenTools.minTouchPixels / 2
//     property real   _editButtonSpacing:     2

//     // Glass colour tokens
//     readonly property color _colCyan:       Qt.rgba(0.0, 0.83, 1.0, 0.78)
//     readonly property color _colValueBright: Qt.rgba(1, 1, 1, 0.92)

//     QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

//     ColumnLayout {
//         id:         topLayout
//         spacing:    ScreenTools.defaultFontPixelWidth

//         RowLayout {
//             spacing: parent.spacing

//             RowLayout {
//                 id:         labelValueColumnLayout
//                 spacing:    ScreenTools.defaultFontPixelWidth * 1.25

//                 Repeater {
//                     model: _root.columns

//                     GridLayout {
//                         rows:           object.count
//                         columns:        2
//                         rowSpacing:     0
//                         columnSpacing:  ScreenTools.defaultFontPixelWidth / 4
//                         flow:           GridLayout.TopToBottom

//                         Repeater {
//                             id:     labelRepeater
//                             model:  object

//                             InstrumentValueLabel {
//                                 Layout.fillHeight:      true
//                                 Layout.alignment:       Qt.AlignRight
//                                 instrumentValueData:    object
//                                 // Cyan muted label colour
//                                 // color:                  _root._colCyan
//                             }
//                         }

//                         Repeater {
//                             id:     valueRepeater
//                             model:  object

//                             property real   _index:     index
//                             property real   maxWidth:   0
//                             property var    lastCheck:  new Date().getTime()

//                             function recalcWidth() {
//                                 var newMaxWidth = 0
//                                 for (var i=0; i<valueRepeater.count; i++) {
//                                     newMaxWidth = Math.max(newMaxWidth, valueRepeater.itemAt(i).contentWidth)
//                                 }
//                                 maxWidth = Math.min(maxWidth, newMaxWidth)
//                             }

//                             InstrumentValueValue {
//                                 Layout.fillHeight:      true
//                                 Layout.alignment:       Qt.AlignLeft
//                                 Layout.preferredWidth:  valueRepeater.maxWidth
//                                 instrumentValueData:    object
//                                 // Bright white value colour
//                                 // color:                  _root._colValueBright

//                                 property real lastContentWidth

//                                 Component.onCompleted:  {
//                                     valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
//                                     lastContentWidth = contentWidth
//                                 }

//                                 onContentWidthChanged: {
//                                     valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
//                                     lastContentWidth = contentWidth
//                                     var currentTime = new Date().getTime()
//                                     if (currentTime - valueRepeater.lastCheck > 30 * 1000) {
//                                         valueRepeater.lastCheck = currentTime
//                                         valueRepeater.recalcWidth()
//                                     }
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }

//             // ── Add/remove column buttons (glass-styled) ──────────────────────
//             ColumnLayout {
//                 spacing: 1
//                 visible: settingsUnlocked

//                 // + column
//                 Rectangle {
//                     Layout.preferredWidth:  ScreenTools.minTouchPixels
//                     Layout.fillHeight:      true
//                     radius:                 4
//                     color:                  addColMa.containsMouse
//                                                 ? Qt.rgba(0.0, 0.83, 1.0, 0.15)
//                                                 : Qt.rgba(1, 1, 1, 0.06)
//                     border.color:           Qt.rgba(1, 1, 1, 0.12)
//                     border.width:           1
//                     enabled:                (_root.width + (2 * (_rowButtonWidth + _margins))) < screen.width

//                     Text {
//                         anchors.centerIn:   parent
//                         text:               "+"
//                         font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
//                         font.weight:        Font.Light
//                         color:              Qt.rgba(1, 1, 1, 0.70)
//                     }
//                     QGCMouseArea {
//                         id:             addColMa
//                         anchors.fill:   parent
//                         hoverEnabled:   true
//                         onClicked:      _root.appendColumn()
//                     }
//                 }

//                 // - column
//                 Rectangle {
//                     Layout.preferredWidth:  ScreenTools.minTouchPixels
//                     Layout.fillHeight:      true
//                     radius:                 4
//                     color:                  delColMa.containsMouse
//                                                 ? Qt.rgba(1.0, 0.22, 0.35, 0.15)
//                                                 : Qt.rgba(1, 1, 1, 0.06)
//                     border.color:           Qt.rgba(1, 1, 1, 0.12)
//                     border.width:           1
//                     enabled:                _root.columns.count > 1

//                     Text {
//                         anchors.centerIn:   parent
//                         text:               "−"
//                         font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
//                         font.weight:        Font.Light
//                         color:              Qt.rgba(1, 1, 1, 0.70)
//                     }
//                     QGCMouseArea {
//                         id:             delColMa
//                         anchors.fill:   parent
//                         hoverEnabled:   true
//                         onClicked:      _root.deleteLastColumn()
//                     }
//                 }
//             }
//         }

//         // ── Add/remove row buttons (glass-styled) ─────────────────────────────
//         RowLayout {
//             Layout.fillWidth:   true
//             spacing:            1
//             visible:            settingsUnlocked

//             // + row
//             Rectangle {
//                 Layout.fillWidth:       true
//                 Layout.preferredHeight: ScreenTools.minTouchPixels
//                 radius:                 4
//                 color:                  addRowMa.containsMouse
//                                             ? Qt.rgba(0.0, 0.83, 1.0, 0.15)
//                                             : Qt.rgba(1, 1, 1, 0.06)
//                 border.color:           Qt.rgba(1, 1, 1, 0.12)
//                 border.width:           1
//                 enabled:                (_root.height + (2 * (_rowButtonHeight + _margins))) < (screen.height - ScreenTools.toolbarHeight)

//                 Text {
//                     anchors.centerIn:   parent
//                     text:               "+"
//                     font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
//                     font.weight:        Font.Light
//                     color:              Qt.rgba(1, 1, 1, 0.70)
//                 }
//                 QGCMouseArea {
//                     id:             addRowMa
//                     anchors.fill:   parent
//                     hoverEnabled:   true
//                     onClicked:      _root.appendRow()
//                 }
//             }

//             // - row
//             Rectangle {
//                 Layout.fillWidth:       true
//                 Layout.preferredHeight: ScreenTools.minTouchPixels
//                 radius:                 4
//                 color:                  delRowMa.containsMouse
//                                             ? Qt.rgba(1.0, 0.22, 0.35, 0.15)
//                                             : Qt.rgba(1, 1, 1, 0.06)
//                 border.color:           Qt.rgba(1, 1, 1, 0.12)
//                 border.width:           1
//                 enabled:                _root.rowCount > 1

//                 Text {
//                     anchors.centerIn:   parent
//                     text:               "−"
//                     font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
//                     font.weight:        Font.Light
//                     color:              Qt.rgba(1, 1, 1, 0.70)
//                 }
//                 QGCMouseArea {
//                     id:             delRowMa
//                     anchors.fill:   parent
//                     hoverEnabled:   true
//                     onClicked:      _root.deleteLastRow()
//                 }
//             }
//         }
//     }

//     // ── Click-to-edit mouse area (unchanged) ──────────────────────────────────
//     QGCMouseArea {
//         x:          labelValueColumnLayout.x
//         y:          labelValueColumnLayout.y
//         width:      labelValueColumnLayout.width
//         height:     labelValueColumnLayout.height
//         visible:    settingsUnlocked
//         cursorShape: Qt.PointingHandCursor

//         property var mappedLabelValueColumnLayoutPosition: _root.mapFromItem(labelValueColumnLayout, labelValueColumnLayout.x, labelValueColumnLayout.y)

//         onClicked: (mouse) => {
//             var columnGridLayoutItem = labelValueColumnLayout.childAt(mouse.x, mouse.y)
//             var mappedMouse = labelValueColumnLayout.mapToItem(columnGridLayoutItem, mouse.x, mouse.y)
//             var labelOrDataItem = columnGridLayoutItem.childAt(mappedMouse.x, mappedMouse.y)
//             if (labelOrDataItem && labelOrDataItem.instrumentValueData !== undefined) {
//                 valueEditDialog.createObject(mainWindow, { instrumentValueData: labelOrDataItem.instrumentValueData }).open()
//             }
//         }
//     }

//     Component {
//         id: valueEditDialog
//         InstrumentValueEditDialog { }
//     }
// }


// ─────────────────────────────────────────────────────────────────────────────
//  HorizontalFactValueGrid.qml  —  BonVGroundStation
//  File: src/QmlControls/HorizontalFactValueGrid.qml
//
//  Changes from stock:
//    • InstrumentValueLabel / InstrumentValueValue colours updated to match
//      glass design tokens (cyan labels, bright white values)
//    • +/- edit buttons replaced with glass-styled equivalents
//    • All logic (repeaters, width recalc, mouse area, edit dialog) unchanged
// ─────────────────────────────────────────────────────────────────────────────
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQml

import QGroundControl.Controls
import QGroundControl.FlightMap
import QGroundControl

HorizontalFactValueGridTemplate {
    id:                     _root
    Layout.preferredWidth:  topLayout.width
    Layout.preferredHeight: topLayout.height

    property bool   settingsUnlocked:       false

    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property int    _rowMax:                2
    property real   _rowButtonWidth:        ScreenTools.minTouchPixels
    property real   _rowButtonHeight:       ScreenTools.minTouchPixels / 2
    property real   _editButtonSpacing:     2

    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    ColumnLayout {
        id:         topLayout
        spacing:    ScreenTools.defaultFontPixelWidth

        RowLayout {
            spacing: parent.spacing

            RowLayout {
                id:         labelValueColumnLayout
                spacing:    ScreenTools.defaultFontPixelWidth * 1.25

                Repeater {
                    model: _root.columns

                    GridLayout {
                        rows:           object.count
                        columns:        2
                        rowSpacing:     0
                        columnSpacing:  ScreenTools.defaultFontPixelWidth / 4
                        flow:           GridLayout.TopToBottom

                        Repeater {
                            id:     labelRepeater
                            model:  object

                            InstrumentValueLabel {
                                Layout.fillHeight:      true
                                Layout.alignment:       Qt.AlignRight
                                instrumentValueData:    object
                            }
                        }

                        Repeater {
                            id:     valueRepeater
                            model:  object

                            property real   _index:     index
                            property real   maxWidth:   0
                            property var    lastCheck:  new Date().getTime()

                            function recalcWidth() {
                                var newMaxWidth = 0
                                for (var i=0; i<valueRepeater.count; i++) {
                                    newMaxWidth = Math.max(newMaxWidth, valueRepeater.itemAt(i).contentWidth)
                                }
                                maxWidth = Math.min(maxWidth, newMaxWidth)
                            }

                            InstrumentValueValue {
                                Layout.fillHeight:      true
                                Layout.alignment:       Qt.AlignLeft
                                Layout.preferredWidth:  valueRepeater.maxWidth
                                instrumentValueData:    object

                                property real lastContentWidth

                                Component.onCompleted:  {
                                    valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
                                    lastContentWidth = contentWidth
                                }

                                onContentWidthChanged: {
                                    valueRepeater.maxWidth = Math.max(valueRepeater.maxWidth, contentWidth)
                                    lastContentWidth = contentWidth
                                    var currentTime = new Date().getTime()
                                    if (currentTime - valueRepeater.lastCheck > 30 * 1000) {
                                        valueRepeater.lastCheck = currentTime
                                        valueRepeater.recalcWidth()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // ── Add/remove column buttons (glass-styled) ──────────────────────
            ColumnLayout {
                spacing: 1
                visible: settingsUnlocked

                // + column
                Rectangle {
                    Layout.preferredWidth:  ScreenTools.minTouchPixels
                    Layout.fillHeight:      true
                    radius:                 4
                    color:                  addColMa.containsMouse
                                                ? Qt.rgba(0.0, 0.83, 1.0, 0.15)
                                                : Qt.rgba(1, 1, 1, 0.06)
                    border.color:           Qt.rgba(1, 1, 1, 0.12)
                    border.width:           1
                    enabled:                (_root.width + (2 * (_rowButtonWidth + _margins))) < screen.width

                    Text {
                        anchors.centerIn:   parent
                        text:               "+"
                        font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
                        font.weight:        Font.Light
                        color:              Qt.rgba(1, 1, 1, 0.70)
                    }
                    QGCMouseArea {
                        id:             addColMa
                        anchors.fill:   parent
                        hoverEnabled:   true
                        onClicked:      _root.appendColumn()
                    }
                }

                // - column
                Rectangle {
                    Layout.preferredWidth:  ScreenTools.minTouchPixels
                    Layout.fillHeight:      true
                    radius:                 4
                    color:                  delColMa.containsMouse
                                                ? Qt.rgba(1.0, 0.22, 0.35, 0.15)
                                                : Qt.rgba(1, 1, 1, 0.06)
                    border.color:           Qt.rgba(1, 1, 1, 0.12)
                    border.width:           1
                    enabled:                _root.columns.count > 1

                    Text {
                        anchors.centerIn:   parent
                        text:               "−"
                        font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
                        font.weight:        Font.Light
                        color:              Qt.rgba(1, 1, 1, 0.70)
                    }
                    QGCMouseArea {
                        id:             delColMa
                        anchors.fill:   parent
                        hoverEnabled:   true
                        onClicked:      _root.deleteLastColumn()
                    }
                }
            }
        }

        // ── Add/remove row buttons (glass-styled) ─────────────────────────────
        RowLayout {
            Layout.fillWidth:   true
            spacing:            1
            visible:            settingsUnlocked

            // + row
            Rectangle {
                Layout.fillWidth:       true
                Layout.preferredHeight: ScreenTools.minTouchPixels
                radius:                 4
                color:                  addRowMa.containsMouse
                                            ? Qt.rgba(0.0, 0.83, 1.0, 0.15)
                                            : Qt.rgba(1, 1, 1, 0.06)
                border.color:           Qt.rgba(1, 1, 1, 0.12)
                border.width:           1
                enabled:                (_root.height + (2 * (_rowButtonHeight + _margins))) < (screen.height - ScreenTools.toolbarHeight)

                Text {
                    anchors.centerIn:   parent
                    text:               "+"
                    font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
                    font.weight:        Font.Light
                    color:              Qt.rgba(1, 1, 1, 0.70)
                }
                QGCMouseArea {
                    id:             addRowMa
                    anchors.fill:   parent
                    hoverEnabled:   true
                    onClicked:      _root.appendRow()
                }
            }

            // - row
            Rectangle {
                Layout.fillWidth:       true
                Layout.preferredHeight: ScreenTools.minTouchPixels
                radius:                 4
                color:                  delRowMa.containsMouse
                                            ? Qt.rgba(1.0, 0.22, 0.35, 0.15)
                                            : Qt.rgba(1, 1, 1, 0.06)
                border.color:           Qt.rgba(1, 1, 1, 0.12)
                border.width:           1
                enabled:                _root.rowCount > 1

                Text {
                    anchors.centerIn:   parent
                    text:               "−"
                    font.pixelSize:     ScreenTools.defaultFontPixelHeight * 0.9
                    font.weight:        Font.Light
                    color:              Qt.rgba(1, 1, 1, 0.70)
                }
                QGCMouseArea {
                    id:             delRowMa
                    anchors.fill:   parent
                    hoverEnabled:   true
                    onClicked:      _root.deleteLastRow()
                }
            }
        }
    }

    // ── Click-to-edit mouse area (unchanged) ──────────────────────────────────
    QGCMouseArea {
        x:          labelValueColumnLayout.x
        y:          labelValueColumnLayout.y
        width:      labelValueColumnLayout.width
        height:     labelValueColumnLayout.height
        visible:    settingsUnlocked
        cursorShape: Qt.PointingHandCursor

        property var mappedLabelValueColumnLayoutPosition: _root.mapFromItem(labelValueColumnLayout, labelValueColumnLayout.x, labelValueColumnLayout.y)

        onClicked: (mouse) => {
            var columnGridLayoutItem = labelValueColumnLayout.childAt(mouse.x, mouse.y)
            var mappedMouse = labelValueColumnLayout.mapToItem(columnGridLayoutItem, mouse.x, mouse.y)
            var labelOrDataItem = columnGridLayoutItem.childAt(mappedMouse.x, mappedMouse.y)
            if (labelOrDataItem && labelOrDataItem.instrumentValueData !== undefined) {
                valueEditDialog.createObject(mainWindow, { instrumentValueData: labelOrDataItem.instrumentValueData }).open()
            }
        }
    }

    Component {
        id: valueEditDialog
        InstrumentValueEditDialog { }
    }
}
