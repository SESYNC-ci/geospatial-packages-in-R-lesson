from pweave import Pweb, PwebPandocFormatter, rcParams
import yaml

rcParams['chunk']['defaultoptions'].update({
    'term': True,
    })

class Formatter(PwebPandocFormatter):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.formatdict.update({
            'termstart': '~~~%s',
            'termend': '~~~\n{:.term}\n\n',
            })
        return
    
    def make_figure_string(self, *args, **kwargs):
        f_str = super().make_figure_string(*args, **kwargs)
        return f_str.replace('..', '{{ site.baseurl }}')
        

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
