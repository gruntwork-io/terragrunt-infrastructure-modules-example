[![Maintained by Gruntwork.io](https://img.shields.io/badge/maintained%20by-gruntwork.io-%235849a6.svg)](https://gruntwork.io/?ref=repo_terragrunt-infra-modules-example)

# Example infrastructure-modules for Terragrunt

This repo, along with the [terragrunt-infrastructure-live-example
repo](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example), show an example file/folder structure
you can use with [Terragrunt](https://github.com/gruntwork-io/terragrunt) to keep your
[Terraform](https://www.terraform.io) code DRY. For background information, check out the [Keep your Terraform code
DRY](https://github.com/gruntwork-io/terragrunt#keep-your-terraform-code-dry) section of the Terragrunt documentation.

This repo contains the following example code:

* [asg-elb-service](/asg-elb-service): An example of how to deploy an Auto Scaling Group (ASG) with an Elastic Load
  Balancer (ELB) in front of it. We run a dirt-simple "web server" on top of the ASG that always returns "Hello, World".

* [mysql](/mysql): An example of how to deploy MySQL on top of Amazon's Relational Database Service (RDS).

Note: This code is solely for demonstration purposes. This is not production-ready code, so use at your own risk. If
you are interested in battle-tested, production-ready Terraform code, check out [Gruntwork](http://www.gruntwork.io/).

## How do you use these modules?

To use a module, create a  `terragrunt.hcl` file that specifies the module you want to use as well as values for the
input variables of that module:

```hcl
# Use Terragrunt to download the module code
terraform {
  source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//path/to/module?ref=v0.0.1"
}

# Fill in the variables for that module
inputs = {
  foo = "bar"
  baz = 3
}
```

(*Note: the double slash (`//`) in the `source` URL is intentional and required. It's part of Terraform's Git syntax
for [module sources](https://www.terraform.io/docs/modules/sources.html).*)

You then run [Terragrunt](https://github.com/gruntwork-io/terragrunt), and it will download the source code specified
in the `source` URL into a temporary folder, copy your `terragrunt.hcl` file into that folder, and run your Terraform
command in that folder:

```text
> terragrunt apply
[terragrunt] Reading Terragrunt config file at terragrunt.hcl
[terragrunt] Downloading Terraform configurations from git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//path/to/module?ref=v0.0.1
[terragrunt] Copying files from . into .terragrunt-cache
[terragrunt] Running command: terraform apply
[...]
```

Check out the [terragrunt-infrastructure-live-example
repo](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) for examples and the [Keep your Terraform
code DRY documentation](https://github.com/gruntwork-io/terragrunt#keep-your-terraform-code-dry) for more info.

## How do you change a module?

### Local changes

Here is how to test out changes to a module locally:

1. `git clone` this repo.
1. Update the code as necessary.
1. Go into the folder where you have the `terragrunt.hcl` file that uses a module from this repo (preferably for a
   dev or staging environment!).
1. Run `terragrunt plan --terragrunt-source <LOCAL_PATH>`, where `LOCAL_PATH` is the path to your local checkout of
   the module code.
1. If the plan looks good, run `terragrunt apply --terragrunt-source <LOCAL_PATH>`.

Using the `--terragrunt-source` parameter (or `TERRAGRUNT_SOURCE` environment variable) allows you to do rapid,
iterative, make-a-change-and-rerun development.

### Releasing a new version

When you're done testing the changes locally, here is how you release a new version:

1. Update the code as necessary.
1. Commit your changes to Git: `git commit -m "commit message"`.
1. Add a new Git tag using one of the following options:
    1. Using GitHub: Go to the [releases page](/releases) and click "Draft a new release".
    1. Using Git:

    ```sh
    git tag -a v0.0.2 -m "tag message"
    git push --follow-tags
    ```

1. Now you can use the new Git tag (e.g. `v0.0.2`) in the `ref` attribute of the `source` URL in `terragrunt.hcl`.
1. Run `terragrunt plan`.
1. If the plan looks good, run `terragrunt apply`.

## Monorepo vs. polyrepo

This example shows live modules in a "monorepo" - several modules in a single repository. There are [benefits and drawbacks to using a monorepo](https://github.com/joelparkerhenderson/monorepo_vs_polyrepo) vs. using a "polyrepo" - one module per repository. Which you choose depends on your tooling, how you build/test Terraform modules, and so on.

For example, if you have a CI pipeline that automates testing on Terraform modules, a monorepo will either need to test all the modules in the repo for any change; or have tooling that supports only testing things that changed. A polyrepo scenario doesn't require such tooling.

On the other hand, if you have several modules that get developed and released together, it may be easier to manage them in a monorepo rather than spreading them across several repositories and build pipelines.

Whichever you choose - monorepo or polyrepo - the [live repo](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) will consume the modules in the same way: a reference to a Git release tag in a `terragrunt.hcl` file.
