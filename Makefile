# look up slides and lesson number in Jekyll _config.yml
SLIDES := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['slide_sorter']")
LESSON := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['lesson']")

# list available Markdown, RMarkdown and Pweave slides
SLIDES_MD := $(shell find . -path "./docs/_slides_md/*.md")
SLIDES_RMD := $(shell find . -path "./docs/_slides_Rmd/*.Rmd")
SLIDES_PMD := $(shell find . -path "./docs/_slides_pmd/*.pmd")

# look up auxillary files trainees will require in Jekyll _config.yml
HANDOUTS := $(shell ruby -e "require 'yaml';puts YAML.load_file('docs/_config.yml')['handouts']")
WORKSHEETS := $(addprefix ../../, $(patsubst worksheet%,worksheet-$(LESSON)%,$(filter-out data/%, $(HANDOUTS))))
DATA := $(addprefix ../,$(filter data/%,$(HANDOUTS)))

# do not run rules in parallel; because
# - bin/build_slides.R runs over all .Rmd slides
# - rsync -r only needs to run once
.NOTPARALLEL:
.DEFAULT_GOAL: slides
.PHONY: course lesson slides archive

# target to build .md slides
slides: $(SLIDES:%=docs/_slides/%.md) | .git/refs/remotes/upstream

# target to ensure upstream remote is lesson-style
.git/refs/remotes/upstream:
	git remote add upstream "git@github.com:sesync-ci/lesson-style.git"
	git fetch upstream
	git checkout -b upstream upstream/master
	git checkout master

# cannot use a pattern as the next three targets, because
# the targets are only a subset of docs/_slides/%.md

$(subst _md,,$(SLIDES_MD)): docs/_slides/%: docs/_slides_md/%
	cp $< $@

$(subst _Rmd,,$(SLIDES_RMD:.Rmd=.md)): $(SLIDES_RMD)
	@bin/build_slides.R

$(subst _pmd,,$(SLIDES_PMD:.pmd=.md)): $(SLIDES_PMD)
	@bin/build_slides.py

# target to update lesson repo on GitHub
lesson: slides
	git pull
	if [ -n "$$(git status -s)" ]; then git commit -am 'commit by make'; fi
	git fetch upstream master:upstream
	git merge --no-edit upstream
	git push

# make target "course" copies lesson handouts to the handouts repository
# adding a lesson number to any "worksheet"
# make course is called within the handouts Makefile, assumed to be at ../../
course: lesson $(WORKSHEETS) $(DATA)
# FIXME use http://sesync.us/lq4iu for link sharing, zip ?

$(WORKSHEETS): ../../worksheet-$(LESSON)%: worksheet%
	cp $< $@

$(DATA): ../%: %
	rsync -au $< $@

# must call the archive target with a
# command line parameter for DATE
archive:
	@curl "https://sesync-ci.github.io/$${PWD##*/}/course/archive.html" -o docs/_posts/$(DATE)-index.html

# create binary for GitHub release
release:
	ln *.Rproj handouts.Rproj && zip -FSr handouts handouts.Rproj $(HANDOUTS) && rm handouts.Rproj
