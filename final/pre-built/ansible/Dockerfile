ARG DEBIAN_IMAGE_VERSION
ARG CI_REGISTRY_IMAGE

FROM ${CI_REGISTRY_IMAGE}/debian:$DEBIAN_IMAGE_VERSION

WORKDIR /root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
      git \
      wget \
      unzip \
      locales \
      openssh-client \
      ca-certificates \
      python3 \
      python3-pip \
      python3-virtualenv; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    localedef -f UTF-8 -i en_US en_US.UTF-8; \
    mkdir -m 0700 /root/.ssh

COPY ssh_config /root/.ssh/config
COPY requirements.yml requirements.txt /var/lib/
COPY ansible-lint.yml /etc/

ENV VIRTUAL_ENV=/srv/venv-ansible
RUN virtualenv $VIRTUAL_ENV
ENV PATH "$VIRTUAL_ENV/bin:$PATH"

ARG ANSIBLE_COLLECTIONS_TOKEN
ARG ANSIBLE_VERSION

RUN set -eux; \
    chmod -v 0600 /root/.ssh/config; \
    pip install --no-cache-dir --prefer-binary --progress-bar=off ansible-core==${ANSIBLE_VERSION}; \
    pip install --no-cache-dir --prefer-binary --progress-bar=off -r /var/lib/requirements.txt; \
    git config --global http.sslVerify false; \
    git config --global credential.helper \
      "!f() { sleep 1; echo 'username=${ANSIBLE_COLLECTIONS_TOKEN%%:*}'; echo 'password=${ANSIBLE_COLLECTIONS_TOKEN##*:}'; }; f"; \
    ansible-galaxy install -r /var/lib/requirements.yml;

# Инвалидация кеша (пересборка слоев)
ARG CACHE_BUSTER

RUN set -eux; \
    git clone https://baltig.ksb.local/iac/ansible.git; \
    mv ansible/roles/ .ansible/; \
    rm -rf ansible/
