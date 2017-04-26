#!/usr/bin/env python
from pweave import Pweb, PwebPandocFormatter, rcParams
import yaml

rcParams['chunk']['defaultoptions'].update({
    'term': True,
    'f_size': (4, 3),
    })

class Formatter(PwebPandocFormatter):

    def __init__(self, *args, **kwargs):
        super(Formatter, self).__init__(*args, **kwargs)
        self.formatdict.update({
            'codestart': '~~~%s',
            'codeend': '~~~\n{:.text-document title="worksheet.py"}\n\n',
            'termstart': '~~~%s',
            'termend': '~~~\n{:.output}\n\n',
            })
        return
    
    def make_figure_string(self, *args, **kwargs):
        f_str = super(Formatter, self).make_figure_string(*args, **kwargs)
        f_str = f_str.replace('..', '{{ site.baseurl }}')
        f_str = f_str[:f_str.find('{#')]
        return f_str
        

with open('docs/_config.yml') as f:
    config = yaml.load(f)
    
for fname in config['slide_sorter']:
    doc = Pweb(
        file='docs/_slides_pmd/{}.pmd'.format(fname),
        output='docs/_slides/{}.md'.format(fname),
        figdir='../images',
        )
    doc.setreader('markdown')
    doc.setformat(Formatter=Formatter)
    doc.weave()
