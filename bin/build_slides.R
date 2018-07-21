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
    prompt = TRUE,
    error = FALSE,
    fig.cap = ' ', # whitespace forces .caption after htmlwidget
    screenshot.force = FALSE)

in_ial <- '\n{:.input title="Console"}'
out_ial <- '\n{:.output}'
fig_ial <- '\n{:.captioned}'
  
knit_hooks$set(chunk = function(x, options) {
    if (!is.null(options$title) & options$eval) {
        in_ial <- paste0('\n{:.text-document title="', options$title, '"}')
    }
    if (!is.null(options$title) & !options$eval) {
        in_ial <- paste0('\n{:.text-document .no-eval title="', options$title, '"}')
    }
  
    # add 'input' class or 'text-document' class with 'title' attribute to code
    x <- gsub('(~~~r\n.+?~~~)(\n|$)', paste0('\\1', in_ial), x)
    
    # add 'output' class to code
    x <- gsub('(?s)(~~~\n(?!{:).+?~~~)(\n|$)', paste0('\\1', out_ial), x, perl = TRUE)

    # add 'captioned' class to r figures
    x <- gsub('(!\\[.+?)(\n|$)', paste0('\\1', fig_ial), x)
    
    return(x)
})
opts_hooks$set(title = function(options) {
  options$prompt <- FALSE
  options
})

files <- list.files('docs/_slides_Rmd')
deps <- list()
for (f in config$slide_sorter) {
    f.Rmd <- paste0(f, '.Rmd')
    if (f.Rmd %in% files) {
        f.md <- paste0(f, '.md')
        opts_chunk$set(
          fig.path = paste0('images/', f, '/'),
          cache.path = paste0('cache/', f, '/'))
        knit(input = file.path('docs/_slides_Rmd', f.Rmd),
             output = file.path('docs/_slides', f.md))
        deps <- c(deps, knit_meta())
    }
}
deps <- unique(deps)
deps <- lapply(deps, FUN = function(d) {
  # create path for htmlwidgets
  htmlwidgets <- str_extract(d$src$file, 'htmlwidgets.*')
  htmlwidgets_dest <- file.path('docs', dirname(htmlwidgets))
  dir.create(htmlwidgets, showWarnings = FALSE, recursive = TRUE)
  system2('rsync', c('-a', '--update', d$src$file, htmlwidgets_dest))
  d$src <- htmlwidgets
  return(unclass(d))
})

if (length(deps) > 0) {
  f <- 'docs/_data/htmlwidgets.yml'
  dir.create('docs/_data', showWarnings = FALSE)
  if (!(file.exists(f) && identical(yaml.load_file(f), deps))) {
    cat(as.yaml(deps), file = f)
  }
}
