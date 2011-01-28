#!/usr/bin/python

f = open('./examples.html', 'w')
f.write('<html>\n<head><title>SBGNML Test Files</title></head>\n<body>\n<table border="2">')

import os
path="../test-files/" 
dirList=os.listdir(path)
for fname in dirList:
    namesplit = os.path.splitext(fname)
    if namesplit[1] != ".sbgn": continue
    f.write('<tr>')
    f.write('<td>')
    image = namesplit[0] + ".png"
    f.write('<a href="'+path+image+'">')
    f.write('<img style="width: 100%" src="'+path+image+'" border="0"><br />')
    f.write('</a>')
    f.write('</td>')
    f.write('<td>')
    f.write('<pre style="width: 100%; max-height: 500px; overflow: auto">')
    g = open(path+fname, 'r')
    xml = g.read()
    html = ""
    for c in xml:
        if c == '<':
            c = '&lt;'
        if c == '>':
            c = '&gt;'
        html += c
    f.write(html)
    g.close()
    f.write('</pre>')
    f.write('</td>')
    f.write('</tr>')

f.write('</tabe>\n</body>\n</html>')
f.close()