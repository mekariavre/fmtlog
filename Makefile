SHELL := /bin/bash

.PHONY: test

test:
	@echo "Running integration test for fmtlog using testrunner.sh..."
	@./testrunner.sh
