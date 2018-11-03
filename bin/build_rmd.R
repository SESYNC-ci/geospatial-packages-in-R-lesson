#!/usr/bin/env Rscript
require(methods)
require(knitr)
require(yaml)
require(stringr)

config <- yaml.load_file('docs/_data/lesson.yml')
render_markdown(fence_char = '~')
opts_knit$set(
    root.dir = '.',
    base.dir = file.path('docs', 'assets', 'images'))
opts_chunk$set(
    comment = NA,
    cache = TRUE,
    prompt = TRUE,
    error = FALSE,
    fig.cap = ' ', # whitespace forces .caption after htmlwidget
    screenshot.force = FALSE)

in_ial <- '\n{:%s title="%s"}' #was .input title="Console"
out_ial <- '\n{:.output}'
fig_ial <- '\n{:.captioned}'
  
knit_hooks$set(chunk = function(x, options) {
    if (options$eval) {
        in_ial <- '\n{:%s title="%s"}'
    } else {
        in_ial <- '\n{:%s .no-eval title="%s"}'
    }
    if (!is.null(options$handout)) {
        in_ial <- sprintf(in_ial, '.text-document', '{{ site.data.lesson.handouts[%d] }}')
        in_ial <- sprintf(in_ial, options$handout - 1)
    } else if (!is.null(options$title)) {
        in_ial <- sprintf(in_ial, '.text-document', options$title)
    } else {
        in_ial <- sprintf(in_ial, '.text-document', 'Console')
    }
  
    # add 'input' class or 'text-document' class with 'title' attribute to code
    x <- gsub('(~~~r\n.+?~~~)(\n|$)', paste0('\\1', in_ial), x)
    
    # add 'output' class to code
    x <- gsub('(?s)(~~~\n(?!{:).+?~~~)(\n|$)', paste0('\\1', out_ial), x, perl = TRUE)

    # correct figure paths and add 'captioned' class
    x <- gsub('(!\\[.+?)\\((.*?)\\)(\n|$)', paste0(
              '\\1({{ "\\2" | prepend: site.imageurl | relative_url }})', fig_ial), x)
    
    return(x)
})
opts_hooks$set(title = function(options) {
  options$prompt <- FALSE
  options
})

files <- list.files('slides')
deps <- list()
for (f in config$sorter) {
    f.Rmd <- paste0(f, '.Rmd')
    if (f.Rmd %in% files) {
        f.md <- paste0(f, '.md')
        opts_chunk$set(
          fig.path = file.path(f, ''),
          cache.path = file.path('cache', f, ''))
        knit(input = file.path('slides', f.Rmd),
             output = file.path('docs', '_slides', f.md))
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
  if (!(file.exists(f) && identical(yaml.load_file(f), deps))) {
    cat(as.yaml(deps), file = f)
  }
}
