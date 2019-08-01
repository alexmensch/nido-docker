*This respository is used to build the base Docker images for the Nido smart thermostat. The images are hosted at [alexmensch/nido](https://hub.docker.com/r/alexmensch/nido) on Docker Hub and are [built automatically](https://hub.docker.com/r/alexmensch/nido/builds) from this repository. If you're looking for instructions on how to run Nido on a Raspberry Pi, see <https://github.com/alexmensch/nido> for instructions and the full project background.*

## Quickstart
```bash
docker pull alexmensch/nido:latest
```

## Automatic Docker Hub builds for ARM architecture
Docker Hub will build automatically from the Dockerfile in this repository, however, we need the image to be built for the ARM processor architecture in order for it to be compatible with the Raspberry Pi.

If building the image locally on a machine that already includes hooks to user-mode emulation for binaries via [QEMU](https://www.qemu.org), eg. on OS X, the machine code translation is taken care of, and the [base arm32v6 Docker image](https://hub.docker.com/u/arm32v6) will work automagically.

However, Docker Hub auto builds run on Ubuntu without the needed emulation, and the build process will fail without going through some extra steps. A more detailed discussion can be found in [this issue thread](https://github.com/docker/hub-feedback/issues/1261), but in summary:
1. The auto build process looks for a `hooks/` folder in the repository.
2. The commands in `post_checkout` are run on the build machine. In this case, we download the QEMU static binaries, which will later be referenced in the Dockerfile.
3. The commands in `pre_build` are executed next. We register the QEMU emulators here. (On a side note, if anyone understands how [the magic](https://github.com/multiarch/qemu-user-static) in this register command works, please [contact me](mailto:amars@alumni.stanford.edu), as I've been unable to find a clear explanation anywhere, and I'd love to document it.)
4. The Dockerfile copies the local ARM binary emulator we need, `qemu-arm-static`, into the image build.

## Manually building the Docker image
The `build.sh` script includes a line to create an empty `qemu-arm-static` file so that we can use the same Dockerfile. This has no effect on the local build process.

**Note:** If your local system does not already include hooks for binary emulation, you will run into problems building this image. This has only been tested on Mac OS X.
