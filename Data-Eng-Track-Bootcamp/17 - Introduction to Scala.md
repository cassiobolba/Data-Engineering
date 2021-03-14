# INTRODUCTION TO SCALA
**What is Scala**
* General Purpose programing language
* For Functional programing offering STRONG static tyep system
* Based on Java 
* Code is intedented to be compiled in Java Bytecode and run on JVM  
**Flexibility**
* Let you add new types, collections and control structs, like they are native to the language  
**Convinient**
* But, it also has a set of convinient types, collections and control struct

## SCALA CODE AND SCALA INTERPRETER
* Scala combines Object-Oriented and Functional Programing
    * Contributes to scalability
* it is OO:
    * Every value is an object
    * Every operation is a method
* It is functional:
    * Functions are first-class values
    * Programs operations should map an input to an output, rather than changing data in place
* Scala Static Types help avoid bugs
* JVM and JavaScript runtimes let you build high-performance systems
* Easy access to many libraries

### The interpreter
* Use the '$ scala' to initialize the interpreter (after instalation)

<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/17%20-%20Introduction%20to%20Scala/Scala_Interpreter.jpg"/> 

* When you type 2 + 3, it packs, translate to a method and returns an auto-generated result called res0:
* you can use the output in another operation, like res0 * 2

## IMMUTABLE VARIABLES (val) AND VALUE TYPES
The 21 game:  
* Each card has a value
<img src="https://github.com/cassiobolba/Data-Engineering/blob/master/src/img/17%20-%20Introduction%20to%20Scala/21_game_points.jpg"/>   

* Each player start with 2 card
* Each player can aim a new card or stay with the first 2 
* Goal is to have sum 21 or get as close as possible
* If you pass 21, you can't win it anymore

### **val**
* immutable
* assigned by val  
```java
val fourHearts: Int = 4
```
* Can use Double, Float, Int, String, Boolean, Char
* In reality, each type comes with a package, like scala.Int, which is already imported
* And when you compile scala code to java, it will be mapped to the equivalent in java, like java.lang.Interger  
**Exercise**
```java
// Define immutable variables for clubs 2♣ through 4♣
val twoClubs: Int = 2
val threeClubs: Int = 3
val fourClubs: Int = 4

// Define immutable variables for player names
val playerA: String = "Alex"
val playerB: String = "Chen"
val playerC: String = "Marta"
```

## MUTABLE VARIABLES (var) AND TYPE INFERENCE
### **var**  
* Can be reassigned
* Can change the value
```py
var aceSpades: Int = 1
```
## PROS AND CONS OF IMMUTABILITY
* Scala programers rather vals then var
* val assure data won't change accidentally
* It is a form of defesive coding
* Code is easier to understand due to fixed values
* You writte fewer testing codes
* A con is that more memory is needed

## TYPE INFERENCE
* Not needed to say the type, scala infers
* Make the code more concise
* It is also applied for collections
```java
// instead of 
val fourHearts: Int = 4
// Use
val fourHearts = 4
```
**Exercise**  
```java
// Define mutable variables for all aces, use the type inference
var aceClubs = 1
var aceDiamonds = 1
var aceHearts = 1
var aceSpades = 1

// Create a mutable variable for Alex as player A
var playerA = "Alex"

// Change the point value of A♦ from 1 to 11
aceDiamonds = 11
jackClubs = 10

// Calculate hand value for J♣ and A♦
println(jackClubs+aceDiamonds)
```

# WORKFLOWS, FUNCTIONS, COLLECTIONS
## SCRIPTS, APPLICATIONS, AND REAL-WORLD WORKFLOWS
### SCRIPTS  
* A sequence of instruction in a file, executed sequentially  
* Used in smaller projects
* basically it goes to cmd, call scala as the interpreter, then compile the code and run

### COMPILED LANGUAGE VS INTERPRETED LANGUAGE
**Interpreter**  
A programa that directly execute instructions written in a programming language, whitout compilation.  
**Compiler**  
Program that translates source code from a high-level programming language to a lower level language (machine code), to create an executable program.  
COMPILED CODES ARE USUALLY FASTER

### SCALA APPLICATIONS
* Compiled explicitly then run
* Many source files, scripts, compiled individually
* Used in larger programs
* Can be compiled previously, so are faster then scripts

### SCALA WORKFLOWS
Two main ways people prefer to work in Scala:  
* Command Line
* IDE
    * Great for large scale projects
    * IntelluJ IDEA
    * Can also run on Jupyter

### BUILDING APS
* SBT is the most used build tool
* compiles, runs and test

