STACK=stack --no-terminal --install-ghc ${STACK_ARGS}
SITE_NAME=site-kyleondy
SITE_EXE=$(STACK) exec $(SITE_NAME)
PROVIDER_FOLDER=provider
ARTIFACT_DIR=_output
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

all: clean check

.PHONY: build
build:
	$(STACK) install
	$(SITE_EXE) -- build

.PHONY: check
check: build
	$(SITE_EXE) -- check

.PHONY: clean-full
clean-full:
	$(STACK) clean
	rm -rf $(ARTIFACT_DIR)
	$(SITE_EXE) -- clean
	rm -f $(shell stack path --local-bin)/$(SITE_NAME)

.PHONY: clean
clean:
	rm -rf $(ARTIFACT_DIR)
	$(SITE_EXE) -- clean

.PHONY: server
server: build
	$(SITE_EXE) -- server

.PHONY: package
package:
	mkdir -p $(ARTIFACT_DIR)
	# I think I can use `tar -C` here, need to look into it.
	cd _site && tar -zcvf ../$(ARTIFACT_DIR)/$(GIT_BRANCH).tar.gz ./*
	echo done packaging $(ARTIFACT_DIR)/$(GIT_BRANCH).tar.gz

.PHONY: watch
watch: build
	$(SITE_EXE) -- watch

.PHONY: deploy
deploy:
	./deploy.sh $(GIT_BRANCH)
