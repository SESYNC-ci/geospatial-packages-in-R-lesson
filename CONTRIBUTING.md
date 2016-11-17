# Guide to `sesync-ci/*-lesson` Repositories

The lessons held in individual repositories within the SESYNC-CI organization nonetheless share common files. The tree shown below reflects all files that should **only** be modified in the `lesson-style` repository and subsequently merged into each lesson.

```
├── CONTRIBUTING.md
├── Makefile
├── README.md **
└── docs
    ├── _config.yml **
    ├── _includes
        ├── head.html
    ├── _layouts
    │   ├── default.html
    │   └── slideshow.html
    ├── class
    │   └── index.md
    ├── css
    │   ├── lesson.css
    │   └── slideshow.css
    ├── index.md
    └── instructor
        └── index.md
```

## Upstream

The repository `lesson-style` is intended to be upstream of all `*-lesson` repositories, but that configuration must be achieved locally. Configure a local clone as follows:

```
git remote add upstream git@github.com:SESYNC-ci/lesson-stylesheets.git
git fetch upstream
get checkout -b upstream upstream/master
```

The `upstream` branch will not have a shared history with the `master` branch--that is okay. To merge changes made within the `lesson-style` repository into a lesson, run `git merge upstream` from the master branch.
