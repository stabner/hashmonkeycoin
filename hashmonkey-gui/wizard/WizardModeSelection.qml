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
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 2.0

import "../js/Wizard.js" as Wizard
import "../components" as MoneroComponents
import moneroComponents.NetworkType 1.0

Rectangle {
    id: wizardModeSelection1
    color: "transparent"

    property alias pageHeight: pageRoot.height
    property string viewName: "wizardModeSelection1"
    property bool portable: persistentSettings.portable
    property bool simpleModeAvailable: !isTails && appWindow.persistentSettings.nettype == 0 && !isAndroid
    property bool testnetBootstrapAvailable: !isTails && appWindow.persistentSettings.nettype == NetworkType.TESTNET && !isAndroid

    function applyWalletMode(mode, wizardState) {
        if (!persistentSettings.setPortable(portable)) {
            appWindow.showStatusMessage(qsTr("Failed to configure portable mode"), 3);
            return;
        }

        logger.resetLogFilePath(portable);
        appWindow.changeWalletMode(mode);
        wizardController.wizardStackView.backTransition = false;
        wizardController.wizardState = wizardState;
    }

    ColumnLayout {
        id: pageRoot
        Layout.alignment: Qt.AlignHCenter;
        width: parent.width - 100
        Layout.fillWidth: true
        anchors.horizontalCenter: parent.horizontalCenter;

        spacing: 10

        ColumnLayout {
            Layout.fillWidth: true
            Layout.maximumWidth: wizardController.wizardSubViewWidth
            Layout.topMargin: wizardController.wizardSubViewTopMargin
            Layout.alignment: Qt.AlignHCenter
            spacing: 0

            WizardHeader {
                title: qsTr("Mode selection") + translationManager.emptyString
                subtitle: qsTr("Please select the statement that best matches you.") + translationManager.emptyString
            }

            ListModel {
                id: networkTypeModel
                ListElement {column1: "Mainnet"; column2: ""; nettype: "mainnet"}
                ListElement {column1: "Testnet"; column2: ""; nettype: "testnet"}
                ListElement {column1: "Stagenet"; column2: ""; nettype: "stagenet"}
            }

            MoneroComponents.TextPlain {
                Layout.topMargin: 12
                Layout.fillWidth: true
                font.pixelSize: 14
                color: MoneroComponents.Style.dimmedFontColor
                text: qsTr("Public HMNY testnet — choose Testnet, then Quick start or Full node (download chain).") + translationManager.emptyString
                wrapMode: Text.WordWrap
            }

            MoneroComponents.StandardDropdown {
                id: modeSelectionNetworkDropdown
                Layout.topMargin: 8
                Layout.maximumWidth: 200
                currentIndex: persistentSettings.nettype === NetworkType.STAGENET ? 2
                    : persistentSettings.nettype === NetworkType.TESTNET ? 1 : 0
                dataModel: networkTypeModel
                labelText: qsTr("Network") + ":" + translationManager.emptyString
                labelFontSize: 14
                onChanged: {
                    var item = dataModel.get(currentIndex).nettype.toLowerCase();
                    if (item === "mainnet") {
                        persistentSettings.nettype = NetworkType.MAINNET
                    } else if (item === "stagenet") {
                        persistentSettings.nettype = NetworkType.STAGENET
                    } else if (item === "testnet") {
                        persistentSettings.nettype = NetworkType.TESTNET
                        appWindow.applyTestnetNodeDefaults()
                    }
                    appWindow.disconnectRemoteNode()
                }
            }

            Rectangle {
                Layout.preferredHeight: 1
                Layout.topMargin: 16
                Layout.bottomMargin: 8
                Layout.fillWidth: true
                color: MoneroComponents.Style.dividerColor
                opacity: MoneroComponents.Style.dividerOpacity
            }

            WizardMenuItem {
                Layout.topMargin: 12
                headerText: qsTr("Testnet — quick start (recommended)") + translationManager.emptyString
                bodyText: qsTr("Wallet connects to the public seed (RPC port 48081). Syncs in minutes with no blockchain download. Best for new testers.") + translationManager.emptyString
                imageIcon: "qrc:///images/hmny-remote-node.png"

                onMenuClicked: {
                    appWindow.persistentSettings.nettype = NetworkType.TESTNET;
                    appWindow.persistentSettings.useRemoteNode = true;
                    appWindow.applyTestnetNodeDefaults();
                    applyWalletMode(2, "wizardHome");
                }
            }

            WizardMenuItem {
                headerText: qsTr("Testnet — full node") + translationManager.emptyString
                bodyText: qsTr("Runs hashmonkeyd on your PC, downloads the testnet chain, and uses the public seed for P2P and bootstrap. Required for mining.") + translationManager.emptyString
                imageIcon: "qrc:///images/hmny-local-node-full.png"

                onMenuClicked: {
                    appWindow.persistentSettings.pruneBlockchain = true;
                    appWindow.persistentSettings.nettype = NetworkType.TESTNET;
                    appWindow.persistentSettings.useRemoteNode = false;
                    appWindow.applyTestnetNodeDefaults();
                    applyWalletMode(2, "wizardHome");
                }
            }

            Rectangle {
                Layout.preferredHeight: 1
                Layout.topMargin: 8
                Layout.bottomMargin: 8
                Layout.fillWidth: true
                color: MoneroComponents.Style.dividerColor
                opacity: MoneroComponents.Style.dividerOpacity
            }

            WizardMenuItem {
                opacity: simpleModeAvailable ? 1.0 : 0.5
                Layout.topMargin: 12
                headerText: qsTr("Simple mode") + translationManager.emptyString
                bodyText: {
                    if (isTails) {
                        return qsTr("Not available on Tails.") + translationManager.emptyString;
                    } else {
                        if (appWindow.persistentSettings.nettype == 0) {
                            return qsTr("Easy access to sending, receiving and basic functionality.") + translationManager.emptyString;
                        } else {
                            return qsTr("Available on mainnet.") + translationManager.emptyString;
                        }
                    }
                }

                imageIcon: "qrc:///images/hmny-remote-node.png"

                onMenuClicked: {
                    if (simpleModeAvailable) {
                        applyWalletMode(0, 'wizardModeRemoteNodeWarning');
                    }
                }
            }

            Rectangle {
                Layout.preferredHeight: 1
                Layout.topMargin: 5
                Layout.bottomMargin: 10
                Layout.fillWidth: true
                color: MoneroComponents.Style.dividerColor
                opacity: MoneroComponents.Style.dividerOpacity
            }

            WizardMenuItem {
                opacity: (simpleModeAvailable || testnetBootstrapAvailable) ? 1.0 : 0.5
                headerText: qsTr("Simple mode") + " (bootstrap)" + translationManager.emptyString
                bodyText: {
                    if (isTails) {
                        return qsTr("Not available on Tails.") + translationManager.emptyString;
                    } else if (testnetBootstrapAvailable) {
                        return qsTr("Downloads the testnet chain using the public seed as bootstrap, then keeps syncing locally.") + translationManager.emptyString;
                    } else if (appWindow.persistentSettings.nettype == 0) {
                        return qsTr("Easy access to sending, receiving and basic functionality. The blockchain is downloaded to your computer.") + translationManager.emptyString;
                    } else {
                        return qsTr("Available on mainnet.") + translationManager.emptyString;
                    }
                }
                imageIcon: "qrc:///images/hmny-local-node.png"

                onMenuClicked: {
                    if (testnetBootstrapAvailable) {
                        appWindow.persistentSettings.pruneBlockchain = true;
                        appWindow.persistentSettings.nettype = NetworkType.TESTNET;
                        appWindow.persistentSettings.useRemoteNode = false;
                        appWindow.applyTestnetNodeDefaults();
                        applyWalletMode(1, "wizardModeBootstrap");
                    } else if (simpleModeAvailable) {
                        appWindow.persistentSettings.pruneBlockchain = true;
                        applyWalletMode(1, "wizardModeBootstrap");
                    }
                }
            }

            Rectangle {
                Layout.preferredHeight: 1
                Layout.topMargin: 5
                Layout.bottomMargin: 10
                Layout.fillWidth: true
                color: MoneroComponents.Style.dividerColor
                opacity: MoneroComponents.Style.dividerOpacity
            }

            WizardMenuItem {
                headerText: qsTr("Advanced mode (same as full node)") + translationManager.emptyString
                bodyText: qsTr("Full local node plus mining and message verification. Same sync defaults as Testnet — full node.") + translationManager.emptyString
                imageIcon: "qrc:///images/hmny-local-node-full.png"

                onMenuClicked: {
                    appWindow.persistentSettings.pruneBlockchain = true;
                    appWindow.persistentSettings.nettype = NetworkType.TESTNET;
                    appWindow.persistentSettings.useRemoteNode = false;
                    appWindow.applyTestnetNodeDefaults();
                    applyWalletMode(2, "wizardHome");
                }
            }

            WizardHeader {
                Layout.topMargin: 20
                title: qsTr("Optional features") + translationManager.emptyString
                subtitle: qsTr("Select enhanced functionality you would like to enable.") + translationManager.emptyString
            }

            WizardMenuItem {
                Layout.topMargin: 20
                headerText: qsTr("Portable mode") + translationManager.emptyString
                bodyText: qsTr("Create portable wallets and use them on any PC. Enable if you installed HashmonkeyCoin on a USB stick, an external drive, or any other portable storage medium.") + translationManager.emptyString
                checkbox: true
                checked: wizardModeSelection1.portable

                onMenuClicked: wizardModeSelection1.portable = !wizardModeSelection1.portable
            }

            WizardNav {
                Layout.topMargin: 5
                btnPrevText: qsTr("Back to menu") + translationManager.emptyString
                btnNext.visible: false
                progressSteps: 0
                autoTransition: false

                onPrevClicked: {
                    if (wizardController.wizardStackView.backTransition) {
                        applyWalletMode(persistentSettings.walletMode, 'wizardHome');
                    } else {
                        wizardController.wizardStackView.backTransition = true;
                        wizardController.wizardState = 'wizardLanguage';
                    }
                }
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200;
            easing.type: Easing.InCubic;
        }
    }
}
