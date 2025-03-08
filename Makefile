.PHONY: build test tag

TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)
ESMTESTS=$(shell cd test/ESM && ls *.coffee | sed s/\.coffee$$//)

build: underscore.deep.js

# compile coffeescript files to ./dist/esm
coffeescript-compile-to-esm:
	node_modules/.bin/coffee --bare -o dist/esm -c src/*.coffee

# transpile ESM to CJS using mkdist
mkdist: coffeescript-compile-to-esm
	node_modules/.bin/mkdist . --src=dist/esm --dist=dist/cjs --format=cjs --pattern='*.js'

underscore.deep.js: mkdist

test: $(TESTS) README.coffee.md $(ESMTESTS)

README.coffee.md: build
	node_modules/.bin/mocha --reporter spec --require coffeescript/register README.coffee.md

$(TESTS): build
	@echo $(LIBS)
	node_modules/.bin/mocha --bail --timeout 60000 --require coffeescript/register test/$@.coffee

$(ESMTESTS): build
	@echo $(ESMLIBS)
	node_modules/.bin/coffee --bare -c test/ESM/$@.coffee
	node_modules/.bin/mocha --bail --timeout 60000 --input-type=module test/ESM/$@.js

tag:
	$(eval VERSION := $(shell grep version package.json | sed -ne 's/^[ ]*"version":[ ]*"\([0-9\.]*\)",/\1/p';))
	@echo \'$(VERSION)\'
	$(eval REPLY := $(shell read -p "Tag as $(VERSION)? " -n 1 -r; echo $$REPLY))
	@echo \'$(REPLY)\'
	@if [[ $(REPLY) =~ ^[Yy]$$ ]]; then \
	    git tag -a v$(VERSION) -m "version $(VERSION)"; \
	    git push --tags; \
	fi
