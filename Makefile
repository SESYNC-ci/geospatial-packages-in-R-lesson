SHELL := /bin/bash

# look up lesson number and slides in Jekyll _config.yml
LESSON := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['lesson']")
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")
SLIDES := $(SLIDES:%=docs/_slides/%.md)

# list available Markdown, RMarkdown and Pweave slides
SLIDES_MD := $(shell find . -path "./docs/_slides_md/*.md")
SLIDES_RMD := $(shell find . -path "./docs/_slides_Rmd/*.Rmd")
SLIDES_PMD := $(shell find . -path "./docs/_slides_pmd/*.pmd")

# look up files for trainees in Jekyll _config.yml
HANDOUTS := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['handouts']")

# do not run rules in parallel
## because bin/build_slides.R (.py) runs over all .Rmd (.pmd) slides
.NOTPARALLEL:
.DEFAULT_GOAL: slides
.PHONY: course lesson slides archive preview

# target to just update docs/_slides
slides: $(SLIDES)
$(SLIDES): | docs/_slides
docs/_slides:
	mkdir docs/_slides
## cannot use a pattern as the next three targets, because
## the targets are only a subset of docs/_slides/%.md and
## they have different recipes
$(subst _md,,$(SLIDES_MD)): docs/_slides/%: docs/_slides_md/%
	cp $< $@
$(subst _Rmd,,$(SLIDES_RMD:.Rmd=.md)): docs/_slides/%.md: docs/_slides_Rmd/%.Rmd bin/build_slides.R
	@bin/build_slides.R
$(subst _pmd,,$(SLIDES_PMD:.pmd=.md)): docs/_slides/%.md: docs/_slides_pmd/%.pmd
	@bin/build_slides.py

# target to update lesson repo on GitHub
lesson: slides | .git/refs/remotes/upstream
	git pull
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push
.git/refs/remotes/upstream:
	git remote add upstream "git@github.com:sesync-ci/lesson-style.git"
	git fetch upstream
	git checkout -b upstream upstream/master
	git checkout master

# targets keep jekyll site up to date
preview: slides | docs/_site
export GEM_HOME=$(HOME)/.gem
SITE = $(shell find ./docs/ ! -name _site)
docs/_site: $(SITE) | docs/Gemfile.lock
	pushd docs && bundle exec jekyll build --baseurl=/p/4000 && popd
	touch docs/_site
docs/Gemfile.lock:
	pushd docs && bundle install && popd

# target that brings this lesson into a course
## make target "course" is called within the handouts Makefile,
## assumed to be at ../../Makefile
course: lesson $(addprefix ../../handouts/,$(HANDOUTS:worksheet%=worksheet-$(LESSON)%))
## copy lesson handouts to the ../../handouts/ directory
## while adding lesson numbers to worksheets
../../handouts/worksheet-$(LESSON)%: worksheet%
	cp $< $@
../../handouts/%: %
	mkdir -p $(dir $@)
	cp -r $< $@

# target to archive a lesson
## call the archive target with a command line parameter for DATE
archive:
	@curl -L "https://sesync-ci.github.io/$${PWD##*/}/course/archive.html" -o docs/_posts/$(DATE)-index.html

# target to create binary for GitHub release
release:
	ln *.Rproj handouts.Rproj && zip -FSr handouts handouts.Rproj $(HANDOUTS) && rm handouts.Rproj
