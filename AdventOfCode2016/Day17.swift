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
fileprivate func ==(lhs: Tile, rhs: Tile) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y && lhs.path == rhs.path
}

fileprivate class Tile: Hashable, CustomStringConvertible
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
    return Tile.walls.contains(where: { $0.x == self.x && $0.y == self.y })
  }
  
  func unlockable(from otherTile:Tile) -> Bool
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
  
  var neighbours:[Tile]
  {
    return [Tile(x: x-1, y: y),
            Tile(x: x, y: y-1),
            Tile(x: x+1, y: y),
            Tile(x: x, y: y+1)]
      .filter({ $0.unlockable(from: self) })
  }
  
  func distance(to otherTile:Tile) -> Int
  {
    return abs(x - otherTile.x) + abs(y - otherTile.y)
  }
  
  // MARK: Hashable
  var hashValue: Int
  {
    return "\(x):\(y):\(path)".hashValue
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
    return Tile(x:x, y:y).drawing
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
  // The set of nodes already evaluated.
  var closedSet = Set<Tile>()
  
  // The set of currently discovered nodes still to be evaluated.
  // Initially, only the start node is known.
  var openSet:Set<Tile> = [start]
  
  // For each node, which node it can most efficiently be reached from.
  // If a node can be reached from many nodes, cameFrom will eventually contain the
  // most efficient previous step.
  var cameFrom = [start:start]
  
  start.gScore = 0
  start.fScore = heuristicCost(start: start, goal: goal)
  
  while !openSet.isEmpty
  {
    let current = openSet.sorted(by: { $0.fScore < $1.fScore }).first!
    
    if (current.x == goal.x && current.y == goal.y)
    {
      return reconstructPath(cameFrom: cameFrom, start: start, goal: current);
    }
    
    openSet.remove(current)
    closedSet.insert(current)

//    print ("CURRENT: \(current).  NEIGHBOURS: \(current.neighbours.map({ $0.path.characters.last ?? "?" }))")

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
      else if (tentativeGScore >= neighbour.gScore)
      {
        // This is not a better path.
        continue
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

fileprivate func longestPath(start:Tile, goal:Tile) -> Int
{
  if (start.x == goal.x && start.y == goal.y)
  {
    return 0
  }
  
  if (start.neighbours.count == 0)
  {
    return Int.min
  }
  
  var longest = Int.min
  for neighbour in start.neighbours
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

func runtime(start:DispatchTime, end:DispatchTime) -> Double
{
  let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
  let timeInterval = Double(nanoTime) / 1_000_000_000 // Technically could overflow for long running tests
  return timeInterval
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
  
  let start = Tile(x: 1, y: 1)
  let goal = Tile(x: 4, y: 4)
  
  var runStart = DispatchTime.now() // <<<<<<<<<< Start time
  let minPath = minimumAStarPath(start: start, goal: goal)
  var runEnd = DispatchTime.now()   // <<<<<<<<<<   end time
  print("Day 17 Part 1 = \(minPath.reversed().map({ $0.path }).last ?? "?")")
  print("Elapsed time = \(runtime(start:runStart, end:runEnd))")
  
  runStart = DispatchTime.now()
  let maxPathLength = longestPath(start: start, goal: goal)
  runEnd = DispatchTime.now()
  print("Day 17 Part 2 = \(maxPathLength)")
  print("Elapsed time = \(runtime(start:runStart, end:runEnd))")
  

  
}
