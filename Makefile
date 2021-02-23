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

sync-git:
	@echo "Pulling down latest stable operator examples from $(OPERATORTAG)"
	@echo "Storing files in $(OPERATORDIR)"

	@wget $(OPERATORGIT)/examples/tenant.yaml \
	  -O $(OPERATORDIR)/tenant.yaml
