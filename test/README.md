# Automated tests

This folder contains automated tests for the examples in the `examples` folder. The tests are written in Go and use a
test library called [Terratest](https://terratest.gruntwork.io/).

## Running the tests

**WARNING**: These tests deploy real resources into real AWS accounts, so they may cost you money.

### Pre-requisites

1. Install [Go](https://go.dev/).
2. Install [OpenTofu](https://opentofu.org/).
3. Configure your [AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html). 

### Run all the tests

```bash
go test -v -timeout 60m
```

### Run a specific test

```bash
go test -v -timeout 60m -run '<TEST_NAME>'
```