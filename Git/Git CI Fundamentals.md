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

## 3.6 Define Variables
* Store and reuse values
* create variables as created before in the UI
* Create also in the git CI (but will be exposed)
```yml
variables:
    STAGING_DOMAIN: myuniquedomaincassiobolba-staging.surge.sh
    PRODUCTION_DOMAIN: myuniquedomaincassiobolba.surge.sh
# then reuse in the code
production tests:
    image: alpine
    stage: production tests
    environment:
        name: production
        url: http://$PRODUCTION_DOMAIN
    script:
        - apk add --no-cache curl
        - curl -s "$PRODUCTION_DOMAIN" | grep -q "Congratulations"
        - curl -s "$PRODUCTION_DOMAIN" | grep -q "$CI_COMMIT_SHORT_SHA"
```

## 3.7 Manual Trigger Only
* Set a stage to deploy only manually
https://docs.gitlab.com/ee/ci/yaml/#whenmanual
* It can cause the task after manual to fail, in case of dependencies
* Then use the argument allow_failure to false, to dont run subsequent tasks after manual
https://docs.gitlab.com/ee/ci/yaml/#allow_failure
```yml
deploy production:
    stage: deploy production
    environment:
        name: production
        url: http://$PRODUCTION_DOMAIN
    # use the manual to make it only run in manual
    when: manual
    # Then use the argument allow_failure to false, to dont run subsequent tasks after manual
    allow_failure: false
    script: 
        - npm install --global surge
        - surge --project ./public --domain $PRODUCTION_DOMAIN
```

## 3.8 Merge Requests and Branches
* Avoid Breaking Master
* Breaking master can interrupt services, causing heavy and costly problems
* Ensures CD always possible
* Each Developes can deploy to a branch the new features
* when new features are approved, it can be merged to master
* There are different strategies like GitFlow
* Just avoid using only one branch 

### 3.8.1 Only run in a specific branch
* Use the only parameter
* Only is to specify policies where to run the step
```yml
deploy production:
    stage: deploy production
    only: 
        - master
    environment:
        name: production
        url: http://$PRODUCTION_DOMAIN
    script: 
        - npm install --global surge
        - surge --project ./public --domain $PRODUCTION_DOMAIN
```

## 3.9 What is Merge Request 
* Merge Requests are a good way to visualize new changes that are about to be made in the master branch.
* Instead of making changes directly into master, the Merge Request workflow allows you to:
  * allow others to review the changes
  * allows the pipeline to run once without affecting others or the master branch
  * allows for additional changes to be made
* Allow to see the status of the pipeline for a specific branch
* but also to give other developers the possibility of giving their feedback regarding a feature/fix before it gets merge into master.

## 3.10 Merge Request Configs
* Under setting > Repository:
  * Set protected branches
  * Allow to merge or not
  * Allow to push: Set to no one, to enforce that no one can push directly to master without a Merge Request
* Under Settings > General > Merge Request :
  * Config Fast-Forward
  * Enforce That pipelines must succeed in order to merge

## 3.11 Creating a Merge Request
* Go to branches > create branch
* After create > do a change > commit and push > see the resilt
* If all good, you will a create merge request button o Git lab
* Craete it > after succeed > merge it

## 3.12 Dynamic Environments
* Can create another enviro. dynamically to each branch
* Allow review the changes by devs and also by non developers
* step to deploy a review env and custom names based on the branch as below
* env name and url based on commit name and on env slug, to be dynamic
* domain also dynamic to create a page based on the current env / branch
* In the pipeline, check that the env deployied is review/commit_ref and the domain also is customized based on variable
```yml
deploy review:
    stage: deploy review
    only: 
        - merge_request 
    environment:
        name: review/$CI_COMMIT_REF_NAME 
        url: http://cassiobolba-$CI_ENVIRONMENT_SLUG.surge.sh
    script: 
        - npm install --global surge
        - surge --project ./public --domain cassiobolba-$CI_ENVIRONMENT_SLUG.surge.sh
```

