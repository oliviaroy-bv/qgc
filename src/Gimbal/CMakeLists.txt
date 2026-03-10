# ============================================================================
# Gimbal Module
# Camera gimbal control and stabilization
# ============================================================================

message(STATUS "Configuring Gimbal module...")

target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        Gimbal.cc
        Gimbal.h
        GimbalController.cc
        GimbalController.h
        GimbalTCPSender.cc
        GimbalTCPSender.h
        GimbalUDPSender.h
        GimbalUDPSender.cc
)

# ----------------------------------------------------------------------------
# Gimbal Configuration Resources
# ----------------------------------------------------------------------------
qt_add_resources(${CMAKE_PROJECT_NAME} json_gimbal
    PREFIX "/json/Vehicle"
    FILES GimbalFact.json
)

# ----------------------------------------------------------------------------
# Gimbal QML Resources
# ----------------------------------------------------------------------------
qt_add_resources(${CMAKE_PROJECT_NAME} gimbal_qml_simple
    PREFIX "/qml"
    FILES GimbalControl.qml
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
