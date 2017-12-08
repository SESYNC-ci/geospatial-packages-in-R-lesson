# Guide to `sesync-ci/*-lesson` Repositories

The lessons maintained by the SESYNC-CI organization are held in separate repositories that nonetheless share common files. The tree shown below shows files from the `lesson-style` repository that are shared (merged) into all lessons. Except for `README.md` and `docs/_config.yml`, these files shall **only** be modified in the `lesson-style` repository.

```
lesson-style.git
├── bin/
│   ├── build_slides.R
│   └── build_slides.py
├── CONTRIBUTING.md
├── data -> /nfs/public-data/training
├── docs/
│   ├── _config.yml
│   ├── course/
│   │   ├── archive.html
│   │   └── index.md
│   ├── css/
│   │   ├── default.css
│   │   ├── slideshow.css
│   │   └── static.css
│   ├── Gemfile
│   ├── Gemfile.lock
│   ├── _includes/
│   │   ├── body.html
│   │   ├── head.html
│   │   └── subst_content.html
│   ├── index.md
│   ├── instructor/
│   │   └── index.md
│   ├── _layouts/
│   │   ├── archive.html
│   │   ├── course.html
│   │   ├── default.html
│   │   ├── instructor.html
│   │   └── slides.html
│   └── slides/
│       └── index.md
├── Makefile
└── README.md
```

Each lesson repository will include the above files in addition to the topical material, carefully arranged within all or some of the following files and folders:

```
*-lesson.git
├── README.md
├── ...
└── docs/
    ├── _posts/
    ├── _slides/
   [├── _slides_pmd/]
   [├── _slides_md/]
   [├── _slides_Rmd/]
    ├── images/
    └── _config.yml
```

Note that `README.md` and `docs/_config.yml` occur in both; the versions/templates in `lesson-style` include instructions on which parts to modify once brought into a `*-lesson` repository to avoid merge conflicts.

For a lesson written in RMarkdown, place .Rmd files within `docs/_slides_Rmd`; knitted slides will be generated within `docs/_slides`. Likewise, any slides to be processed by Pweave go in `docs/_slides_pmd`. If a lesson is written purely in Markdown, the slides may reside in `docs/_slides`, but a lesson that combines Markdown slides with processed slides should include `doc/_slides_md` and let the build process populate `docs/_slides`.

Data for the lesson goes in the `public-data/training` folder on SESYNC's research storage server, which is symlinked from the `data` folder in each lesson. References to data in lesson code shall be via the relative path `data/`. Figures produced during build and any external images go in `docs/images`. Archived versions of the lesson go in `docs/_posts`.

Including a `handouts.Rproj` makes it convenient to start an R session with the appropriate working directory, and will be included in the [handouts] associated with each lesson. All additional handouts (including data) must be listed in the `docs/_config.yml`.

The Makefile includes targets for building and publishing lessons:
  - `make slides` to run the `bin/build_slides.*` scripts that populate `docs/_slides`
  - `make lesson` makes the slides and publishes to GitHub
  - `make archive $DATE` copies the lesson as generated on GitHub into the `docs/_posts` archive.

## Creating a **new** lesson

Create a new, public repository owned by the SESYNC-CI organization: use a short name, provide a description that can be exported as a human readable lesson title (e.g. on SESYNC's [lessons] tab), and do not include a README.

Locally clone `lesson-style` repository into a suitably named `*-lesson` folder, rename the branch and remote, and checkout a new master:

```
git clone git@github.com:SESYNC-ci/lesson-style.git $LESSON-lesson
cd $LESSON-lesson
git remote set-url origin git@github.com:SESYNC-ci/$LESSON-lesson.git
git push
```

Everythin above is standardized across lessons, the following is where the real work begins! First, go to the lesson repository's GitHub settings and select `master/docs` as the GitHub Pages source. Configure `README.md` by commiting the following to the `README.md` file, after replacing `$LESSON` with the new lesson's name.

```
[lesson]: https://sesync-ci.github.io/$LESSON-lesson
[slideshow]: https://sesync-ci.github.io/$LESSON-lesson/slides
```

Configure the lesson by setting the following variables in the `# Site` section of the `docs/_config.yml` YAML file.

- `title`: a lesson title
- `handouts`: the list of handouts, e.g. worksheets and data
- `tag`: the release version associated with the `handouts.zip` attached to a release, if any
- `lesson`: the number of the lesson in a workshop setting
- `instructor`: who will give the lesson in a workshop setting
- `authors`: the list of contributors

Always create the `docs/_slides` folder, but develop content within one of the following folders as appropriate:

- `docs/_slides_md` for markdown (.md)
- `docs/_slides_Rmd` for RMarkdown (.Rmd)
- `docs/_slides_pmd` for Pweave (.pmd)

Each file within one of these folders becomes a vertical stack of slides in a [Reveal.js] presentation: use "===" on it's own line to indicate a slide break. Vertical stacks are concatenated horizontally in the order supplied by the `slide_sorter` array in `docs/_config.yml`.

## Viewing a Lesson

Each lesson is a Jekyll site, automatically deployed by GitHub when pushed but also possible to serve up (with a little work) locally. The following instructions work with a `*-lesson` repo open as a project on https://rstudio.sesync.org.

From a terminal, execute:

```bash
cd docs
bundle install
bundle exec jekyll build --watch --baseurl /p/4321
```

This builds a static Jekyll site, while watching for changes in the source (e.g. the `docs/_slides` folder). To view the page in a browser, use the `servr` R package:

```r
servr::httw('docs/_site', port = 4321, initpath = 'instructor', daemon = TRUE)
```

Other valide `initpath` arguments are `course`, `slides`, or nothing. If port 4321 is not available, try 4322, etc.

## Versioning and Releases

A lesson should be archived after any event in which it is presented&mdash;either in a workshop or à la carte setting. The archive is a built (i.e. processed into HTML) page copied into `docs/_posts`. Given a date for the post, the `archive` target in the Makefile will download from `docs/course/archive.html` from GitHub, non-course archives should be downloaded manually. There are two "versioning" variables to set in `docs/_config.yml` before archiving:

- `tag` refers to a release of the lesson, along with associated data and worksheets
- `styleurl` refers to a release of `lesson-style`

The corresponing releases must exist:
- The lesson's repository needs a release corresponding to `tag` that includes any data and worksheets in a `handouts.zip` "binary" attachement.
- After updating the `styleurl`, create the release in `lesson-style` before archiving any lessons

## Upstream

The repository `lesson-style` is intended to be upstream of all `*-lesson` repositories, but configuration as such must be achieved in a local clone (i.e. not on GitHub). This upstream remote will be configured on the first call to `make slides`.

To merge changes made within the `lesson-style` repository into a lesson, run `git pull upstream master` from the master branch. The `upstream` commits may not have a shared history with the `master` branch; it is okay to use `--allow-unrelated-histories`.  Modifications to the upstream branch shall be meant for all lessons. A change to `docs/_layouts/default.html`, for example, should be commited to the upstream branch and pushed to the master branch of the upstream remote (i.e. to the `lesson-style` repository on GitHub):

```
git checkout upstream
git add docs/_layouts/default.html
git commit
git push upstream HEAD:master
```

Prefer to make changes directly to the `lesson-style`.

[Reveal.js]: http://lab.hakim.se/reveal-js
[lessons]: http://www.sesync.org/for-you/cyberinfrastructure/training/%C3%A0-la-carte-lessons
[handout]: https://github.com/sesync-ci/handouts
