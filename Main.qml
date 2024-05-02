import QtQuick
import QtQuick.Shapes

Window {
    id: core
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    property real centerX: width / 2
    property real centerY: height / 2
    property real requiredDistance: 100
    property list<var> dots: []
    property list<var> lines: []

    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true

        Component.onCompleted: {
            onMouseXChanged.connect(update)
            onMouseYChanged.connect(update)
            onExited.connect(update)
        }

        function update(event) {
            if (event === undefined) {
                dotPhantom.visible = false
                return
            }
            let distanceFromCenter = Math.sqrt((event.x - core.centerX) ** 2 + (event.y - core.centerY) ** 2)
            if (Math.abs(distanceFromCenter - circle.r) < core.requiredDistance) {
                dotPhantom.visible = true
                let angle = Math.atan2(event.y - core.centerY, event.x - core.centerX);
                dotPhantom.posX = circle.r + Math.cos(angle) * (circle.r - circleBorder.border.width / 2)
                dotPhantom.posY = circle.r + Math.sin(angle) * (circle.r - circleBorder.border.width / 2)
            } else {
                dotPhantom.visible = false
            }
        }

        onPressed: {
            if (dotPhantom.visible) {
                core.dots.push({'posX': dotPhantom.posX, 'posY': dotPhantom.posY})
            }
        }
    }

    Item {
        id: circle
        anchors.centerIn: parent
        property real r: Math.min(core.width, core.height) * 0.8 / 2
        width: r * 2
        height: r * 2

        Rectangle {
            id: dotPhantom
            z: 1
            property real r: 8
            property real posX: 0
            property real posY: 0
            width: r * 2
            height: r * 2
            x: posX - r
            y: posY - r
            visible: false
            radius: r
            opacity: 0.5
            border {
                color: 'black'
            }
        }

        Repeater {
            model: core.dots

            Rectangle {
                id: dot
                property real r: 8
                required property var modelData
                property real posX: modelData['posX']
                property real posY: modelData['posY']
                z: 1
                width: r * 2
                height: r * 2
                x: posX - r
                y: posY - r
                radius: r
                opacity: 1
                color: "#aaa"
            }
        }

        Shape {
            Repeater {
                model: core.lines
                PathLine {

                }
            }
        }

        Rectangle {
            id: circleBorder
            anchors.fill: parent
            color: 'transparent'
            radius: width / 2
            border {
                color: '#aaa'
                width: 2
            }
        }
    }
}
