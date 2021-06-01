// DISCLAIMER
// BELOW ARE SNIPPETS OF THE CODE REGRADDING THE 21 GAME CARD DONEDURING THE COURSE
// THE STILL NEEDS TO BE CREATED

// Define immutable variables for clubs 2♣ through 4♣
val twoClubs: Int = 2
val threeClubs: Int = 3
val fourClubs: Int = 4
val aceClubs = 1
val aceDiamonds = 1
val aceHearts = 1
val aceSpades = 1

// Define immutable variables for player names
val playerA: String = "Alex"
val playerB: String = "Chen"
val playerC: String = "Marta"

// Creating the players list
val players1 = List("Alex","Chen")
val players2 = List("Vic","Cassio")
val allPlayers = players1 ::: players2

// Choose 
val hand = 

// define the functio taking hand as int, then insinde {} id the function
def bust(hand: int) = {
    hand > 21
}

// function to compare and show the biggest hand
def maxHand(handA: Int, handB: Int): Int = {
  if (bust(handA) & bust(handB)) println(0)
  else if (bust(handA)) println(handB)
  else if (bust(handB)) println(handA)
  else if (handA > handB) println(handA)
  else handB
}

// Create, parameterize, and initialize an array for a round of Twenty-One
// In this exercise it is done at same time, different from previous one
val hands = Array(tenClubs  + fourDiamonds,
              nineSpades  + nineHearts,
              twoClubs  + threeSpades)

// Inform a player where their current hand stands
val informPlayer: String = {
  if (hand > 21)
    "Bust! :("
  else if (hand == 21)
    "Twenty-One! :)"
  else  
    "Hit or stay?"
}

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
