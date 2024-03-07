# Terragrunt scaffold custom template example

This is an example of how to create a custom [boilerplate](https://github.com/gruntwork-io/boilerplate) template that
will be used automatically for code generation when this module is used in [Terragrunt 
scaffolding](https://terragrunt.gruntwork.io/docs/features/scaffold/).

- You can define input variables and other configuration in `boilerplate.yml`. E.g., This example defines a variable
  called `TeamName`, which you've set to: `{{ .TeamName }}`.
- Any files in this folder will be generated as part of scaffolding.

See [Introducing Boilerplate](https://blog.gruntwork.io/introducing-boilerplate-6d796444ecf6) for more info.