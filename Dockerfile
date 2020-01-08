FROM alpine:3.10

RUN apk add --no-cache curl ca-certificates python3 bash jq &&\
    pip3 --no-cache-dir install ruamel.yaml

ENV helm_version=v2.16.1
ENV helm_checksum=7eebaaa2da4734242bbcdced62cc32ba8c7164a18792c8acdf16c77abffce202

ENV kubectl_version=v1.17.0
ENV kubectl_checksum=6e0aaaffe5507a44ec6b1b8a0fb585285813b78cc045f8804e70a6aac9d1cb4c

RUN curl -s https://storage.googleapis.com/kubernetes-release/release/${kubectl_version}/bin/linux/amd64/kubectl > /tmp/kubectl &&\
    sha256sum /tmp/kubectl | grep -q ${kubectl_checksum} &&\
    chmod +x /tmp/kubectl &&\
    mv /tmp/kubectl /usr/local/bin/ &&\
    rm -rf /tmp/* &&\
    curl -s https://storage.googleapis.com/kubernetes-helm/helm-${helm_version}-linux-amd64.tar.gz > /tmp/helm.tar.gz &&\
    sha256sum /tmp/helm.tar.gz | grep -q ${helm_checksum} &&\
    tar xzf /tmp/helm.tar.gz -C /tmp/ &&\
    chmod +x /tmp/linux-amd64/helm &&\
    mv /tmp/linux-amd64/helm /usr/local/bin &&\
    rm -rf /tmp/*

COPY env2helm /usr/local/bin/
COPY kait-for-it /usr/local/bin/

SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash"]
