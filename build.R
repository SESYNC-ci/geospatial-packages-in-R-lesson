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
  cache = FALSE,
  block_ial = c("{:.input}", "{:.output}"))

current_chunk = knit_hooks$get("chunk")
chunk = function(x, options) {
  x <- current_chunk(x, options)
  fence_count <- str_count(x, "~~~")
  if (fence_count > 2) {
    x <- gsub("~~~\n\n",
              paste0("~~~\n", options$block_ial[1], "\n\n"),
              x)
    if (!is.na(options$block_ial[2])) {
      x <- gsub("~~~$",
                paste0("~~~\n", options$block_ial[2]),
                x)
    }
  } else if (options$echo) {
    x <- gsub("~~~$",
              paste0("~~~\n", options$block_ial[1]),
              x)
  }
  return(x)
}
knit_hooks$set(chunk = chunk)

knit(args[1])