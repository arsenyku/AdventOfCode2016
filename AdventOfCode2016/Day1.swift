//
//  Day1.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class Tile: CustomStringConvertible
{
  let row:Int
  let column:Int
 
  required init(row:Int, column:Int)
  {
    self.row = row
    self.column = column
  }
  
  func distanceFromOrigin() -> Int
  {
    return abs(row) + abs(column)
  }
  
  var description:String
  {
    return "\(row) \(column)"
  }
}

class Board
{
  enum Direction:Int
  {
    case North = 0
    case East
    case South
    case West
    
    func turn(rotation:Rotation) -> Direction
    {
      switch self {
      case .North:
        return rotation == .Clockwise ? .East : .West
      case .East:
        return rotation == .Clockwise ? .South : .North
      case .South:
        return rotation == .Clockwise ? .West : .East
      case .West:
        return rotation == .Clockwise ? .North : .South
      }
    }
   
  }
  
  enum Rotation:String
  {
    case Clockwise        = "R"
    case Counterclockwise = "L"
  }
  
  var position:Tile = Tile(row: 0, column: 0)
  var facing:Direction = .North
  var tiles = [Int:[Int:Tile]]()
  var firstRevisited:Tile? = nil
  
  required init()
  {
    tiles[position.row] = [position.column:position]
  }
  
  func move(rotation:Rotation, distance:Int)
  {
    facing = facing.turn(rotation: rotation)

    for _ in 1...distance
    {
      next()
    }
  }
  
  func next()
  {
    var nextTile:Tile

    switch facing {
    case .North:
      nextTile = Tile(row: position.row+1, column: position.column)
    case .South:
      nextTile = Tile(row: position.row-1, column: position.column)
    case .East:
      nextTile = Tile(row: position.row, column: position.column+1)
    case .West:
      nextTile = Tile(row: position.row, column: position.column-1)
    }
    
    if (firstRevisited == nil)
    {
      firstRevisited = tileAt(row: nextTile.row, column: nextTile.column)
    }
    
    if (nextTile.row != position.row)
    {
      var row = tilesAt(row: nextTile.row)
      row[nextTile.column] = nextTile
      tiles[nextTile.row] = row
      position = nextTile
    }
    else
    {
      var row = tilesAt(row: nextTile.row)
      row[nextTile.column] = nextTile
      tiles[nextTile.row] = row
      position = nextTile
    }
  }

  func tilesAt(row:Int) -> [Int:Tile]
  {
    guard let rowOfTiles = tiles[row]
    else
    {
      tiles[row] = [Int:Tile]()
      return tiles[row]!
    }
    
    return rowOfTiles

  }
  
  func tileAt(row:Int, column:Int) -> Tile?
  {
    let tilesAtRow = tilesAt(row:row)
    
    guard let tile = tilesAtRow[column]
    else { return nil }
    
    return tile
  }

}

func day1()
{
  let input = read(pathAndFilename: basePath + "day1-input.txt")
//  let input = "L5"
  
  let instructions:[(rotation:Board.Rotation, distance:Int)] =
    input.components(separatedBy: ", ")
      .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)  }
      .map { $0.uppercased() }
      .map { (Board.Rotation( rawValue: $0[0]! )!, Int($0.from(substringStart: 1)!)! ) }
  
  let board = Board()
  
  for instruction in instructions
  {
//    print ("MOVE: \(instruction.rotation.rawValue) \(instruction.distance)")
    board.move(rotation: instruction.rotation, distance: instruction.distance)
//    print (board.tiles)
  }
  
  print("Day 1 Part 1 = \(board.position.distanceFromOrigin())")
  print("Day 1 Part 2 = \(board.firstRevisited?.distanceFromOrigin())")
}
