SHELL := /bin/bash

.PHONY: test

test:
	@echo "Running Ruby integration test for fmtlog..."
	@ruby test_fmtlog.rb
