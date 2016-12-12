//
//  Day1.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

enum rotation:String
{
  case left = "L"
  case right = "R"
}

enum direction:Int
{
  case North = 0
  case East
  case South
  case West
  
  func turnRight() -> direction
  {
    switch self
    {
      case .North: return .East
      case .East:  return .South
      case .South: return .West
      case .West:  return .North
    }
  }

  func turnLeft() -> direction
  {
    switch self
    {
      case .North: return .West
      case .West:  return .South
      case .South: return .East
      case .East:  return .North
    }
  }
  
  func turn(towards:rotation) -> direction
  {
    if (towards == .left) { return self.turnLeft()  }
    else                  { return self.turnRight() }
  }

}

func day1()
{
  let input = read(pathAndFilename: basePath + "day1-input.txt")
  let instructions:[(rotation:rotation, distance:Int)] =
    input.components(separatedBy: ", ")
        .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)  }
        .map { $0.uppercased() }
        .map { (rotation( rawValue: $0[0]! )!, Int($0.from(substringStart: 1)!)! ) }

  var northSouthDistance = 0
  var eastWestDistance = 0
  var currentDirection = direction.North
  
  for instruction in instructions
  {
    currentDirection = currentDirection.turn(towards: instruction.rotation)
    
    switch currentDirection {
    case .North:
      northSouthDistance += instruction.distance
    case .South:
      northSouthDistance -= instruction.distance
    case .East:
      eastWestDistance += instruction.distance
    case .West:
      eastWestDistance -= instruction.distance
    }
    
  }
  
  let endDistance = abs(northSouthDistance) + abs(eastWestDistance)
  
  print ("Day 1 = \(endDistance)")
  
}
