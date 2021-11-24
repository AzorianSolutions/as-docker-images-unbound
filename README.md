# Unbound Resolver packaged by [Azorian Solutions](https://azorian.solutions)

The Unbound Resolver is a validating, recursive, caching DNS resolver. It is designed to be fast and lean and incorporates modern features based on open standards.

[Unbound Resolver Website](https://www.nlnetlabs.nl/projects/unbound/)

[Unbound Resolver Documentation](https://www.nlnetlabs.nl/documentation/unbound/)

## Quick reference

- **Maintained by:** [Matt Scott](https://github.com/AzorianSolutions)
- **Github:** [https://github.com/AzorianSolutions/docker-unbound-resolver](https://github.com/AzorianSolutions/docker-unbound-resolver)
- **Website:** [https://azorian.solutions](https://azorian.solutions)

## TL;DR

    docker run -d -p 12053:53/udp -p 12053:53 azoriansolutions/unbound-resolver

## Azorian Solutions Docker image strategy

The goal of creating this image and others alike is to provide a fairly uniform and turn-key implementation for a chosen set of products and solutions. By compiling the server binaries from source code, a greater chain of security is maintained by eliminating unnecessary trusts. This approach also helps assure support of specific features that may otherwise vary from distribution to distribution. A secondary goal of creating this image and others alike is to provide at least two Linux distribution options for any supported product or solution which is why you will often see tags for both Alpine Linux and Debian Linux.

All documentation will be written with the assumption that you are already reasonably familiar with this ecosystem. This includes container concepts, the Docker ecosystem, and more specifically the product or solution that you are deploying. Simply put, I won't be fluffing the docs with content explaining every detail of what is presented.

## Supported tags

### Alpine Linux

- 1.13.2, 1.13.2-alpine, 1.13.2-alpine-3.14, alpine, latest

### Debian Linux

- 1.13.2-debian, 1.13.2-debian-11.1-slim, debian

## Deploying this image

### Server configuration

Configuration of the Unbound resolver may be achieved through the traditional configuration file approach.

With this approach, you may create a traditional Unbound resolver conf file and map it to the "/etc/unbound/unbound.conf" location inside of the container. For example, say you have an Unbound resolver conf file located on your container host at "/srv/unbound-resolver.conf" then the proper mapping would be as follows;

    /srv/unbound-resolver.conf:/etc/unbound/unbound.conf

### Deploy with Docker Run

To run a simple container on Docker with this image, execute the following Docker command;

    docker run -d -p 12053:53/udp -p 12053:53 azoriansolutions/unbound-resolver

If all goes well and the container starts, you should now be able to query this DNS recursor using dig;

    dig -p 12053 @IP-OR-HOSTNAME-OF-DOCKER-HOST a docker.com

### Deploy with Docker Compose

To run this image using Docker Compose, create a YAML file with a name and place of your choosing and add the following contents to it;

    version: "3.3"
    services:
      recursor:
        image: azoriansolutions/unbound-resolver
        restart: unless-stopped
        ports:
          - "12053:53/udp"
          - "12053:53"
        volumes:
          - "/path/to/unbound/conf/file.conf:/etc/unbound/unbound.conf"

Then execute the following Docker Compose command;

    docker-compose -u /path/to/yaml/file.yml

## Building this image

If you want to build this image yourself, you can easily do so using the **build-release** command I have included.

The build-release command has the following parameter format;

    build-release IMAGE_TAG_NAME UNBOUND_VERSION DISTRO_REPO_NAME DISTRO_TAG

So for example, to build the Unbound resolver version 1.13.1 on Alpine Linux 3.14, you would execute the following shell command:

    build-release 1.13.1-alpine-3.14 1.13.1 alpine 3.14

The build-realease command assumes the following parameter defaults;

- Image Tag Name: latest
- Unbound Version: 1.13.2
- Distro Name: alpine
- Distro Tag: 3.14

This means that running the build-release command with no parameters would be the equivalent of executing the following shell command:

    build-release latest 1.13.2 alpine 3.14

When the image is tagged during compilation, the repository portion of the image tag is derived from the contents of the .as/docker-registry file and the tag from the first parameter provided to the build-release command.

