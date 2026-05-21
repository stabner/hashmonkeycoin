import os
from pathlib import Path

ROOT = Path(os.environ.get("HMNY_ROOT", Path(__file__).resolve().parent.parent))
GUI = Path(os.environ.get("HMNY_GUI", ROOT / "hashmonkey-gui"))

# Style.qml
s = GUI / "components/Style.qml"
t = s.read_text()
t = t.replace('property string orange: "#FF6C3C"', 'property string orange: "#5BC0EB"\n    property string accent: "#5BC0EB"\n    property string accentHover: "#3DA8D8"')
t = t.replace('property string warningColor: "orange"', 'property string warningColor: "#E6A23C"')
t = t.replace('property string _b_buttonBackgroundColor: "#FA6800"', 'property string _b_buttonBackgroundColor: "#5BC0EB"')
t = t.replace('property string _b_buttonBackgroundColorHover: "#E65E00"', 'property string _b_buttonBackgroundColorHover: "#3DA8D8"')
t = t.replace('property string _w_buttonBackgroundColor: "#FA6800"', 'property string _w_buttonBackgroundColor: "#5BC0EB"')
t = t.replace('property string _w_buttonBackgroundColorHover: "#E65E00"', 'property string _w_buttonBackgroundColorHover: "#3DA8D8"')
t = t.replace('property string _w_menuButtonImageRightColorActive: "#FA6800"', 'property string _w_menuButtonImageRightColorActive: "#5BC0EB"')
t = t.replace('property string _b_errorColor: "#FA6800"', 'property string _b_errorColor: "#F44336"')
t = t.replace('property string _w_errorColor: "#FA6800"', 'property string _w_errorColor: "#F44336"')
s.write_text(t)

# main.qml key strings
m = GUI / "main.qml"
t = m.read_text()
t = t.replace('title: "Monero"', 'title: "HashmonkeyCoin"')
t = t.replace('+ " XMR"', '+ " HMNY"')
t = t.replace('monero://', 'hmny://')
t = t.replace('monero:', 'hmny:')
t = t.replace('Invalid Monero URI', 'Invalid HMNY URI')
t = t.replace('return 18081;', 'return 28081;')
t = t.replace('case NetworkType.TESTNET:\n                return 28081;', 'case NetworkType.TESTNET:\n                return 48081;')
t = t.replace('color: "#FF6C3C"', 'color: MoneroComponents.Style.accent')
t = t.replace('monerod.exe', 'hashmonkeyd.exe')
t = t.replace(': "monerod"', ': "hashmonkeyd"')
m.write_text(t)

# DaemonManager
d = GUI / "src/daemon/DaemonManager.cpp"
t = d.read_text()
t = t.replace('monerod.exe', 'hashmonkeyd.exe')
t = t.replace('"/monerod"', '"/hashmonkeyd"')
t = t.replace('"monerod.exe"', '"hashmonkeyd.exe"')
t = t.replace("taskkill\",  {\"/F\", \"/IM\", \"monerod.exe\"}", "taskkill\",  {\"/F\", \"/IM\", \"hashmonkeyd.exe\"}")
t = t.replace("name = 'monerod.exe'", "name = 'hashmonkeyd.exe'")
# keep member name m_monerod (see patch5.py)
d.write_text(t)

# main.cpp
mp = GUI / "src/main/main.cpp"
t = mp.read_text()
t = t.replace('setApplicationName("monero-core")', 'setApplicationName("hashmonkey-core")')
t = t.replace('setOrganizationDomain("getmonero.org")', 'setOrganizationDomain("hashmonkeycoin.local")')
t = t.replace('setOrganizationName("monero-project")', 'setOrganizationName("hashmonkeycoin")')
t = t.replace('"/Monero/wallets"', '"/HashmonkeyCoin/wallets"')
t = t.replace('"/Persistent/Monero/wallets"', '"/Persistent/HashmonkeyCoin/wallets"')
mp.write_text(t)

# Logger.cpp
lg = GUI / "src/main/Logger.cpp"
t = lg.read_text()
t = t.replace('monero-wallet-gui.log', 'hashmonkey-wallet-gui.log')
t = t.replace('appFolder = "monero-wallet-gui"', 'appFolder = "hashmonkey-wallet-gui"')
t = t.replace('appFolder = ".bitmonero"', 'appFolder = ".hashmonkeycoin"')
lg.write_text(t)

# CMakeLists root
cm = GUI / "CMakeLists.txt"
t = cm.read_text()
t = t.replace('project(monero-gui)', 'project(hashmonkey-gui)')
if 'WITH_UPDATER' in t:
    t = t.replace('option(WITH_UPDATER "Regularly check for new updates" ON)', 'option(WITH_UPDATER "Regularly check for new updates" OFF)')
cm.write_text(t)

# src/CMakeLists.txt
sc = GUI / "src/CMakeLists.txt"
t = sc.read_text()
t = t.replace('monero-wallet-gui', 'hashmonkey-wallet-gui')
sc.write_text(t)

# ProcessingSplash logo
ps = GUI / "components/ProcessingSplash.qml"
t = ps.read_text()
t = t.replace('monero-vector.svg', 'monero-vector.svg')
ps.write_text(t)

print("gui patches ok")
