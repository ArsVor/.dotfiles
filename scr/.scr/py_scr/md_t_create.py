from tabulate import tabulate


with open("/home/ars/tmp.txt", "r") as f:
    lines = f.readlines()

content = []

for line in lines:
    if len(line) == 1:
        continue

    if len(line) == 2:
        content.append(["## " + line, '\n', [["Name", "Description"]]])

    else:
        splited_line = line.strip().split(" — ")
        content[-1][-1].append(splited_line)

with open("/home/ars/scr/py_scr/output/mdt.txt", "w", encoding="utf-8") as of:
    for head, sep, data in content:
        table = tabulate(data, headers="firstrow", tablefmt="pipe")
        of.write(head)
        of.write(sep)
        of.write(table + "\n")
        of.write("&uarr; [[#Contents]]\n")
        of.write("\n")
