# Guide to `sesync-ci/*-lesson` Repositories

The lessons maintained by the SESYNC-CI organization are held in separate
repositories that nonetheless share common files. The tree shown below shows
files from the `lesson-style` repository that are shared (merged) into all
lessons. These files shall **only** be modified in the `lesson-style`
repository.

```
 lesson-style.git
 ├── bin/
 │   ├── build_worksheet.R (under development)
 │   ├── build_rmd.R
 │   └── build_ipynb.py (under development)
 ├── CONTRIBUTING.md
 ├── data -> /nfs/public-data/training
 ├── docs/
 │   ├── _archive.yml
 │   ├── _config.yml
 │   ├── assets/css/
 │   ├── Gemfile
 │   ├── _includes/
 │   ├── _layouts/
 │   └── _views/
 ├── LICENSE (under development)
 └── Makefile
```

The Makefile includes operations for building and publishing lessons. You can call
the following targets from the command line. In RStudio, the "Build All" button
runs the default Makefile target.

  - `make preview` (default) to build `docs/_site` locally during development
  - `make slides` run the `bin/build_*` scripts that populate `docs/_slides`
  - `make upstream` merge updates made in the upstream `lesson-style` repository
  - `make archive DATE="yyyy-mm-dd"` freeze the lesson in the `docs/_archive` collection
  - `make release` zip the handouts for attachment to a GitHub release

Sometimes the "Build All" button in RStudio results in a failure or halted execution.
This can be due to a caching problem with knitr not reloading packages when it uses
cached chunks.  The solution is to delete the cache folder in the top-level and 
rebuild.  

Each lesson repository will include the above files **in addition to** lesson
metadata and content wholly contained within the following files:

```
 *-lesson.git
 ├── docs/
 │   ├── assets/images/
 │   ├── _data/lesson.yml
 │   └── _slides/
 ├── slides/
[├── worksheet*.*]
[├── *.Rproj]
 └─ README.md
```

Developing a lesson primarily involves writing "slides" (e.g. as Markdown or RMarkdown files),
creating worksheets that will be distributed along with any data through a handout, and updating
the metadata in `docs/_data/lesson.yml`.

## Lesson Content

Each file in the top-level `slides` folder is a lesson section. Each file must
be written in either Markdown (with a ".md" extension), RMarkdown (with a ".Rmd"
extension), or Jupyter Notebook (with a ".ipynb" extension). A single lesson can
use multiple types, if the code in each has no interdependencies. Rendered
slides will be generated as Markdown within `docs/_slides`.

Data for the lesson goes in the `/nfs/public-data/training` folder on SESYNC's
research storage server, which is symlinked to `data` in each lesson. References
to data in lesson code shall be via the relative path
`data/`. Figures produced during build go automatically to `docs/assets/images`,
and any additional images must go there too. Archived, HTML versions of the
lesson go automatically to `docs/_archive`.

A `*.Rproj` is optional but convenient for starting an R session with the
appropriate working directory. A `handouts.Rproj` file will be included in the
handouts associated with any lesson having a `*.Rproj` file and a .R or .Rmd
worksheet. All handouts (including data and worksheets) must be listed in the
`docs/_data/lesson.yml`.

Please **note** the following useful details about how content is rendered:

- Code chunks within a document are rendered to either look like content within
a text editor or content typed directly into the interpreter/console. The
console-look is the default. To achieve the editor-look in a Rmd script, add
`handout = i` to the code chunk options, replacing `i` with the (zero-indexed)
position of the worksheet in the list of handouts. Alternatively, explicitly set
the `title="{{ site.data.lesson.handouts[i] }}"` attribute to a Markdown chunk.
- If an expression in a code chunk generates results, it may render as multiple
code chunks with the result interspersed. Prefer to only end code chunks with
expressions that print output or generate plots.
- Vertical slide breaks are introduced with `===` on a line by itself.
- Paragraphs followed by `{:.notes}` on a line by itself, with no blank line
after the paragraph, only show up in non-slideshow views.
- Every file in `slides` must begin with YAML frontmatter fenced above and below
by `---`.


## Creating a **new** lesson

