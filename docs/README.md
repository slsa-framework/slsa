# slsa.dev sources

This directory contains sources for [https://slsa.dev](https://slsa.dev), served
via GitHub pages and rendered with Jekyll.

## Developing and testing locally

1.  Install ruby, bundler, and the dev headers:

    ```bash
    apt install ruby bundler ruby-dev bundler
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

4.  (optional) Create a GitHub
    [personal access token](https://github.com/settings/tokens/new) and add it
    to your `~/.netrc`, like so:

    ```none
    machine api.github.com
        login github-username
        password 123abc-your-token
    ```

5.  Run the project locally with `jekyll serve` (optionally appending
    `--livereload`):

    ```bash
    bundle exec jekyll serve
    ```

6.  Browse to http://localhost:4000 to view the site locally.

## Deployment

Pushing to `main` will trigger a deployment of GitHub Pages.
