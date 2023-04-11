# slsa.dev sources

This directory contains sources for [https://slsa.dev](https://slsa.dev), served
via GitHub pages and rendered with Jekyll.

## Developing and testing locally

1.  Install ruby, bundler, and the dev headers:

    ```bash
    apt install ruby ruby-dev bundler
    ```

    Alternatively, you can use `rbenv` to use the exact version of Ruby used by
    GitHub Pages, but Debian's versions are likely close enough.

2.  Clone this repo and change directory to `/docs`:

    ```bash
    git clone https://github.com/slsa-framework/slsa
    cd slsa/docs
    ```

3.  Install the dependencies locally:

    ```bash
    bundle config set --local path 'vendor/bundle'
    bundle install
    ```

4.  (optional) To enable `jekyll-github-metadata` to read metadata about the
    slsa repository from the GitHub API, create a GitHub
    [personal access token](https://github.com/settings/tokens/new) and add it
    to your `~/.netrc`, like so:

    ```none
    machine api.github.com
        login github-username
        password 123abc-your-token
    ```

5.  Run the project locally with `jekyll serve`:

    ```bash
    bundle exec jekyll serve --livereload --incremental
    ```

    The options can be omitted if preferred. `--livereload` causes the website
    to autorefresh after every build. `--incremental` results in faster
    incremental builds at the cost of possibly missing some changes.

6.  Browse to http://localhost:4000 to view the site locally.

## Deployment

Pushing to `main` will trigger a deployment of GitHub Pages.
