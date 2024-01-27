FROM python:slim-bookworm as builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
        curl \
        apt-utils \
        gcc \
        g++ \
        build-essential libssl-dev libffi-dev \
        git swig libpulse-dev libasound2-dev  \
        libsphinxbase3 libsphinxbase-dev \
        libpocketsphinx-dev libavdevice-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 user && useradd --uid 1000 --gid 1000 -m user
USER user

WORKDIR /app

RUN curl -sL https://github.com/sc0ty/subsync/archive/refs/heads/master.tar.gz -o source.tar.gz && \
    tar zxvf source.tar.gz --strip-components 1 && \
    rm source.tar.gz && \
    cp subsync/config.py.template subsync/config.py

RUN pip install ./

ENTRYPOINT ["/app/bin/subsync"]