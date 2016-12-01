# look up slides in Jekyll _config.yml
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")
# filter to RMarkdown slides
SLIDES_RMD := $(filter %.Rmd, $(SLIDES))

# do not run rules in parallel; because
# bin/build_slides.R runs over all .Rmd slides
.NOTPARALLEL:

lesson: $(SLIDES_RMD:%.Rmd=docs/_slides/%.md)
	git fetch upstream master:upstream # maybe could streamline this?
	git merge --no-edit upstream
	git push

docs/_slides/%.md: $(SLIDES_RMD:%=docs/_slides_Rmd/%)
	@bin/build_slides.R

.PHONY: lesson
