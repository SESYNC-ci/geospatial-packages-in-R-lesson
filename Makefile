SHELL := /bin/bash
PORT ?= 4321
BASEURL ?= /
.DEFAULT_GOAL := preview

# # Get File Names

# look up lesson number and slides in Jekyll _config.yml
LESSON := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['lesson']")
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")
SLIDES := $(SLIDES:%=docs/_slides/%.md)

# look up available Markdown, RMarkdown and Pweave slides
SLIDES_MD := $(shell find . -path "./docs/_slides_md/*.md")
SLIDES_RMD := $(shell find . -path "./docs/_slides_Rmd/*.Rmd")
SLIDES_PMD := $(shell find . -path "./docs/_slides_pmd/*.md")

# look up files for trainees in Jekyll _config.yml
HANDOUTS := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['handouts']")

# look up all files whose modification should trigger rebuild of Jekyll site (erring conservatively)
SITE = $(shell find ./docs/ ! -name _site)

# # Set Options

# do not run rules in parallel because bin/build_slides.R (.py) runs
# over all .Rmd (.pmd) slides
.NOTPARALLEL:
.PHONY: course upstream slides archive preview

# use user library for bundle install
export GEM_HOME=$(HOME)/.gem

# # Merge with (upstream) lesson-style Repository

# target to merge changes
upstream: | .git/refs/remotes/upstream
	git pull
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push
# target to create upstream branch
.git/refs/remotes/upstream:
	git remote add upstream "git@github.com:sesync-ci/lesson-style.git"
	git fetch upstream master:upstream
	git branch -u upstream/master upstream

# # Build Slides for Jekyll Site

# target to identify slide files
slides: $(SLIDES)

# targets to trigger the order-only prerequisite just once
$(SLIDES): | docs/_slides
docs/_slides:
	mkdir -p docs/_slides

# targets to call bin/build_slides.*
# cannot use a pattern as the next three targets, because
# the targets are only a subset of docs/_slides/%.md and
# they have different recipes
$(subst _md,,$(SLIDES_MD)): docs/_slides/%: docs/_slides_md/%
	cp $< $@
$(subst _Rmd,,$(SLIDES_RMD:.Rmd=.md)): docs/_slides/%.md: docs/_slides_Rmd/%.Rmd bin/build_slides.R
	@bin/build_slides.R
$(subst _pmd,,$(SLIDES_PMD)): docs/_slides/%.md: docs/_slides_pmd/%.md bin/build_slides.py
	@bin/build_slides.py

# # Build the Jekyll Site locally

# targets keep jekyll site up to date
preview: slides | docs/_site
docs/_site: $(SITE) | docs/Gemfile.lock
	pushd docs && bundle exec jekyll build --baseurl=$(BASEURL)p/$(PORT) && popd
	touch docs/_site
docs/Gemfile.lock:
	pushd docs && bundle install && popd

# # Copy Handouts and Data for a Course
#
# make target "course" is called within the handouts Makefile,
# assumed to be at ../../Makefile
#
# files matching "worksheet*" will be renumbered by lesson numbers

# target to update style and identify course handout files
course: upstream $(addprefix ../../handouts/,$(HANDOUTS:worksheet%=worksheet-$(LESSON)%))

# target to copy worksheets to the ../../handouts/
# directory while adding lesson numbers
../../handouts/worksheet-$(LESSON)%: worksheet%
	cp $< $@

# target to copy remaining handouts to ../../handouts/
../../handouts/%: %
	mkdir -p $(dir $@)
	cp -r $< $@

# # Archiving

# target to archive a lesson must be called with a command line
# parameter for DATE
archive:
	@curl -L "https://sesync-ci.github.io/$${PWD##*/}/course/archive.html" -o docs/_posts/$(DATE)-index.html

# target to create binary for GitHub release
release:
	ln -s . handouts
	if [ -f *.Rproj ]; then ln *.Rproj handouts.Rproj; fi
	zip -FSr handouts handouts/handouts.Rproj $(addprefix handouts/,$(HANDOUTS))
	rm -f handouts handouts.Rproj
