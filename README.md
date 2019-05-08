# Infra

This repo is an experiment to apply the practices of [Infrastructure as Code][1] to OpenOakland. Why?

* *Inclusivity* - Being transparent in our operations promotes collaboration and involvement of many.
* *Documentation* - We will have documentation in source code about why infrastructure changes were made.
* *Sustainability* - With better documentation and better participation, we will build a more sustainable organization.

## Setup (macOS)
_*Note:* If you are looking to set up the infra repo for your Brigade, see [README.setup.md][setup] for how to set up the repo for the first time._

To run Terraform within OpenOakland, follow these instructions:

Prerequisites: [Homebrew][2]

```bash
# 1. Install Terraform
brew install terraform jq ansible

# 2. Install 1password command line tool
# from: https://app-updates.agilebits.com/product_history/CLI
op signin openoakland.1password.com [email] A3-[master-key]
eval $(op signin openoakland) # you will have to do this per shell

# Download the root SSH key
op get item 7rh246cuoreo3lurhxdtlf5b44 | jq -r .details.notesPlain > ~/.ssh/id_rsa_openoakland
chmod 600 ~/.ssh/id_rsa_openoakland
```

### Secrets

_TODO we should be able to get secrets from the terraform state without sharing
secrets out of band._

Copy the .env sample and fill it in with secrets from another operator or the
terraform state.

    $ cp env.sample .env
    $ source .env


## Running

### Terraform

```bash
terraform plan
terraform apply
```

You can also work with a specific module.

```bash
terraform plan -target=module.oakcrime -out=plan.tfplan
terraform apply plan.tfplan
```

### Ansible

Running Ansible (Councilmatic):
```bash
ansible-playbook -i inventory playbooks/councilmatic/councilmatic.yml
```

## TODO:
* Create an SSH key which isn't anyone's personal key to use for provisioning a machine
* Use Ansible or some kind of desired-state configuration so that all the setup isn't in terraform

## Related resources

- [**`openoakland/terraform-modules`.**][modules] Collection of Terraform modules used to manage digital infrastructure.


[1]: https://en.wikipedia.org/wiki/Infrastructure_as_Code
[2]: https://brew.sh/
[modules]: https://github.com/openoakland/terraform-modules
[setup]: https://github.com/openoakland/infra/blob/master/README.setup.md
