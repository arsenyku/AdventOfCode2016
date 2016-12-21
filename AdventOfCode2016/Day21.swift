//
//  Day21.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-20.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

enum Direction:String
{
  case left = "left"
  case right = "right"
}

// swap position X with position Y    
//      - means that the letters at indexes X and Y (counting from 0) should be swapped.
func swap(text:String, x:Int, y:Int) -> String
{
  var result = text
  result = result.replace(at: x, with: text[y]!)
  result = result.replace(at: y, with: text[x]!)
  
  return result
}

// swap letter X with letter Y
//      - means that the letters X and Y should be swapped (regardless of where they appear in the string).
func swap(text:String, x:Character, y:Character) -> String
{
  return String(text.characters.map({ element -> Character in
    if (element == x) { return y }
    else if (element == y) { return x }
    else { return element }
  }))
}

// rotate left/right X steps
//      - means that the whole string should be rotated; for example, one right rotation would turn abcd into dabc.
func rotate(text:String, direction:Direction, steps:Int) -> String
{
  let length = text.length
  let adjustment = (direction == .right) ? -steps : steps
  return String(text.characters.enumerated().map({ index, element -> Character in
    var adjustedIndex = (index+adjustment) % length
    adjustedIndex = adjustedIndex  + ( (adjustedIndex < 0) ? length  : 0 )
    return text.characters[ text.index(text.startIndex, offsetBy: adjustedIndex ) ]
  }))
}

// rotate based on position of letter X 
//      - means that the whole string should be rotated to the right based on the index of letter X (counting from 0) as determined before this instruction does any rotations. Once the index is determined, rotate the string to the right one time, plus a number of times equal to that index, plus one additional time if the index was at least 4.
func rotate(text:String, pivotLetter:Character) -> String
{
  let pivotIndex = text.range(of: String(pivotLetter))!.lowerBound
  var steps = text.distance(from: text.startIndex, to: pivotIndex)
  steps = steps + 1 + ( (steps >= 4) ? 1 : 0 )
  return rotate(text: text, direction: .right, steps: steps)
}


// reverse positions X through Y 
//      - means that the span of letters at indexes X through Y (including the letters at X and Y) should be reversed in order.
func reverse(text:String, from x:Int, to y:Int) -> String
{
  let reverseStart = text.index(text.startIndex, offsetBy: x)
  let reverseEnd = text.index(text.startIndex, offsetBy: y)
  return text[text.startIndex..<reverseStart] + String(text[reverseStart...reverseEnd].characters.reversed()) + text[text.index(after: reverseEnd)..<text.endIndex]
}

// move position X to position Y 
//      - means that the letter which is at index X should be removed from the string, then inserted such that it ends up at index Y.
func move(text:String, fromPosition x:Int, toPosition y:Int) -> String
{
  var result = text
  let removalIndex = result.index(result.startIndex, offsetBy: x)
  let charToReinsert = result.remove(at: removalIndex)
  result.insert(charToReinsert, at: result.index(result.startIndex, offsetBy:y))
  return result
}

func scramble(text original:String, instructions:[String]) -> String
{
  var result = original
  for instruction in instructions
  {
    result = scramble(text: result, instruction: instruction)
  }
  return result
}


func scramble(text:String, instruction:String) -> String
{
  let tokens = instruction.components(separatedBy: CharacterSet.whitespaces)
  var result = text
  
  switch tokens[0] {
  case "swap":
    let x = tokens[2]
    let y = tokens[5]
    if (tokens[1] == "position")
    {
      result = swap(text: text, x: Int(x)!, y: Int(y)!)
    }
    else if (tokens[1] == "letter")
    {
      result = swap(text: text, x: Character(x), y: Character(y))
    }
    
  case "rotate":
    if (tokens[1] == "based")
    {
      let x = Character(tokens[6])
      result = rotate(text: text, pivotLetter: x)
    }
    else
    {
      let direction = Direction(rawValue: tokens[1])!
      let x = Int(tokens[2])!
      result = rotate(text: text, direction: direction, steps: x)
    }
    
  case "reverse":
    result = reverse(text: text, from: Int(tokens[2])!, to: Int(tokens[4])!)
    
  case "move":
    result = move(text: text, fromPosition: Int(tokens[2])!, toPosition: Int(tokens[5])!)

  default:
    break
    
  }
  
  return result
}