## FUNCTIONS
We will continue writting code based on the our 21 game program
* Functions are invoked to produce a result
* It is composed by parameter list, body and result type
* Ex: Function to find if the hand of player is bust
```java
// define the functio taking hand as int, then insinde {} id the function
def bust(hand: int) = {
    hand > 21
}

// print it
println(bust(20))

// can also use other functions inside the call
println(bust(aceSpaces + King))
```
* Functions are first-class values
* All functions produces results 
* All results have a type
**Exercise**
```java
// function to compare and show the biggest hand
def maxHand(handA: Int, handB: Int): Int = {
  if (handA > handB) handA
  else handB
}
```
```java
// Calculate hand values
val handPlayerA: Int = 19
val handPlayerB: Int = 20

// Find and print the maximum hand value
println(maxHand(handPlayerA, handPlayerB))
```
## COLLECTIONS
* Mutable
* Immutable
    * Cna perform a sort of change, but it actually generates a new collection

### ARRAY
* Mutable sequence of objects
* Can parameterize an array
```java
// parameterize with the type of array objects (here is string) and the lenght of objects (3)
val players: Array[String] = new Array[String](3)
```
* Can initialize the parameters by
```java
players(0) = "Alex"
players(1) = "Chen"
players(2) = "Marta"
// can later on change one value, because arrays are mutable
players(0) = "Cassio"
```
* Values in the array must be of same type
* To use differents types in array, use the any type
```java
// parameterize with the type of array objects (here is string) and the lenght of objects (3)
val mixedTypes: Array[Any] = new Array[Any](3)
```
**Execise**
```java
// Create and parameterize an array for a round of Twenty-One
val hands: Array[Int] = new Array[Int](3)

// Initialize the first player's hand in the array
// The card values used below were already defined in the system
hands(0) = tenClubs + fourDiamonds

// Initialize the second player's hand in the array
hands(1) = nineSpades + nineHearts

// Initialize the third player's hand in the array
hands(2) = twoClubs + threeSpades
```
```java
// Create, parameterize, and initialize an array for a round of Twenty-One
// In this exercise it is done at same time, different from previous one
val hands = Array(tenClubs  + fourDiamonds,
              nineSpades  + nineHearts,
              twoClubs  + threeSpades)
```
```java
// Initialize player's hand and print out hands before each player hits
hands(0) = tenClubs + fourDiamonds
hands(1) = nineSpades + nineHearts
hands(2) = twoClubs + threeSpades
hands.foreach(println)

// Add 5♣ to the first player's hand
hands(0) = hands(0) + fiveClubs

// Add Q♠ to the second player's hand
hands(1) = hands(1) + queenSpades

// Add K♣ to the third player's hand
hands(2) = hands(2) + kingClubs

// Print out hands after each player hits
hands.foreach(println)
```

### LISTS
* Most commonly used collection in scala
* Immutable
```java
// use list if you want immutable lists
val players: List[String] = new List[String](3)
```
* Why use imutable lists?
* It has methods
    * A function that belongs to ans object
* Many list methods
    * mylistname.drop()
    * mylistname.mkString(",")
    * mylistname.reverse

#### Cons (::)
* Since it is ummutable, if you want to add new values to a list, use the cons (::)
```java
// Declaring a list
val players = List("Alex","Chen")
// this below will append to the beggining the new player and create a new list
val newPlayers = "Cassio" :: players
```

#### Nil
* Common way to initialize new lists combines Nil and ::
```java
// concatenae values to a list. Nil is a method that belogs to list objects
val players = "Alex" :: "Chen" :: Nil
```

#### Concatenate lists (:::)
```java
val players1 = List("Alex","Chen")
val players2 = List("Vic","Cassio")
val allPlayers = players1 ::: players2
```
**Exercise**
Let's say we want to create a list of prized for 5 rounds, but later we decided to prepend another round:
```java
// Initialize a list with an element for each round's prize
val prizes = List(10,15,20,25,30)
println(prizes)

// Prepend to prizes to add another round and prize
val newPrizes = 5 :: prizes
println(newPrizes)
```
Concatenating Lists
```java
// The original NTOA and EuroTO venue lists
val venuesNTOA = List("The Grand Ballroom", "Atlantis Casino", "Doug's House")
val venuesEuroTO = "Five Seasons Hotel" :: "The Electric Unicorn" :: Nil

// Concatenate the North American and European venues
val venuesTOWorld = venuesNTOA ::: venuesEuroTO
```

