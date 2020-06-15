# SOFTWARE ENGINEERING WITH PYTHON

- [SOFTWARE ENGINEERING WITH PYTHON](#software-engineering-with-python)
  * [1. SOFTWARE ENGINEERING & DATA SCIENCE](#1-software-engineering---data-science)
    + [1.1 PYTHON, DATA SCIENCE & SOFTWARE ENGINEERING](#11-python--data-science---software-engineering)
      - [Benefits of Modularity](#benefits-of-modularity)
      - [Benefits of Documentation](#benefits-of-documentation)
      - [Benefits of Testing](#benefits-of-testing)
    + [1.2 INTRODUCTION TO PACKAGES & DOCUMENTATION](#12-introduction-to-packages---documentation)
    + [1.2 CONVENTIONS AND PEP8](#12-conventions-and-pep8)
      - [what are conventions?](#what-are-conventions-)
  * [2. WRITING A PYTHON MODULE](#2-writing-a-python-module)
    + [2.1 WRITING YOUR FIRST PACKAGE](#21-writing-your-first-package)
      - [Importing local package](#importing-local-package)
    + [2.2 ADDING FUNCTIONALITY TO PACKAGES](#22-adding-functionality-to-packages)
    + [2.3 MAKING YOUR PACKAGES PORTABLE](#23-making-your-packages-portable)
      - [requirement.txt](#requirementtxt)
      - [setup. py](#setup-py)
  * [3. UTILIZING CLASSES](#3-utilizing-classes)
    + [3.1 ADDING CLASSES TO A PACKAGE](#31-adding-classes-to-a-package)
      - [Anatomy of classes:](#anatomy-of-classes-)
      - [Using a class in a package](#using-a-class-in-a-package)
      - [The self Convention](#the-self-convention)
      - [Back to our Text Analyzer Package](#back-to-our-text-analyzer-package)
      - [Using the class in your script](#using-the-class-in-your-script)
    + [3.1 ADDING FUNCTIONALITIES TO CLASSES](#31-adding-functionalities-to-classes)
    + [3.2 CLASSES AND THE DRY PRINCIPLE](#32-classes-and-the-dry-principle)
      - [Intro to Inheritance](#intro-to-inheritance)
      - [Multi-level Inheritance](#multi-level-inheritance)
  * [4. MAINTANABILITY](#4-maintanability)
    + [4.1 DOCUMENTATION](#41-documentation)
      - [Comments:](#comments-)
      - [Docstrings:](#docstrings-)
    + [4.2 READABILITY](#42-readability)
      - [The Zen of Python](#the-zen-of-python)
      - [Warning Signals](#warning-signals)
    + [4.3 UNIT TESTING](#43-unit-testing)
      - [How to test in Python](#how-to-test-in-python)
      - [doctest](#doctest)
      - [pytest](#pytest)
    + [4.4 DOCUMENTATION AND TEST IN PRACTICE](#44-documentation-and-test-in-practice)
      - [Another tools suggested](#another-tools-suggested)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>

## 1. SOFTWARE ENGINEERING & DATA SCIENCE
### 1.1 PYTHON, DATA SCIENCE & SOFTWARE ENGINEERING
Main software engineering concepts discussed here are:
* Modularity
* Documentation
* Testing
* (won't be discussed here, but are important) Version control & git  

#### Benefits of Modularity
Code is better and easier to use and understand if it is modular.
* Improve readability
* Improve maintainability
* Solve problems only once (in the module defined)  

Use packages, classes, and methods to leverage modularity:
```py
# import the pandas PACKAGE
import pandas as pd

# Create some example data
data = {
        'x' : [1,2,3]
        'y' : ['a','b','c']
}

# Create a dataframe CLASS object
df = pd.DataFrame(data)

# Use the plot METHOD
df.plot('x','y')
```
#### Benefits of Documentation
* Show users how to use your project
* Prevent confusion from tour collaborators
* Prevent frustration from future you

#### Benefits of Testing
* Save time over manual testing
* Find and fix more bugs
* Rus tests anytime/anywhere

### 1.2 INTRODUCTION TO PACKAGES & DOCUMENTATION
Pypi is a Python Package Index, and due to it when can easily use pip install to install packages in the command line or shell.
```py
server: $ pip install numpy
```
After installing numpy, you can use its functions. To learn what a specific function does:
```py
help(numpy.busday_count)
```
Use help in basically any function, method or code to learn it.

### 1.2 CONVENTIONS AND PEP8
#### what are conventions?
Rules a community defines as standard. PEP8 is the convention in Python. Some PEP8 most common conventions are:
* Indent inner line in codes
* Space separate chunks of your code
* Comment each piece to better understand what it does
* Import all packages in the top of the file


<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/3%20-%20Software%20Engineering%20in%20Python/fig%201%20-%20PEP%20and%20non%20PEP%20codes.JPG"/>  

fig 1 - PEP and non PEP codes

Use another packages and tools to help you check if you are compliant with PEP8:
* PEP8 extension in visual studio
* pycodestyle (from command line, pip install and run a file on it method, or use in the console)
```py
# Import needed package
import pycodestyle

# Create a StyleGuide instance
style_checker = pycodestyle.StyleGuide()

# Run PEP 8 check on multiple files
result = style_checker.check_files(['nay_pep8.py','yay_pep8.py'])

# Print result of PEP 8 style check
print(result.messages)
```
   
## 2. WRITING A PYTHON MODULE 
### 2.1 WRITING YOUR FIRST PACKAGE
A basic package have at least 1 folder and 1 file.py
* for folder name, use all lower case letter, no spaces, avoid underscore, but use if make readability easier. like *package_name*
* for file, name MUST be *__init__.py* it makes python understand it is a package

#### Importing local package
Since your local package have the below structure, in red are the package files, the rest is you local area and python code.

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/3%20-%20Software%20Engineering%20in%20Python/fig%203%20-%20Portable%20package%20structure.JPG"/>
     
fig 1 - Local package structure  

just need to run the famous import. Can even run the help command, which in this case will only show basic info.

```py
import package_name

help(package_name)
```

### 2.2 ADDING FUNCTIONALITY TO PACKAGES
Let's create a package, we will work to define the functions needed for a text analysis of word usage. The structure will be: a folder "text_analyzer", with 2 files inside: *__init__.py* and **counter_utils.py**, like below:  
```sh
working_dir  
├── text_analyzer  
│    ├── __init__.py  
│    ├── counter_utils.py  
└── my_script.py  
```
In the file **counter_utils.py**, you will write 2 functions to be a part of your package: plot_counter and sum_counters.
```py
# this is the counter_utils.py file
# Import needed functionality
from collections import Counter

# defining our function
def plot_counter(counter, n_most_common=5):
  # Subset the n_most_common items from the input counter
  top_items = counter.most_common(n_most_common)
  # Plot `top_items`
  plot_counter_most_common(top_items)

def sum_counters(counters):
  # Sum the inputted counters
  return sum(counters, Counter())
```
In your my_script, call your new package:
```py
# Import local package
import text_analyzer

# Sum word_counts using sum_counters from text_analyzer
# Consider the word_counts a list of words.  
word_count_totals = text_analyzer.sum_counters(word_counts)

# Plot word_count_totals using plot_counter from text_analyzer
text_analyzer.plot_counter(word_count_totals)
```

### 2.3 MAKING YOUR PACKAGES PORTABLE
Now, to send you package to your friends, you need to add 2 more files to the structure: setup. py and  requirements.txt

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/3%20-%20Software%20Engineering%20in%20Python/fig%203%20-%20Portable%20package%20structure.JPG"/>  

fig 3 - Portable package structure

#### requirement.txt
Contains all needed packages and versions to use your package, to recreate the environment to run it.  
```py
requirements = """
matplotlib>=3.0.0
numpy==1.15.4
pandas<=0.22.0
pycodestyle
"""
```

Users can the run this file in the terminal to install all needs.
```py
cassi: ~$ pip install -r requirements.txt
```

#### setup. py
The most common package used to create the setup.py is the setuptools.
This file make possible to install your package by pip install.  
After having requirements.txt and setup. py, you can then install the packages in that folder
```py
cassi: ~/workdir $ pip install .
```
It will install all packages in that folder.  
In order to make your package installable by pip you need to create a setup.py file. In this exercise you will create this file for the text_analyzer package you've been building.
```py
# Import needed function from setuptools
from setuptools import setup

# Create proper setup to be used by pip
setup(name='text_analyzer',
      version='0.0.1',
      description='Perform and visualize a text anaylsis.',
      author='cassio.bolba@gmail.com',
      packages=['text_analyzer'],
      install_requires=['matplotlib>=3.0.0'])
```

## 3. UTILIZING CLASSES
### 3.1 ADDING CLASSES TO A PACKAGE
To make easy the use of classes is important to know OOP (object oriented programing) to have a clean and readable code.
#### Anatomy of classes:
* define the class name with no underscore
* In red, is what appear when you use help in your class
* Define the instance of your class

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/3%20-%20Software%20Engineering%20in%20Python/fig%204%20-%20Anatomy%20of%20classes.JPG"/> 

fig 4 - Anatomy of classes

#### Using a class in a package
Now, import the class created in your init file:
```py
from .myclass import MyClass
```
Then you can use it in your python script:
```py
import my_package
# create the instance
my_instance = my_package.MyClass(value='class attribute value')

# print it out
print(my_instance.attribute)
```
Why we are no seeing the self value as we declared before?

#### The self Convention
Self is a way to declare an instance name without knowing what the user will actually name the instance.  
So, when defining the _init__ you can declare self as first argument, but don't need to call it because is done automatically behind the scenes.  
You can use another name instead of self, but it is highly recommended self according to PEP8

#### Back to our Text Analyzer Package
Considering our package is like below:
```py
working_dir
├── text_analyzer
│    ├── __init__.py
│    ├── counter_utils.py
│    ├── document.py
└── my_script.py
```
Go to the document. py and you'll be creating the beginnings of a Document class that will be a foundation for text analysis in your package.
```py
# Define Document class. this class create a text file
class Document:
    """A class for text analysis
    
    :param text: string of text to be analyzed
    :ivar text: string of text to be analyzed; set by `text` parameter
    """
    # Method to create a new instance of MyClass
    def __init__(self, text):
        # Store text parameter to the text attribute
        self.text = text
```
Add the class in the init
```py
from .document import Document
```

#### Using the class in your script
```py
# Import custom text_analyzer package
import text_analyzer

# Create an instance of Document with datacamp_tweet
my_document = text_analyzer.Document(text=datacamp_tweet)

# Print the text attribute of the Document instance
print(my_document.text)
```

### 3.1 ADDING FUNCTIONALITIES TO CLASSES
Now, our class just convert an object to a text. Let's add more functions to it.
Tokenize separate each word in a file by a separator, let's add it in the init definition
You can define a method as non public, so it is only used inside the package, for package functions and you define as private using _ before method, according to PEP8.
```py
from .token_utils import tokenize
from collections import Counter

class Document:
  def __init__(self, text):
    self.text = text
    # Tokenize the document with non-public tokenize method
    self.tokens = self._tokenize()
    # Perform word count with non-public count_words method
    self.word_counts = self._count_words()

  def _tokenize(self):
    return tokenize(self.text)
	
  # non-public method to tally document's word counts with Counter
  def _count_words(self):
    return Counter(self.tokens)
```
How to use this class:
```py 
# create a new document instance from datacamp_tweets and transform it in a class document
datacamp_doc = Document(datacamp_tweets)

# print the first 5 tokens from datacamp_doc, using the tokens class
print(datacamp_doc.tokens[:5])

# print the top 5 most used words in datacamp_doc using the count words class
print(datacamp_doc.word_counts.most_common(5))
```
Thanks to the functionality you added to the __init__ method, your users get the benefits of tokenization and word counts without any extra effort.

### 3.2 CLASSES AND THE DRY PRINCIPLE
If we want to analyze the result of one class in another class created in another file, we should not break DRY principle.
It stands for Don't repeat yourself. It saves time, reuse code, avoid needing to fix same bug in many places, makes the code reusable.

#### Intro to Inheritance
You can create a child class that inherit all features from the parent class. 
For example: We want to further analyze tweeter insights and need to use the same attributes as Document class have before do the analisys. In this case, to don't repeat the code in both files, you can create a child class from the parent document class.
It will live right together with other functions from text analyzer, as tweet.py 

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/3%20-%20Software%20Engineering%20in%20Python/fig%205%20-%20Inheritance.JPG"/>   

fig 5 - Inheritance

How to code a parent child class
```py
# Import the parent class
from text_analyzer import Document

# Define a SocialMedia class that is a child of the `Document class`
class SocialMedia(Document):
    # define the init this way will bring all attributes from parent
   def __init__(self, text):
        Document.__init__(self,text)
        self.hashtag_counts = self._count_hashtags()
        self.mention_counts = self._count_mentions()
        
    def _count_hashtags(self):
        # Filter attribute so only words starting with '#' remain
        return filter_word_counts(self.word_counts, first_char='#')      
    
    def _count_mentions(self):
        # Filter attribute so only words starting with '@' remain
        return filter_word_counts(self.word_counts, first_char='@')
```
How to call it:
```py
# Import custom text_analyzer package
import text_analyzer

# Create a SocialMedia instance with datacamp_tweets
dc_tweets = text_analyzer.SocialMedia(text=datacamp_tweets)

# Print the top five most most mentioned users
print(dc_tweets.mention_counts.most_common(5))

# Plot the most used hashtags
text_analyzer.plot_counter(dc_tweets.hashtag_counts)
```

#### Multi-level Inheritance
* A class can give attributes to child classes, and also to grand child classes and on
* A child class can receive attributes from more than one Parent Class this is called multilevel inheritance 
* grandchild and multilevel use the super() function
* Use the command dir(class) to now all methods a class or function contains


## 4. MAINTANABILITY
### 4.1 DOCUMENTATION
#### Comments: #
* In python documentation is lead by comments.
* Comments are to make the code easier to understand for devs;
* Not seen by end user unless they access the code;
* Use to explain the code;

#### Docstrings:
* used for documentation, to generate results for help
* Final users can access without accessing the code
```py
"""
square of the number - explanation

Additional details

:param x: number to square
:return: explain any other parameters

>>>> # Example Functions usage
Expected output of example function usage
"""
```

### 4.2 READABILITY
#### The Zen of Python
Find a poem that explains the concepts of readability in python using *import this*. Check it out to get inspired. Some good practices are:
* Descriptive naming: When creating a funtion, use meaninful variables, not x or y, use temp, text, of whatever is expected to be there. This is also known as self descriptive code;
* Provide help desciptions for functions;
* If in doubt of using comments, then do it. Overcommented is better than undercommented;
* Don't complicate code: break it in pieces to be reusable, not only inside the code, but outside. Example of making pizza, don't use all the steps of cooking inside the same function, it will restricted. Write an external function for each step, then call all of them inside the final step.

#### Warning Signals
* Functions should accomplish only one thing, if they do many many things, must be a warning. Split it up!
* If is hard to think of a good meaninful name, it is not an easy funtion

### 4.3 UNIT TESTING
* Confirm code is working fine
* Ensure on function don't break other
* Protect against changes in dependency

#### How to test in Python
We will cover doctest and pytest

#### doctest
* A library to test code in the file
* After creating the code, import doctest and your functions for testing
* Used for small test functions not to test a dataframe for example
Example of doc test
```py
def square(x):
"""Square the number x
:param x: number to square
:return: x squared
>>> square(3)
9
"""
return x ** x
import doctest
doctest.testmod()
```
In this case, it would return error, because the ** means square root, no multiplication.


#### pytest
* For larges tests
* Usually creates a separate folder in the package structure to hold the test_script
```py
working_dir
├── text_analyzer
│    ├── __init__.py
│    ├── counter_utils.py
│    ├── document.py
└── my_script.py
└── test.py
```
example os test with pytest:
```py
from collections import Counter
from text_analyzer import SocialMedia

# Create an instance of SocialMedia for testing
test_post = 'learning #python & #rstats is awesome! thanks @datacamp!'
sm_post = SocialMedia(test_post)

# Test hashtag counts are created properly
def test_social_media_hashtags():
    expected_hashtag_counts = Counter({'#python': 1, '#rstats': 1})
    assert sm_post.hashtag_counts == expected_hashtag_counts
```

### 4.4 DOCUMENTATION AND TEST IN PRACTICE
* When you do a nice documentation, you can use **sphinx** to generate a page html from your code documented and host in on GIT, to show a nice page of documentation.
* For CI (continous Integration), you can use **Travis CI**, so you can add new code and travis will test it for you, and let you know if the new code breaks old code. Will also let you kow if the fix will work, and control the release.

#### Another tools suggested 
* Sphinx - Generate beautiful documentation
* Travis CI - Continuously test your code
* GitHub & GitLab - Host your projects with git
* Codecov - Discover where to improve your projects tests
* Code Climate - Analyze your code for improvements in readability