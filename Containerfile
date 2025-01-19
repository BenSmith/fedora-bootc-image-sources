FROM quay.io/fedora/fedora:41 as builder
RUN dnf -y install rpm-ostree selinux-policy-targeted
ARG MANIFEST=fedora-bootc.yaml
COPY . /src
WORKDIR /src
RUN rm -vf /src/*.repo && cp /etc/yum.repos.d/*.repo ./

RUN --mount=type=cache,target=/workdir \
    --mount=type=bind,rw=true,src=.,dst=/buildcontext,bind-propagation=shared \
    rpm-ostree compose image \
        --cachedir=/workdir \
        --format=ociarchive \
        --image-config fedora-bootc-config.json \
        --initialize \
        ${MANIFEST} \
        --source-root=/ \
        /buildcontext/out.ociarchive

FROM oci-archive:./out.ociarchive
# Need to reference builder here to force ordering. But since we have to run
# something anyway, we might as well cleanup after ourselves.
RUN --mount=type=bind,from=builder,src=.,target=/var/tmp \
    --mount=type=bind,rw=true,src=.,dst=/buildcontext,bind-propagation=shared \
      rm /buildcontext/out.ociarchive
