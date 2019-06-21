FROM alpine:3.9

RUN apk add --no-cache curl ca-certificates python3 bash &&\
    pip3 --no-cache-dir install ruamel.yaml

ENV helm_version=v2.14.1
ENV helm_checksum=804f745e6884435ef1343f4de8940f9db64f935cd9a55ad3d9153d064b7f5896

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
