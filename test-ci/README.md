# git-jenkins-docker


## Overview
The purpose of this challenge is to know not only about your technical skills, but also:

- Know how do you approach the infrastructure design
- Know how do you explain the solution and communicate

As the position is based on the DevOps world, we ask you to set up a CI/CD pipeline. Basically, you need to set up a repository, connect it to a pipeline with some automation on it, so every time the repository is updated, a new Docker image is build, ready to use it in a deployment.

In this repository we provide you the [containerized application](./app), and the [Dockerfile](./Dockerfile). Is a simple Nginx webserver, serving a static HTML file.

The deadline is **7 days**, starting today (the day you got the email from HR with this information). Feel free to get back to us if you have any questions or concerns, or if for any reason you can't finish within the given timeline.


## Requirements
At least:
1. You must use [GitHub](https://github.com), [Gitlab](https://about.gitlab.com) or any other `git`-like repository for hosting the source code.
2. You must use [Jenkins](https://www.jenkins.io), [GitHub Actions](https://docs.github.com/en/actions), [Gitlab CI/CD](https://docs.gitlab.com/ee/ci/) or any other automation tool for setting up the pipeline.
3. You must use [Docker Hub](https://hub.docker.com) or any other *Docker* container registres like ACR, ECR etc. to save the container images.
4. The pipeline should be triggered when a *Pull request* is merged into `main` or `master` branches of your repository. Direct commits into `main` or `master` are not allowed.
5. You must use as much configuration-as-code (CaC) as possible. Authentication secrets like usernames/passwords/tokens should be isolated from the tools you're using.
6. (BONUS POINT) Deploy the image and run the app somewhere

## Steps
To achieve the requirements, you should follow this procedure:
1. Clone this repository to your repo
2. Set up the pipeline
3. Modify the `index.html` file, changing the content inside `<main></main>` tags for something else i.e. `Hello! I'm [YOUR_NAME]`.
4. Build the docker image and push it to a container registry
5. (BONUS POINT) Deploy the image and run the app somewhere on AKS/EKS/Minikube/Your own Kubernetes cluster, if possible create the CD pipeline in Jenkins for the deployment to Kubernetes cluster.


## Deliverables
You must:
1. Provide the **source code** you used.
2. **Show us** how the CI/CD works with a real example.
