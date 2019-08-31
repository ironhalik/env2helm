FROM alpine:3.10

RUN apk add --no-cache curl ca-certificates python3 bash jq &&\
    pip3 --no-cache-dir install ruamel.yaml

ENV helm_version=v2.14.3
ENV helm_checksum=38614a665859c0f01c9c1d84fa9a5027364f936814d1e47839b05327e400bf55

ENV kubectl_version=v1.15.3
ENV kubectl_checksum=6e805054a1fb2280abb53f75b57a1b92bf9c66ffe0d2cdcd46e81b079d93c322

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
