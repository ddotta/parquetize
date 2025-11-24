# Contributing to parquetize development

The goal of this guide is to help you get up and contributing to
`parquetize` as quickly as possible. The guide is divided into two main
pieces:

1.  Filing a bug report or feature request in an issue.
2.  Suggesting a change via a pull request.

## Issues

When filing an issue, the most important thing is to include a minimal
reproducible example so that I can quickly verify the problem, and then
figure out how to fix it. There are three things you need to include to
make your example reproducible: required packages, data, code.

1.  **Packages** should be loaded at the top of the script, so it’s easy
    to see which ones the example needs.

2.  The easiest way to include **data** is to use
    [`dput()`](https://rdrr.io/r/base/dput.html) to generate the R code
    to recreate it. For example, to recreate the `mtcars` dataset in R,
    I’d perform the following steps:

    1.  Run `dput(mtcars)` in R
    2.  Copy the output
    3.  In my reproducible script, type `mtcars <-` then paste.

    But even better is if you can create a
    [`data.frame()`](https://rdrr.io/r/base/data.frame.html) with just a
    handful of rows and columns that still illustrates the problem.

3.  Spend a little bit of time ensuring that your **code** is easy for
    others to read:

    - make sure you’ve used spaces and your variable names are concise,
      but informative

    - use comments to indicate where your problem lies

    - do your best to remove everything that is not related to the
      problem.  
      The shorter your code is, the easier it is to understand.

You can check you have actually made a reproducible example by starting
up a fresh R session and pasting your script in.

(Unless you’ve been specifically asked for it, please don’t include the
output of [`sessionInfo()`](https://rdrr.io/r/utils/sessionInfo.html).)

## Pull requests

To contribute a change to `parquetize`, you follow these steps:

1.  Create a branch in git and make your changes.
2.  Push branch to github and issue pull request (PR).
3.  Discuss the pull request.
4.  Iterate until either I accept the PR or decide that it’s not a good
    fit for `parquetize`.

Each of these steps are described in more detail below. This might feel
overwhelming the first time you get set up, but it gets easier with
practice.

If you’re not familiar with git or github, please start by reading
[http://r-pkgs.had.co.nz/git.html](http://r-pkgs.had.co.nz/git.md)

Pull requests will be evaluated against a seven point checklist:

1.  **Motivation**. Your pull request should clearly and concisely
    motivate the need for change.

    Also include this motivation in `NEWS` so that when a new release of
    parquetize comes out it’s easy for users to see what’s changed. Add
    your item at the top of the file and use markdown for formatting.
    The news item should end with
    `(@yourGithubUsername, #the_issue_number)`.

2.  **Only related changes**. Before you submit your pull request,
    please check to make sure that you haven’t accidentally included any
    unrelated changes. These make it harder to see exactly what’s
    changed, and to evaluate any unexpected side effects.

    Each PR corresponds to a git branch, so if you expect to submit
    multiple changes make sure to create multiple branches. If you have
    multiple changes that depend on each other, start with the first one
    and don’t submit any others until the first one has been processed.

3.  If you’re adding new parameters or a new function, you’ll also need
    to document them with
    [roxygen](https://github.com/klutometis/roxygen). Make sure to
    re-run `devtools::document()` on the code before submitting.

4.  If fixing a bug or adding a new feature, please add a
    [testthat](https://github.com/r-lib/testthat) unit test.

This seems like a lot of work but don’t worry if your pull request isn’t
perfect. A pull request (“PR”) is a process, and unless you’ve submitted
a few in the past it’s unlikely that your pull request will be accepted
as is.

Many thanks in advance !
