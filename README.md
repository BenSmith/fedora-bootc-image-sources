# Fedora bootc base images

Create and maintain base *bootable* container images from Fedora packages.

## Motivation

The original Docker container model of using "layers" to model applications has
been extremely successful. This project aims to apply the same technique for
bootable host systems - using standard OCI/Docker containers as a transport and
delivery format for base operating system updates.

## Building images

The current default user experience is to build *layered* images on top of the official
binary base images produced and tested by this project. See the documentation[5] for more info.

You can build custom base images by forking this repository; however,
https://gitlab.com/fedora/bootc/tracker/-/issues/32 tracks a more supportable
mechanism that is not simply forking. For more information see[6].

## Build process

Building the images in this repo can be done with `podman build`, but
note the build process uses a special podman-ecosystem specific mechanism
to create fully custom images while inside a `Containerfile`.
You need to enable some privileges as nested containerization is required.

```
podman build --security-opt=label=disable --cap-add=all \
  --device /dev/fuse -t localhost/fedora-bootc .
```

See the `Containerfile` for more details. This builds the default `tier-1` image.

## Fedora versions

By default, the base images are built for Fedora rawhide. To build against a
different Fedora version, you can override the `FROM` image used to obtain the
Fedora repos and dnf variables. E.g.:

```
podman build --from quay.io/fedora/fedora:41 ...
```

### Deriving

You are of course also free to fork, customize, and build base images yourself.
See this page[6] of the documentation for more information.

## Tiers

At the current time, there is just one reference base image published
to the registry. Internally the content set is split up somewhat
into "tiers", but this is an internal implementation detail and may change
at any time.

It is planned to rework and improve this in the future, especially
to support smaller custom images. For more on this, see
[this tracker issue](https://gitlab.com/fedora/bootc/tracker/-/issues/32).

- **tier-1**: This image is the default, what is published as
  https://quay.io/repository/fedora/fedora-bootc
- **tier-0**: This content set is more of a convenient centralization point for CI
  and curation around a package set that we can all agree is the rough minimum
  necessary for a usable system. It's not meant to be used as is, but layered
  upon.
- **tier-x**: This content set is the shared base used by all image-based
  Fedora variants (IoT, Atomic Desktops, and CoreOS).
  Changes to this tier may be done without accounting for external users.
  To build this, pass `--build-arg=MANIFEST=fedora-tier-x.yaml` to the build
  command above.

**tier-1** inherits from **tier-x** and **tier-x** in turn inherit from **tier-0**.

All non-trivial changes to **tier-0** and **tier-x** should be ACKed by at least
one stakeholder of each Fedora variant WGs.

## More information

Documentation: <https://docs.fedoraproject.org/en-US/bootc/>

## Badges

| Badge                   | Description          | Service      |
| ----------------------- | -------------------- | ------------ |
| [![Renovate][1]][2]     | Dependencies         | Renovate     |
| [![Pre-commit][3]][4]   | Static quality gates | pre-commit   |

[1]: https://img.shields.io/badge/renovate-enabled-brightgreen?logo=renovate
[2]: https://renovatebot.com
[3]: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit
[4]: https://pre-commit.com/
[5]: https://docs.fedoraproject.org/en-US/bootc/building-containers/
[6]: https://docs.fedoraproject.org/en-US/bootc/building-custom-base/