# TYPE SYSTEM, CONTROL STRUCTURES, STYLES
## SCALA'S STATIC TYPE SYSTEM
Some definitions
* Types: restricts possible values a variable can refer, or expressiona can produce, at run time  
* Compile time: When source code is translated into machine code. Ie. Code a computer can read.  
* Run Time: When program executing commands after being compiled, in a JVM
* Static Type Systems: the types are checked before run time ( C, Fortran, Java, Scala)  
* Dynamic Type System: Types are checked on the fly, during the run time (Python, JavaScript, R)  
### Pros os Static Systems
* Increase Performance, due to being static and compiled language
* Properties of your progam are verifies, bugs are caught early
* Safe refactoring, it alerts your in case of an error during refactoring
* Documentation in the form of type anotations make the code self-dorcumented
```java
// :Int ia type annotation
val fourHearts: Int = 4
```
### Cons of Static Systems
* Takes time to check types (before the execution)  
* Code is verbose (is longes, more annoying to write)  
* The language is not flexible (only one way to compose a type)

## CONTROL STRUCTURES
So far we can:
```java
// define variables
val fourHearts: int = 4
// define collections
val hands: Array[Int] = new Array[Int](3)
// define functions
def bust(hand: int) = {
    hand > 21
}
```
Let's add control structures: IF ELSE
```java
def maxHand(handA: Int, handB: Int): Int = {
  if (bust(handA) & bust(handB)) println(0)
  else if (bust(handA)) println(handB)
  else if (bust(handB)) println(handA)
  else if (handA > handB) println(handA)
  else handB
}
```
Common Operators:
> , < , >= , <= , == , != , && , || , ! (not)
**Exercise**
Lets inform the player about his status when he gets cards form the dealers:
```java
// Point value of a player's hand
val hand = sevenClubs + kingDiamonds + threeSpades

// Inform a player where their current hand stands
val informPlayer: String = {
  if (hand > 21)
    "Bust! :("
  else if (hand == 21)
    "Twenty-One! :)"
  else  
    "Hit or stay?"
}

// Print the message
print(informPlayer)
```
In this exercise, you'll create the body a function for your Twenty-One program called pointsToBust, which takes the current hand's point value as an input and calculates the the number of points remaining until 21. As a player, knowing how many additional points it takes to cause your current hand to bust will help you decide whether to hit or stay. The card variables you need and the bust function are already defined for you.
```java
// Find the number of points that will cause a bust
def pointsToBust(hand: Int): Int = {
  // If the hand is a bust, 0 points remain
  if (bust(hand))
    0
  // Otherwise, calculate the difference between 21 and the current hand
  else
    21 - hand
}

// Test pointsToBust with 10♠ and 5♣
val myHandPointsToBust = pointsToBust(tenSpades + fiveClubs)
println(myHandPointsToBust)
```

## WHILE AND THE IMPERATIVE STYLE
* Another control structure
* Loop over hands in the game to see which is a bust
* In scala, expression in the loops must be surrounded by parenthesis
```java
var i = 0
var hands = Array(17,24,21)
while (i > hands.lenght) {
    println(bust(hands(i)))
    i += 1
}
```
**Exercise**
```java
// Define counter variable
var i = 0

// Define the number of loop iterations
var numRepetitions = 3

// Loop to print a message for winner of the round
while (i < numRepetitions) {
  if (i < numRepetitions-1)
    println("winner")
  else
    println("chicken dinner")
  // Increment the counter variable
    i += 1
}
```
Iterate over the hands and print if the hands burts
``` java
// Define counter variable
var i = 0

// Create list with five hands of Twenty-One
var hands = List(16, 21, 8, 25, 4)

// Loop through hands
while (i < hands.length) {
  // Find and print number of points to bust
  println(pointsToBust(hands(i)))
  // Increment the counter variable
  i += 1
}
```


## FOR EACH AND THE FUNCTIONAL STYLE GUIDE
* Scala is a hybrid of functional and imperative style
* Scala nugdes the devs to be functional
* foreach in Scala is nor a built in control structure, it is a method
* We can convert the while loop into a for each
```java
// much more consice
var hands = Array(17,24,21)
hands.foreach(bust)
```
**Exercise**
* Creating a for loop to run a defined functions
```java
// Find the number of points that will cause a bust
def pointsToBust(hand: Int) = {
  // If the hand is a bust, 0 points remain
  if (bust(hand))
    println(0)
  // Otherwise, calculate the difference between 21 and the current hand
  else
    println(21 - hand)
}

// Create list with five hands of Twenty-One
var hands = List(16, 21, 8, 25, 4)

// Loop through hands, finding each hand's number of points to bust
hands.foreach(pointsToBust)
```

# THE ESSENCE OF SCALA
* Functional code can be compared to a pipe with no leaks
* Because functional programing rather map an input to an output rather than changing data at place
* Some benefits of functional style
 * Data won't change inadvertenlty
 * Code is easier to reason about
 * you have to write fewer tests
 * Functions a more reliable and reusable
* But sometimes using imperative can be benefitial
* Scala creators suggest to always go firts for val, imutable and functions with no side effects (functional), if necessary, the go to var, mutable and function with side effects (imperative)
