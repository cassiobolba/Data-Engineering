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
