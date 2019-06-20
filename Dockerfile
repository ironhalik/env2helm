FROM alpine:3.9

RUN apk add --no-cache curl ca-certificates python3 bash &&\
    pip3 --no-cache-dir install ruamel.yaml

ENV helm_version=v2.13.1
ENV helm_checksum=c1967c1dfcd6c921694b80ededdb9bd1beb27cb076864e58957b1568bc98925a

ENV kubectl_version=v1.13.4
ENV kubectl_checksum=92de2edbc8c21cfce6f70daa48e95560274a7413a51a6f8c348d974490fd1338

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

SHELL ["/bin/bash", "-c"]

CMD ["/bin/bash"]
