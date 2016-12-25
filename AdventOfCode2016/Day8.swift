//
//  Day8.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-15.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

typealias Pixel = (x:Int, y:Int, on:Bool)
typealias Screen = [Int:[Pixel]]

func createScreen(width:Int, height:Int) -> Screen
{
  var result = Screen()
  
  for y in 0..<height
  {
    var row = [Pixel]()
    for x in 0..<width
    {
      row.append((x: x, y: y, on:false))
    }
    result[y] = row
  }

  return result
}

func rect(screen:Screen, rectWidth:Int, rectHeight:Int) -> Screen
{
  var result = screen
  for row in 0..<rectHeight
  {
    result[row] = result[row]!.map({ $0.x < rectWidth ? ($0.x, $0.y, true) : $0 })
  }
  return result
}

func row(_ row:Int, ofScreen screen:inout Screen) -> [Pixel]
{
  return screen[row]!
}

func column(_ column:Int, ofScreen screen:inout Screen) -> [Pixel]
{
  return screen.map({ $0.value[column] }).sorted(by: { $0.y < $1.y })
}

func rotate<T>(array:Array<T>, direction:Direction, by steps:Int) -> Array<T>
{
  let length = array.count
  let adjustment = (direction == .right) ? -steps : steps
  let rotatedValues = array.enumerated().map({ index, element -> T in
    var adjustedIndex = (index+adjustment) % length
    adjustedIndex = adjustedIndex  + ( (adjustedIndex < 0) ? length  : 0 )
    return array[ adjustedIndex ]
  })
  
  return rotatedValues
}

func rotate(screen:Screen, row rowNumber:Int, by steps:Int) -> Screen
{
  var result = screen
  let rowOfPixels = row(rowNumber, ofScreen: &result)
  var rotatedRow = rotate(array:rowOfPixels, direction:.right, by:steps)

  for pixel in rowOfPixels
  {
    result[pixel.y]![pixel.x] = (pixel.x, pixel.y, rotatedRow[pixel.x].on)
  }
  
  return result
}

func rotate(screen:Screen, column columnNumber:Int, by steps:Int) -> Screen
{
  var result = screen
  let columnOfPixels = column(columnNumber, ofScreen:&result)
  var rotatedColumn = rotate(array:columnOfPixels, direction:.right, by:steps)
  
  for pixel in columnOfPixels
  {
    result[pixel.y]![pixel.x] = (pixel.x, pixel.y, rotatedColumn[pixel.y].on)
  }
//  print ("Rotate by \(steps) COLUMN: \(columnOfPixels)")
  
  return result
}

func swipeCard(screen:Screen, cardData:[String]) -> Screen
{
  var result = screen

  for instruction in cardData
  {
    switch instruction {
    case instruction where instruction.hasPrefix("rect"):
      let tokens = instruction.capturedGroups(withRegex: "rect ([0-9]+)x([0-9]+)")!
      result = rect(screen: result, rectWidth: Int(tokens[0])!, rectHeight: Int(tokens[1])!)

    case instruction where instruction.hasPrefix("rotate row"):
      let tokens = instruction.capturedGroups(withRegex: "rotate row y=([0-9]+) by ([0-9]+)")!
      result = rotate(screen:result, row:Int(tokens[0])!, by: Int(tokens[1])!)
    
    case instruction where instruction.hasPrefix("rotate column"):
      let tokens = instruction.capturedGroups(withRegex: "rotate column x=([0-9]+) by ([0-9]+)")!
      result = rotate(screen:result, column:Int(tokens[0])!, by: Int(tokens[1])!)
    
    default:
      break
    }
    
//    print(screen:result)
  }
  
  return result
}

func print(screen:Screen)
{
  var screenOut = ""
  for y in 0..<screen.count
  {
    let row = screen[y]!
    for x in 0..<row.count
    {
      screenOut += row[x].on ? "!" : "_"
    }
    screenOut += "\n"
  }
  print (screenOut)
}

func countLitPixels(screen:Screen) -> Int {
  return screen.reduce(0, { result, rowData -> Int in
    let row = rowData.value
    let litPixels = row.filter({ pixel -> Bool in return pixel.on }).count
    return result+litPixels
  })
}

func day8()
{
  let pathAndFilename = basePath + "day8-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter({ !$0.isEmpty })

  let screen = createScreen(width: 50, height: 6)
  let postSwipe = swipeCard(screen: screen, cardData: lines)
  
  //  let lines = ["rect 3x2", "rotate column x=1 by 1", "rotate row y=0 by 4", "rotate column x=1 by 1"]
  //  let screen = createScreen(width: 7, height: 3)
  //  let postSwipe = swipeCard(screen: screen, cardData: lines)

  print ("Day 8 Part 1 = \(countLitPixels(screen: postSwipe))")
  print ("Day 8 Part 2 = ZFHFSFOGPO")
}
