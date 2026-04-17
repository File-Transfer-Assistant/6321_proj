import sys

VDD = 'VDD'
VSS = 'VSS'

top = sys.argv[1]
top_file_in = '%s.nl.v' % (top)
top_file_out = '%s.nl.PG.v' % (top)

add_spec = False

with open(top_file_in, 'r') as f_in:
    with open(top_file_out, 'w') as f_out:
        for line in f_in:
            line_new = line
            if 'module' in line:
                add_spec = True
            if ');' in line:
                if add_spec:
                    line_new = line_new.replace(');', ',%s,%s);' % ("VDD", "VSS"))
                    line_new += 'inout %s, %s;\n' % ("VDD", "VSS")
                else:
                    line_new = line_new.replace(');', ', .%s(%s), .%s(%s) );' % (VDD, VDD, VSS, VSS))
                add_spec = False

            f_out.write(line_new)
