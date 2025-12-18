# Minor tweaks to the base galaxy image(s)
# Installs docker.io and missing dependencies via uv.

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

# Pin existing requirements
RUN uv add --frozen -r requirements.txt && uv sync

# Install from lockfile
ARG GALAXY_VERSION
RUN if [ "${GALAXY_VERSION}" = "25.0.2" ] ; then \
        uv add boto3 psycopg2-binary watchdog; \
        uv sync; \
    # elif [ "${GALAXY_VERSION}" = "25.1.0" ] ; then \
    #  ...
    else \
        echo "Unknown GALAXY_VERSION ${GALAXY_VERSION}" ; \
        exit 1 ; \
    fi
