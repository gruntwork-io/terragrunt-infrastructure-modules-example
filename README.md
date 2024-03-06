[![Maintained by Gruntwork.io](https://img.shields.io/badge/maintained%20by-gruntwork.io-%235849a6.svg)](https://gruntwork.io/?ref=repo_terragrunt-infra-modules-example)

# Example infrastructure-modules for Terragrunt

This repo, along with the [terragrunt-infrastructure-live-example 
repo](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example), show an example file/folder structure
you can use with [Terragrunt](https://github.com/gruntwork-io/terragrunt) to keep your 
[Terraform](https://www.terraform.io) code DRY. For background information, check out the [Keep your Terraform code
DRY](https://github.com/gruntwork-io/terragrunt#keep-your-terraform-code-dry) section of the Terragrunt documentation.

This repo contains the following example modules:

* [asg-alb-service](/modules/asg-alb-service): An example of how to deploy an Auto Scaling Group (ASG) with an 
  Application Load Balancer (ALB) in front of it. We run a dirt-simple "web server" on top of the ASG that always 
  returns "Hello, World".

* [mysql](/modules/mysql): An example of how to deploy MySQL on top of Amazon's Relational Database Service (RDS).  

Note: This code is solely for demonstration purposes. This is not production-ready code, so use at your own risk. If 
you are interested in battle-tested, production-ready Terraform code, check out [Gruntwork](http://www.gruntwork.io/).





## How do you use these modules?

To use a module, create a  `terragrunt.hcl` file that specifies the module you want to use in the `source` URL as well 
as values for the input variables of that module in the `inputs` block:

```hcl
# Use Terragrunt to download the module code
terraform {
  source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//path/to/module?ref=<VERSION>"
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

```
> terragrunt apply
[terragrunt] Reading Terragrunt config file at terragrunt.hcl
[terragrunt] Downloading Terraform configurations from git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//path/to/module?ref=<VERSION>
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

    ```
    git tag -a v0.0.2 -m "tag message"
    git push --follow-tags
    ```
1. Now you can use the new Git tag (e.g. `v0.0.2`) in the `ref` attribute of the `source` URL in `terragrunt.hcl`.
1. Run `terragrunt plan`.
1. If the plan looks good, run `terragrunt apply`.   

## Folder structure

This repo uses the following "standard" folder structure:

- `modules`: Put module code into this folder.
- `examples`: Put example code into this folder. These are examples of how to use the modules in the `modules` folder.
  This is useful both for manual testing (you can manually run `tofu apply` on these examples) and automated testing
  (as per the tests in the `test` folder, as described next).
- `test`: Put test code into this folder. These should be automated tests for the examples in the `examples` folder. 

## Monorepo vs. polyrepo

This repo is an example of a *monorepo*, where you have multiple modules in a single repository. There are benefits and drawbacks to using a monorepo vs. using a *polyrepo* - one module per repository. Which you choose depends on your tooling, how you build/test Terraform modules, and so on. Regardless, the [live repo](https://github.com/gruntwork-io/terragrunt-infrastructure-live-example) will consume the modules in the same way: a reference to a Git release tag in a `terragrunt.hcl` file.

### Advantages of a monorepo for Terraform modules

* **Easier to make global changes across the entire codebase.** For example, applying a critical security fix or upgrading everything to a new version of Terraform can happen in one logical commit.
* **Easier to search across the entire codebase.** You can search through all the module code using a standard text editor or file searching utility just with one repo checked out.
* **Simpler continuous integration across modules.** All your code is tested and versioned together. This reduces the chance of _late integration_ issues arising from out-of-date module-dependencies.
* **Single repo and build pipeline to manage.** Permissions, pull requests, etc. all happen in one spot. Everything validates and tests together so you can see any failures in one spot.

### Disadvantages of a monorepo for Terraform modules

* **Harder to keep changes isolated.** While you're modifying module `foo`, you also have to think through whether this will affect module `bar`.
* **Ever increasing testing time.** The simple approach is to run all tests after every commit, but as the monorepo grows, this gets slower and slower (and more brittle).
* **No dependency management system.** To only run a subset of the tests or otherwise validate only changed modules, you need a way to tell which modules were affected by which commits. Unfortunately, Terraform has no first-class dependency management system, so there's no way to know that a code change in a file in module `foo` won't affect module `bar`. You have to build custom tooling that figures this out based on heuristics (brittle) or try to integrate Terraform with dependency management / monorepo tooling like [bazel](https://bazel.build/) (lots of work).
* **Doesn't work with the Terraform Private Registry.** Private registries (part of Terraform Enterprise and Terraform Cloud) require one module per repo.
* **No feature toggle support.** Terraform doesn't support feature toggles, which are often critical for making large scale changes in a monorepo.
* **Release versions change even if module code didn't change.** A new "release" of a monorepo involves tagging the repo with a new version. Even if only one module changed, all the modules effectively get a new version.

### Advantages of one-repo-per-module

* **Easier to keep changes isolated.** You mostly only have to think about the one module/repo you're changing rather than how it affects other modules.
* **Works with the Terraform Private Registry.** Private registries (part of Terraform Enterprise and Terraform Cloud) can list modules in a one-repo-per-module format if you [follow their module structure](https://www.terraform.io/docs/modules/index.html#standard-module-structure) and [repository naming conventions](https://www.terraform.io/docs/registry/modules/publish.html#requirements).
* **Testing is faster and isolated.** When you run tests, it's just tests for this one module, so no extra tooling is necessary to keep tests fast.
* **Easier to detect individual module changes.** With only one module in a repo, there's no guessing at which module changed as releases are published.

### Disdvantages of one-repo-per-module

* **Harder to make global changes.** Changes across repos require lots of checkouts, separate commits and pull requests, and an updated release per module. This may need to be done in a specific order based on depedency graphs. This may take a lot of time in a large organization, which is problematic when dealing with security issues.
* **Harder to search across the codebase.** Searches require checking out all the repos or having tooling (e.g., GitHub or Azure DevOps) that allows searching across repositories remotely.
* **No continuous integration across modules.** You might make a change in your module and the teams that depend on that module might not consume that change for a long time. When they do, they may find an incompatibility or other issue that could be hard to fix given the amount of time that's passed.
* **Many repos and builds to manage.** Permissions, pull requests, build pipelines, test failures, etc. get managed in several places.
* **Potential dependency graph problems.** It is possible to run into issues like "diamond dependencies" when using many modules together, though Terraform can avoid many of these issues since it can run different versions of the same dependency at the same time.
* **Slower initialization.** Terraform downloads each dependency from scratch, so if one repo depends on modules from many other repos — or even the exact same module from the same repo, but used many times in your code — it will download that module every time it's used rather than just once.
