## Running it locally

- Add your public key into ssh-pub-key. This is usually found under ~/.ssh/id_rsa.pub
- Download the service account json key by follwing the steps at https://cloud.google.com/docs/authentication/getting-started
- Provide authentication credentials by setting the environment variable GOOGLE_APPLICATION_CREDENTIALS
`export GOOGLE_APPLICATION_CREDENTIALS="/home/user/Downloads/service-account-file.json"`