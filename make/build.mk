# Sub-Makefile (included by main Makefile)

# Docker image builder
DOCKER := docker

# Main target base name
BIN := c-tools

# Variation points for build type configurations
VAR_PTS := \
    build-gcc \
    build-gcc-avr \
    check-cloc \
    check-cppcheck \
    check-lizard \
    doc-doxygen \
    doc-pandoc \
    doc-umlet \
    generic-python \
    test-ceedling
ifeq ($(t),build-gcc)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := gcc
SRC_PATH_VAR_PT := src/build/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),build-gcc-avr)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := gcc-avr
SRC_PATH_VAR_PT := src/build/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),check-cloc)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := cloc
SRC_PATH_VAR_PT := src/check/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),check-cppcheck)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := cppcheck
SRC_PATH_VAR_PT := src/check/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),check-lizard)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := lizard
SRC_PATH_VAR_PT := src/check/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),doc-doxygen)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := doxygen
SRC_PATH_VAR_PT := src/doc/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),doc-pandoc)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := pandoc
SRC_PATH_VAR_PT := src/doc/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),doc-umlet)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := umlet
SRC_PATH_VAR_PT := src/doc/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),generic-python)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := python
SRC_PATH_VAR_PT := src/generic/$(DOCKER_IMG_NAME_VAR_PT)
endif
ifeq ($(t),test-ceedling)
BUILD_PATH_VAR_PT := $(t)
DOCKER_IMG_NAME_VAR_PT := ceedling
SRC_PATH_VAR_PT := src/test/$(DOCKER_IMG_NAME_VAR_PT)
endif

# Build *directory* path
BUILD_PATH := $(ROOT_BUILD_PATH)/$(BIN)-$(BUILD_PATH_VAR_PT)

# Docker(file) image version (read from Dockerfile)
DOCKER_IMG_VER = \
    $(shell grep "ARG DOCKER_IMG_VER=" $(SRC_PATH_VAR_PT)/Dockerfile | cut -d "=" -f 2)

# Workaround for newline insertion (two empty lines as Make ignores last newline)
define NEWLINE


endef

# Sanity check; assert that build type is defined
t ?= no-build-type-defined
SANITY_CHECK = \
    $(if $(shell echo "$(VAR_PTS)" | grep -E "(^|[[:space:]])$(t)([[:space:]]|$$)"), \
    , \
    $(error No/invalid build type provided via variable `t`))

# Build Docker image
HELP += $(BIN)~Build_Docker_image_\(req._build_type\)
.PHONY: $(BIN)
$(BIN): LOG_FIL = $@-log.txt
$(BIN): SHA_FIL = $@-checksums.sha1
$(BIN):
	$(SANITY_CHECK)
	@mkdir -p $(BUILD_PATH)/
	@echo "$(PROMPT)  Docker version:" \
	    2>&1 | tee $(BUILD_PATH)/$(LOG_FIL)
	@$(DOCKER) --version | \
	    cut -d " " -f 3- \
	    2>&1 | tee -a $(BUILD_PATH)/$(LOG_FIL)
	@$(MAKE) \
	    $(BUILD_PATH)/$@ \
	    2>&1 | tee -a $(BUILD_PATH)/$(LOG_FIL)
	@echo "---" \
	    2>&1 | tee -a $(BUILD_PATH)/$(LOG_FIL)
	@echo "$(PROMPT)  Total warnings count: $$(grep -c "WARNING\|Warning\|warning" $(BUILD_PATH)/$(LOG_FIL))" \
	    2>&1 | tee -a $(BUILD_PATH)/$(LOG_FIL)
	@echo "$(PROMPT)  Total errors count: $$(grep -c "ERROR\|Error\|error" $(BUILD_PATH)/$(LOG_FIL))" \
	    2>&1 | tee -a $(BUILD_PATH)/$(LOG_FIL)
	@echo "$(PROMPT)  Total failures count: $$(grep -c "FAIL\|Fail\|fail" $(BUILD_PATH)/$(LOG_FIL))" \
	    2>&1 | tee -a $(BUILD_PATH)/$(LOG_FIL)
	@cd $(BUILD_PATH)/ && \
	    rm -f ./$(SHA_FIL) && \
	    sha1sum ./$@* > ./$(SHA_FIL)
.PHONY: $(BUILD_PATH)/$(BIN)
$(BUILD_PATH)/$(BIN):
	@mkdir -p $(dir $@)
	@echo "$(PROMPT)  Build Docker image \`$(DOCKER_IMG_NAME_VAR_PT)\`"
	@sudo $(DOCKER) build \
	    -t $(DOCKER_IMG_NAME_VAR_PT):$(DOCKER_IMG_VER) \
	    -t $(DOCKER_IMG_NAME_VAR_PT):latest \
	    $(SRC_PATH_VAR_PT)/ \
	    -f $(SRC_PATH_VAR_PT)/Dockerfile

# Cleanup
HELP += clean-$(BIN)~Clean_up_target_\(req._build_type\)
.PHONY: clean-$(BIN)
clean-$(BIN):
	$(SANITY_CHECK)
	rm -rf $(BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"

# Build all Docker images
HELP += $(BIN)-all~Build_all_Docker_images
.PHONY: $(BIN)-all
$(BIN)-all:
	$(foreach BUILD_TYPE,$(VAR_PTS), \
	    @$(MAKE) $(BIN) t="$(BUILD_TYPE)" $(NEWLINE))

# Cleanup
HELP += clean-$(BIN)-all~Clean_up_target
.PHONY: clean-$(BIN)-all
clean-$(BIN)-all:
	$(foreach BUILD_TYPE,$(VAR_PTS), \
	    @$(MAKE) clean-$(BIN) t="$(BUILD_TYPE)" $(NEWLINE))
