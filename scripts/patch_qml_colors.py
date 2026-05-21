from pathlib import Path
import sys

GUI = Path(sys.argv[1])
count = 0
for qml in GUI.rglob("*.qml"):
    text = qml.read_text(encoding="utf-8")
    if "#FF6C3C" not in text:
        continue
    qml.write_text(text.replace("#FF6C3C", "#5BC0EB"), encoding="utf-8")
    count += 1
print(f"updated {count} qml files")
