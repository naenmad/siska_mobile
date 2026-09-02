with open("lib/presentation/widgets/statistic_widgets.dart", "r") as f:
    text = f.read()

import re
text = re.sub(r'\}\s*static Widget buildSemesterGradeCharts', '  static Widget buildSemesterGradeCharts', text)

if not text.rstrip().endswith('}'):
    text = text.rstrip() + '\n}\n'

with open("lib/presentation/widgets/statistic_widgets.dart", "w") as f:
    f.write(text)
