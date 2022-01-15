# 1.Introduction
* Git CI is a tool to create CI (continuoous Integration) and CD (continuous Deployment)
* It uses Git to mantain code versioning and control
* Uses repository structure
## My first Git CI Pipeline
* Check the FILE gitlab-ci<my first pipeline>.yml in this repo
* to use in Git project, remove <> and what is inside

## Git Architecture
* Git server manages the repos and pipelines in their database
* Server sends to Git Lab runner run the pipelines and save artifacts
* Can scale runners easily
* flexible and modern CI CD
* Git runner use git runner based on its own docker image by default
* after job runs, runner is destroied
* Can check the runners config in admin > pipelines
* Can specify your own runners for specific projects

## Why Git CI ?
* Docker first based
* Simple and scalable
* Pipeline as a code
* MR with CI support

## Cost
* can check prices on Git Lab page
* can run on Git Server or in your own server
* on Git server, is paied per user

# 2. Basic CI/CD Workflow with Git Lab
CI CD IMAGE
## CI : 
* Integrate your code, with others code, with code in production
* Did the changes afected the current functionalities? Testing
* Cont. feedback and quality check
## CD :
* Usually need the CI part
* Review and test in different environment (branch , dev , hml)
* Deploied in all enviromnet automatically
* Reduce Integration problems because error are detected forehead 

# 3. Git CI Fundamentals
## Enviroment Variables
Check the Env Var available:    
https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
```yml

```
