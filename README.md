# Harness

Inspired by: https://github.com/cloudposse/build-harness

This is a collection of Makefiles to facilitate building One Concern projects. It contains a collection of reusable `make` targets that can be composed together.

Goal: encapsulate logic around common software tasks using `make` in a way that can be versioned and easily composed with repo-specific build logic.

- The same targets can and should be used in both local dev and in CI
- Provide reasonable defaults but allow extension of standard targets
- Design for composition so that targets can be easily composed together

## Usage

At the top of your Makefile, include the harness:

```makefile
-include $(shell curl -sSL -o .build-harness "https://cloudposse.tools/build-harness"; echo .build-harness)
```

## Design

- Namespace targets with / as delimiter. E.g. `docker/build:`
- Use `-include` to break up Makefiles by responsibility and compose groups of commands together
- Keep targets small. For more complex tasks, write shell scripts and call those from targets
- Separate repo, releases, and versioning for harness. Download/include it in each project’s main Makefile

## Responsibilities

The master set of makefiles exposes targets for specific tools, and it is up to the master Makefile in each repo to compose the applicable targets appropriately.

### Lint

### Test

### Build

### Release

### Install

## Standard Targets

- All: build and deploy the entire program from scratch 
- Install: install any needed tools/packages for working in the repo
- Uninstall: delete this application
- Clean: remove all build artifacts (aka dist/ directory, built Docker images, etc…)
- Check: run any tests on a built artifact before ‘installation’. Linting, formatting, unit tests

## Custom Targets

- Test: run all unit tests
    - Integration: only integration tests
    - Performance: only performance tests
    - Load: only load tests
    - Stress: only stress tests
- Lint: runs the same linting checks that are run in CI
- Build: build all application assets
- Deps: install all project dependencies (i.e. from Poetry)
    - Dev: install all project dependencies AND dev dependencies 
- Help: generate well formatted output for targets (this is the default)

## CI/CD

- Build small custom images that can perform each responsibility in a separate step?
- At the least, create a base harness Docker image that already has all the major deps installed so that CI doesn’t have to install them each time
