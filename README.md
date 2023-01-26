# MinIO Kubernetes Operator Docs

This repository contains the source code for https://docs.min.io/minio/k8s. 

This repository is now fully defunct and has been absorbed in its entirety by https://github.com/minio/docs.

# Build Instructions

MinIO uses [Sphinx](https://www.sphinx-doc.org/en/master/index.html) to generate
static HTML pages using ReSTructured Text.

## Prerequisites

- Python 3.10.X. 

- NodeJS 14.5.0 or later.

- `git` or a git-compatible client.

- Access to https://github.com/minio/docs-k8s

All instructions below are intended for Linux systems. Windows builds may work
using the following instructions as general guidance.

## Build Process

1. Run `git checkout https://github.com/minio/docs-k8s` and `cd docs-k8s` to move into
   the working directory.

2. Create a new virtual environment `python -3 m venv venv`. Activate it using
   `source venv/bin/activate`.

3. Run `pip install -r requirements.txt` to setup the Python environment.

4. Run `make stage`

5. Open your browser to http://localhost:8000 to view the staged output.

This project is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/legalcode).

See [CONTRIBUTIONS](https://github.com/minio/docs/tree/master/CONTRIBUTIONS.md) for more information on contributing content to the MinIO Documentation project.
