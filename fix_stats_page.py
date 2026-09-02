import re

with open("lib/presentation/pages/ip_stats_page.dart", "r") as f:
    text = f.read()

# Replace the broken app bar section
pattern = r"appBar: const CustomAppBar\(title: 'Statistik Akademik'\).*?leading: IconButton\(.*?onPressed: \(\) => Navigator\.pop\(context\),\s*\),\s*\),"
replacement = "appBar: const CustomAppBar(title: 'Statistik Akademik'),"

# If text doesn't contain extendBodyBehindAppBar: true, we might need to add it, but it seems to have it already.
text = re.sub(pattern, replacement, text, flags=re.DOTALL)

with open("lib/presentation/pages/ip_stats_page.dart", "w") as f:
    f.write(text)

