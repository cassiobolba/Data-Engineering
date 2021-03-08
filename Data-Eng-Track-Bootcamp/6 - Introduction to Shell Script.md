# INTRODUCTION TO SHELL

These are my notes regarding the chapter 5 out of 19, in the Data Enginnering learning path at www.datacamp.com

## TABLE OF CONTENTS

- [INTRODUCTION TO SHELL](#introduction-to-shell)
  * [1. MANIPULATING FILES AND DIRECTORIES](#1-manipulating-files-and-directories)
    + [1.1 HOW THE SHELL COMPARE TO A DESKTOP INTERFACE?](#11-how-the-shell-compare-to-a-desktop-interface-)
    + [1.2 Where am I?](#12-where-am-i-)
    + [1.3 How Can I identify Files and Directories?](#13-how-can-i-identify-files-and-directories-)
    + [1.4 How else can I identify Files and Directories?](#14-how-else-can-i-identify-files-and-directories-)
    + [1.5 How can I to another Directories?](#15-how-can-i-to-another-directories-)
    + [1.6 How can I move up a Directory?](#16-how-can-i-move-up-a-directory-)
    + [1.7 How can I copy files?](#17-how-can-i-copy-files-)
    + [1.8 How can I move files?](#18-how-can-i-move-files-)
    + [1.9 How can I rename files?](#19-how-can-i-rename-files-)
    + [1.10 How can I delete files?](#110-how-can-i-delete-files-)
    + [1.11 How can I delete and create directories?](#111-how-can-i-delete-and-create-directories-)
  * [2. MANIPULATING DATA](#2-manipulating-data)
    + [2.1  How can I file's content?](#21--how-can-i-file-s-content-)
    + [2.1  How can I file's content piece by piece?](#21--how-can-i-file-s-content-piece-by-piece-)
    + [2.3 How can I look at the start of a file?](#23-how-can-i-look-at-the-start-of-a-file-)
    + [2.4 How can I type less?](#24-how-can-i-type-less-)
    + [2.5 How can I control what commands do?](#25-how-can-i-control-what-commands-do-)
    + [2.6 How can I list everything below a directory?](#26-how-can-i-list-everything-below-a-directory-)
    + [2.7 How can I get help for a command?](#27-how-can-i-get-help-for-a-command-)
    + [2.8 How can I select columns from a file?](#28-how-can-i-select-columns-from-a-file-)
    + [2.9 What can't cut do?](#29-what-can-t-cut-do-)
    + [2.10 How can I repeat commands?](#210-how-can-i-repeat-commands-)
    + [2.11 How can I select lines containing specific values?](#211-how-can-i-select-lines-containing-specific-values-)
    + [2.12 Why isn't it always safe to treat data as text?](#212-why-isn-t-it-always-safe-to-treat-data-as-text-)
  * [3. COMBINING TOOLS](#3-combining-tools)
    + [3.1 How can I store a command's output in a file?](#31-how-can-i-store-a-command-s-output-in-a-file-)
    + [3.2 How can I use a command's output as an input?](#32-how-can-i-use-a-command-s-output-as-an-input-)
    + [3.3 What's a better way to combine commands?](#33-what-s-a-better-way-to-combine-commands-)
    + [3.4 How can I combine many commands?](#34-how-can-i-combine-many-commands-)
    + [3.5 How can I count the records in a file?](#35-how-can-i-count-the-records-in-a-file-)
    + [3.6 How can I specify many files at once?](#36-how-can-i-specify-many-files-at-once-)
    + [3.7 How can I sort lines of text?](#37-how-can-i-sort-lines-of-text-)
    + [3.8 How can I remove duplicate lines?](#38-how-can-i-remove-duplicate-lines-)
    + [3.9 How can I save the output of a pipe?](#39-how-can-i-save-the-output-of-a-pipe-)
    + [3.10 How can I stop a running program?](#310-how-can-i-stop-a-running-program-)
    + [3.11 Wrap up](#311-wrap-up)
  * [4. BATCH PROCESSING](#4-batch-processing)
    + [4.1 How does the shell store information?](#41-how-does-the-shell-store-information-)
    + [4.2 How can I print a variable's value?](#42-how-can-i-print-a-variable-s-value-)
    + [4.3 How else does the shell store information?](#43-how-else-does-the-shell-store-information-)
    + [4.4 How can I repeat a command many times?](#44-how-can-i-repeat-a-command-many-times-)
    + [4.5 How can I repeat a command once for each file?](#45-how-can-i-repeat-a-command-once-for-each-file-)
    + [4.6 How can I record the names of a set of files?](#46-how-can-i-record-the-names-of-a-set-of-files-)
    + [4.7 A variable's name versus its value](#47-a-variable-s-name-versus-its-value)
    + [4.8 How can I run many commands in a single loop?](#48-how-can-i-run-many-commands-in-a-single-loop-)
    + [4.9 Why shouldn't I use spaces in filenames?](#49-why-shouldn-t-i-use-spaces-in-filenames-)
    + [4.10 How can I do many things in a single loop?](#410-how-can-i-do-many-things-in-a-single-loop-)
  * [5. Creating new tools](#5-creating-new-tools)
    + [5.1 How can I edit a file?](#51-how-can-i-edit-a-file-)
    + [5.2 How can I record what I just did?](#52-how-can-i-record-what-i-just-did-)
    + [5.3 How can I save commands to re-run later?](#53-how-can-i-save-commands-to-re-run-later-)
    + [5.4 How can I re-use pipes?](#54-how-can-i-re-use-pipes-)
    + [5.5 How can I pass filenames to scripts?](#55-how-can-i-pass-filenames-to-scripts-)
    + [5.6 How can I process a single argument?](#56-how-can-i-process-a-single-argument-)
    + [5.7 How can one shell script do many things?](#57-how-can-one-shell-script-do-many-things-)
    + [5.8 How can I write loops in a shell script?](#58-how-can-i-write-loops-in-a-shell-script-)
    + [5.9 How can I write loops in a shell script?](#59-how-can-i-write-loops-in-a-shell-script-)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## 1. MANIPULATING FILES AND DIRECTORIES
This chapter is a brief introduction to the Unix shell. You'll learn why it is still in use after almost 50 years, how it compares to the graphical tools you may be more familiar with, how to move around in the shell, and how to create, modify, and delete files and folders.

### 1.1 HOW THE SHELL COMPARE TO A DESKTOP INTERFACE?
Humans use graphical representations os digital commands, like create folder, move files, delete. But inside, it is just bytes. But before that, we needed to run commands in a **Command Line Shell** to do actions.

* The file system manages files and directories
* File and directories are identified by absolute paths
```shell
/home/repl #directory
/home/repl/text.txt #file
```
### 1.2 Where am I?
Commmand **pwd** to know which directory you are:
```shell
pwd
```
### 1.3 How Can I identify Files and Directories?
Abbreviation of listing is **ls**
```shell
ls
```
Use **ls** + directory path to list what is in there
```shell
ls /home/repl/seasonal
```
### 1.4 How else can I identify Files and Directories?
* Relative path: starts from where you are, don't use / before initial directory call
* Absolute path: independent where you are, type a full location, use / before
```shell
# you are in home, list the files in home/people/season
ls people/season
```
### 1.5 How can I to another Directories?
Move around using **cd** (change directory)
```shell
# you are in home/repl and wanna go to home/repl/season
cd season
# now wanna go back to hom
cd home
```

### 1.6 How can I move up a Directory?
Use **cd ..**
```shell
# move to parent
cd ..
# list home directory (no matter where you are)
ls ~
# go home
cd ~
```

### 1.7 How can I copy files?
use **cp** (copy) 
```shell
# copy summer.csv to backup
cp seasonal/summer.cvs backup/summer.bck
# copy spring.csv and summer.csv from seasonal to backup
cp seasonal/summer.csv seasonal/spring.csv backup
```

### 1.8 How can I move files?
use the **mv**, and mv file .. to move up a directory, or instead ...
```shell
mv seasonal/spring.csv seasonal/summer.csv backup
```

### 1.9 How can I rename files?
also use **mv** to rename
```shell
mv text.txt old_text.txt
```

### 1.10 How can I delete files?
Use **rm** (remove) to delete files. there is no trash bin it is permanently deleted. Passa as many files and directories as you want.
```shell
rm seasonal/summer.csv
```

### 1.11 How can I delete and create directories?
**mv** can also rename directories:
```shell
mv seasonal by-season
```
use rmdir to remove directories, but you must clean all files inside before. It only deletes empty directories. (advanced option is use -r)
```shell
# clean the directory
rm season/file.txt
# delete direct
rmdir season
# create a new dir
mkdir season_new
```

## 2. MANIPULATING DATA
### 2.1  How can I file's content?
use **cat** command
```shell
cat course.txt
```

### 2.1  How can I file's content piece by piece?
use more to open a file page per page. to navigate next page, use **spacebar**, and use **q** to quit.
You can calso open multiple files, the to navigate among files use **:n** to get back use **:p**, to quit use **:q**
```shell
less seasonal/spring.csv seasonal/summer.csv
```

### 2.3 How can I look at the start of a file?
use the **head** command.
```shell
head people/agarwal.txt
```

### 2.4 How can I type less?
type the first chars os a folder or file and the tab.
Type sea + TAB = seasonal/.
Then after seasonal/ type seasonal/au + TAB / seasonal/autumn.csv

### 2.5 How can I control what commands do?
Shell have the flags like **-n** which stands for number. So you can use together with **head** to diplay a number of lines
```shell
head -n 5 seasonal/winter.csv
```

### 2.6 How can I list everything below a directory?
Use the command we know for listing + **-R**, then you gonna see every file in the folder, and the filed in the directories below.
Also, use a second flag **-F** to make a easy read of the **-R** commnad. It eill specidy what is a directory with an / before it, and what is a program with * after it.
```shell
ls  -R -F
```

### 2.7 How can I get help for a command?
Normally, people use **man** to show the manual of a function.
man automatically invokes less, so you may need to press spacebar to page through the information and :q to quit.
This commnad describe a known command, to learn new commands go to stackoverflow or also see the section SEE ALSO in the man command.
```shell
man tail
```

### 2.8 How can I select columns from a file?
The command **cut** is use to select columns by delimiter.
It uses -f (meaning "fields") to specify columns and -d (meaning "delimiter") to specify the separator.
```shell
cut -f 1 -d , seasonal/spring.csv
```
### 2.9 What can't cut do?
It does not understand if the value of a column is separated by , and you use the parameter -d ,.
Be careful, skip that column if possible.

### 2.10 How can I repeat commands?
Press arrow up to go back to previous commands.
use **history** to check a list. Then run the command of your choice by the command id, usually !10, the 10th command in the list.

### 2.11 How can I select lines containing specific values?
The **grep** command can do this. 
For example: print all lines containing bicuspid
```shell
grep bicuspid seasonal/winter.csv
```
There are more parameter in grep:
* -c: print a count of matching lines rather than the lines themselves
* -h: do not print the names of files when searching multiple files
* -i: ignore case (e.g., treat "Regression" and "regression" as matches)
* -l: print the names of files that contain matches, not the matches
* -n: print line numbers for matching lines
* -v: invert the match, i.e., only show lines that don't match
Show the line number where there aren't molar match in the file
```shell
grep -v -n  molar seasonal/spring.csv
```
Count lines containing incisor in 2 files
```shell
grep -c incisor  seasonal/autumn.csv seasonal/winter.csv
```

### 2.12 Why isn't it always safe to treat data as text?
The **paste** command join files
```shell
paste -d , seasonal/autumn.csv seasonal/winter.cs
```
joining the lines with columns creates only one empty column at the start, not two. Since the files had same 2 columns, bu different number of lines, the lines at the bottom gained only one empty columns, not 2 as it was needed.

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/5%20-%20Introduction%20to%20Shell%20Script/fig%201%20-%20paste%20command.JPG"/>   

fig 1 - paste command

## 3. COMBINING TOOLS
### 3.1 How can I store a command's output in a file?
Use the greater than **> name**  to save a commando into a file, it is called **redirection**
```shell
head -n 5 seasonal/summer.csv > top.csv
```
### 3.2 How can I use a command's output as an input?
Suppose you want to get lines 3-5 from one of our data files. You can start by using head to get the first 5 lines and redirect that to a file, and then use tail to select the last 3:
```shell
tail -n 2 seasonal/winter.csv > bottom.csv
```
Now, select the first line from bottom.csv to get the second last row:
```shell
head -n 1 bottom.csv
```

### 3.3 What's a better way to combine commands?
**Redirection** is not the best, because it leaves many files behind to save the commands, and also rely on many lines in history.
**Pipe** like **|** is a good option.
ex: Use cut to select all of the tooth names from column 2 of the comma delimited file seasonal/summer.csv, then pipe the result to grep, with an inverted match, to exclude the header line containing the word "Tooth".
```shell
cut -f 2 -d , seasonal/summer.csv | grep -v Tooth
```
it used the result of cut as the input for the grep

### 3.4 How can I combine many commands?
Can write many pipes.
```shell
cut -d , -f 1 seasonal/spring.csv | grep -v Date | head -n 10
```
will:
* select the first column from the spring data;
* remove the header line containing the word "Date"; and
* select the first 10 lines of actual data.

### 3.5 How can I count the records in a file?
The **wc** can count lines, characteres and words:
* -c count chars
* -w count words
* -l count lines
```shell
grep 2017-07 seasonal/spring.csv | wc -l
```

### 3.6 How can I specify many files at once?
Most shell commands accept many file names, and will apply the command to all the files.
Also, use the * to load all files from a folder like seasonal/*, or all files with a specific extension seasonal/ *.csv.
wild cards:
* ? match a single char
* [**] match any charactere inside the brackets. Ex: 201[78] for year, will find years or 2017 e 2018.
* {...}} match all extensions inside it {*.txt, *.csv}

### 3.7 How can I sort lines of text?
Use the **sort**, to arrange. By default it is ascending and alphabetical
* -n sort numerically
* -r sort reverse
* -b ingnore blanks
* -f turn insensitive
```shell
$ cut -d , -f 2 seasonal/winter.csv | grep -v Tooth | sort -r
```

### 3.8 How can I remove duplicate lines?
Use **uniq** to select unique values, but they have to be in sorted by **sort**. If same values are dispersed they are kept, they must one above each other.
```shell
cut -d , -f 2 seasonal/winter.csv | grep -v Tooth | sort| uniq -c
```
get the second column, remove Tooth, sorting, unique count of each row

### 3.9 How can I save the output of a pipe?
Can use > at the begining also btu then the name comes in the begining, and in the end as usual.
```shell
> result.txt head -n 3 seasonal/winter.csv
```
### 3.10 How can I stop a running program?
The commands and scripts that you have run so far have all executed quickly, but some tasks will take minutes, hours, or even days to complete. You may also mistakenly put redirection in the middle of a pipeline, causing it to hang up. If you decide that you don't want a program to keep running, you can type **Ctrl + C** to end it. This is often written ^C in Unix documentation; note that the 'c' can be lower-case.

### 3.11 Wrap up
To wrap up, you will build a pipeline to find out how many records are in the shortest of the seasonal data files.
```shell
wc -l seasonal/* | grep -v total | sort -n | head-n 1
```

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/5%20-%20Introduction%20to%20Shell%20Script/fig%202%20-%20wrap%20up%20manipulating%20data.JPG"/>

fig 2 - wrap up manipulating data 

## 4. BATCH PROCESSING
### 4.1 How does the shell store information?
The shell stores information in variables. They are called **environment variables**, are available all the time. Environment variables' names are conventionally written in upper case:
* HOME -> /home/repl
* PWD -> pwd
* SHELL -> /bin/bash (the current program running)
* USER -> repl (the user id)
To check all variables, use **set**.

### 4.2 How can I print a variable's value?
To print variables use the **echo** command. It works like print in python.
But to print a variable, you need to use $ before.
```shell
echo $USER
# to get os type
echo $OSTYPE
```

### 4.3 How else does the shell store information?
There is also the **Shell variable** which you can store using = (without spaces) and read with **echo**.
```shell
testing=seasonal/winter.csv
# then use it as you want
head -n 1 $testing
```

### 4.4 How can I repeat a command many times?
Can use **loops** to repeat commands:
```shell
for filetype in gif jpg png; do echo $filetype; done
```
* The structure is for ...variable... in ...list... ; do ...body... ; done
* The list of things the loop is to process (in our case, the words gif, jpg, and png).
* The variable that keeps track of which thing the loop is currently processing (in our case, filetype).
* The body of the loop that does the processing (in our case, echo $filetype).

### 4.5 How can I repeat a command once for each file?
Similar to before, bu changing the text with the extension by the directory to perform the filename.
```shell
for filename in people/* ; do echo $filename ; done
```

### 4.6 How can I record the names of a set of files?
People often set a variable using a wildcard expression to record a list of filenames. For example, if you define datasets like this:
```shell
datasets=seasonal/*.csv
```
then
```shell
for filename in $datasets ; do echo $filename ; done
```

### 4.7 A variable's name versus its value
There are 2 very common mistakes:
* forget the $ before a variable. If you do this, you will be using a text instead the actual variable
* mistype the  variable. dataset=1 then use $datset... nothing will be printed

### 4.8 How can I run many commands in a single loop?
In the body area of your **loop** (after first ; ), you can use **pipes** to perform many actions.
Ex: print the last record for all files in seasonal where line value contain 2017-07:
```shell
for file in seasonal/*.csv ; do grep 2017-07 $file | tail -n 1 ; done
```

### 4.9 Why shouldn't I use spaces in filenames?
If your file spaces in the name, like file name.csv, when performing commands, it can read it as two separate things, file is one, name.csv is other.
For this situations, don't forget to single quote your file as 'file name.csv' and it will be interpreted as a single name.

### 4.10 How can I do many things in a single loop?
You can performa many actions within a **loop**, not with **pipe** because it perform actions in the same file, for example. You can separate actions after the do command with semicolons ; like this:
```shell
for f in seasonal/*.csv; do echo $f; head -n 2 $f | tail -n 1; done
```
it will to the following:

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/5%20-%20Introduction%20to%20Shell%20Script/fig%203%20-%20multiple%20actions%20loop.JPG"/>

fig 3 - multiple actions loop

## 5. Creating new tools
### 5.1 How can I edit a file?
There are many text editors in unix, here we will be using nano. type nano and it will open up. Or, type nano + path of a file
There are many functions within nano, some are displayed in the bottom.

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/5%20-%20Introduction%20to%20Shell%20Script/fig%204%20-%20nano%20interface.JPG"/>

fig 4 - nano UI

### 5.2 How can I record what I just did?
You can look at history and pipe what you just did in a command and save it.
1 - move files from seasonal to home
```shell
cp seasonal/s* ~
```
2 - remove the header Tooth from them and save to a file
```shell
grep -h -v Tooth spring.csv summer.csv > temp.csv
```
3 - save the steps using history and the last 3 steps
```shell
history | tail -n 3 > steps.txt
```

### 5.3 How can I save commands to re-run later?
Since the commands we are creating are just text, we can store it into a file and re-run later just by calling the file using **bash** before it.
1 - create a file caled dates.sh in nano
```shell
nano dates.sh
```
2 - type in the file a command to extract the first column from all of the CSV files in seasonal:
```shell
cut -d , -f 1 seasonal/*.csv
```
3 - run the file using bash
```shell
bash dates.sh
```

### 5.4 How can I re-use pipes?
Files full of shell commands are called **shell scripts**.
We use .sh as convention, is not mandatory. But, can be a good practice to don't mix different extensions doing different things, like .txt being a script and a data source.
```shell
cut -d , -f 1 seasonal/*.csv | grep -v Date | sort | uniq > script.sh
```
bash

### 5.5 How can I pass filenames to scripts?
If you can write a scritp that can be reused in any file, it is more useful.
Let's say your file unique.sh find the unique values in a list and you can reuse for many files, you can wite it like this:
```shell
sort $@ | uniq
```
Instead of using a file name in the sort, you call **$@**, then when running the script, you use the files names as parameter.
```shell
bash unique.sh folder/filenames.csv
```

### 5.6 How can I process a single argument?
You can also use $1, $2 and on as parameters, when you want to use more than one paramenter in a script. Note that the script uses parameters in reverse order.  
For example, you can create a script called column.sh that selects a single column from a CSV file when the user provides the filename as the first parameter and the column as the second:
```shell
cut -d , -f $2 $1
```
To call it:
```shell
bash column.sh seasonal/autumn.csv 1
```

### 5.7 How can one shell script do many things?
You can writte many lines of commands, like one line to find the shortest values and another line to show the highest value.
1 - Create a file called range.sh
```shell
nano range.sh
```
2 - in the nano editor, count with wc ignoring the total line sorting to get the first line, in the second line you just user -r to reverse the sorting and then getting the minimum count.
```shell
wc -l $@ | grep -v total | sort -n | head -n 1
wc -l $@ | grep -v total | sort -n -r | head -n 1
```
3 - run the program in a file
```shell
bash range.sh seasonal/*.csv > range.out
```

### 5.8 How can I write loops in a shell script?
It possible also to use loop insithe the script, being optional to beak the code with semicolon as before or breaking by new lines. Example inside a script range.sh:
```shell
# Print the first and last data records of each file.
for filename in $@
do
    head -n 2 $filename | tail -n 1
    tail -n 1 $filename
done
```
Now,you can also still pipe some command to see some transformation else.
```shell
$ bash range.sh seasonal/*.csv | sort
```

### 5.9 How can I write loops in a shell script?
If you write some code and don't provide file, it will wait forever and will jump top next command. However it will still be looking for that file in the first command.
```shell
head -n 5 | tail -n 3 somefile.txt
```
It will jump to tail command, but head will remain looking for a file.
What should you do?
cancel the search by pressing crtl + c. 
It can also display a message of file not found, but is still necessary to use crtl + c.