Create a new, public repository owned by the SESYNC-CI organization: use a short
hyphenated name, provide a description that can be exported as a human readable
lesson title (e.g. on SESYNC's [lessons] tab), and do not include a README,
LICENSE, or any commit whatsoever.

Locally clone the `lesson-style` repository into a suitably named `*-lesson`
folder, rename the branch and remote, and checkout a new master:

```
git clone git@github.com:SESYNC-ci/lesson-style.git $LESSON-lesson
cd $LESSON-lesson
git remote set-url origin git@github.com:SESYNC-ci/$LESSON-lesson.git
git push
```

Go to the lesson repository's GitHub settings and select `master/docs` as the
GitHub Pages source. Update the repository's description with the
website address `https://cyberhelp.sesync.org/*-lesson` and verify the page
exists.

Create a `README.md` file at the top of your `*-lesson` repository, following
this template:

```
## Lesson Title

brief lesson description for potential students

## Instructor Notes

tips on running the tutorial for instructors

## Cyberhelp @SESYNC

The National Socio-Environmental Synthesis Center (SESYNC) curates and runs
tutorials on using cyberinfrastructure in pursuit of the Center's scientific
mission. Visit [www.sesync.org](https://www.sesync.org) to learn more about
SESYNC and [cyberhelp.sesync.org](https://cyberhelp.sesync.org) for more
tutorials and ideas.
```

Create a YAML file called `docs/_data/lesson.yml` specifying lesson-specific
variables following this template:

```
title: ...       # the lesson's title
handouts:        # a list of handouts, e.g. worksheets and data
 - ...
tag: ...         # current handout release version
lesson: ...      # the number of the lesson (for /instructor view)
lifecycle: alpha # status for lifecycle badge 
badgecolor: pink # color for lifecycle badge
warning: true    # whether to include note about lifecycle status
instructor: ...  # the name of the instructor (for /instructor view)
authors:         # a list of those writing the lesson
 - ...
sorter:          # an ordered list of slides (file names without extension)
 - ...           # contained in the top-level "slides" folder
```

Use the following guide for lifecycle variables:

| lifecycle | badgecolor | warning | 
|-----------|------------|---------|
| alpha     | pink       | true    |
| beta      | blue       | true    |
| stable    | green      | false   |
| archived  | gray       | true    |

Files within the "slides" folder become a vertical stack of slides in a
[Reveal.js] presentation. Stacks are concatenated horizontally in the order
specified by the `sorter` array in `docs/_data/lesson.yml`.

## Preview a Lesson

Each lesson is a Jekyll site, automatically deployed by GitHub when pushed but
also possible to build and view locally. The following instructions work with a
`*-lesson` repository opened as a project on https://rstudio.sesync.org.

From RStudio, choose "Build All" from the "Build" tab. This builds a static
Jekyll site if any of the content has been updated since the last site build. To
view the built page in a browser under the default port, use the `servr` R package:

```r
servr::httw('docs/_site')
```

If needed, additionally specify an `initpath` value of `'instructor/'`, `'course/'`, or `'slideshow/'`.

If the default port is in use, try a different port, e.g.:

```r
servr::httw('docs/_site', port = 4322)
```

For the site to load correctly, you must update the `RSTUDIO_PROXY`
environment variable using the next line of code and then force the site to build again.

```r
Sys.setenv(RSTUDIO_PROXY=rstudioapi::translateLocalUrl('http://127.0.0.1:4322'))
```

In order to force the site to build again, you may need to delete the entire `docs/_site`
directory manually. Rebuilding is necessary because the `RSTUDIO_PROXY` environment variable is
a hash that is generated within your Rstudio session every time Rstudio restarts, and
it is hard-coded into the file paths for the images and stylesheets. If this is not done, the
images will appear as "broken links" in the slideshow, and the slides will be formatted incorrectly.

**Important note**: If you display the lesson as a slideshow in the viewer pane using
`server::httw('docs/_site', initpath = 'slideshow/')`, the images do not display. This is 
a feature, not a bug! The idea is for the instructor to generate the plots and other images
and display them in their "Plots" tab, not on the slide.

## Releases and Handouts

*Before teaching a lesson*: Bump the `tag` value in `docs/_data/lesson.yml`. This will be the version number for the GitHub release. 
Then, create a release on GitHub using the `tag` value as the version with a "handouts.zip" (created through `make release`) attached. 
To get the file contents for the release description, use `tree` on the unzipped handouts directory. 
Copy and paste the output of `tree handouts` into the release description.

*After teaching a lesson*: A lesson should be archived after any event in which it is presented&mdash;either in a workshop or à la carte setting. 

Archive the lesson html using the makefile. The archive is built (i.e. processed into HTML) page copied into `docs/_archive`. For example:

`make archive DATE="2020-07-21"` 

To manually archive an html, copy the html from  `_site`  into `_archive`. Add the following header to the html file:

```
---
---

```

The archive actually depends on two releases, and both must exist on GitHub:
- The lesson's repository needs a release corresponding to `tag`.
- The upstream `lesson-style` repository must have a release matching ~~the string
found in the `styleurl` value in~~ `docs/_archive.yml`.

When preparing the first release, be sure to include all data and worksheets in
a `handouts.zip` binary attachment and use the `tree` command to generate a
file tree of the zip's contents.

## Lesson Lifecycle

Lesson status should be categorized as Alpha, Beta, Stable, or Archived according to 
the [lifecycle definitions]. Assign these categories in 3 places: 

1. set variables in the lesson repository `docs/_data/lesson.yml`
1. copy a badge from below to top of lesson `readme.md`
1. add or move the lesson repository on the GitHub [curriculum] page.

These assignments are for internal tracking, but the `lesson.yml` will also 
modify the default lesson view to include the lifecycle badge and a note at 
the top of the page (if warning: true). 

Additionally, make sure to link/unpublish lessons as follows: 

* For beta and stable lessons, ensure lesson is linked from cyberhelp lessons 
page by adding a file in `lesson/_posts/`. 
* For archived lessons, turn off github pages in `-lesson` repository settings
and add to instructor notes (in lesson `readme.md`) "This lesson is archived" 
and either "and was replaced with the following lesson: ...", "Active lessons 
covering similar material include: ... ", or similar. 

**Alpha**  `[![lifecycle](https://img.shields.io/badge/lifecycle-alpha-pink.svg)](https://github.com/SESYNC-ci/sesync-ci.github.io/blob/master/lesson/lesson-lifecycle.md#alpha)`

**Beta** `[![lifecycle](https://img.shields.io/badge/lifecycle-beta-blue.svg)](https://github.com/SESYNC-ci/sesync-ci.github.io/blob/master/lesson/lesson-lifecycle.md#beta)`

**Stable** `[![lifecycle](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://github.com/SESYNC-ci/sesync-ci.github.io/blob/master/lesson/lesson-lifecycle.md#stable)`

**Archived** `[![lifecycle](https://img.shields.io/badge/lifecycle-archived-lightgrey.svg)](https://github.com/SESYNC-ci/sesync-ci.github.io/blob/master/lesson/lesson-lifecycle.md#archived)`


## Working Upstream

The repository `lesson-style` is intended to be upstream of all `*-lesson`
repositories, but configuration as such must be achieved in a local clone (i.e.
not on GitHub). This upstream remote will be configured on the first call to
`make upstream`. Modifications to the upstream branch shall be meant for all
lessons. A change to `docs/_layouts/default.html`, for example, should be
commited to the upstream branch and pushed to the master branch of the upstream
remote (i.e. to the `lesson-style` repository on GitHub):

```
git checkout upstream
git add docs/_layouts/default.html
git commit
git push upstream HEAD:master
```

Prefer to make changes directly to the `lesson-style`.

In some (older) lessons, `make upstream` may fail. To merge changes made within
the `lesson-style` repository into a lesson, run `git pull upstream master` from
the master branch. The `upstream` commits may not have a shared history with the
`master` branch; it is okay to merge using `--allow-unrelated-histories`.

## Permissions

Add repositories to the [Instructors team page] on GitHub with Write permission for
members of the Instructors team to push changes on lessons. 

[Reveal.js]: http://lab.hakim.se/reveal-js
[lessons]: http://www.sesync.org/for-you/cyberinfrastructure/training/%C3%A0-la-carte-lessons
[lifecycle definitions]: https://github.com/SESYNC-ci/sesync-ci.github.io/blob/master/lesson/lesson-lifecycle.md
[curriculum]: https://github.com/orgs/SESYNC-ci/projects/2
[Instructors team page]: https://github.com/orgs/SESYNC-ci/teams/instructors/repositories
