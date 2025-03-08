.PHONY: build test tag

TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)

build: underscore.deep.js

underscore.deep.js: underscore.deep.coffee
	node_modules/.bin/coffee --bare -c underscore.deep.coffee

test: $(TESTS) README.coffee.md

README.coffee.md: build
	node_modules/.bin/mocha --reporter spec --require coffeescript/register README.coffee.md

$(TESTS): build
	@echo $(LIBS)
	node_modules/.bin/mocha --bail --timeout 60000 --require coffeescript/register test/$@.coffee

tag:
	$(eval VERSION := $(shell grep version package.json | sed -ne 's/^[ ]*"version":[ ]*"\([0-9\.]*\)",/\1/p';))
	@echo \'$(VERSION)\'
	$(eval REPLY := $(shell read -p "Tag as $(VERSION)? " -n 1 -r; echo $$REPLY))
	@echo \'$(REPLY)\'
	@if [[ $(REPLY) =~ ^[Yy]$$ ]]; then \
	    git tag -a v$(VERSION) -m "version $(VERSION)"; \
	    git push --tags; \
	fi
