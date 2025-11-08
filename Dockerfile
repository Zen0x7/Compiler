FROM debian:latest

ARG BOOST_VERSION="1.89.0"
ARG BOOST_VARIANT="release"

ENV TZ="UTC" \
    DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    BOOST_ROOT="/srv/boost"

WORKDIR /srv

COPY scripts/install_dependencies.sh install_dependencies.sh
COPY scripts/install_boost.sh install_boost.sh

RUN bash install_dependencies.sh \
    && bash install_boost.sh