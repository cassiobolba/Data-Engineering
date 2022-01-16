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
## 3.1 Predefined Enviroment Variables
* Check the Env Var available:    
https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
* There are an infinity of usages for it
* They are create by the Git Ci Enviroment
* Can be used to idenfy type of branch, user, if MR or Commit
```yml
#examples
$CI_COMMIT_SHA : full commit sha id
$CI_COMMIT_SHOR_SHA : short commit sha
$CI_COMMIT_BRANCH : the branch that is runnig the pipeline

# Usage
build website:
  stage: build
  script:
    - echo $CI_COMMIT_SHORT_SHA
    - sed -i "s/%%VERSION%%/$CI_COMMIT_SHORT_SHA/" ./public/index.html #sed search for %%VERSION%% and replace by the value of $CI_COMMIT_SHORT_SHA 

```

## 3.2 Schedule Pipeline
* Pipelines can be scheduled using cron job
https://docs.gitlab.com/ee/ci/pipelines/schedules.html#pipeline-schedules

## 3.3 Cache to optimize speed
* Some tasks takes more time because it need to download things, like the npm install need to download the package
* Can cache this things to download in a cache folder for a time, and not download everytime
```yml
cache: 
    key: ${CI_COMMI_REF_SLUG} # refer to the current branch, and this download will available for the  job level, or global
    paths:
      - node_modules/ # path to cache the downloads
```
* usgin cache here, will cache globally, if inside a step, would cache only that step
* This will cache everything, usually this is not what we want, because cache download, and upload every run
* Upload all the project to cache may be long also
* Better is to cache only the steps needed
* Suggestions: create a new step only to cache the npm install

## 3.4 Cache x Artifacts
https://docs.gitlab.com/ee/ci/caching/#cache-vs-artifacts
* Similar, but not same
* Artifact: 
    * Used to pass information from one job to another job
    * Used for compiled results from a step to another
* Cache:
    * Used to save execution time
    * Download and save dependencies temporarily 

## 3.5 Deployment Environment
https://docs.gitlab.com/ee/ci/environments/  
* the CD part of pipeline is usually divided into different enviroment to allow testing the changes before productions
* Git Lab has the concepts of environments
* Allow  easy track of deployments
* We know exactly what was deployied and on which env.
* Keep full history of deployments
* Example of deployment in 2 stages, for 2 different envs:
```yml
deploy staging:
    stage: deploy staging
    enviroment: #enviroment label is used to define to which env it will be deployed
        name: staging
        url: http://myuniquedomaincassiobolba-staging.surge.sh
    script: 
        - npm install --global surge
        - surge --project ./public --domain myuniquedomaincassiobolba-staging.surge.sh

production tests:
    image: alpine
    stage: production tests
    enviroment:
        name: production
        url: http://myuniquedomaincassiobolba.surge.sh
    script:
        - apk add --no-cache curl
        - curl -s "https://myuniquedomaincassiobolba.surge.sh" | grep -q "Congratulations"
        - curl -s "https://myuniquedomaincassiobolba.surge.sh" | grep -q "$CI_COMMIT_SHORT_SHA"
```
* Go to Deployments > Enviroments and can check both deployments to different environments