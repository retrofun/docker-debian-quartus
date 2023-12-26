# Docker Debian [Quartus 13.1](https://www.intel.com/content/www/us/en/software-kit/666220/intel-quartus-ii-web-edition-design-software-version-13-1-for-linux.html)

Since a recent update of libc6 in Debian 12 Bookworm (2.35 or some version earlier) Quartus' 13.1 _Analysis & Synthesis_ hangs in an endless loop in kernel function sched_yield().

As Quartus 13.1 runs fine on Debian 11 the scripts provided here create a Debian 11 [bullseye-slim](https://hub.docker.com/_/debian/tags?page=1&name=bullseye-slim) container image with a Quartus 13.1.4 installation for use on later Debian systems.

The scripts are based on the following helpful sources:

* [https://github.com/mist-devel/mist-board/tree/master/tools/docker-quartus](https://github.com/mist-devel/mist-board/tree/master/tools/docker-quartus)
* [https://github.com/halfmanhalftaco/fpga-docker](https://github.com/halfmanhalftaco/fpga-docker)
* [https://mattaw.blogspot.com/2014/05/making-modelsim-altera-starter-edition.html](https://mattaw.blogspot.com/2014/05/making-modelsim-altera-starter-edition.html)
* [https://profile.iiita.ac.in/bibhas.ghoshal/COA_2020/Lab/ModelSim%20Linux%20installation.html](https://profile.iiita.ac.in/bibhas.ghoshal/COA_2020/Lab/ModelSim%20Linux%20installation.html)

The container image is created with information from the user that runs the image build script (user name, user id, group id, language setting) and the system (timezone) so that a resulting container plugs in the host system as transparent as possible.

## Overview of files

* `addr_no_randomize.json`

  Adapted default seccomp Docker profile `default.json` with _personality(ADDR_NO_RANDOMIZE)_
  added based on the documentation at [https://hub.docker.com/r/benlubar/dwarffortress](https://hub.docker.com/r/benlubar/dwarffortress).
  _ADDR_NO_RANDOMIZE_ is required for Modelsim to run.

* `build_docker.sh`, `build_podman.sh`

  Shell script to build the Docker/Podman image. Required build parameters are determined from the current user
  (user name, user id, group id, language setting) and the system (timezone).

* `default.json`

  Default seccomp Docker profile from [https://github.com/moby/moby/blob/master/profiles/seccomp/default.json](https://github.com/moby/moby/blob/master/profiles/seccomp/default.json) as mentioned in the documentation
  [https://docs.docker.com/engine/security/seccomp/](https://docs.docker.com/engine/security/seccomp/).
  Provided as reference to compare against `addr_no_randomize.json`.

* `Dockerfile`

  Build file for container image based on Debian 11 bullseye-slim.

* `Dockerfile.buster`

  Build file for container image based on Debian 10 buster-slim. Initial development of the container image build
  scripts was done with Debian buster-slim image and then switched to Debian 11 bullseye-slim.

* `download.sh`

  Downloads all necessary files required to create the container image.

  * `Quartus-web-13.1.0.162-linux.tar`: Quartus II 13.1.0.162 installation archive.
  * `QuartusSetup-13.1.4.182.run`: Quartus II 13.1.4.182 update.
  * `libpng12-0_1.2.50-2+deb8u3_amd64.deb`: libpng 1.2.5, required for Quartus 64bit to run.
  * `libpng12-0_1.2.50-2+deb8u3_i386.deb`: libpng 1.2.5, required for Quartus 32bit to run.
  * `freetype-2.4.12.tar.gz`: freetype 2.4.12, required for ModelSim to run.

* `run_docker.sh`, `run_podman.sh`

  Shell script to run the Docker/Podman image. Without command argument it starts `/opt/quartus/quartus/bin/quartus --64bit`.
  To run a bash shell in the container: `./run_docker.sh /bin/bash`/`./run_podman.sh /bin/bash`.

## Create the container image

The initial image creation is a two step process:

1. Run script `download.sh`.
2. Run script `build_docker.sh`/`build_podman.sh`.

When all required files have been downloaded and are in place subsequent builds can be started by running `build_docker.sh`/`build_podman.sh` again.

The resulting container image is `debian:quartus131`.

NOTES:
* ModelSim AE is deleted (`/opt/quartus/modelsim_ae`) and ModelSim ASE is kept in the image to save some space. When you want to change this look for `modelsim_ae` and `modelsim_ase` in the Dockerfile and modify/change/remove the commands to your needs.
* The Quartus uninstall directory `/opt/quartus/uninstall` is deleted to save some space.

## Run the container image

Run script `run_docker.sh`/`run_podman.sh`.

### First run

Here are some things you may want to configure in Quartus when the container image `debian:quartus131` is run for the first time:

* Set correct path to ModelSim-Altera

  `Tools` -> `Options...` -> `General` -> `EDA Tool Options` -> `ModelSim-Altera`

  Change _Location of Executable_ from `/opt/quartus/modelsim_ase/linuxaloem` to `/opt/quartus/modelsim_ase/bin`.

* Enable TalkBack

  Required to unlock features like parallel processing on multiple CPU cores.

  `Tools` -> `Options` -> `General` -> `Internet Connectivity` -> `TalkBack Options...` -> `Enable sending TalkBack data to Altera`

### Overview of what run_docker.sh/run_podman.sh does

* seccomp security profile `addr_no_randomize.json` will be used. This is required to run ModelSim.
* X11 display is set up.
* USB device tree is mounted in the container to be able to access the USB Blaster programmer.

  USB Blaster udev rules must be installed on the host system (group plugdev):
  [https://gist.github.com/gmarkall/6f0a1c16476e8e0a9026](https://gist.github.com/gmarkall/6f0a1c16476e8e0a9026).
* The home directory of the user is mounted in the container for transparent access.
