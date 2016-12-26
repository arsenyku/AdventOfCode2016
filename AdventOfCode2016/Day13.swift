//
//  Day13.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-13.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

let designerFavouriteNumber = 1362

// MARK: Equatable for CubicleTile
fileprivate func ==(lhs: CubicleTile, rhs: CubicleTile) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.magicNumber == rhs.magicNumber
}

fileprivate class CubicleTile: AStarTile  //, Hashable, CustomStringConvertible
{
  var x:Int = 0
  var y:Int = 0
  var magicNumber:Int = designerFavouriteNumber
  
  // The cost of getting from the start node to this node.
  var gScore = Int.max
  
  // The total cost of getting from the start node to the goal
  // by passing by this node. 
  var fScore = Int.max
  
  convenience init(x:Int, y:Int, magicNumber:Int) {
    self.init()
    self.x = x
    self.y = y
    self.magicNumber = magicNumber
  }
  
  func binaryVersion(of number:Int) -> [Bool]
  {
    guard number > 0
      else { return [false] }
    
    let exponentOf2 = Int(floor(log2(Float(number))))
    var result = [Bool]()
    return binaryVersionIter(of: number, exponentOf2: exponentOf2, result: &result)
  }
  
  func binaryVersionIter(of number:Int, exponentOf2:Int, result:inout [Bool]) -> [Bool]
  {
    if (exponentOf2 == 0)
    {
      result = [number > 0]
      return result
    }
    
    let powerOf2 = 2.raise(toPower: exponentOf2)
    
    if (powerOf2 > number)
    {
      result = binaryVersionIter(of: number, exponentOf2:exponentOf2-1, result: &result)
      result.append(false)
    }
    else
    {
      let remain = number - powerOf2
      result = binaryVersionIter(of: remain, exponentOf2: exponentOf2-1, result: &result)
      result.append(true)
    }
    
    return result
    
  }
  
  var isWall:Bool
  {
    var testNumber = x*x + 3*x + 2*x*y + y + y*y
    
    testNumber += magicNumber
    
    let binaryTestNumber = binaryVersion(of: testNumber)
    
    return (binaryTestNumber.filter({$0}).count % 2 == 1)
  }
  
  var drawing: String
  {
    return isWall ? "#" : "."
  }

  func neighbours<T : AStarTile>() -> [T] {
    return [CubicleTile(x: x-1, y: y, magicNumber: magicNumber),
            CubicleTile(x: x, y: y-1, magicNumber: magicNumber),
            CubicleTile(x: x+1, y: y, magicNumber: magicNumber),
            CubicleTile(x: x, y: y+1, magicNumber: magicNumber)]
      .filter({ $0.x >= 0 && $0.y >= 0 && !$0.isWall })
      .map({ $0 as! T })
  }
  
  func distance<T : AStarTile>(to otherTile: T) -> Int
  {
    return abs(x - otherTile.x) + abs(y - otherTile.y)
  }

  var hashString: String
  {
    return "\(x):\(y):\(magicNumber)"
  }
  
  fileprivate func isEquivalent<T : AStarTile>(to otherTile: T) -> Bool
  {
    return hashString == otherTile.hashString
  }

  fileprivate func isGoal<T : AStarTile>(_ goal: T) -> Bool
  {
    guard let goal = goal as? CubicleTile
      else { return false }
    return self == goal
  }
  
  fileprivate static func heuristicCost<T : AStarTile>(start: T, goal: T) -> Int
  {
    return 0
  }
  
  // MARK: Hashable
  var hashValue: Int
  {
    return hashString.hashValue
  }
  
  // MARK: CustomStringConvertible
  var description: String
  {
    return "[\(x):\(y):\(gScore):\(fScore)]"
  }
  
}

fileprivate func validationTest()
{
  let validationNumber = 10
  
  func validationTile(x:Int, y:Int) -> String
  {
    return CubicleTile(x:x, y:y, magicNumber:validationNumber).drawing
  }
  
  for y in 0...6
  {
    var row = ""
    for x in 0...9
    {
      row = row + validationTile(x: x,y: y)
    }
    print (row)
  }

}

func day13(realRun:Bool)
{
  if (!realRun)
  {
    print ("Day 13 Part 1 = 82")
    print ("Day 13 Part 2 = 138")
    return
  }

  let start = CubicleTile(x: 1, y: 1, magicNumber: designerFavouriteNumber)
  let goal = CubicleTile(x: 31, y: 39, magicNumber: designerFavouriteNumber)
  let path = minimumAStarPath(start: start, goal: goal)
  print("Day 13 Part 1 = \(path.count - 1)")
  
  var countOfPathsUnder50Steps = 0
  
  for y in 0...50
  {
    for x in 0...50
    {
      let testGoal = CubicleTile(x: x, y: y, magicNumber: designerFavouriteNumber)
      let testPath = minimumAStarPath(start: start, goal: testGoal)
      let steps = testPath.count - 1

      if (!testPath.isEmpty && steps <= 50)
      {
        countOfPathsUnder50Steps += 1
        print("\(countOfPathsUnder50Steps): \(steps) steps to (\(testGoal.x),\(testGoal.y))")
      }
    }
  }
  
  print("Day 13 Part 2 = \(countOfPathsUnder50Steps)")  

}




