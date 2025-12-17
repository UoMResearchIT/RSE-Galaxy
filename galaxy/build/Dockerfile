# Take (optinally specified) galaxy image as base
ARG GALAXY_VERSION=latest # WARNING: 'latest' is very old - you probably want to specify a tag
FROM galaxy/galaxy-min:${GALAXY_VERSION}

# Install docker dependancy (for docker-in-docker)
USER root
RUN apt update && apt -y install docker.io

# Set up UV for python package management
USER galaxy
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV HOME=/tmp
ENV UV_CACHE=/tmp/uv_cache

# Add the TUSD binary
COPY tusd /usr/local/sbin/tusd

# Install from lockfile
ARG GALAXY_VERSION
COPY build/uv.lock.* /tmp/
RUN if [ -f /tmp/uv.lock.${GALAXY_VERSION} ]; \
    then \
      cp /tmp/uv.lock.${GALAXY_VERSION} uv.lock ; \
      uv sync --frozen ; \
    else \
      echo "No uv.lock file found for GALAXY_VERSION=${GALAXY_VERSION}!" ; \
      echo "Generate one manually and commit as ./galaxy/build/uv.lock.${GALAXY_VERSION}" ; \
      exit 1 ; \

    fi
