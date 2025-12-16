# Minor tweaks to the base galaxy image(s)
# Will try to restore an existing uv.lock.<GALAXY_VERSION> file, if present.
# Otherwise it will install missing 'boto3' pinning 'fastapi-slim'
# (See: https://github.com/UoMResearchIT/Airbus-Wing-of-the-Future/issues/29)
# Once built and tested, the new uv.lock file can be committed to the repo.

ARG GALAXY_VERSION=latest
FROM galaxy/galaxy-min:${GALAXY_VERSION}
USER root
RUN apt update && apt -y install docker.io
USER galaxy
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
ENV HOME=/tmp
ENV UV_CACHE=/tmp/uv_cache

# Can help resolve dependency conflicts
ARG PIN_PYTHON=0
RUN if [ "${PIN_PYTHON}" -eq "1" ]; then \
        THIS_PYTHON=$(python --version | cut -d' ' -f2) ; \
        sed -i.bak "s/requires-python = .*/requires-python = \"~=${THIS_PYTHON}\"/" pyproject.toml ; \
    fi

ARG GALAXY_VERSION
COPY uv.lock.* /tmp/
RUN if [ -f /tmp/uv.lock.${GALAXY_VERSION} ]; then \
        cp /tmp/uv.lock.${GALAXY_VERSION} uv.lock && uv sync --frozen ; \
        [ -z $(diff uv.lock /tmp/uv.lock.${GALAXY_VERSION}) ] || exit 1; \
    else \
        echo "No uv.lock file found for GALAXY_VERSION=${GALAXY_VERSION}!" \
             "Generate one manually and commit as ./galaxy/build/uv.lock.${GALAXY_VERSION}" ; \
    fi
