require(knitr)
require(yaml)
require(stringr)

# If sourcing, set value appropriately
args = "index.Rmd"

# # If running as "Rscript build.R ..."
# args = commandArgs(trailingOnly=TRUE)

config = yaml.load_file("_config.yml")
render_markdown(fence_char = "~")
opts_knit$set(base.url = paste0(config$baseurl, "/"))
opts_chunk$set(
  comment = NA,
  fig.path = "images/",
  block_ial = c("{:.input}", "{:.output}"))

current_chunk = knit_hooks$get("chunk")
chunk = function(x, options) {
  x <- current_chunk(x, options)
  x <- gsub("~~~\n\n",
            paste0("~~~\n", options$block_ial[1], "\n\n"),
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

knit(args[1])