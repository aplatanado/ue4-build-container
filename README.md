# ue4-build-container

Build Unreal Engine 4 on Linux in a container, as is described by
[Unreal Engine 4 documentation](https://wiki.unrealengine.com/Building_On_Linux).

## Requirements

Mainly, you need [Podman](https://podman.io). The build script `build.sh` is
easily modifiable to use docker. But I prefer Podman because it not needs a
daemon and allows to mount volumes in build time.

## Build a virtual machine

To build Unreal Engine just run:

    $ ./build.sh

from the directory of this repository, where is the Dockerfile.

# Copyright and license

Copyright (c) 2019, Jesús Torres &lt;<jmtorres@ull.es>&gt;. This work is
licensed under a [Creative Commons Public Domain Dedication 1.0 License](https://creativecommons.org/publicdomain/zero/1.0/).
