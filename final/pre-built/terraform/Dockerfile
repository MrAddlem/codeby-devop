ARG DEBIAN_IMAGE_VERSION
ARG CI_REGISTRY_IMAGE

FROM ${CI_REGISTRY_IMAGE}/debian:$DEBIAN_IMAGE_VERSION

WORKDIR /root/terraform

ARG TERRAFORM_VERSION
# hadolint ignore=DL3008
RUN set -eux; \
    apt-get update && apt-get install -y --no-install-recommends \
      jq \
      unzip \
      locales \
      wget \
      iputils-ping \
      ca-certificates; \
    apt-get clean && rm -rf /var/lib/apt/lists/*; \
    wget --progress=dot:giga "https://hashicorp-releases.yandexcloud.net/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"; \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/; \
    localedef -f UTF-8 -i en_US en_US.UTF-8; \
    chmod +x /usr/local/bin/terraform; \
    rm "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

COPY baltig.ksb.local.crt /etc/ssl/certs/
COPY .terraformrc /root
