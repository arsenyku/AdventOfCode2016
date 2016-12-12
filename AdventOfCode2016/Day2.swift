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
  
  required init?(withPad pad: [[String]])
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
    self.currentButtonCoordinates = (self.maxRow/2, self.maxColumn/2)
  }
  
  func currentButton() -> String
  {
    return pad[currentButtonCoordinates.row][currentButtonCoordinates.column]
  }
  
  func move(direction:direction)
  {
    switch direction {
    case .Up:
      currentButtonCoordinates.row -= (currentButtonCoordinates.row == 0) ? 0 : 1
    case .Down:
      currentButtonCoordinates.row += (currentButtonCoordinates.row == self.maxRow) ? 0 : 1
    case .Left:
      currentButtonCoordinates.column -= (currentButtonCoordinates.column == 0) ? 0 : 1
    case .Right:
      currentButtonCoordinates.column += (currentButtonCoordinates.column == self.maxColumn) ? 0 : 1
    }
  }
}

func day2()
{
  let pathAndFilename = basePath + "day2-input.txt"
  
  guard let keypad = Keypad(withPad:[["1","2","3"],["4","5","6"],["7","8","9"]])
  else
  {
    print ("oops")
    return
  }
  
  let lines = readLines(pathAndFilename: pathAndFilename)
//  let lines = [ "ULL", "RRDDD", "LURDL", "UUUUD"]
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

  print ("Day 2 Part 1 = \(code)")
  
//  guard let keypad2 = Keypad(withPad:[[],[],[],[],[]])
  
  
}
