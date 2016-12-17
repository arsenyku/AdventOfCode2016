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
  return lhs.x == rhs.x && lhs.y == rhs.y
}

fileprivate class Tile: Hashable, CustomStringConvertible
{
  static let walls:[(x:Int,y:Int)] =
    [(0,0),(1,0),(2,0),(3,0),(4,0),(5,0),(6,0),(7,0),(8,0),
     (0,1),(8,1),
     (0,2),(2,2),(4,2),(6,2),(8,2),
     (0,3),(8,3),
     (0,4),(2,4),(4,4),(6,4),(8,4),
     (0,5),(8,5),
     (0,6),(2,6),(4,6),(6,6),(8,6),
     (0,7),
     (0,8),(1,8),(2,8),(3,8),(4,8),(5,8),(6,8),
     ]
  
  static let doors:[(x:Int,y:Int)] =
  [(2,1),(4,1),(6,1),
   (1,2),(3,2),(5,2),(7,2),
   (2,3),(4,3),(6,3),
   (1,4),(3,4),(5,4),(7,4),
   (2,5),(4,5),(6,5),
   (1,6),(3,6),(5,6),(7,6),
   (2,7),(4,7),(6,7),
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
  
  var isDoor:Bool
  {
    return Tile.doors.contains(where: { $0.x == self.x && $0.y == self.y })
  }
  
  func unlockable(from tile:Tile) -> Bool
  {
    if isWall
    {
      return false
    }
    
    if !isDoor
    {
      return true
    }
    
    // Tile is a door.  Calculate if it is open
    let doorCode = passcode + tile.path
    let hash = doorCode.md5()
    var testValue = ""
    
    switch tile {
    case _ where tile.x < self.x: // EAST or RIGHT of the other tile
      testValue = hash[3]!
      path = tile.path + "R"
    case _ where tile.x > self.x: // WEST or LEFT of the other tile
      testValue = hash[2]!
      path = tile.path + "L"
    case _ where tile.y < self.y: // SOUTH or DOWN from the other tile
      testValue = hash[1]!
      path = tile.path + "D"
    default:                      // NORTH or UP from the other tile
      testValue = hash[0]!
      path = tile.path + "U"

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
    return "\(x):\(y)".hashValue
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
    print ("ITER: \(openSet)")
    let current = openSet.sorted(by: { $0.fScore < $1.fScore }).first!
    
    if (current == goal)
    {
      return reconstructPath(cameFrom: cameFrom, start: start, goal: goal);
    }
    
    openSet.remove(current)
    closedSet.insert(current)

    print ("CURRENT: \(current).  NEIGHBOURS: \(current.neighbours.map({ $0.path.characters.last ?? "?" }))")

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

func day17()
{
  passcode = "pxxbnzuo"
  passcode = "ihgpwlah"

  let start = Tile(x: 1, y: 1)
  let goal = Tile(x: 8, y: 8)
  let path = minimumAStarPath(start: start, goal: goal)

  print("Day 17 Part 1 = \(path.reversed().map({ $0.path }))")
  
  
}
