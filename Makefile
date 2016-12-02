# look up slides in Jekyll _config.yml
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")

# list available RMarkdown slides
SLIDES_RMD := $(shell ls docs/_slides_Rmd/*.Rmd)

# do not run rules in parallel; because
# bin/build_slides.R runs over all .Rmd slides
.NOTPARALLEL:

.PHONY: lesson slides $(SLIDES)

# default target will commit and push
lesson: slides
	if [ -n "$(git status -s)" ]; then git commit -am 'commit by make'; fi
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push

# use this .PHONY target to avoid commit and push 
slides: $(SLIDES:%=docs/_slides/%.md)

$(subst _Rmd,,$(SLIDES_RMD:.Rmd=.md)): $(SLIDES_RMD)
	@bin/build_slides.R
