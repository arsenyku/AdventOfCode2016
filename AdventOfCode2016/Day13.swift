//
//  Day13.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-13.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

let designerFavouriteNumber = 1362

fileprivate class Tile
{
  var x:Int = 0
  var y:Int = 0
  var magicNumber:Int = designerFavouriteNumber
  
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

func AStarPathFinder()
{
  
}


func day13()
{

}




