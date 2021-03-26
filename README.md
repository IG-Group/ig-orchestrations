# This repo has moved

This repo has moved to [github](https://github.com/IG-Group/ig-orchestrations)

When you commit to the master branch there it will be released to maven central.

Development still happens in this repo in order to:
  - Have consistent PR experience, using the same tooling as for any other repo of the team.
  - Force IG's SCM to be in the loop, so that in the unlikely event that github becomes unavailable no source code is lost.

see https://wiki.iggroup.local/display/FIXAPI/IG+US+Fix+Orchestrations

# Work flow
Make a new branch from github-staging. After your work is complete raise a PR against github-staging.
Once merged push to github.

# local branch structure (bit-bucket)
## master
Aka (bitbucket:IG Public FIX API/ig-orchestrations/master)

Empty apart from this README.md explaining that you have to use github.

## github-staging

Aka (bitbucket:IG Public FIX API/ig-orchestrations/github-staging)

A [Bamboo](https://bamboo5.iggroup.local/browse/PFA-IOMG) build pulls changes once a day github --ff-only and is used as an onsite backup of github.

We merge changes there and then push to github via a [Bamboo build](https://bamboo5.iggroup.local/browse/PFA-IOPTG).
