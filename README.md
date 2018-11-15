# Infra

This repo is an experiment to apply the practices of [Infrastructure as Code][1] to OpenOakland. Why?

* *Inclusivity* - Being transparent in our operations promotes collaboration and involvement of many.
* *Documentation* - We will have documentation in source code about why infrastructure changes were made.
* *Sustainability* - With better documentation and better participation, we will build a more sustainable organization.

## Setup (macOS)
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

[1]: https://en.wikipedia.org/wiki/Infrastructure_as_Code
[2]: https://brew.sh/


## Running

Running Terraform
```bash
terraform plan
terraform apply
```

Running Ansible (Councilmatic):
```bash
ansible-playbook -i inventory playbooks/councilmatic/councilmatic.yml
```

## TODO:
* Create an SSH key which isn't anyone's personal key to use for provisioning a machine
* Check in IAM policy needed for people running terraform
* Create an S3 bucket to store terraform state (that is only accessible by the terraformers)
* Use Ansible or some kind of desired-state configuration so that all the setup isn't in terraform
