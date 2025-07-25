ARG DEBIAN_IMAGE_VERSION
ARG CI_REGISTRY_IMAGE

FROM ${CI_REGISTRY_IMAGE}/debian:${DEBIAN_IMAGE_VERSION}

WORKDIR /root/packer
COPY packer/plugins.pkr.hcl plugins.pkr.hcl
COPY entrypoint.sh entrypoint.sh

ARG PACKER_VERSION
# hadolint ignore=DL3008
RUN set -eux; \
    chmod +x /root/packer/entrypoint.sh; \
    apt-get update && apt-get install -y --no-install-recommends \
      jq \
      unzip \
      locales \
      wget \
      iputils-ping \
      ca-certificates; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    wget --progress=dot:giga "https://hashicorp-releases.yandexcloud.net/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"; \
    unzip "packer_${PACKER_VERSION}_linux_amd64.zip" -d /usr/local/bin/; \
    localedef -f UTF-8 -i en_US en_US.UTF-8; \
    rm "packer_${PACKER_VERSION}_linux_amd64.zip"; \
    packer init plugins.pkr.hcl

ENTRYPOINT ["/root/packer/entrypoint.sh"]