func unscramble(text password:String, instructions:[String]) -> String
{
  var result = password
  let reverseInstructions = instructions.reversed()

  for instruction in reverseInstructions
  {
    result = unscramble(text: result, instruction: instruction)
  }
  return result
}

func unscramble(text:String, instruction:String) -> String
{
  let tokens = instruction.components(separatedBy: CharacterSet.whitespaces)
  var result = text
  
  let unrotate = [ 1:1, 3:2, 5:3, 7:4, 2:6, 4:7, 6:0, 0:1 ]
  // The Arcana:
  // aka Cheat for the special case where the input text is 8 characters long.  :P    #dontjudgeme
  // 0 -> 1             1L
  // 1 -> 3             2L
  // 2 -> 5             3L
  // 3 -> 7             4L
  // 4 -> 10 % 8 = 2    6L
  // 5 -> 12 % 8 = 4    7L
  // 6 -> 14 % 8 = 6    0L
  // 7 -> 16 % 8 = 0    1L

  switch tokens[0] {
  case "swap":
    let x = tokens[2]
    let y = tokens[5]
    if (tokens[1] == "position")
    {
      result = swap(text: text, x: Int(x)!, y: Int(y)!)
    }
    else if (tokens[1] == "letter")
    {
      result = swap(text: text, x: Character(x), y: Character(y))
    }
    
  case "rotate":
    if (tokens[1] == "based")
    {
      let pivotLetter = Character(tokens[6])
      let pivotScrambledIndex = text.range(of: String(pivotLetter))!.lowerBound
      let scrambledPosition = text.distance(from: text.startIndex, to: pivotScrambledIndex) % text.length
      let steps = unrotate[scrambledPosition]!
      result = rotate(text: text, direction: .left, steps: steps)
    }
    else
    {
      var direction = Direction(rawValue: tokens[1])!
      direction = (direction == .left) ? .right : .left
      let x = Int(tokens[2])!
      result = rotate(text: text, direction: direction, steps: x)
    }
    
  case "reverse":
    result = reverse(text: text, from: Int(tokens[2])!, to: Int(tokens[4])!)
    
  case "move":
    result = move(text: text, fromPosition: Int(tokens[5])!, toPosition: Int(tokens[2])!)
    
  default:
    break
    
  }
  
  return result
}


func day21()
{
  let pathAndFilename = basePath + "day21-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename)

//  let text = "abcdefghijklmnopqrstuvwxyz"
//  print (swap(text: text, x: 0, y: 25))
//  print (swap(text: text, x: "j", y: "r"))
//  print (rotate(text: text, direction: .left, steps: 1))
//  print (rotate(text: text, direction: .left, steps: 5))
//  print (rotate(text: text, direction: .right, steps: 1))
//  print (rotate(text: text, direction: .right, steps: 5))
//  print (rotate(text: text, direction: .right, steps: 25))
//  print (rotate(text: text, pivotLetter: "f"))
//  print (rotate(text: "abdec", pivotLetter: "b"))
//  print (reverse(text: text, from: 0, to: 6))
//  print (reverse(text: text, from: 22, to: 25))
//  print (move(text: "bdeac", fromPosition: 3, toPosition: 0))
  
  print ("Day 21 Part 1 = \(scramble(text: "abcdefgh", instructions: lines))")
  print ("Day 21 Part 2 = \(unscramble(text: "fbgdceah", instructions: lines))")

}
