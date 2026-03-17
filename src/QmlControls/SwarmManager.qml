// SwarmState.qml — BonVGroundStation
// Shared singleton — holds swarm feed state in memory.
// Both VideoSettings.qml and FlyView.qml read/write this directly,
// so changes reflect immediately across the app without needing
// disk reads. Also persists to QtCore Settings for across-restart recall.
//
// File: src/BonV/SwarmState.qml
// Register in CMakeLists as a QML singleton:
//   qt_add_qml_module(... QML_FILES SwarmState.qml ...)
// And in qmldir:
//   singleton SwarmState 1.0 SwarmState.qml

pragma Singleton
import QtQuick
import QtCore

QtObject {
    id: root

    // ── In-memory state (reactive — changes propagate instantly) ──────────────
    property string link0:   _s.link0
    property string link1:   _s.link1
    property string link2:   _s.link2
    property string link3:   _s.link3
    property bool   active0: _s.active0
    property bool   active1: _s.active1
    property bool   active2: _s.active2
    property bool   active3: _s.active3

    // ── Persistence ───────────────────────────────────────────────────────────
    property var _s: Settings {
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

    // ── Public setters — write both memory and disk ───────────────────────────
    function setLink(i, val) {
        if (val !== "" && !val.startsWith("rtsp://") &&
            !val.startsWith("udp://") && !val.startsWith("tcp://"))
            val = "rtsp://" + val
        switch(i) {
            case 0: link0 = val; _s.link0 = val; if (val === "") setActive(0, false); break
            case 1: link1 = val; _s.link1 = val; if (val === "") setActive(1, false); break
            case 2: link2 = val; _s.link2 = val; if (val === "") setActive(2, false); break
            case 3: link3 = val; _s.link3 = val; if (val === "") setActive(3, false); break
        }
    }

    function setActive(i, val) {
        var links = [link0, link1, link2, link3]
        var v = val && links[i] !== ""
        switch(i) {
            case 0: active0 = v; _s.active0 = v; break
            case 1: active1 = v; _s.active1 = v; break
            case 2: active2 = v; _s.active2 = v; break
            case 3: active3 = v; _s.active3 = v; break
        }
    }

    function setAllActive(val) {
        setActive(0, val); setActive(1, val)
        setActive(2, val); setActive(3, val)
    }
}
