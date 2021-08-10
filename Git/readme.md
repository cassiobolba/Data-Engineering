# GIT FOR GIT LAB PROJECTS
## 1. Install (windows)
### 1.1 Download and Install Git
* Download the latest version from: https://git-scm.com/  
* To install, click next until the end.

### 1.2 Configure SSH
* After Instalation, open git and:
```md
ssh-keygen
```
* note the folder where you key will be saved, mine is: "(/c/Users/cassi/.ssh/id_rsa)"
* Define a passphrase


## 2. Main Commands
### Create Users:
```md
git config --global user.name "Cassio Bolba"
git config --global user.email "cassio.bolba@gmail.com"
```
### Create Folder:
```md
mkdir <folder name>
```
### Check Status:
```md
git status
```
### Create a Git Repository:
```md
git init
```
### List content of a folder:
```md
ls
-- use the -a to show hidden folders
ls -a
```
### 2.1 First Commit:
First create a .txt or .md file in the folder (manually on the folder or via VIM).   
Then add it to the staging area and list of file to be commited, it is not commited to Git yet!
```md
git add readme.md
```
Finally commit, adding a -m as comment parameter
```md
git commit -m "My first commit"
```