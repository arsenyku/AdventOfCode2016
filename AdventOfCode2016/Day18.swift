//
//  Day18.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-17.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

let safe = "."
let trap = "^"

// MARK: Equatable for Tile
fileprivate func ==(lhs: Tile, rhs: Tile) -> Bool
{
  return lhs.x == rhs.x && lhs.y == rhs.y
}

fileprivate class Tile: Hashable, CustomStringConvertible
{
  let x:Int
  let y:Int
  let isSafe:Bool
  
  required init(x:Int, y:Int, safe:Bool)
  {
    self.x = x
    self.y = y
    self.isSafe = safe
  }
  
  convenience init(x:Int, y:Int, rowAbove:String) {
    let nwIsSafe = rowAbove[0] == safe
    let nIsSafe = rowAbove[1] == safe
    let neIsSafe = rowAbove[2] == safe

    let isTrap = (!nwIsSafe && !nIsSafe && neIsSafe) ||
      (nwIsSafe && !nIsSafe && !neIsSafe) ||
      (!nwIsSafe && nIsSafe && neIsSafe) ||
      (nwIsSafe && nIsSafe && !neIsSafe)
    
    self.init(x:x, y:y, safe:!isTrap)
  }
  
  var drawing: String
  {
    return isSafe ? safe : trap
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
    return drawing
  }
  
  class func tiles(forRowNumber y:Int, withPreviousRow previousRow:String) -> [Tile]
  {
    return previousRow.characters.enumerated().map({ offset, element -> String in
      let atZeroOffset = (0 == offset)
      let previous =
        ( atZeroOffset ? safe : previousRow[offset-1]!) +
        previousRow[offset]! +
        ((offset == previousRow.length-1) ? safe : previousRow[offset+1]!)
      return previous
    }).enumerated().map({ (offset, element) -> Tile in
      let tile = Tile(x:offset, y:y, rowAbove:element)
      return tile
    })
  }
}

fileprivate func computeMap(rows:Int, initialRow:String) -> [[Tile]]
{
  var result = [String]()
  result.append(initialRow)
  
  var resultTiles = [[Tile]]()
  resultTiles.append( initialRow.characters.enumerated().map({ (offset, element) -> Tile in
    return Tile(x:offset, y:0, safe: (element == Character(safe)))
  }) )
  
  for r in 1..<rows
  {
    resultTiles.append( Tile.tiles(forRowNumber: r, withPreviousRow: result.last! ))
    result.append( resultTiles.last!.map({ $0.drawing }).joined() )
    
    if (r % 1000 == 0)
    {
      print ("Generated \(r) rows of the map.")
    }
  }

  return resultTiles
}

let trapStrings = ["^^.", ".^^", "^..", "..^"]

fileprivate func computeSafeTiles(rows:Int, initialRow:String) -> Int
{
  var safeTileCount = initialRow.characters.reduce(0, { ($1 == Character(safe)) ? $0+1 : $0 })
  let tilesInRow = initialRow.length
  var previousRow = initialRow
  for r in 1..<rows
  {
    let currentRow = previousRow.characters.enumerated().map({ (offset, element) -> String in
      let firstElement = (offset == 0)
      let lastElement = (offset == tilesInRow-1)
      let testTiles = (firstElement ? safe : previousRow[offset-1]!) +
                      previousRow[offset]! +
                      (lastElement ? safe : previousRow[offset+1]!)
      return trapStrings.contains(testTiles) ? trap : safe
    })
    
    safeTileCount += currentRow.reduce(0, { ($1 == safe) ? $0+1 : $0 })
    previousRow = currentRow.joined()
    
    if (r % 1000 == 0)
    {
      print ("Generated \(r) rows of the map.")
    }

  }
  
  return safeTileCount
}

func day18(realRun:Bool)
{
  if (!realRun)
  {
    print ("Day 18 Part 1 = 2005")
    print ("Day 18 Part 2 = 20008491")
    return
  }
  
  let pathAndFilename = basePath + "day18-input.txt"
  let numberOfRows = 40
  let initialTileRow = readLines(pathAndFilename: pathAndFilename).first!

//  let numberOfRows = 10
//  let initialTileRow = ".^^.^.^^^^"

  let map = computeMap(rows: numberOfRows, initialRow: initialTileRow)
  
  let safeCount = map.reduce(0, { partialResult, tileRow -> Int in
    let countOfSafeTiles = partialResult + tileRow.filter( {$0.isSafe} ).count
    return countOfSafeTiles
  })
  
  print ("Day 18 Part 1 = \(safeCount)")
  
//  let map2 = computeMap(rows: 400000, initialRow: initialTileRow)
//  let safeCount2 = map2.reduce(0, { partialResult, tileRow -> Int in
//    let countOfSafeTiles = partialResult + tileRow.filter( {$0.isSafe} ).count
//    return countOfSafeTiles
//  })
  
  let safeCount2 = computeSafeTiles(rows:400000, initialRow:initialTileRow)

  print ("Day 18 Part 2 = \(safeCount2)")

}
