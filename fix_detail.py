import re

with open("lib/presentation/pages/akademik/hasil_studi_detail_page.dart", "r") as f:
    content = f.read()

# Remove the gradient appBar
content = re.sub(
    r'flexibleSpace: Container\(.*?decoration: BoxDecoration\(.*?gradient: LinearGradient\(.*?\),.*?\),.*?\),',
    '',
    content,
    flags=re.DOTALL
)

# And fix background color
content = content.replace("backgroundColor: Colors.transparent,", "backgroundColor: AppColors.background,")

with open("lib/presentation/pages/akademik/hasil_studi_detail_page.dart", "w") as f:
    f.write(content)

