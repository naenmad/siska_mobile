import re
import glob

def fix_floating_action_button(file):
    with open(file, 'r') as f:
        text = f.read()

    # We want to replace FloatingActionButton.extended(
    # with FloatingActionButton.extended(heroTag: null,
    
    new_text = text.replace("FloatingActionButton.extended(", "FloatingActionButton.extended(\n          heroTag: null,")
    
    with open(file, 'w') as f:
        f.write(new_text)

files = [
    "lib/presentation/pages/studi/studi_tab.dart",
    "lib/presentation/pages/administrasi/administrasi_tab.dart",
    "lib/presentation/pages/akademik/akademik_tab.dart"
]

for file in files:
    fix_floating_action_button(file)

print("Fixed hero tags")
