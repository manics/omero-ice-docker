OMERO Ice Docker
================

[![Actions Status](https://github.com/manics/omero-ice-docker/workflows/Build/badge.svg)](https://github.com/manics/omero-ice-docker/actions)

A Ubuntu 22.04 Zeroc Ice 3.6 image.

Use this as a source for Zeroc Ice 3.6 when building OMERO.server or OMERO.web:

```Dockerfile
FROM ghcr.io/manics/omero-ice-docker:main AS ice-builder

FROM docker.io/library/ubuntu:22.04

COPY --from=ice-builder /opt/Ice-3.6.5/ /opt/Ice-3.6.5/
COPY --from=ice-builder /opt/setup/zeroc-ice-3.6.5/dist/zeroc_ice-3.6.5-cp310-cp310-linux_x86_64.whl /opt/omero/server/

RUN ln -s /opt/Ice-3.6.5/bin/* /usr/local/bin/ && \
    echo /opt/Ice-3.6.5/lib64 > /etc/ld.so.conf.d/ice-3.6.5.conf && \
    ldconfig

...

RUN pip install /opt/omero/server/zeroc_ice-3.6.5-cp310-cp310-linux_x86_64.whl ...

...
```
