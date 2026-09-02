import re

with open("lib/presentation/pages/ip_stats_page.dart", "r") as f:
    text = f.read()

# Replace the broken app bar body
pattern = r"appBar: const CustomAppBar\(title: 'Statistik Akademik'\),\n.*?(?=\bbody: )"
replacement = "appBar: const CustomAppBar(title: 'Statistik Akademik'),\n      "

text = re.sub(pattern, replacement, text, flags=re.DOTALL)

with open("lib/presentation/pages/ip_stats_page.dart", "w") as f:
    f.write(text)

