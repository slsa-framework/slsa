# slsa.dev sources

This directory contains sources for https://slsa.dev, served via GitHub pages
and rendered with Jekyll.

## Testing locally

Use [github/pages-gem](https://github.com/github/pages-gem) to spawn a local web
server. We recommend the "Docker" method as follows:

1.  Install Docker.

2.  Clone and build the Docker image.

    ```bash
    git clone https://github.com/github/pages-gem
    cd pages-gem
    make image
    ```

3.  Run the server from the pages-gem directory, where `PATH_TO_SLSA_REPO` is
    the path to this repo.

    ```bash
    SITE=PATH_TO_SLSA_REPO/docs make server
    ```

4.  Browse to http://localhost:4000.
