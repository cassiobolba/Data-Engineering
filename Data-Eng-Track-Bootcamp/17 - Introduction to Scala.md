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