import QtQml.Models

import QGroundControl
import QGroundControl.Controls

ToolStripActionList {
    id: _root
    signal displayPreFlightChecklist

    model: [
        ToolStripAction {
            property bool _is3DViewOpen:            viewer3DWindow.isOpen
            property bool   _viewer3DEnabled:       QGroundControl.settingsManager.viewer3DSettings.enabled.rawValue

            id: view3DIcon
            visible: _viewer3DEnabled
            text:           qsTr("3D View")
            iconSource:     "/qml/QGroundControl/Viewer3D/City3DMapIcon.svg"
            onTriggered:{
                if(_is3DViewOpen === false){
                    viewer3DWindow.open()
                }else{
                    viewer3DWindow.close()
                }
            }

            on_Is3DViewOpenChanged: {
                if(_is3DViewOpen === true){
                    view3DIcon.iconSource =     "/qmlimages/PaperPlane.svg"
                    text=           qsTr("Fly")
                }else{
                    iconSource =     "/qml/QGroundControl/Viewer3D/City3DMapIcon.svg"
                    text =           qsTr("3D View")
                }
            }
        },
        PreFlightCheckListShowAction { onTriggered: actionListRoot.displayPreFlightChecklist() },
        GuidedActionTakeoff { },
        GuidedActionLand { },
        GuidedActionRTL { },
        GuidedActionPause { },

        ToolStripAction {
            id:                 refreshCameraAction
            text:               qsTr("Refresh")
            iconSource:         "qrc:/res/refresh.svg"
            visible:            true
            enabled:            QGroundControl.multiVehicleManager.activeVehicle !== null
            
            onTriggered: {
                console.log("🔄 Refreshing camera feed...")
                
                // Restart video stream
                if (QGroundControl.videoManager) {
                    QGroundControl.videoManager.restartVideo()
                    console.log("Video stream restarted")
                }
                
                // Show notification (optional)
                mainWindow.showMessageArea(
                    qsTr("Camera Refresh"),
                    qsTr("Video stream restarted"),
                    StandardButton.Ok
                )
            }
        },

        ToolStripAction {
            id:                 motorTestAction
            text:               qsTr("Motor")
            iconSource:         "qrc:/res/MotorTest.svg"
            // Only show when a vehicle is connected
            visible:            QGroundControl.multiVehicleManager.activeVehicle !== null
            enabled:            QGroundControl.multiVehicleManager.activeVehicle !== null
            dropPanelComponent: Component {
                FlyViewMotorTest {}
            }
        },

        ToolStripAction {
            id:                 servoAction
            text:               qsTr("Servo")
            iconSource:         "qrc:/res/servo.svg"
            visible:            QGroundControl.multiVehicleManager.activeVehicle !== null
            enabled:            QGroundControl.multiVehicleManager.activeVehicle !== null
            dropPanelComponent: Component {
                FlyViewServoPanel {}
            }
            onTriggered: {
                console.log("⚙️ Servo control clicked")
                
                // Placeholder for servo functionality
                // You can add your servo control logic here
                
                // Example: Show a dialog
                mainWindow.showMessageArea(
                    qsTr("Servo Control"),
                    qsTr("Servo control activated\nVehicle: " + 
                        (QGroundControl.multiVehicleManager.activeVehicle ? 
                        QGroundControl.multiVehicleManager.activeVehicle.id : "None")),
                    StandardButton.Ok
                )
            }
        },

        FlyViewAdditionalActionsButton { },
        FlyViewGripperButton { }
    ]
}
