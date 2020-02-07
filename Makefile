SHELL := /bin/bash -euo pipefail

export GO111MODULE := on
export ADDON_TESTS_PER_ADDON_WAIT_DURATION := 10m
export GIT_TERMINAL_PROMPT := 1
export ADDON_TESTS_SETUP_WAIT_DURATION := 30m
export GOPRIVATE := github.com/mesosphere/kubeaddons


.DEFAULT_GOAL := test.integration

.PHONY: git-credentials
git-credentials:
ifndef GITHUB_TOKEN
	@echo "GITHUB_TOKEN not specified, ignore git-credentials target"
else
	@git config --global url."https://${GITHUB_TOKEN}:@github.com/".insteadOf "https://github.com/"
	@git config user.email "ci@mesosphere.com"
	@git config user.name "CI"
endif


.PHONY: test.integration
test.integration: git-credentials
	cd test && git fetch; \
	for g in $(shell cd test && go run scripts/test-wrapper.go); do \
		go test -timeout 30m -race -v -run $$g; \
	done

.PHONY: go-ver
go-ver:
	go version