## 3.13 Clean-up Environments
BETTER EXPLANATION https://lab.las3.de/gitlab/help/ci/yaml/README.md#environmentaction
* After mergin the branch to master, the branch enviroment will still continue live, we need to clean it
* use on_stop and action paramenter to be able to connecto jobs one after other for cleaning purporses
* both jobs should be in the same environment
```yml
# step to deploy a review env and custom names based on the branch
deploy review:
    stage: deploy review
    only: 
        - merge_request
    environment:
        # env name and url based on commit name and on env slug, to be dynamic
        name: review/$CI_COMMIT_REF_NAME 
        url: http://cassiobolba-$CI_ENVIRONMENT_SLUG.surge.sh
        on_stop: stop review
    script: 
        - npm install --global surge
        # domain also dynamic to create a page based on the current env / branch
        - surge --project ./public --domain cassiobolba-$CI_ENVIRONMENT_SLUG.surge.sh

# step to enable the destruction of staging environment after merge
stop review:
    stage: deploy review
    # define git strategy to none and it avoid that in case the branch is already deleted, it wont clone the branch to perform the actions, which would be default strategy
    variables:
        GIT_STRATEGY: none
    environment:
        name: review/$CI_COMMIT_REF_NAME 
        action: stop
    script: 
        - npm install --global surge
        # here we use the surge command to delete the surge enviroment
        - surge teardown cassiobolba-$CI_ENVIRONMENT_SLUG.surge.sh
    when: manual
    only: 
        - merge_request
```

## 3.14 before_script and after_script
https://docs.gitlab.com/ee/ci/yaml/#before_script-and-after_script
* before_script
    * define a script that should run before the task or globally
```yml
my_job:
    before_script:
        - echo "test"
```
* after_script
    * define commands to run after the main step block

# 4. YAML basics
## 4.1 Understanding YAML
* It is a key value pair combination
* a key can store string, integer, boolean...
* to create lists:
```yml
stuff:
    - laptop
    - bike
# or
food: [pizza,donuts,coke]
```
* make all as part of an object
```yml
my_stuf:
    stuff:
        - laptop
        - bike
    # this is a comment
    friends:
        - name: cassio
          age: 33
        - name: Vic
          age: 22
```

## 4.2 Disabling in jobs in YAML
* Simply put a dot before the job definition
```yml
.my_stage:
    stage: build
```

## 4.3 Anchors
* anchor a value to reuse it
* alias the reusable object with &name
* if full set of objects reuse with << *name
* if just single object reuse with *name
```yml
basic_stuff: &basic_stuff
    city: nyc
    country: usa

my_stuf:
    <<: *basic_stuff
    name: &name cassio
    stuff:
        - laptop
        - bike
    friends:
        - name: cassio
          age: 33
        - name: Vic
          age: 22
    self: *name
```

## 4.4 Creating job Templates
* We can create a template for deploy jobs since they are similar
```yml
# template created with dot before to dont be created as step
# template was alias as anchor
.deploy_template: &deploy
# put inside template all share info
    only: 
        - master
    # domains were different, we created a generic variable for it, and then we reference the domain to the correct domain within the real step
    script: 
        - npm install --global surge
        - surge --project ./public --domain $DOMAIN
    environment:
        url: http://$DOMAIN

deploy production:
    # call the anchor
    <<: *deploy
    stage: deploy production
    # this variable read the $PRODUCTION_DOMAIN and say its value is assigned to $DOMAIN in this step
    variable:
        DOMAIN: $PRODUCTION_DOMAIN
    environment:
        # the name could not be templated because it has to be unique
        name: production

deploy staging:
    <<: *deploy
    stage: deploy staging
    variable:
        DOMAIN: $STAGING_DOMAIN
    environment: 
        name: staging
```
