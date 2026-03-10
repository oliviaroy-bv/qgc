// LiquidGlassCard.qml
// Recessed glass card — sits inside the drawer and looks sunken INTO the glass
// Two visual modes:
//   raised:  floats above surface (use for the drawer itself)
//   recessed: pushed into surface (use for inner content panels)

import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // ── Public API ────────────────────────────────────────────────────────
    default property alias content:     _innerLayout.children
    property string        heading:     ""
    property bool          recessed:    true    // true = sunken, false = raised

    implicitWidth:  400
    implicitHeight: _col.implicitHeight

    Column {
        id:     _col
        width:  parent.width

        // ── Border glow (gradient border trick) ───────────────────────────
        Item {
            width:  parent.width
            height: _cardBody.height

            // Gradient border layer
            Rectangle {
                anchors.fill:    parent
                anchors.margins: -1
                radius:          18
                gradient: Gradient {
                    orientation: Gradient.Diagonal
                    GradientStop { position: 0.00; color: root.recessed ? Qt.rgba(0,0,0,0.40) : Qt.rgba(1,1,1,0.55) }
                    GradientStop { position: 0.25; color: root.recessed ? Qt.rgba(0,0,0,0.15) : Qt.rgba(1,1,1,0.20) }
                    GradientStop { position: 0.55; color: root.recessed ? Qt.rgba(1,1,1,0.05) : Qt.rgba(1,1,1,0.06) }
                    GradientStop { position: 0.80; color: root.recessed ? Qt.rgba(1,1,1,0.08) : Qt.rgba(1,1,1,0.18) }
                    GradientStop { position: 1.00; color: root.recessed ? Qt.rgba(1,1,1,0.22) : Qt.rgba(1,1,1,0.40) }
                }
            }

            // Card body
            Rectangle {
                id:    _cardBody
                width: parent.width; height: _cardCol.implicitHeight
                radius: 18
                color:  root.recessed ? Qt.rgba(0,0,0,0.22) : Qt.rgba(1,1,1,0.07)

                // Recessed: top dark inset shadow
                // Raised: top bright specular
                Rectangle {
                    anchors.top:          parent.top
                    anchors.topMargin:    1
                    anchors.left:         parent.left
                    anchors.leftMargin:   parent.width * 0.06
                    anchors.right:        parent.right
                    anchors.rightMargin:  parent.width * 0.06
                    height:               parent.height * (root.recessed ? 0.25 : 0.38)
                    radius:               root.recessed ? 0 : height / 2
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: root.recessed ? Qt.rgba(0,0,0,0.30) : Qt.rgba(1,1,1,0.18)
                        }
                        GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.00) }
                    }
                }

                Column {
                    id:    _cardCol
                    width: parent.width

                    // Section heading
                    Item {
                        width:          parent.width
                        implicitHeight: root.heading !== "" ? _headingText.implicitHeight + 18 : 0
                        visible:        root.heading !== ""

                        Text {
                            id:               _headingText
                            anchors.left:     parent.left
                            anchors.leftMargin: 14
                            anchors.verticalCenter: parent.verticalCenter
                            text:             root.heading.toUpperCase()
                            color:            Qt.rgba(1,1,1,0.28)
                            font.pointSize:   ScreenTools.smallFontPointSize * 0.85
                            font.weight:      Font.Bold
                            font.letterSpacing: 1.6
                        }

                        // Separator
                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width; height: 1
                            color: Qt.rgba(1,1,1,0.06)
                        }
                    }

                    // Content slot
                    ColumnLayout {
                        id:            _innerLayout
                        width:         parent.width
                        spacing:       0
                        // topPadding:    root.heading !== "" ? 4 : 8
                        // bottomPadding: 8
                    }
                }
            }
        }
    }
}
