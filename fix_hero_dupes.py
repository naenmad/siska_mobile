import re

files = [
    "lib/presentation/pages/studi/studi_tab.dart",
    "lib/presentation/pages/administrasi/administrasi_tab.dart",
    "lib/presentation/pages/akademik/akademik_tab.dart"
]

for file in files:
    with open(file, 'r') as f:
        text = f.read()

    # regex to clean up duplicate heroTag: null,
    # find `heroTag: null,` followed by spacing and another `heroTag: null,`
    
    text = re.sub(r'heroTag:\s*null,\s*heroTag:\s*null,', 'heroTag: null,', text)
    # Also if there was a preexisting one with a different value
    text = re.sub(r'heroTag:\s*null,\s*heroTag:\s*[^,]+,', 'heroTag: null,', text)

    with open(file, 'w') as f:
        f.write(text)

