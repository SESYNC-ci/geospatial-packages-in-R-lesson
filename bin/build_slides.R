#!/usr/bin/env Rscript
require(knitr)
require(yaml)
require(stringr)

config = yaml.load_file("docs/_config.yml")
render_markdown(fence_char = "~")
opts_knit$set(
    root.dir = '.',
    base.dir = 'docs/',
    base.url = '{{ site.baseurl }}/')
opts_chunk$set(
    comment = NA,
    fig.path = "images/",
    block_ial = c("{:.input}", "{:.output}"))

current_chunk = knit_hooks$get("chunk")
chunk = function(x, options) {
    x <- current_chunk(x, options)
    if (!is.null(options$title)) {
        x <- gsub("~~~(\n*(!\\[.+)?$)",
                  paste0("~~~\n{:.text-document title=\"", options$title, "\"}\\1"),
                  x)
        return(x)
    }
    x <- gsub("~~~\n(\n+~~~)",
              paste0("~~~\n", options$block_ial[1], "\\1"),
              x)
    if (str_count(x, "~~~") > 2) {
        idx <- 2
    } else {
        idx <- 1
    }
    x <- gsub("~~~(\n*$)",
              paste0("~~~\n", options$block_ial[idx], "\\1"),
              x)
    return(x)
}
knit_hooks$set(chunk = chunk)

idx <- grep('.Rmd$', config$slide_sorter)
for (f.Rmd in config$slide_sorter[idx]) {
    f.md <- sub(".Rmd$", ".md", f.Rmd)
    knit(input = file.path("docs", "_slides_Rmd", f.Rmd),
         output = file.path("docs", "_slides", f.md))
}
