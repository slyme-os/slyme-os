import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    function nextSlide() {
        presentation.goToNextSlide()
    }

    Timer {
        id: slideTimer
        interval: 5000
        repeat: true
        running: presentation.activatedInCalamares
        onTriggered: nextSlide()
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#030703"
            Column {
                anchors.centerIn: parent
                spacing: 20
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "SLYME OS"
                    font.family: "monospace"
                    font.pixelSize: 48
                    font.bold: true
                    color: "#39ff14"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "AI-Native Linux"
                    font.family: "monospace"
                    font.pixelSize: 22
                    color: "#ffffff"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Setting up your AI-native environment..."
                    font.family: "monospace"
                    font.pixelSize: 14
                    color: "#6a8f6a"
                }
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#030703"
            Column {
                anchors.centerIn: parent
                spacing: 16
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "slyme-ai daemon"
                    font.family: "monospace"
                    font.pixelSize: 32
                    font.bold: true
                    color: "#39ff14"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Your local AI. No cloud. No tracking."
                    font.family: "monospace"
                    font.pixelSize: 16
                    color: "#b0c8b0"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "$ slyme-ai status"
                    font.family: "monospace"
                    font.pixelSize: 13
                    color: "#39ff14"
                    opacity: 0.7
                }
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#030703"
            Column {
                anchors.centerIn: parent
                spacing: 16
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Stay terminal."
                    font.family: "monospace"
                    font.pixelSize: 32
                    font.bold: true
                    color: "#ffffff"
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Stay free."
                    font.family: "monospace"
                    font.pixelSize: 32
                    font.bold: true
                    color: "#39ff14"
                }
            }
        }
    }
}
