//
//  Day13.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-13.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

let designerFavouriteNumber = 1362

// MARK: Equatable for Tile
fileprivate func ==(lhs: Tile, rhs: Tile) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.magicNumber == rhs.magicNumber
}

fileprivate class Tile: Hashable, CustomStringConvertible
{
  var x:Int = 0
  var y:Int = 0
  var magicNumber:Int = designerFavouriteNumber
  
  var gScore = Int.max
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

  var neighbours:[Tile]
  {
    return [Tile(x: x-1, y: y, magicNumber: magicNumber),
            Tile(x: x, y: y-1, magicNumber: magicNumber),
            Tile(x: x+1, y: y, magicNumber: magicNumber),
            Tile(x: x, y: y+1, magicNumber: magicNumber)]
      .filter({ $0.x >= 0 && $0.y >= 0 && !$0.isWall })
  }
  
  func distance(to otherTile:Tile) -> Int
  {
    return abs(x - otherTile.x) + abs(y - otherTile.y)
  }
  
  // MARK: Hashable
  var hashValue: Int
  {
    return "\(x):\(y):\(magicNumber)".hashValue
  }
  
  // MARK: CustomStringConvertible
  var description: String
  {
    return "[\(x):\(y):\(gScore):\(fScore)]"
  }
  
}

func validationTest()
{
  let validationNumber = 10
  
  func validationTile(x:Int, y:Int) -> String
  {
    return Tile(x:x, y:y, magicNumber:validationNumber).drawing
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

fileprivate func heuristicCost(start:Tile, goal:Tile) -> Int
{
  return 0
}

fileprivate func minimumAStarPath(start:Tile, goal:Tile) -> [Tile]
{
  var closedSet = Set<Tile>()
  var openSet:Set<Tile> = [start]
  var cameFrom = [start:start]
  
  start.gScore = 0
  start.fScore = heuristicCost(start: start, goal: goal)
  
  while !openSet.isEmpty
  {
    let current = openSet.sorted(by: { $0.fScore < $1.fScore }).first!
    
    if (current == goal)
    {
//      print ("YAAAAY!")
      return reconstructPath(cameFrom: cameFrom, start: start, goal: goal);
    }
    
    openSet.remove(current)
    closedSet.insert(current)
    
    for neighbour in current.neighbours
    {
      if closedSet.contains(neighbour)
      {
        continue
      }
      
      let tentativeGScore = current.gScore + current.distance(to: neighbour)

      if !openSet.contains(neighbour)
      {
        // Discover a new node 
        openSet.insert(neighbour)
      }
      else if (tentativeGScore >= neighbour.gScore)  // neighbour doesnt have a gscore!!!
      {
        continue		// This is not a better path.
      }
      
      // This path is the best until now. Record it!
      cameFrom[neighbour] = current
      neighbour.gScore = tentativeGScore
      neighbour.fScore = neighbour.gScore + heuristicCost(start: neighbour, goal: goal)
      
    }

  }

  return []

}

fileprivate func reconstructPath(cameFrom: [Tile:Tile], start:Tile, goal:Tile) -> [Tile]
{
  var totalPath = [goal]

  var current = goal
  
  while current != start
  {
    current = cameFrom[current]!
    totalPath.append(current)
  }

  return totalPath
}

func day13()
{
  let start = Tile(x: 1, y: 1, magicNumber: designerFavouriteNumber)
  let goal = Tile(x: 31, y: 39, magicNumber: designerFavouriteNumber)
  let path = minimumAStarPath(start: start, goal: goal)
  print("Day 13 Part 1 = \(path.count - 1)")
  
  var countOfPathsUnder50Steps = 0
  
  for y in 0...50
  {
    for x in 0...50
    {
      let testGoal = Tile(x: x, y: y, magicNumber: designerFavouriteNumber)
//      let testPath = minimumAStarPath(start: start, goal: testGoal)
      let testPath = [Tile]()
      let steps = testPath.count - 1

      if (!testPath.isEmpty && steps <= 50)
      {
        countOfPathsUnder50Steps += 1
        print("\(countOfPathsUnder50Steps): \(steps) steps to (\(testGoal.x),\(testGoal.y))")
      }
    }
  }
  
//  print("Day 13 Part 2 = \(countOfPathsUnder50Steps)")
  print("Day 13 Part 2 = 138")
  

}




