//
//  Day17.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-16.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

fileprivate var passcode = ""

// MARK: Equatable for Tile
fileprivate func ==(lhs: VaultTile, rhs: VaultTile) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.path == rhs.path
}

fileprivate class VaultTile: AStarTile
{
  static let walls:[(x:Int,y:Int)] =
    [(1,0),(2,0),(3,0),(4,0),
     (0,1),(5,1),
     (0,2),(5,2),
     (0,3),(5,3),
     (0,4),(5,4),
     (1,5),(2,5),(3,5),(4,5),
     ]
  
  var x:Int = 0
  var y:Int = 0
  
  var path = ""
  
  // The cost of getting from the start node to this node.
  var gScore = Int.max
  
  // The total cost of getting from the start node to the goal
  // by passing by this node.
  var fScore = Int.max
  
  required init(x:Int, y:Int) {
    self.x = x
    self.y = y
  }
  
  var isWall: Bool
  {
    return VaultTile.walls.contains(where: { $0.x == self.x && $0.y == self.y })
  }
  
  func unlockable(from otherTile:VaultTile) -> Bool
  {
    if isWall
    {
      return false
    }
    
    // Calculate if this tile is unlockable from other tile
    let doorCode = passcode + otherTile.path
    let hash = doorCode.md5()
    var testValue = ""
    
    switch otherTile {
    case _ where otherTile.x < self.x: // EAST or RIGHT of the other tile
      testValue = hash[3]!
      path = otherTile.path + "R"
    case _ where otherTile.x > self.x: // WEST or LEFT of the other tile
      testValue = hash[2]!
      path = otherTile.path + "L"
    case _ where otherTile.y < self.y: // SOUTH or DOWN from the other tile
      testValue = hash[1]!
      path = otherTile.path + "D"
    default:                           // NORTH or UP from the other tile
      testValue = hash[0]!
      path = otherTile.path + "U"

    }
    
    // Any b, c, d, e, or f means that the corresponding door is open
    // Any other character (any number or a) means that the corresponding door is closed and locked.
  
    if ("bcdef".contains(testValue))
    {
      return true
    }
    else
    {
      return false
    }
  }
  
  var drawing: String
  {
    return "#"
  }
  
  func neighbours<T : AStarTile>() -> [T]
  {
    return [VaultTile(x: x-1, y: y),
            VaultTile(x: x, y: y-1),
            VaultTile(x: x+1, y: y),
            VaultTile(x: x, y: y+1)]
      .filter({ $0.unlockable(from: self) })
      .map({ $0 as! T })
  }
 
  func distance<T : AStarTile>(to otherTile: T) -> Int
  {
    return abs(x - otherTile.x) + abs(y - otherTile.y)
  }
  
  func isEquivalent<T:AStarTile>(to otherTile:T) -> Bool
  {
    return hashString == otherTile.hashString
  }
  
  func isGoal<T:AStarTile>(_ goal:T) -> Bool
  {
    return x == goal.x && y == goal.y
  }
  
  static func heuristicCost<T:AStarTile>(start:T, goal:T) -> Int
  {
    return 0
  }
  
  var hashString: String
  {
    return "\(x):\(y):\(path)"
  }
  
  // MARK: Hashable
  var hashValue: Int
  {
    return hashString.hashValue
  }
  
  // MARK: CustomStringConvertible
  var description: String
  {
    let gScoreText = (gScore == Int.max) ? "MAX" : (gScore == Int.min) ? "MIN" : String(gScore)
    return "[\(x):\(y):\(path):\(gScoreText)]"
  }
  
}

fileprivate func validationTest()
{
  let validationNumber = 10
  
  func validationTile(x:Int, y:Int) -> String
  {
    return VaultTile(x:x, y:y).drawing
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

fileprivate func longestPath(start:VaultTile, goal:VaultTile) -> Int
{
  if (start.x == goal.x && start.y == goal.y)
  {
    return 0
  }
  
  let neighbours:[VaultTile] = start.neighbours()
  if (neighbours.count == 0)
  {
    return Int.min
  }
  
  var longest = Int.min
  for neighbour in neighbours
  {
    let longestPathForNeighbour = longestPath(start: neighbour, goal: goal)
    if (longest < longestPathForNeighbour)
    {
      longest = longestPathForNeighbour
    }
  }

  if (longest >= 0)
  {
    longest += 1
  }
  
//  print (start, longest)

  return longest
}

func day17(realRun:Bool)
{
  if (!realRun)
  {
    print ("Day 17 Part 1 = RDULRDDRRD")
    print ("Day 17 Part 2 = 752")
    return
  }
  
  passcode = "pxxbnzuo"
//  passcode = "ihgpwlah"
  
  let start = VaultTile(x: 1, y: 1)
  let goal = VaultTile(x: 4, y: 4)
  let minPath = minimumAStarPath(start: start, goal: goal)
  print("Day 17 Part 1 = \(minPath.reversed().map({ $0.path }).last ?? "?")")
  
  let maxPathLength = longestPath(start: start, goal: goal)
  print("Day 17 Part 2 = \(maxPathLength)")
  

  
}
