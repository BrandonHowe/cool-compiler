import sys

lines = []
for line in sys.stdin:
    lines.append(line.strip())

dependencies = {}
reverse_dependencies = {}
for i in range(0, len(lines), 2):
    if (lines[i + 1] in dependencies):
        dependencies[lines[i + 1]].append(lines[i])
    else:
        dependencies[lines[i + 1]] = [lines[i]]

    if (lines[i] in reverse_dependencies):
        reverse_dependencies[lines[i]].append(lines[i + 1])
    else:
        reverse_dependencies[lines[i]] = [lines[i + 1]]

l = []
s = []
for line in lines:
    if (line not in s and line not in reverse_dependencies):
        s.append(line)
s.sort(reverse=True)

while len(s) > 0:
    n = s.pop()
    l.append(n)
    if (n not in dependencies): continue
    for m in dependencies[n]:
        if m in reverse_dependencies:
            reverse_dependencies[m].remove(n)
        if (m not in reverse_dependencies or len(reverse_dependencies[m]) == 0):
            s.append(m)
            s.sort(reverse=True)
    dependencies[n] = []
    
has_edges = False
for key in dependencies:
    if len(dependencies[key]) > 0:
        has_edges = True
        break

if has_edges:
    print("cycle")
else:
    for e in l: print(e)