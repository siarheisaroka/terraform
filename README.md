# terraform
terraform
# Creating Infrastructure

## TASK 1 - Creating VPC
Change current directory  to `~/tf-epam-lab/base`

Create a network stack for your infrastructure:

-	**VPC**: `name={StudentName}-{StudentSurname}-01-vpc`, `auto_create_subnetworks=false`
-	**Public subnetworks**:
    - `name={StudentName}-{StudentSurname}-01-subnetwork-central`, `cidr=10.10.1.0/24`, `region=us-central1`)
    - `name={StudentName}-{StudentSurname}-01-subnetwork-east`, `cidr=10.10.3.0/24`, `region=us-east1`)

**Hint**: A local value assigns a name to an expression, so you can use it multiple times within a module without repeating it. 

Store all resources from this task in the `network.tf` file.
Store all locals in `locals.tf`.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

### Definition of DONE:

- Terraform created infrastructure with no errors
- GCP resources created as expected (check GCP Console)
- Push *.tf configuration files to git

## TASK 2 - Create a project metadata

Ensure that the current directory is `~/tf-epam-lab/base`

Create a project metadata:

- Create a project metadata refer to [this document](https://cloud.google.com/compute/docs/metadata/overview) and [this document](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_project_metadata).
- Create a `variables.tf` file with empty variable `ssh_key` but with the following description "Provides custom public ssh key". Never store you secrets inside the code!
- Create a `ssh.tf` file with `google_compute_project_metadata` resource. Create a metadata item key `shared_ssh_key`, as a value use an `ssh_key` variable as a public key source.
- Run `terraform plan` and provide required public key. Observe the output and run `terraform plan` again.
- To prevent providing ssh key on each configuration run and staying secure set binding environment variable - `export TF_VAR_ssh_key="YOUR_PUBLIC_SSH_KEY_STRING"`
- Run `terraform plan` and observe the output.

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created infrastructure with no errors
- GCP resources created as expected (check GCP Console)
- Push *.tf configuration files to git

## TASK 3 - Create a Cloud Storage Bucket

Ensure that the current directory is  `~/tf-epam-lab/base`

Create a Cloud Storage bucket as the storage for your infrastructure:

-	Create `storage.tf`. Name your bucket "epam-gcp-tf-lab-${random_string.my_numbers.result}" to provide it with partition unique name. See [random_string](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) documentation for details.
-	Set bucket acl as private. Never share your bucket to the whole world!

Equip the bucket with following labels:
    - `Terraform=true`, 
    - `epam-tf-lab`
    - `Owner={StudentName}_{StudentSurname}`

Run `terraform validate` and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created infrastructure with no errors
- GCP resources created as expected (check GCP Console)
- Push *.tf configuration files to git

## TASK 4 - Create IAM Resources
Ensure that the current directory is  `~/tf-epam-lab/base`

Create IAM resources:

-	Create **Service account**, attach the `Project Owner` permission to it.

Store all resources from this task in the `iam.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created infrastructure with no errors
- GCP resources created as expected (check GCP Console)
- Push *.tf configuration files to git

## TASK 5 - Create Firewall rules
Ensure that the current directory is  `~/tf-epam-lab/base`

Create the following resources:

-	Firewall rule (`name=ssh-inbound`, `port=22`, `allowed_ip_ranges="your_IP or EPAM_office-IP_ranges"`, `description="allows ssh access from safe IP-range"`, `target_tags=web-instances`).
-	Firewall rule (`name=http-inbound`, `port=80`, `allowed_ip_ranges="130.211.0.0/22", "35.191.0.0/16"`, `description="allows http access from LoadBalancer"`, `target_tags=web-instances`). 

**Hint:** These firewall should be created for the VPC which was created in the Task 1
**Note:** "130.211.0.0/22", "35.191.0.0/16" are IP ranges of the GCP health checkers. See [there](https://cloud.google.com/load-balancing/docs/firewall-rules)

Store all resources from this task in the `network_security.tf` file.

Equip all resources with following labels:
- `Terraform=true`, 
- `Project=epam-tf-lab`
- `Owner={StudentName}_{StudentSurname}`

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying  your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Terraform created infrastructure with no errors
- AWS resources created as expected (check AWS Console)
- Push *.tf configuration files to git

## TASK 6 - Form TF Output
Ensure that current directory is  `~/tf-epam-lab/base`

Create outputs for your configuration:

- Create `outputs.tf` file.
- Following outputs are required: `vpc_id`, `subnetworks_ids`[set of strings], `service_account_email`, `project_metadata_id`, `bucket_id`.

Store all resources from this task in the `outputs.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready. You can update outputs without using `terraform apply` - just use the `terraform refresh` command.

### Definition of DONE:

- Push *.tf configuration files to git

## TASK 7 - Configure a remote data source

Learn about [terraform remote state data source](https://www.terraform.io/docs/language/state/remote-state-data.html).

! Change the current directory to  `~/tf-epam-lab/compute`
! Copy `root.tf` from `~/tf-epam-lab/base` to `~/tf-epam-lab/compute`

Add remote state resources to your configuration to be able to import output resources:

-	Create a data resource for base remote state. (backend="local")

Store all resources from this task in the `data.tf` file.

Run `terraform validate`  and `terraform fmt` to check if your configuration is valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when ready.

### Definition of DONE:

- Push *.tf configuration files to git

## TASK 8 - Create VM Instance/Instance Group/Load Balancer

Ensure that the current directory is  `~/tf-epam-lab/compute`

Create instance groups resources for subnetworks' regions:

- Create a Instance Template resources for subnetworks' regions:   
  - `name=epam-gcp-tf-lab-{region}`,
  - `source_image="debian-cloud/debian-10"`,
  - `machine_type=f1-micro`,
  - `tags="web-instances"`,
  - `key_name`,
  - `service_account`,
  - `startup-script`
- Author a Startup bash script which should get 2 parameters on instance start-up and send it to a Cloud Storage Bucket as a text file with instance_id as its name:

User Data Details:

Getting VM Metadata
```
VM_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid |tr '[:upper:]' '[:lower:]')
INSTANCE_ID=$(replace this text with request instance id from metadata e.g. using curl)
```
command to send text to S3 bucket (**use data rendering to pass the Bucket Name to this script**):
```
This message was generated on instance {INSTANCE_ID} with the following UUID {VM_MACHINE_UUID}
echo "This message was generated on instance ${INSTANCE_ID} with the following UUID ${VM_MACHINE_UUID}" | aws s3 cp - s3://{Backet name from task 3}/${INSTANCE_ID}.txt
```
**Note:** Without assigned service account requests to metadata service won't work


- Create an `google_compute_region_instance_group_manager` resource:
  - `name=epam-gcp-tf-lab-{region}`,
  - `target_size=1`,
  - `instance_template=epam-gcp-tf-lab-{region}`
- Create a Global HTTP Loadbalancer and attach it to an instance group with `google_compute_health_check`.

Store all resources from this task in the `application.tf` file.

Ensure that all instances in the instance groups contain:
    - `Terraform=true`, 
    - `Project=epam-tf-lab`
    - `Owner={StudentName}_{StudentSurname}`

Please keep in mind that instance groups or an instance templates require using a special format for `labels` section!

Run `terraform validate` and `terraform fmt` to check if your configuration valid and fits to a canonical format and style. Do this each time before applying your changes.
Run `terraform plan` to see your changes.

Apply your changes when you're ready.

As a result vm instance should be launched by the instance groups and a new file should be created in the Cloud Storage bucket. 

### Definition of DONE:

- Terraform created infrastructure with no errors
- GCP resources created as expected (check GCP Console)
- After a new instance launch, a new text file appears in the cloud storage bucket storage with the appropriate text.
- Push *.tf configuration files to git


