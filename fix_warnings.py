with open("lib/presentation/pages/akademik/akademik_tab.dart", "r") as f:
    text = f.read()

text = text.replace("import 'package:share_plus/share_plus.dart';\n", "")

import re
text = re.sub(r'  Color _getScoreColor\([^\}]+\}\n?', '', text, flags=re.DOTALL)

with open("lib/presentation/pages/akademik/akademik_tab.dart", "w") as f:
    f.write(text)

