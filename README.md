# This repo has moved

This repo has moved to [github](https://github.com/IG-Group/ig-orchestrations)

When you commit to the master branch there it will be released to maven central.

Development still happens in this repo, in order to have consistent PR experience. See branch structure below.

# Work flow
Make a new branch from github-staging. After your work is complete raise a PR against github-staging.
Once merged push to github (TODO: bamboo build to push).

# local branch structure (bit-bucket)
## master
Aka (bitbucket:IG Public FIX API/ig-orchestrations/master)

Empty with README.md explaining that you have to use github

## github-staging

Aka (bitbucket:IG Public FIX API/ig-orchestrations/github-staging)

A [Bamboo](https://bamboo5.iggroup.local/browse/PFA-IOMG) build pulls changes once a day github --ff-only and is used as an onsite backup of github.

We merge changes there and then push to github via a [Bamboo build](https://bamboo5.iggroup.local/browse/PFA-IOPTG).

This is done so that we can use familiar change process tools for this project.
