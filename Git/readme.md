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
## 3. First Commit:
First create a .txt or .md file in the folder (manually on the folder or via VIM).   
Then add it to the staging area and list of file to be commited, it is not commited to Git yet!
```md
git add <file name>
```
Finally commit, adding a -m as comment parameter
```md
git commit -m "My first commit"
```
## 4. Staging
### Add multiple files to staging
```md
git add --all
--or
git add .
```
### Unstaging
```md
 git reset HEAD <file name>
```

## 5. Commiting folder
* Git does not track folders
* to track a folder, you must track a file inside it, an can ben an empty file
```md
---create folder
mkdir temp

---create an empty file called gitkeep
touch temp/.gitkeep

--- now can add it an commit
```

## 6. Removing file or folder
remove file
```md
rm <file name>
```
remove folder
```md
rm -rf -- <folder name>
```
After this, need to also add to staging adn also commit.   
Delete is also a git action.

## 7. Ignore file or folder
Lets say I have a private file on a folder:
```md
mkdir private
touch private/config.txt
```
After this, if run git status, it will say to git add config.txt
If I want my config folder not to be included in any commit or add, for some reason, just need to create a .gitignore file and add the file or folder name inside it.
```
-- create the file
vim .gitignore
```
add the file name or folder inside the git ignore and save it.   
Now run git status, and the folders and files inside gitignore will no longer asked to be git add

## 8. Branch
* So far, just used the master branch
* Usually we don't do that, we create a local or test branch
* Is basically like create a copy of the other repository and start in the copy
Create a new branch
```md
git checkout -b feature/table
```
Now you can start developing changes in your files in a different branch.   
You can add theses changes and commit them, without changing the master.  
To change between branches:
```md
-- back to master
git checkout master

-- go to branch again
git checkout feature/table
```

## 9. Merging Branches
After working in a branch, you may want to discard de work:
```md
git branch -D feature/table
```
Mostly, you'd want to merge it in the master/main branch:
* move to the branch you want the changes to be merged in
* run merge specifying the branch to merge to the branch you just moved in
```md
git checkout master
git merge feature/table
```
If you take a look on  git log, it will show a fast foward merge.  
It is when the branch you copied to the new branch have not changed since.  
When the branch you copied changed, your development branch and that branch are no longe compatible, it leads us to advanced merging.  

## 9. Advanced Merge
If you branch master and someone change master before you merge the branch back to master, when you merge your branch to a different master source, you gonna have to create a message saying why doing this.  
This is the Recursive strategy, different from Fast Forward (when master still the same).   
This is not the most common cenário