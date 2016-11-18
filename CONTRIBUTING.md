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

## Archiving a delivered lesson

