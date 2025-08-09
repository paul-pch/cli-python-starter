# Python CLI Project Makefile Template

# Variables
PYTHON := python3
VENV_DIR := venv
VENV_BIN := $(VENV_DIR)/bin

DIST_NAME ?= $(notdir $(CURDIR))
PIP := $(VENV_BIN)/pip
PRE_COMMIT := $(VENV_BIN)/pre-commit
PYINSTALLER_OPTS ?= --onefile
PYTHON_CMD := $(VENV_BIN)/python
SOURCE_DIR := app
TEST_DIR := tests

.PHONY: venv
venv:
	$(PYTHON) -m venv $(VENV_DIR)
	@echo "Virtual environment created in $(VENV_DIR)"

.PHONY: clean-venv
clean-venv:
	rm -rf $(VENV_DIR)

.PHONY: install
install: venv
	@$(PIP) install -r requirements.txt || (echo "Erreur d'installation - Vérifiez que venv est correctement activé"; exit 1)
	@echo "Dependencies installed"

.PHONY: update-deps
update-deps:
	$(PIP) install --upgrade -r requirements.txt
	@echo "Dependencies updated"

.PHONY: lint
lint: install
	$(PRE_COMMIT) run ruff --all-files
	@echo "Ruff linting checked"

.PHONY: test
test: lint
	$(PYTHON_CMD) -m pytest $(TEST_DIR) --cov=$(SOURCE_DIR) --cov-report=html:coverage-report
	@echo "Tests completed"

.PHONY: build
build:
	pyinstaller $(PYINSTALLER_OPTS) --name=$(DIST_NAME) $(SOURCE_DIR)/main.py
	@echo "Application built"

# Integration
.PHONY: integrate
integrate: install
	grep -q '$(CURDIR)' ~/.zshrc || echo 'export PATH=$(CURDIR)/dist:$$PATH' >> ~/.zshrc
	@echo "Application integrated into shell"

# Clean
.PHONY: clean
clean:
	rm -rf dist build *.egg-info .coverage coverage-report
	@echo "Build artifacts removed"

# Pre-commit
.PHONY: pre-commit
pre-commit: install
	$(PRE_COMMIT) install
	@echo "Pre-commit hooks installed"

.PHONY: check
check: lint test

# Default target
.PHONY: all
all: install test build
