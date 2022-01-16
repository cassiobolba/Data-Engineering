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
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/Git/img/CI%20CD%20Pipeline.png" >

## 2.1 CI : 
* Integrate your code, with others code, with code in production
* Did the changes afected the current functionalities? Testing
* Cont. feedback and quality check
## 2.2 CD :
* Usually need the CI part
* Review and test in different environment (branch , dev , hml)
* Deploied in all enviromnet automatically
* Reduce Integration problems because error are detected forehead 

## 2.3 Advantages
* Ensure changes are reliable
* Are able to test and deploy faster
* Reduce risk
* Values come much faster

## 2.4 Docker
* Based on Containers images that allow virtualization
* Image is a file with instructions to download and install all dependencies for cirtual environment
* Docker execute the image and it become a container, similar to a VM
* It is good to create, run and deploy an application with all it needs, in a package
* It isolates versions, so avoid errors of applications that use different versions
* You can select the image you want to run in a CI runner step


# 3. Git CI Fundamentals
## Predefined Enviroment Variables
* Check the Env Var available:    
https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
* There are an infinity of usages for it
```yml
#examples
$CI_COMMIT_SHA : full commit sha id
$CI_COMMIT_SHOR_SHA : short commit sha
$CI_COMMIT_BRANCH : the branch that is runnig the pipeline
_
```
