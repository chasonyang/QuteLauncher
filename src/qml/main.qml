import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import com.iktwo.qutelauncher 1.0

ApplicationWindow {
    id: applicationWindow

    property bool isWindowActive: Qt.application.state === Qt.ApplicationActive
    property int dpi: Screen.pixelDensity * 25.4
    color: "black"
    property var resolutions: [
        {"height": 480, "width": 320}, // HVGA
        {"height": 640, "width": 480}, // VGA
        {"height": 800, "width": 480}, // WVGA
        {"height": 800, "width": 600}, // SVGA
        {"height": 640, "width": 360}, // nHD
        {"height": 960, "width": 540}  // qHD
    ]

    property int currentResolution: 3
    property bool isScreenPortrait: height >= width
    property bool activeScreen: Qt.application.state === Qt.ApplicationActive

    property int tilesHorizontally: getNumberOfTilesHorizontally(isScreenPortrait)
    property int tilesVertically: getNumberOfTilesVertically(isScreenPortrait)

    function getNumberOfTilesHorizontally(isScreenPortrait) {
        if (isScreenPortrait) {
            if (ScreenValues.isTablet) {
                return 5
            } else {
                return 4
            }
        } else {
            if (ScreenValues.isTablet) {
                return 6
            } else {
                return 4
            }
        }
    }

    function getNumberOfTilesVertically(isScreenPortrait) {
        if (isScreenPortrait) {
            return 6
        } else {
            if (ScreenValues.isTablet) {
                return 5
            } else {
                return 4
            }
        }
    }

    width: resolutions[currentResolution].width
    height: resolutions[currentResolution].height

    visible: true

    onActiveScreenChanged: {
        if (activeScreen)
            ScreenValues.updateScreenValues()
    }

    FocusScope {
        id: backKeyHandler

        height: 1
        width: 1

        focus: true

        Keys.onAsteriskPressed: {
            if (explandableItem.isOpened) {
                explandableItem.close()
            }
        }

        Keys.onBackPressed: {
            if(appGrid.editMode){
                appGrid.editMode=false;
            }
            else if (explandableItem.isOpened) {
                explandableItem.close()
            }
        }
    }

    Timer {
        interval: 550
        running: true
        onTriggered: PackageManager.registerBroadcast()
    }


    Item {
        anchors {
            top: parent.top; topMargin: ScreenValues.statusBarHeight
            bottom: parent.bottom
            bottomMargin: Math.round(48 * ScreenValues.dp)
            left: parent.left
            right: parent.right
        }

        ExpandableItem {
            id: explandableItem

            anchors.fill: parent

                ApplicationGrid {
                    id:appGrid
                    model: PackageManager

                    anchors.fill: parent
                }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: explandableItem.busy
    }

}
