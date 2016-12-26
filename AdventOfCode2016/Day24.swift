//
//  Day24.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-25.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

// MARK: Equatable for HashableTile
func ==<T:AStarTile>(lhs: T, rhs: T) -> Bool
{
  return lhs.isEquivalent(to: rhs) // lhs.x == rhs.x && lhs.y == rhs.y && lhs.path == rhs.path
}

protocol AStarTile: Hashable,CustomStringConvertible
{
  var x:Int { get }
  var y:Int { get }

  var gScore:Int { get set }
  var fScore:Int { get set }
  
  var hashString:String { get }

  func neighbours<T:AStarTile>() -> [T]
  func distance<T:AStarTile>(to otherTile:T) -> Int
  func isEquivalent<T:AStarTile>(to otherTile:T) -> Bool
  func isGoal<T:AStarTile>(_ goal:T) -> Bool

  static func heuristicCost<T:AStarTile>(start:T, goal:T) -> Int
}

//class HashableTile:Hashable
//{
//  private let tileHolder:() -> AStarTile
//  var tile: AStarTile { return tileHolder() }
//  
//  init<T: AStarTile>(_ someTile: T)
//  {
//    tileHolder = { someTile }
//  }
//  
//  var hashValue: Int
//  {
//    return tile.hashString.hashValue
//  }
//}

func minimumAStarPath<T:AStarTile>(start startTile:T, goal:T) -> [T]
{
  var start = startTile
  
  // The set of nodes already evaluated.
  var closedSet = Set<T>()
  
  // The set of currently discovered nodes still to be evaluated.
  // Initially, only the start node is known.
  var openSet:Set<T> = [start]
  
  // For each node, which node it can most efficiently be reached from.
  // If a node can be reached from many nodes, cameFrom will eventually contain the
  // most efficient previous step.
  var cameFrom:[T:T] = [start:start]
  
  start.gScore = 0
  start.fScore = T.heuristicCost(start: start, goal: goal)
  
  while !openSet.isEmpty
  {
    let current = openSet.sorted(by: { $0.fScore < $1.fScore }).first!
    
    if (current.isGoal(goal))
    {
      return reconstructPath(cameFrom: cameFrom , start: start, goal: current)
//      return reconstructPath(cameFrom: cameFrom as! [HashableTile:_], start: start, goal: current);
    }
    
    openSet.remove(current)
    closedSet.insert(current)
    
    //    print ("CURRENT: \(current).  NEIGHBOURS: \(current.neighbours.map({ $0.path.characters.last ?? "?" }))")
    let neighbours:[T] = current.neighbours()
    for neighbour in neighbours
    {
      var neighbour = neighbour
      
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
      neighbour.fScore = neighbour.gScore + T.heuristicCost(start: neighbour, goal: goal)
      
    }
    
  }
  
  return []
  
}

fileprivate func reconstructPath<T:AStarTile>(cameFrom: [T:T], start:T, goal:T) -> [T]
{
  var totalPath = [goal]
  
  var current = goal
  
  while !current.isEquivalent(to: start)
  {
    current = cameFrom[current]!
    totalPath.append(current)
  }
  
  return totalPath
}



func day24()
{
  
  
  print ("Day 24 Part 1 =")
  print ("Day 24 Part 2 =")
}
