# docker-image-base

This is an Ubuntu-based Docker image specification (Dockerfile), intended to be used as a base for other images. It doesn't (and shouldn't) do much, but it sets up/installs the following things:

- Timezone (via the build arg `TIMEZONE`): Setting the timezone in the base image provides consistency in things like log timestamps for descendant images.
- Apt cache/proxy (via the build arg `APT_PROXY`): If you use an apt cache of some sort (whether `apt-cacher`, `apt-cacher-ng` or `deb-squid-proxy`, as examples), this allows it to be set once and implicitly used by all descendant images.
- A base set of apt repositories for the release specified via the build arg `RELEASE`.
- The `apt-transport-https` package to allow use of HTTPS-based repos.
- The `curl` and `wget` packages to allow retrieval of miscellaneous resources.
- The `gosu` tool to allow images to cleanly run applications as non-root users.
