import re
with open("lib/presentation/pages/akademik/akademik_tab.dart", "r") as f:
    text = f.read()

text = re.sub(r'var\s+copiedSemester.*?;\n', '', text)
with open("lib/presentation/pages/akademik/akademik_tab.dart", "w") as f:
    f.write(text)
