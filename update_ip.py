import re

with open('lib/presentation/pages/ip_stats_page.dart', 'r') as f:
    content = f.read()

import_statement = "import '../widgets/custom_app_bar.dart';"

if import_statement not in content:
    content = content.replace("import 'package:flutter/material.dart';", f"import 'package:flutter/material.dart';\n{import_statement}")

pattern = re.compile(r'appBar:\s*AppBar\(.*?\),', re.DOTALL)
replacement = "appBar: const CustomAppBar(title: 'Statistik Akademik'),"

match = pattern.search(content)
if match:
    content = content[:match.start()] + replacement + content[match.end():]

with open('lib/presentation/pages/ip_stats_page.dart', 'w') as f:
    f.write(content)

