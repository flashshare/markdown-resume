SHELL := /bin/bash

# For Docker support
export TIMESTAMP=$(shell date +"%s" 2>/dev/null || powershell -Command "Get-Date -UFormat '%s'")
export pwd=$(shell pwd 2>/dev/null || echo %cd%)

# Detect OS and set platform-specific variables
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
    RM_CMD := powershell -Command "Remove-Item -Path"
    COMPILE_SCRIPT := powershell -Command "./compile.ps1"
    COMPILE_ALL_SCRIPT := powershell -Command "./compile_all.ps1"
    CHECK_DEPS_SCRIPT := powershell -Command "./check_deps.ps1"
    PATH_SEP := \\
else
    DETECTED_OS := $(shell uname -s)
    RM_CMD := rm -f
    COMPILE_SCRIPT := ./compile.sh
    COMPILE_ALL_SCRIPT := ./compile_all.sh
    CHECK_DEPS_SCRIPT := # No equivalent check script for Linux/Mac yet
    PATH_SEP := /
endif

# Define output paths with correct separators
OBJDIR := output
PDF_PATTERN := $(OBJDIR)$(PATH_SEP)*.pdf
HTML_PATTERN := $(OBJDIR)$(PATH_SEP)*.html

.PHONY: all
all:
ifeq ($(DETECTED_OS),Windows)
	@echo "Detected Windows OS"
	$(CHECK_DEPS_SCRIPT)
endif
	$(COMPILE_ALL_SCRIPT)

.PHONY: check-deps
check-deps:
ifeq ($(DETECTED_OS),Windows)
	$(CHECK_DEPS_SCRIPT)
else
	@echo "Dependency check only implemented for Windows currently."
endif

.PHONY: watch
watch:
ifeq ($(DETECTED_OS),Windows)
	@echo "Watch functionality not implemented for Windows yet."
else
	./watch.sh
endif

.PHONY: test
test:
ifeq ($(DETECTED_OS),Windows)
	@echo "Testing on Windows..."
	$(COMPILE_ALL_SCRIPT)
else
	@echo "Testing on Linux/macOS..."
	shellcheck ./compile.sh
	shellcheck ./compile_all.sh
	shellcheck ./watch.sh
	$(COMPILE_ALL_SCRIPT)
endif
	# Verify outputs exist (platform-independent)
	@test -f $(OBJDIR)/sample.pdf || (echo "Error: sample.pdf not found!" && exit 1)
	@test -f $(OBJDIR)/sample.html || (echo "Error: sample.html not found!" && exit 1)
	$(MAKE) clean
	@test ! -f $(OBJDIR)/sample.pdf || (echo "Error: sample.pdf not cleaned!" && exit 1)
	@test ! -f $(OBJDIR)/sample.html || (echo "Error: sample.html not cleaned!" && exit 1)

.PHONY: clean
clean:
ifeq ($(DETECTED_OS),Windows)
	powershell -Command "Remove-Item -Path '$(PDF_PATTERN)' -ErrorAction SilentlyContinue"
	powershell -Command "Remove-Item -Path '$(HTML_PATTERN)' -ErrorAction SilentlyContinue" 
else
	$(RM_CMD) $(PDF_PATTERN)
	$(RM_CMD) $(HTML_PATTERN)
endif

.PHONY: docker
docker:
	docker build -t markdown-resume .
	docker run -it --rm -v "$(pwd)/src:/mdr/src" -v "$(pwd)/output:/mdr/output" markdown-resume
