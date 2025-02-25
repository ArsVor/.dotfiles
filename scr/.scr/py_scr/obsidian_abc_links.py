link_list = ""

for i in range(65, 91):
    link_list += f"**[[#{chr(i)}]]**    "

with open("/home/ars/scr/py_scr/output/obsidian_abc_links.txt", "w", encoding="utf-8") as f:
    f.write(link_list)
    f.write("\n")
