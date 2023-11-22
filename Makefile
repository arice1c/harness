# templates/Makefile.build-harness includes this Makefile
# and this Makefile includes templates/Makefile.build-harness
# to support different modes of invocation. Use a guard variable
# to prevent infinite recursive includes
ifeq ($(BUILD_HARNESS_TOP_LEVEL_MAKEFILE_GUARD),)
BUILD_HARNESS_TOP_LEVEL_MAKEFILE_GUARD := included

export OS := $(shell uname -s | tr '[:upper:]' '[:lower:]')
export BUILD_HARNESS_PATH ?= $(shell 'pwd')
export BUILD_HARNESS_OS ?= $(OS)
export BUILD_HARNESS_ARCH ?= $(shell uname -m | sed 's/x86_64/amd64/g')
export SELF ?= $(MAKE)
export DOCKER_BUILD_FLAGS ?=

# Forces auto-init off to avoid invoking the macro on recursive $(MAKE)
export BUILD_HARNESS_AUTO_INIT := false

# Debug should not be defaulted to a value because some cli consider any value as `true` (e.g. helm)
export DEBUG ?=

ifeq ($(CURDIR),$(realpath $(BUILD_HARNESS_PATH)))
# Only execute this section if we're actually in the `build-harness` project itself
# List of targets the `readme` target should call before generating the readme
export DEFAULT_HELP_TARGET = help/all

# builder/build is defined in templates/Makefile.build-harness
build: builder/build

endif

# Import Makefiles into current context
include $(BUILD_HARNESS_PATH)/Makefile.*
include $(BUILD_HARNESS_PATH)/modules/*/bootstrap.Makefile*
include $(BUILD_HARNESS_PATH)/modules/*/Makefile*
