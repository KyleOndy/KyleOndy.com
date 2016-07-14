SITE_EXE=stack exec site-kyleondy
PROVIDER_FOLDER=provider
ARTIFACT_DIR=_output

.PHONY: build
build:
	stack install
	$(SITE_EXE) -- build

.PHONY: check
check: build
	$(SITE_EXE) -- check -i

.PHONY: check-full
check-full: build
	$(SITE_EXE) -- check

.PHONY: clean
clean:
	rm -rf $(ARTIFACT_DIR)
	$(SITE_EXE) -- clean

.PHONY: server
server: build
	$(SITE_EXE) -- server

.PHONY: package
package: check
	mkdir -p $(ARTIFACT_DIR)
	# I think I can use `tar -C` here, need to look into it.
	cd _site && tar -zcvf ../$(ARTIFACT_DIR)/latest.tar.gz ./*

.PHONY: deploy
deploy: package
	./deploy.sh


.PHONY: watch
watch: build
	$(SITE_EXE) -- watch
