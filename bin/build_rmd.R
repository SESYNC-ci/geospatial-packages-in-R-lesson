#!/usr/bin/env Rscript
library(methods)
library(knitr)
library(yaml)
library(stringr)
library(reticulate)

use_python('/usr/bin/python3')

config <- yaml.load_file(file.path('docs', '_data', 'lesson.yml'))
render_markdown(fence_char = '~')
opts_knit$set(
    root.dir = '.',
    base.dir = file.path('docs', 'assets'))
opts_chunk$set(
    comment = NA,
    cache = TRUE,
    prompt = FALSE,
    error = FALSE,
    title = "Console",
    text.document = TRUE,
    fig.cap = ' ', # whitespace forces .caption after htmlwidget
    screenshot.force = FALSE)

in_ial <- '\n{:title="%s"%s}'
out_ial <- '\n{:.output}'
fig_ial <- '\n{:.captioned}'
  
opts_hooks$set(title = function(options) {
  if (!is.null(options$handout)) {
    options$title <- sprintf('{{ site.data.lesson.handouts[%d] }}', options$handout)
  } else if (options$title == "Console") {
    options$prompt <- TRUE
    options$text.document <- FALSE
  }
  options
})
opts_hooks$set(fig.path = function(options) { ## FIXME file a knitr bug about this
  if (options$engine == 'python') {
    options$fig.path = file.path(opts_knit$get('base.dir'), options$fig.path)
  }
  options
})
knit_hooks$set(chunk = function(x, options) {
  if (!options$eval) {
    in_ial <- sprintf(in_ial, '%s', ' .no-eval%s')
  }
  if (options$text.document) {
    in_ial <- sprintf(in_ial, '%s', ' .text-document%s')
  } else {
    in_ial <- sprintf(in_ial, '%s', ' .input%s')
  }
  in_ial <- sprintf(in_ial, options$title, '')
  
  # add 'input' class or 'text-document' class with 'title' attribute to code
  in_block <- sprintf('(~~~%s\n.+?~~~)(\n|$)', tolower(options$engine))
  x <- gsub(in_block, paste0('\\1', in_ial), x)
  
  # add 'output' class to code
  x <- gsub('(?s)(~~~\n(?!{:).+?~~~)(\n|$)', paste0('\\1', out_ial), x, perl = TRUE)
  
  # correct figure paths and add 'captioned' class
  x <- gsub('(!\\[.+)\\(.*(images/.*)\\)(\n|$)', paste0(
    '\\1({% include asset.html path="\\2" %})', fig_ial), x)
  
  return(x)
})

deps <- list()
for (f in config$sorter) {
  f.Rmd <- file.path('slides', paste0(f, '.Rmd'))
  if (!file.exists(f.Rmd)) next
  f.md <- file.path('docs', '_slides', paste0(f, '.md'))
  opts_chunk$set(
    fig.path = file.path('images', f, ''),
    cache.path = file.path('cache', f, ''))
  knit(input = f.Rmd, output = f.md)
  deps <- c(deps, knit_meta())
}
deps <- unique(deps)
deps <- lapply(deps, FUN = function(d) {
  # create path for htmlwidgets
  htmlwidgets <- str_extract(d$src$file, 'htmlwidgets.*')
  htmlwidgets_dest <- file.path('docs', 'assets', dirname(htmlwidgets))
  dir.create(htmlwidgets, showWarnings = FALSE, recursive = TRUE)
  system2('rsync', c('-a', '--update', d$src$file, htmlwidgets_dest))
  d$src <- htmlwidgets
  return(unclass(d))
})

if (length(deps) > 0) {
  f <- file.path('docs', '_data', 'htmlwidgets.yml')
  if (!(file.exists(f) && identical(yaml.load_file(f), deps))) {
    cat(as.yaml(deps), file = f)
  }
}
