import re

with open("lib/presentation/pages/akademik/akademik_tab.dart", "r") as f:
    text = f.read()

# Fix aspect ratio
text = text.replace("childAspectRatio: 1.1,", "childAspectRatio: 0.85,")

# Replace Spacer
text = text.replace("const Spacer(),", "const SizedBox(height: 16),")

with open("lib/presentation/pages/akademik/akademik_tab.dart", "w") as f:
    f.write(text)

