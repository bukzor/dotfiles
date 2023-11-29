export PYTHON ?= python$(shell cat  .python-version)
export PORT ?= 8088

venv: ./lib/make/venv .brew.done requirements-dev.txt .python-version
	./lib/make/venv "$@"

.brew.done: Brewfile
	brew bundle
	touch .brew.done


requirements-dev.txt: requirements-dev.in
	pip-compile requirements-dev.in --upgrade > requirements-dev.txt


coverage: venv
	./venv/bin/coverage run -m pytest

coverage-html: coverage
	./venv/bin/coverage html
	$(PYTHON) -m http.server --directory ./htmlcov $(PORT)


format: ./lib/make/format venv
	./lib/make/format

lint: ./lib/make/lint venv format
	./lib/make/lint


# this makes `make -d` output readable:
.SUFFIXES:
MAKEFLAGS:=--no-builtin-rules --no-builtin-variables
