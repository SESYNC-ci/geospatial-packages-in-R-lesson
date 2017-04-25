# Guide to `sesync-ci/*-lesson` Repositories

The lessons held in individual repositories within the SESYNC-CI organization nonetheless share common files. The tree shown below reflects all files that should **only** be modified in the `lesson-style` repository and subsequently merged into each lesson.

```
lesson-style.git
├── CONTRIBUTING.md
├── Makefile
├── README.md **
└── docs
    ├── _config.yml **
    ├── _includes
        ├── head.html
    ├── _layouts
    │   ├── default.html
    │   └── slideshow.html
    ├── class
    │   └── index.md
    ├── css
    │   ├── lesson.css
    │   └── slideshow.css
    ├── index.md
    └── instructor
        └── index.md
```

The content of individual lessons shall be located within the `_slides` collection. The skeleton of a brand new lesson repository might be:

```
*-lesson.git
├── worksheet.R
├── handouts.Rproj
├── data
└── docs
    ├── _posts
    ├── _slides
    ├── _slides_Rmd
    └── images
```

For a lesson written in RMarkdown, the .Rmd files reside in `docs/_slides_Rmd` and only knitted slides go in `docs/_slides`. Likewise, slides to be processed by Pweave go in `docs/_slides_pmd`. Data read by any .Rmd/.pmd file or by any worksheets (e.g. `worksheet.R`) goes in the `data` folder, which will be distributed as a handout to participants. Figures produced during build and external images go in `docs/images`, and archived versions of the slides go in `docs/_posts`. Creating an .Rproj to include in the distributed handouts makes it convenient to start an R session with the appropriate working directory. The Makefile currently does not but will handle all conversions to kramdown and place slide decks in the `docs/_slides` collection.

## Upstream

The repository `lesson-style` is intended to be upstream of all `*-lesson` repositories, but configuration as such must be achieved locally. Configure a local clone as follows:

```
git remote add upstream git@github.com:SESYNC-ci/lesson-style.git
git fetch upstream
git branch --track upstream upstream/master
```

The `upstream` branch will not have a shared history with the `master` branch—that is okay. To merge changes made within the `lesson-style` repository into a lesson, run `git merge upstream` from the master branch. Modifications to the upstream branch shall be meant for all lessons. A change to `docs/_layouts/default.html`, for example, should be commited to the upstream branch and pushed to the origin:

```
git checkout upstream
git add docs/_layouts/default.html
git commit
git push
```

## Creating a **new** lesson

Create a new, public repository owned by the SESYNC-CI organization: use a short name, provide a description that can be exported as a human readable lesson title (e.g. on SESYNC's [lessons] tab), and do not include a README.

Locally clone the new empty repository and initialize it with the content of the lesson-style repo:

```
git remote add upstream git@github.com:SESYNC-ci/lesson-style.git
git fetch upstream
git branch --track upstream upstream/master
git merge upstream
git push
```

Go to the repository's GitHub settings and select 'master/docs' as the GitHub Pages source. Configure the README by commiting the following to the `README.md` file, where `<new-lesson>` should be replaced with the new repository's name.

```
[lesson]: https://sesync-ci.github.io/<new-lesson>
[slideshow]: https://sesync-ci.github.io/<new-lesson>/instructor
```

Everythin above is standard, the following is where the real work begins! Configure the GitHub page by setting the following variables in the `# Site` section of the `docs/_config.yml` YAML file.

- `title`: a lesson title
- `worksheet`: the base string displayed for `code.text-document` titles
- `handouts`: the release version associated with the `handouts.zip` attached to a release, if any
- `instructor`: who will give the lesson in a workshop setting
- `authors`: the list of contributors
- `lesson`: the number of the lesson in a workshop setting

Always create the `docs/_slides` folder, but develop content within one of the following folders as appropriate:

- `docs/_slides` for markdown (.md)
- `docs/_slides_Rmd` for RMarkdown (.Rmd)
- `docs/_slides_pmd` for Pweave (.pmd)

A file within one of these folders becomes a vertical stack of slides in a [Reveal.js] presentation: use "===" on it's own line to indicate a slide break. Vertical stacks on concatenated horizontally in the order supplied by the `slide_sorter` variable in `docs/_config.yml`.

## Archiving a delivered lesson

[Reveal.js]: http://lab.hakim.se/reveal-js
[lessons]: http://www.sesync.org/for-you/cyberinfrastructure/training/%C3%A0-la-carte-lessons
