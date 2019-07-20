# # Make Settings

.DEFAULT_GOAL := preview

.PHONY: release archive preview course slides upstream

# do not run rules in parallel because bin/build_rmd.R 
# (bin/build_ipynb.py) runs over all .Rmd (.ipynb) slides
.NOTPARALLEL:

# use user library for bundle install
export GEM_HOME = $(HOME)/.gem

# execute recipes with bash shell for pushd/popd
SHELL := /bin/bash

# use user library for bundle install
export GEM_HOME = $(HOME)/.gem

# execute recipes with bash shell for pushd/popd
SHELL := /bin/bash

# override RStudio display setting
unexport DISPLAY

# specify the owner of the upstream and current repo
OWNER := SESYNC-ci

# # Read Slide/File Names

# look up lesson number and slides in Jekyll _config.yml
LESSON := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_data/lesson.yml')['lesson']")
SORTER := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_data/lesson.yml')['sorter']")
SLIDES := $(SORTER:%=docs/_slides/%.md)

# list available Markdown, RMarkdown and Jupyter Notebook slides
SLIDES_MD := $(shell find slides/ -name "*.md" -exec basename {} \;)
SLIDES_RMD := $(shell find slides/ -name "*.Rmd" -exec basename {} \;)
SLIDES_IPYNB := $(shell find slides/ -name "*.ipynb" -exec basename {} \;)

# look up handouts (worksheets and data) for trainees in _data/lesson.yml
HANDOUTS := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_data/lesson.yml')['handouts']")

# look up files whose modification require Jekyll build (erring conservatively)
SITE := $(shell find docs/ ! -path "docs/_site*")

# # Merge with Upstream Repo "lesson-style"

# target to merge changes
upstream: | .git/refs/remotes/upstream
	git pull
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push
# target to create upstream branch
.git/refs/remotes/upstream:
	git remote add -f upstream "git@github.com:$(OWNER)/lesson-style.git"
	git branch -t upstream upstream/master

# # Build Slides for Jekyll Site

# target to identify slide files
slides: $(SLIDES)

# targets to trigger the order-only prerequisite just once
$(SLIDES): | docs/_slides
docs/_slides:
	mkdir -p docs/_slides

## cannot use a pattern as the next three targets, because
## the targets are only a subset of docs/_slides/%.md and
## they have different recipes
$(addprefix docs/_slides/,$(SLIDES_MD)): docs/_slides/%: slides/%
	cp $< $@
$(addprefix docs/_slides/,$(SLIDES_RMD:.Rmd=.md)): docs/_slides/%.md: bin/build_rmd.R slides/%.Rmd 
	@$<
$(addprefix docs/_slides/,$(SLIDES_PMD:.ipynb=.md)): docs/_slides/%.md: bin/build_ipynb.py /slides/%.ipynb 
	@$<

# # Build the Jekyll Site locally

# target to build local jekyll site for RStudio Server preview
preview: slides | docs/_site
docs/_site: $(SITE) | docs/Gemfile.lock
	pushd docs && bundle exec jekyll build --baseurl=$(RSTUDIO_PROXY) && popd
	touch docs/_site
docs/Gemfile.lock:
	pushd docs && bundle install && popd

# # Copy Handouts and Data for a Course
# 
# make target "course" is called within the handouts Makefile,
# whose own recipes put it at ../../Makefile
# 
# files matching "worksheet*" will be numbered by lesson number

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

# # Archive
# 
# call the archive target with a command line parameter for DATE

# target to archive a lesson
archive: | docs/_archive
	cp docs/_views/course.md docs/_archive/$(DATE)-index.md
	pushd docs && bundle exec jekyll build --config _config.yml,_archive.yml && popd
	echo -e "---\n---\n" > docs/_archive/$(DATE)-index.html
	cat docs/_site/$(subst -,/,$(DATE))/index.html >> docs/_archive/$(DATE)-index.html
	rm docs/_archive/$(DATE)-index.md
docs/_archive:
	mkdir docs/_archive

# target to create binary for GitHub release
release:
	mkdir handouts
	re=".R(|md)( |$$)"; \
	if [ -f *.Rproj ] && [[ "$(filter worksheet%,$(HANDOUTS))" =~ $$re ]]; \
	    then ln *.Rproj handouts/handouts.Rproj; \
	fi
	ln -s $(addprefix ../,$(HANDOUTS)) handouts
	zip -FSr handouts.zip handouts
	rm -rf handouts
