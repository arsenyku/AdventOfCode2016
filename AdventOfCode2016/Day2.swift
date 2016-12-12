//
//  Day2.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class Keypad
{
  enum direction:String
  {
    case Up =     "U"
    case Down =   "D"
    case Left =   "L"
    case Right =  "R"
  }
  
  let pad:[[String]]
  let maxRow:Int, maxColumn:Int
  var currentButtonCoordinates:(row:Int, column:Int) = (0,0)

  required init?(withPad pad: [[String]], initialButtonCoordinates:(Int,Int))
  {
    maxRow = pad.count - 1

    guard let firstRowLength = pad.first?.count else { return nil }
    maxColumn = firstRowLength - 1
    
    for row in pad
    {
      if (row.count != self.maxColumn + 1)
      {
        return nil
      }
    }
    
    self.pad = pad
    self.currentButtonCoordinates = initialButtonCoordinates
  }
  
  func currentButton() -> String
  {
    return pad[currentButtonCoordinates.row][currentButtonCoordinates.column]
  }
  
  func buttonAt(row:Int, column:Int) -> String?
  {
    guard let result = pad[safe: row]?[safe: column]
    else { return nil }
    
    if result == ""
    {
      return nil
    }
    
    return result;
  }
  
  func move(direction:direction)
  {
    switch direction {
    case .Up:
      currentButtonCoordinates.row -= buttonAt(row: currentButtonCoordinates.row-1, column: currentButtonCoordinates.column) == nil ? 0 : 1
    case .Down:
      currentButtonCoordinates.row += buttonAt(row: currentButtonCoordinates.row+1, column: currentButtonCoordinates.column) == nil ? 0 : 1
    case .Left:
      currentButtonCoordinates.column -= buttonAt(row: currentButtonCoordinates.row, column: currentButtonCoordinates.column-1) == nil ? 0 : 1
    case .Right:
      currentButtonCoordinates.column += buttonAt(row: currentButtonCoordinates.row, column: currentButtonCoordinates.column+1) == nil ? 0 : 1
    }
  }
}

func calculateCode(lines:[String], keypad:Keypad) -> String
{
  var code = ""
  
  for line in lines
  {
    if (line.characters.count == 0) { continue }
    
    for i in 0..<line.characters.count
    {
      keypad.move( direction: Keypad.direction(rawValue: line[i]!)! )
    }
    
    code.append(keypad.currentButton())
  }
  
  return code
}

func day2()
{
  let pathAndFilename = basePath + "day2-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename)
  //  let lines = [ "ULL", "RRDDD", "LURDL", "UUUUD"]
  
  guard let keypad1 = Keypad(withPad:[["1","2","3"],["4","5","6"],["7","8","9"]], initialButtonCoordinates: (1,1))
  else
  {
    print ("oops")
    return
  }
  
  let code1 = calculateCode(lines:lines, keypad:keypad1)
  print ("Day 2 Part 1 = \(code1)")

  guard let keypad2 = Keypad(withPad:[["","","1","",""],["","2","3","4",""],["5","6","7","8","9"],["","A","B","C",""],["","","D","",""]], initialButtonCoordinates:(2,0))
    else
  {
    print ("oops2")
    return
  }

  let code2 = calculateCode(lines:lines, keypad:keypad2)
  print ("Day 2 Part 2 = \(code2)")

}
