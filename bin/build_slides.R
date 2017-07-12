#!/usr/bin/env Rscript
require(methods)
require(knitr)
require(yaml)
require(stringr)

config = yaml.load_file('docs/_config.yml')
render_markdown(fence_char = '~')
opts_knit$set(
    root.dir = '.',
    base.dir = 'docs/',
    base.url = '{{ site.baseurl }}/')
opts_chunk$set(
    comment = NA,
    fig.path = 'images/',
    block_ial = c('{:.input}', '{:.output}'),
    cache = TRUE,
    cache.path = 'docs/_slides_Rmd/cache/')

current_chunk = knit_hooks$get('chunk')
chunk = function(x, options) {
    x <- current_chunk(x, options)
    if (!is.null(options$title)) {
        # add title to kramdown block IAL
        x <- gsub('~~~(\n*(!\\[.+)?$)',
                  paste0('~~~\n{:.text-document title="', options$title, '"}\\1'),
                  x)
        # add 'captioned' class to figures
        x <- gsub('(!\\[.+$)', '===\n\n\\1\n{:.captioned}', x)
    } else {
        # add default kramdown block IAL to kramdown block IAL to input
        x <- gsub('~~~\n(\n+~~~)',
                  paste0('~~~\n', options$block_ial[1], '\\1'),
                  x)
        if (str_count(x, '~~~') > 2) {
            idx <- 2
        } else {
            idx <- 1
        }
        x <- gsub('~~~(\n*$)',
                  paste0('~~~\n', options$block_ial[idx], '\\1'),
                  x)
    }
    return(x)
}
knit_hooks$set(chunk = chunk)

files <- list.files('docs/_slides_Rmd')
for (f in config$slide_sorter) {
    f.Rmd <- paste0(f, '.Rmd')
    if (f.Rmd %in% files) {
        f.md <- paste0(f, '.md')
        knit(input = file.path('docs/_slides_Rmd', f.Rmd),
             output = file.path('docs/_slides', f.md))
    }
}
