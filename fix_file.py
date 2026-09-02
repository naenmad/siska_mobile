with open("lib/presentation/widgets/statistic_widgets.dart", "r") as f:
    data = f.read()

# I appended to the file. That appended to the end of the file, outside the class block.
# Let's fix that.
if "\n  static Widget buildSemesterGradeCharts" in data:
    # remove the closing brace of the class before the new function and append the brace at the end
    data = data.replace("\n}\n  static Widget buildSemesterGradeCharts", "\n  static Widget buildSemesterGradeCharts")
    data = data + "\n}\n"

with open("lib/presentation/widgets/statistic_widgets.dart", "w") as f:
    f.write(data)
