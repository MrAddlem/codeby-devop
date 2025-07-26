ARG DEBIAN_IMAGE_VERSION
ARG CI_REGISTRY_IMAGE

FROM ${CI_REGISTRY_IMAGE}/debian:$DEBIAN_IMAGE_VERSION

WORKDIR /root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY yamllint.yml /etc/
COPY requirements.txt /var/lib/

# hadolint ignore=DL3008,DL4006
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
      curl \
      unzip \
      locales \
      ca-certificates \
      python3 \
      python3-pip \
      python3-virtualenv; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    localedef -f UTF-8 -i en_US en_US.UTF-8

ENV VIRTUAL_ENV=/srv/venv-ansible
RUN virtualenv $VIRTUAL_ENV
ENV PATH "$VIRTUAL_ENV/bin:$PATH"

RUN pip install --no-cache-dir --prefer-binary --progress-bar=off -r /var/lib/requirements.txt; \
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash -o pipefail
