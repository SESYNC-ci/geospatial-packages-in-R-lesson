# look up slides in Jekyll _config.yml
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")
# filter to RMarkdown slides
SLIDES_RMD := $(filter %.Rmd, $(SLIDES))

# do not run rules in parallel; because
# bin/build_slides.R runs over all .Rmd slides
.NOTPARALLEL:

# default target will commit and push
lesson: slides
	if [ -n "$(git status -s)" ]; then git commit -am 'commit by make'; fi
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push

# use slides target to preview locally
slides: $(SLIDES_RMD:%.Rmd=docs/_slides/%.md)

docs/_slides/%.md: $(SLIDES_RMD:%=docs/_slides_Rmd/%)
	@bin/build_slides.R

.PHONY: lesson slides
