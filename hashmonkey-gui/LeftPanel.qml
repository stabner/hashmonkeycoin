// Copyright (c) 2014-2024, The HashmonkeyCoin Project
// 
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are
// permitted provided that the following conditions are met:
// 
// 1. Redistributions of source code must retain the above copyright notice, this list of
//    conditions and the following disclaimer.
// 
// 2. Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
// 
// 3. Neither the name of the copyright holder nor the names of its contributors may be
//    used to endorse or promote products derived from this software without specific
//    prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
// THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import QtQuick 2.9
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import moneroComponents.Wallet 1.0
import moneroComponents.NetworkType 1.0
import moneroComponents.Clipboard 1.0
import FontAwesome 1.0

import "components" as MoneroComponents
import "components/effects/" as MoneroEffects

Rectangle {
    id: panel

    property int currentAccountIndex
    property alias currentAccountLabel: accountLabel.text
    property string balanceString: "?.??"
    property string balanceUnlockedString: "?.??"
    property string balanceFiatString: "?.??"
    property string minutesToUnlock: ""
    property bool isSyncing: false
    property alias networkStatus : networkStatus
    property alias progressBar : progressBar
    property alias daemonProgressBar : daemonProgressBar

    property int titleBarHeight: 50
    property string copyValue: ""
    Clipboard { id: clipboard }

    signal historyClicked()
    signal transferClicked()
    signal receiveClicked()
    signal advancedClicked()
    signal settingsClicked()
    signal addressBookClicked()
    signal accountClicked()

    function selectItem(pos) {
        menuColumn.previousButton.checked = false
        if(pos === "History") menuColumn.previousButton = historyButton
        else if(pos === "Transfer") menuColumn.previousButton = transferButton
        else if(pos === "Receive")  menuColumn.previousButton = receiveButton
        else if(pos === "AddressBook") menuColumn.previousButton = addressBookButton
        else if(pos === "Settings") menuColumn.previousButton = settingsButton
        else if(pos === "Advanced") menuColumn.previousButton = advancedButton
        else if(pos === "Account") menuColumn.previousButton = accountButton
        menuColumn.previousButton.checked = true
    }

    width: 300
    color: "transparent"
    anchors.bottom: parent.bottom
    anchors.top: parent.top

    MoneroEffects.GradientBackground {
        anchors.fill: parent
        fallBackColor: MoneroComponents.Style.middlePanelBackgroundColor
        initialStartColor: MoneroComponents.Style.leftPanelBackgroundGradientStart
        initialStopColor: MoneroComponents.Style.leftPanelBackgroundGradientStop
        blackColorStart: MoneroComponents.Style._b_leftPanelBackgroundGradientStart
        blackColorStop: MoneroComponents.Style._b_leftPanelBackgroundGradientStop
        whiteColorStart: MoneroComponents.Style._w_leftPanelBackgroundGradientStart
        whiteColorStop: MoneroComponents.Style._w_leftPanelBackgroundGradientStop
        posStart: 0.6
        start: Qt.point(0, 0)
        end: Qt.point(height, width)
    }

    // card with monero logo
    Column {
        visible: true
        z: 2
        id: column1
        height: 175
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: (persistentSettings.customDecorations)? 50 : 0

        Item {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.leftMargin: 20
            width: 260
            height: 135
            clip: true

            Rectangle {
                id: card
                anchors.fill: parent
                radius: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#1e4a66" }
                    GradientStop { position: 1.0; color: "#0f2838" }
                }
            }

            MoneroComponents.Label {
                fontSize: 12
                id: accountIndex
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.left: parent.left
                anchors.leftMargin: 10
                horizontalAlignment: Text.AlignLeft
                text: qsTr("Account") + translationManager.emptyString + " #" + currentAccountIndex
                color: MoneroComponents.Style.blackTheme ? "white" : "black"
                themeTransition: false

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: appWindow.showPageRequest("Account")
                }
            }

            Item {
                id: hmnyCardLogoBox
                width: hmnyCardLogo.width
                anchors.top: accountIndex.bottom
                anchors.topMargin: 2
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6

                Image {
                    id: hmnyCardLogo
                    readonly property real logoAspect: 128 / 151
                    readonly property real maxLogoHeight: hmnyCardLogoBox.height
                    width: Math.min(84, maxLogoHeight * logoAspect)
                    height: width / logoAspect
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:///images/hmny-card-logo.png"
                    fillMode: Image.PreserveAspectFit
                    mipmap: true
                }
            }

            Item {
                id: accountHeaderRight
                anchors.top: parent.top
                anchors.topMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: hmnyCardLogoBox.right
                anchors.leftMargin: 8
                height: accountHeaderColumn.height

                Column {
                    id: accountHeaderColumn
                    anchors.right: parent.right
                    spacing: 4
                    width: parent.width

                    MoneroComponents.TextPlain {
                        id: accountLabel
                        width: parent.width
                        horizontalAlignment: Text.AlignRight
                        font.pixelSize: 14
                        font.bold: false
                        elide: Text.ElideLeft
                        color: MoneroComponents.Style.blackTheme ? "white" : "black"
                        themeTransition: false

                        MouseArea {
                            hoverEnabled: true
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: appWindow.showPageRequest("Account")
                        }
                    }

                    MoneroComponents.TextPlain {
                        id: testnetLabel
                        visible: persistentSettings.nettype != NetworkType.MAINNET
                        width: parent.width
                        horizontalAlignment: Text.AlignRight
                        text: (persistentSettings.nettype == NetworkType.TESTNET ? qsTr("Testnet") : qsTr("Stagenet")) + translationManager.emptyString
                        font.bold: true
                        font.pixelSize: 11
                        lineHeight: 1.2
                        color: "#f33434"
                        themeTransition: false
                    }

                    MoneroComponents.TextPlain {
                        id: viewOnlyLabel
                        visible: viewOnly
                        width: parent.width
                        horizontalAlignment: Text.AlignRight
                        text: qsTr("View Only") + translationManager.emptyString
                        font.pixelSize: 11
                        font.bold: true
                        color: MoneroComponents.Style.accent
                        themeTransition: false
                    }
                }
            }

            Item {
                id: cardRightMiddle
                anchors.left: hmnyCardLogoBox.right
                anchors.leftMargin: 6
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.top: accountHeaderRight.bottom
                anchors.topMargin: 4
                anchors.bottom: balanceNumbersRow.top
                anchors.bottomMargin: 4

                Column {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6
                    width: parent.width

                MoneroComponents.Label {
                    fontSize: 12
                    id: syncingLabel
                    visible: isSyncing
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("Syncing...") + translationManager.emptyString
                    color: MoneroComponents.Style.dimmedFontColor
                    themeTransition: false
                }

                MoneroComponents.TextPlain {
                    id: currencyLabel
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 13
                    text: {
                        if (persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle) {
                            return appWindow.fiatApiCurrencySymbol();
                        } else {
                            return "HMNY"
                        }
                    }
                    color: MoneroComponents.Style.blackTheme ? "white" : "black"
                    themeTransition: false

                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        visible: persistentSettings.fiatPriceEnabled
                        cursorShape: Qt.PointingHandCursor
                        onClicked: persistentSettings.fiatPriceToggle = !persistentSettings.fiatPriceToggle
                    }
                }
                }
            }

            Row {
                id: balanceNumbersRow
                anchors.right: parent.right
                anchors.rightMargin: 14
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 6
                spacing: 0

                MoneroComponents.TextPlain {
                    id: balancePart1
                    themeTransition: false
                    color: MoneroComponents.Style.blackTheme ? "white" : "black"
                    Binding on color {
                        when: balancePart1MouseArea.containsMouse || balancePart2MouseArea.containsMouse
                        value: MoneroComponents.Style.orange
                    }
                    text: {
                        if (persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle) {
                            return balanceFiatString.split('.')[0] + "."
                        } else {
                            return balanceString.split('.')[0] + "."
                        }
                    }
                    font.pixelSize: {
                        var defaultSize = 22;
                        var totalLen = balancePart1.text.length + balancePart2.text.length
                        if (totalLen > 12) {
                            return Math.max(13, defaultSize - (totalLen - 12) * 1.1)
                        }
                        return defaultSize
                    }
                    MouseArea {
                        id: balancePart1MouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            clipboard.setText(balancePart1.text + balancePart2.text);
                            appWindow.showStatusMessage(qsTr("Copied to clipboard"), 3)
                        }
                    }
                }

                MoneroComponents.TextPlain {
                    id: balancePart2
                    themeTransition: false
                    color: balancePart1.color
                    text: {
                        if (persistentSettings.fiatPriceEnabled && persistentSettings.fiatPriceToggle) {
                            return balanceFiatString.split('.')[1]
                        } else {
                            return balanceString.split('.')[1]
                        }
                    }
                    font.pixelSize: {
                        var n = text.length
                        return n > 6 ? Math.max(8, 12 - (n - 6) * 0.6) : 12
                    }
                    MouseArea {
                        id: balancePart2MouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: balancePart1MouseArea.clicked(mouse)
                    }
                }
            }
        }
    }

    Rectangle {
        id: menuRect
        z: 2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: column1.bottom
        color: "transparent"

        Flickable {
            id:flicker
            contentHeight: menuColumn.height
            anchors.top: parent.top
            anchors.bottom: progressBar.visible ? progressBar.top : networkStatus.top
            width: parent.width
            boundsBehavior: isMac ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
            clip: true

        Column {
            id: menuColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            clip: true
            property var previousButton: transferButton

            // top border
            MoneroComponents.MenuButtonDivider {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Account tab ---------------
            MoneroComponents.MenuButton {
                id: accountButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Account") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "T" + translationManager.emptyString

                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = accountButton
                    panel.accountClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: accountButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Transfer tab ---------------
            MoneroComponents.MenuButton {
                id: transferButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Send") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "S" + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = transferButton
                    panel.transferClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: transferButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- AddressBook tab ---------------

            MoneroComponents.MenuButton {
                id: addressBookButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Address book") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "B" + translationManager.emptyString
                under: transferButton
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = addressBookButton
                    panel.addressBookClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: addressBookButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Receive tab ---------------
            MoneroComponents.MenuButton {
                id: receiveButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Receive") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "R" + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = receiveButton
                    panel.receiveClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: receiveButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- History tab ---------------

            MoneroComponents.MenuButton {
                id: historyButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Transactions") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "H" + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = historyButton
                    panel.historyClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: historyButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Advanced tab ---------------
            MoneroComponents.MenuButton {
                id: advancedButton
                visible: appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Advanced") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "D" + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = advancedButton
                    panel.advancedClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: advancedButton.present && appWindow.walletMode >= 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

            // ------------- Settings tab ---------------
            MoneroComponents.MenuButton {
                id: settingsButton
                anchors.left: parent.left
                anchors.right: parent.right
                text: qsTr("Settings") + translationManager.emptyString
                symbol: (isMac ? "⌃" : qsTr("Ctrl+")) + "E" + translationManager.emptyString
                onClicked: {
                    parent.previousButton.checked = false
                    parent.previousButton = settingsButton
                    panel.settingsClicked()
                }
            }

            MoneroComponents.MenuButtonDivider {
                visible: settingsButton.present
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 20
            }

        } // Column

        } // Flickable

        Rectangle {
            id: separator
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 0
            anchors.rightMargin: 0
            anchors.bottom: progressBar.visible ? progressBar.top : networkStatus.top
            height: 10
            color: "transparent"
        }

        MoneroComponents.ProgressBar {
            id: progressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: daemonProgressBar.top
            height: 48
            syncType: qsTr("Wallet") + translationManager.emptyString
            visible: !appWindow.disconnected
        }

        MoneroComponents.ProgressBar {
            id: daemonProgressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: networkStatus.top
            syncType: qsTr("Daemon") + translationManager.emptyString
            visible: !appWindow.disconnected
            height: 62
        }
        
        MoneroComponents.NetworkStatusItem {
            id: networkStatus
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.rightMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            connected: Wallet.ConnectionStatus_Disconnected
            height: 48
        }
    }
}
