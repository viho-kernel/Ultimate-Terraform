TO provision infra using terraform we have 5 important steps called as Terraform workflow
--> Terraform init (Initializes terraform in an working directory and download necessary plugins.)
--> Terraform validate (Validates the terraform config files with respect to directory you are and make sure all files are syntatically valid and internally consistent.)
--> Terraform plan (Execution plan performs a refresh and determines what actions are necessary to achieve the desired state specified in the configuration files.)
--> Terraform apply (Used to apply the changes required with are speccified in the desired configuration.)
--> Terraform destory (Destroy entire infrastrucutre with single click by mentioning the infra you want. )

#These 5 commands are necessary for you to perform any changes in your infrastructure.

Terraform lanaguage user limited number of top-lvel blocks, which are blocks that can appear outside of any other block in a TF configuration file.

Fundamental Blocks
|- Terraform Block
|- Providers Block
|- Resources Block
Variable Blocks
| - Input Variables Block
| - Output Values Block
| 0 Local Values Block
Calling/Reference Block
| - Data source Block
| - Module Block
Variable Blocks
Calling/ Reference Blocks

# Terraform Block

--- Special block used to configure some behaviours
-- Required Terraform version

- List required providers
  -- Terraform Backend

# Provider Block

. HEART of Terraform
. Terraform relies on providers to interact with Remote Systems
. Declare providers for Terraform to install providers & use them
. Provider configurations belong to Root Module

# Resource Block

Each Resource Block describes one or more Infrastructure Objects

Resource Syntax: How to declare Resources?

Resource Behavior: How Terraform handles resource declarations?

Provisioners: We can configure Resource post-creation actions

Meta-arguments are called extra arguments or any resource to change the behaviour of the resources.

# Arugment references: Are inputs to our resoruce.

# Attribute references: Are outputs to out resource
