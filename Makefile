# look up slides, lesson number and handouts in Jekyll _config.yml
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")
LESSON := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['lesson']")
HANDOUTS := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['handouts']")

# list available Markdown, RMarkdown and Pweave slides and data
SLIDES_MD := $(shell find . -path "./docs/_slides_md/*.md")
SLIDES_RMD := $(shell find . -path "./docs/_slides_Rmd/*.Rmd")
SLIDES_PMD := $(shell find . -path "./docs/_slides_pmd/*.pmd")
DATA := $(shell find . -path "./data/*")

# make target "course" copies handouts to ../../
# adding a lesson number to any "worksheet"
# it is intended to be called in the handouts Makefile
HANDOUTS := $(addprefix ../../, $(HANDOUTS:worksheet%=worksheet-$(LESSON)%))

# do not run rules in parallel; because
# - bin/build_slides.R runs over all .Rmd slides
# - rsync -r only needs to run once
.NOTPARALLEL:
.DEFAULT_GOAL: slides
.PHONY: course lesson slides archive

# this target exists for building .md slides
# without commit and push 
slides: $(SLIDES:%=docs/_slides/%.md)

# cannot use a pattern as the target for next three blocks, because
# the targets are only a subset of docs/_slides/%.md

$(subst _md,,$(SLIDES_MD)): docs/_slides/%: docs/_slides_md/%
	cp $< $@

$(subst _Rmd,,$(SLIDES_RMD:.Rmd=.md)): $(SLIDES_RMD)
	@bin/build_slides.R

$(subst _pmd,,$(SLIDES_PMD:.pmd=.md)): $(SLIDES_PMD)
	@bin/build_slides.py

# this target updates the lesson repo
# on GitHub following a slide build
lesson: slides
	git pull
	if [ -n "$$(git status -s)" ]; then git commit -am 'commit by make'; fi
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push

# this target inserts into handouts repo
# with root assumed to be at ../
course: lesson $(HANDOUTS)
	if [ -d "data" ]; then rsync -au data/ ../data/; fi

../../worksheet-$(LESSON)%: worksheet%
	cp $< $@

$(filter-out ../../worksheet%, $(HANDOUTS)): ../../%: %
	cp $< $@

# must call the archive target with a
# command line parameter for DATE
archive:
	@curl "https://sesync-ci.github.io/$${PWD##*/}/course/archive.html" -o docs/_posts/$(DATE)-index.html
