<!--
Keywords:
build, build-process, check, continuous-delivery, continuous-deployment,
continuous-integration, docker, documentation, embedded, embedded-systems,
product-assurance, quality-assurance, quality-metrics, quality, scripting,
test, testing, toochain
-->

# C-Tools (Docker) - Simple C language tools collection

This set of Dockerfiles provides a simple

*collection of useful C language tools shipped as Docker images*

based on Alpine Linux with UID/GID handling to support software development,
deployment and continuous integration, tailored to the C programming language
in a GNU/Linux environment.

The collection comprises:

* Build
    * GCC - Compile C language code with GCC
    * GCC-AVR - Compile C language code with GCC for AVR targets
* Check
    * CLOC - Count lines of code with CLOC
    * Cppcheck - Analyze code statically with Cppcheck
    * Lizard - Analyze code complexity with Lizard
* Doc
    * Doxygen - Generate documentation from source code with Doxygen
    * Pandoc - Convert documentation markup formats with Pandoc
    * UMLet - Convert UMLet UML diagrams into common digital image formats
* Generic: Python - Execute arbitrary genral purpose scripts with Python
* Test: Ceedling - Unit test C programs with Ceedling/Unity/CMock/CExeption

## Requirements specification

The following loosely lists requirements, constraints, features and goals.

* Collection of useful C language tools shipped as Docker images that supports
  software development, deployment and continuous integration in a GNU/Linux
  environment
* Based on Alpine Linux
* Docker containers run with local non-root user
* Proper UID/GID handling (mapped to host user)
* Individual highly focused Docker images that build, check, document, test and
  run arbitrary scripts in software project repositories
* Run main ("payload") software as default Docker image entry point
* Run main ("payload") software help screen as default Docker image command (if
  available)

<!-- Separator -->

* Microservice design
* (Very) Suitable for embedded systems
* Tailored to the C (and assembly) programming language

<!-- Separator -->

* Low impact on technical budgets: Small storage and memory footprint
* Quality model
    * "Simple" (low complexity, essential features only)
    * Modular
    * Re-usable
    * Portable (between GNU/Linux distributions)
    * Scalable from simple and small to complex and large projects
    * Extensible (to other programming languages)
    * Version pinning for key software packages
    * SCM via Git with [Semantic Versioning](https://semver.org)
* Well documented (from requirements over key features to usage), using
  Markdown

## How to deploy

> Used variables in this documentation:
>
> * `BUILD_TYPE` - Identifier for the individual Docker images.
>   Run `make help` to list all available build types.
> * `DOCKER_IMG_NAME` - Name of the Docker image
> * `DOCKER_IMG_VER` - Version of the Docker image
> * `CATEGORY` - Sub-directories under `src/` that group the Docker images into
>   different categories
> * `TARGET_REPO` - Path to the target project directory
> * `MIRSA_C_2012_RULES_TEXT` - Path to the (optional) MISRA C:2012 rule texts
>   text file

This project comes with a GNU Make build process for easy deployment.
First, run:

```sh
$ make # Or `make help`
```

This lists available Make targets and build type variation points (that might
be required by some targets).

### Build

To build all Docker images, run:

```sh
$ make c-tools-all
```

To build individual Docker images only, run:

```sh
$ make c-tools t=${BUILD_TYPE}
```

> Run `make help` or just `make` to list available build types.

To manually build individual Docker images only, run:

```sh
$ sudo docker build \
    -t ${DOCKER_IMG_NAME}:${DOCKER_IMG_VER} \
    -t ${DOCKER_IMG_NAME}:latest \
    -f src/${CATEGORY}/${DOCKER_IMG_NAME}/Dockerfile
```

### Run

To execute a C tool, run the respective Docker container in the target software
repository:

```sh
$ cd ${TARGET_REPO}
$ sudo docker run \
    --rm \
    -v $(pwd):/project/ \
    -u $(id -u):$(id -g) \
    -it \
    --name ${DOCKER_IMG_NAME} \
    ${DOCKER_IMG_NAME}:latest
```

> Add the `--userns=host` option if user namespace isolation is used.

This runs the main ("payload") software with the "help" option (if available)
and no other command line interface arguments.

* To provide actual command line interface aguments (instead of the "help"
  option default), append them to the command above.
* To run the Docker container interactively without automatically executing the
  main ("payload") software, append `--entrypoint ash` (directly after `-it`)
  in the command above.
* To run the Docker container with a GNU Make target, append `--entrypoint make`
  (directly after `-it`) and the target (at the end) in the command above.

For ease of use, it is recommended to create shell aliases for the command
above for each Docker image.
For example, add this to the alias file (BASH/ZSH):

```sh
# C-Tools (Docker) aliases
alias ${DOCKER_IMG_NAME}-docker='sudo docker run --rm -v $(pwd):/project/ -u $(id -u):$(id -g) -it --name ${DOCKER_IMG_NAME} ${DOCKER_IMG_NAME}:latest'
alias ${DOCKER_IMG_NAME}-docker-make='sudo docker run --rm -v $(pwd):/project/ -u $(id -u):$(id -g) -it --entrypoint make --name ${DOCKER_IMG_NAME} ${DOCKER_IMG_NAME}:latest'
```

### Query version information from inside Docker container

To query the Docker image version information, run the following from inside
the Docker container:

```sh
$ echo $DOCKER_IMG_VER
```

> See the "Run" section for how to execute a command within a Docker container.

### Extra steps for individual Docker images

Some Docker containers require extra steps to perform their services.

#### Cppcheck

To invoke Cppcheck’s MISRA C:2012 checker (after generating `*.dump` files),
run:

```sh
$ cppcheck-misra *.dump
```

> Optionally, place the MISRA C:2012 rules text file within the project
> directory (or bind-mount somewhere extra) and add the
> `--rule-texts=${MIRSA_C_2012_RULES_TEXT}` flag.

#### UMLet

The UMLet Docker image is designed for command line interface batch conversion
of existing UMLet UML diagrams into common digital image formats--not for
creating new diagrams.

##### Run

To batch-convert UMLet files in the current directory, run either:

```sh
$ umlet -action=convert -format=png -filename=*.uxf # Full command
$ umlet-conv png "*.uxf" # Shortcut; quote or escape (`\*`) filepath glob necessary so glob expansion only happens inside wrapper script
```

##### Fonts configuration

To make sure the converted UMLet UML diagrams look exactly the same as the
graphical representation of the sources, the fonts must be metric-compatible.
Therefore, FreeSerif, FreeSans and FreeMono from GNU FreeFont must be used (or
another metric-compatible font).
Install the "GNU FreeFont" package for your GNU/Linux distribution and copy
`fonts.conf` (see UMLet Dockerfile build context) into your GNU/Linux
distribution’s fontconfig path.

## Architecture

The Docker images/files are divided into typical build process and continuous
integration pipeline "stages", coarsely guiding the development workflow of
"build -> test -> check -> document", plus one additional "generic" stage for
general purpose scripting.

## Coding standard - style conventions

The style is only loosely defined:

New added code should use the same style (i.e. "look similar") as the already
existing code base.

## Workflow

This project uses a simple topic branch Git workflow.
The only permanently existing branches are "develop" (development status;
unstable) and "master" (release status; stable).
New development efforts are done in separate topic branches, which are then
merged into "develop" once ready.
For releases, the "develop" branch is then merged into "master" and tagged.
Fast-forward merges are preferred, if possible.
