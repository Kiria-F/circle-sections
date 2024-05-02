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
    property list<var> points: []
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
                phantomPoint.visible = false
                return
            }
            let distanceFromCenter = Math.sqrt((event.x - core.centerX) ** 2 + (event.y - core.centerY) ** 2)
            if (Math.abs(distanceFromCenter - circle.r) < core.requiredDistance) {
                phantomPoint.visible = true
                let angle = Math.atan2(event.y - core.centerY, event.x - core.centerX);
                phantomPoint.posX = circle.r + Math.cos(angle) * (circle.r - circleBorder.border.width / 2)
                phantomPoint.posY = circle.r + Math.sin(angle) * (circle.r - circleBorder.border.width / 2)
            } else {
                phantomPoint.visible = false
            }
        }

        onPressed: {
            if (phantomPoint.visible) {
                for (let i = 0; i < core.points.length; i++) {
                    // let a = (dotPhantom.posY - core.dots[i]['posY']) / (dotPhantom.posX - core.dots[i]['posX'])
                    // let b = core.dots[i]['posY'] - core.dots[i]['posX'] * a
                    // core.lines.push((x) => a * x + b)
                    core.lines.push({'ax': core.points[i]['posX'], 'ay': core.points[i]['posY'], 'bx': phantomPoint.posX, 'by': phantomPoint.posY})
                }
                core.points.push({'posX': phantomPoint.posX, 'posY': phantomPoint.posY})
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
            id: phantomPoint
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
            model: core.points

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

        Repeater {
            model: core.lines

            Shape {
                required property var modelData
                antialiasing: true

                ShapePath {
                    startX: modelData['ax']
                    startY: modelData['ay']
                    fillColor: 'transparent'
                    strokeColor: '#aaa'
                    strokeWidth: 1

                    PathLine {
                        x: modelData['bx']
                        y: modelData['by']
                    }
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
