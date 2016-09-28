#!/usr/bin/python
"""
Script generating the example.html
"""
from __future__ import print_function, division
import os
from glob import glob


def create_html(path, f_html):
    """ Create html report of SBGN files.

    :param path: path to the *.sbgn and corresponding *.png files
    :param f_html: output html file
    :return:
    """
    f = open(f_html, 'w')
    header = '<html>\n' \
             '<head>\n' \
             '<title>SBGN-ML Test Files</title>\n' \
             '</head>\n' \
             '<body>\n' \
             '<h1>SBGN examples</h1>' \
             '\t<table border="2">\n'
    f.write(header)

    # all *.sbgn files recursively in folder
    fnames = [y for x in os.walk(path) for y in glob(os.path.join(x[0], '*.sbgn'))]
    for fname in sorted(fnames):
        print(fname)

        namesplit = os.path.splitext(fname)
        if namesplit[1] != ".sbgn":
            continue

        root = namesplit[0]
        href_image = root + ".png"

        f.write('\t\t<tr>\n')
        f.write('\t\t\t<td>{}\n'.format(href_image))
        f.write('\t\t\t<a href="' + href_image + '">')
        f.write('<img style="width: 100%" src="' + href_image + '" border="0"><br />')
        f.write('</a>\n')
        f.write('\t\t\t</td>\n')
        f.write('\t\t\t<td>\n')
        f.write('\t\t\t<pre style="width: 100%; max-height: 500px; overflow: auto">\n')

        # write the SBGN

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

        f.write('\t\t\t</pre>\n')
        f.write('\t\t\t</td>\n')
        f.write('\t\t</tr>\n')

    footer = '\t</table>\n' \
             '</body>\n' \
             '</html>'
    f.write(footer)
    f.close()

#################################################################################

if __name__ == "__main__":

    # files are relative to this script
    script_path = os.path.dirname(os.path.realpath(__file__))
    os.chdir(script_path)
    print("-"*80)
    print("Creating examples")
    print("-" * 80)

    test_path = "../test-files/"
    f_html = "./examples.html"
    print('input folder: ' + test_path)
    print('output file: ' + f_html)

    create_html(test_path, f_html)
