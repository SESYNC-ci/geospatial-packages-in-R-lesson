#!/usr/bin/env Rscript
library(rvest)

args <- commandArgs(TRUE)
url <- args[[1]]
s <- html_session(url)
n <- html_nodes(s, css = 'h2, .text-document pre')

ws <- lapply(n, function(x) {
  out <- html_text(x)
  if (html_name(x) == 'h2') out <- paste('##', out, '\n')
  return(out)
})
cat(paste(ws, collapse = '\n'), file = 'worksheet.R')
    
