## Running it locally

### Prerequisites
- Add your public key into ssh-pub-key. This is usually found under ~/.ssh/id_rsa.pub
- Download the service account json key by follwing the steps at https://cloud.google.com/docs/authentication/getting-started
- Provide authentication credentials by setting the environment variable GOOGLE_APPLICATION_CREDENTIALS like the example below

`export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/service-account-file.json"`
- Enable the following APIs in the GCP project:
    * Compute Engine API

- Grant the service acccount the following roles:
    * roles/compute.networkAdmin
    * roles/project.editor

### Terraform
To download the gcp provider and the required modules, run:
`terraform init`

To see the changes being applied, run:
`terraform plan`

To apply the changes, run:
`terraform apply`

### Connecting to the instances
To connect to the bastion host and the application host:

* Provide your public SSH key using one of the available options. Make sure you provide this public SSH key to both the Linux bastion host instance and the instance without an external IP address.

* On your local machine, start the ssh-agent to manage your SSH keys for you:


    `eval ssh-agent $SHELL`
* Use the ssh-add command to load your private SSH key from your local computer into the agent. Once added, SSH commands automatically use the private SSH key file for authentication.

    `ssh-add ~/.ssh/PRIVATE_KEY`
    
    Replace PRIVATE_KEY with the name of your private key file.

* In the Google Cloud Console, go to the VM Instances page. In the External IP column, find the external IP address of the Linux bastion host instance. And in the Internal IP column, find the internal IP address of the internal instance that you want to connect to.

* Connect to the Linux bastion host instance using either ssh or gcloud compute ssh. For either option, include the -A argument to enable authentication agent forwarding.

* Connect to the Linux bastion host instance and forward your private keys with ssh:

    `ssh -A USERNAME@BASTION_HOST_EXTERNAL_IP`
Replace the following:

    - USERNAME: the name attached to your SSH key.
    - BASTION_HOST_EXTERNAL_IP: the external IP address of the bastion host instance that you're using to gain access to the internal network.

* From the Linux bastion host instance, use SSH to connect to the instance that doesn't have an external IP address:

`ssh USERNAME@INTERNAL_INSTANCE_IP_ADDRESS`