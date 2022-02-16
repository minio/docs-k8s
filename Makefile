# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?= -n
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build
GITDIR        = $(shell git rev-parse --abbrev-ref HEAD)
OPERATORGIT   = https://raw.githubusercontent.com/minio/operator/master
OPERATORDIR   = $(SOURCEDIR)/includes/git-operator

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

# dry-run build command to double check output build dirs

dryrun:
	@echo "$(SPHINXBUILD) -M $@ '$(SOURCEDIR)' '$(BUILDDIR)/$(GITDIR)' $(SPHINXOPTS) $(O)"

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)/$(GITDIR)" $(SPHINXOPTS) $(O)
	@npm run build

sync-operator-version:
	@echo "Retrieving latest Operator version"
	$(shell wget -O /tmp/downloads-operator.json https://api.github.com/repos/minio/operator/releases/latest)
	$(eval OPERATOR = $(shell cat /tmp/downloads-operator.json | jq '.tag_name[1:]'))

	@echo "Replacing variables"

	@cp source/default-conf.py source/conf.py

	@sed -i "s|OPERATOR|${OPERATOR}|g" source/conf.py

sync-git:
	@echo "Pulling down latest stable operator examples from $(OPERATORTAG)"
	@echo "Storing files in $(OPERATORDIR)"

	@wget $(OPERATORGIT)/examples/tenant.yaml \
	  -O $(OPERATORDIR)/tenant.yaml

sync-deps:
	@echo "Synchronizing all external dependencies"
	@make sync-operator-version
	@make sync-git

clean:

	@echo "Cleaning $(BUILDDIR)/$(GITDIR)"
	@rm -rf $(BUILDDIR)/$(GITDIR)

stage:
	@make clean && make html
	python -m http.server --directory $(BUILDDIR)/$(GITDIR)/html

publish:
	@make clean
	make html
