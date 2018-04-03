#!/usr/bin/env Rscript
require(methods)
require(knitr)
require(yaml)
require(stringr)

config <- yaml.load_file('docs/_config.yml')
render_markdown(fence_char = '~')
opts_knit$set(
    root.dir = '.',
    base.dir = 'docs/',
    base.url = '{{ site.baseurl }}/')
opts_chunk$set(
    comment = NA,
    cache = TRUE,
    cache.path = 'docs/_slides_Rmd/cache/')

in_ial <- '\n{:.input}\n'
out_ial <- '\n{:.output}\n'
fig_ial <- '\n{:.captioned}\n'
  
current_chunk <- knit_hooks$get('chunk')
chunk <- function(x, options) {
    if (!is.null(options$title)) {
      in_ial <- paste0('\n{:.text-document title="', options$title, '"}\n')
    }
    x <- current_chunk(x, options)
    
    # add 'input' class or 'text-document' class with 'title' attribute to code
    x <- gsub('(~~~r\n.+?~~~)(\n|$)', paste0('\\1', in_ial), x)
    
    # add 'output' class to code
    x <- gsub('(?s)(~~~\n(?!{:).+?~~~)(\n|$)', paste0('\\1', out_ial), x, perl = TRUE)

    # add 'captioned' class to r figures
    x <- gsub('(!\\[.+?)(\n|$)', paste0('\\1', fig_ial), x)
    
    return(x)
}
knit_hooks$set(chunk = chunk)

files <- list.files('docs/_slides_Rmd')
for (f in config$slide_sorter) {
    f.Rmd <- paste0(f, '.Rmd')
    if (f.Rmd %in% files) {
        f.md <- paste0(f, '.md')
	opts_chunk$set(fig.path = paste0('images/', f, '/'))
        knit(input = file.path('docs/_slides_Rmd', f.Rmd),
             output = file.path('docs/_slides', f.md))
    }
}
