#!/usr/bin/env python3
from pweave import PwebIPythonProcessor
from pweave import Pweb, PwebPandocFormatter, rcParams
import IPython
import yaml
import re

rcParams['chunk']['defaultoptions'].update({
    'wrap': False,
    'term': False,
    'f_size': (4, 3),
    })

IPy = IPython.core.interactiveshell.InteractiveShell().get_ipython()

def init(self, *args, **kwargs):
    super(PwebIPythonProcessor, self).__init__(*args, **kwargs)
    self.IPy = IPy
    self.prompt_count = 1
    
PwebIPythonProcessor.__init__ = init

class Formatter(PwebPandocFormatter):
    
    out = re.compile(r'\nOut\[\d+\]: +')

    def __init__(self, *args, **kwargs):
        super(Formatter, self).__init__(*args, **kwargs)
        self.formatdict.update({
            'codestart': '~~~%s',
            'codeend': '~~~\n{:.input title="Console"}\n',
            'outputstart': '~~~',
            'outputend': '~~~\n{:.output}\n\n'
            })
        return
    
    def make_figure_string(self, *args, **kwargs):
        f_str = super(Formatter, self).make_figure_string(*args, **kwargs)
        f_str = f_str.replace('..', '{{ site.baseurl }}')
        f_str = f_str[:f_str.find('\\')]
        f_str = f_str.replace(
            '[]',
            '[plot of {}]'.format(args[0]))
        return f_str

    def preformat_chunk(self, chunk):
        if chunk['type'] == 'code':
            if 'title' in chunk:
                codeend = '~~~\n{{:.text-document title="{}"}}\n\n'
                chunk['codeend'] = codeend.format(chunk['title'])
            chunk['result'] = self.out.sub('\n', chunk['result'])
        return chunk
        

with open('docs/_config.yml') as f:
    config = yaml.load(f)
    
for fname in config['slide_sorter']:
    doc = Pweb(
        file = 'docs/_slides_pmd/{}.md'.format(fname),
        output = 'docs/_slides/{}.md'.format(fname),
        figdir = '../images',
        )
    doc.setreader('markdown')
    doc.setformat(Formatter=Formatter)
    doc.weave(shell='ipython') ## See https://github.com/mpastell/Pweave/issues/59
#    doc.weave()
