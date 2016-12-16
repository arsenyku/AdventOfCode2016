//
//  Day6.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-15.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func testInput() -> [String]
{
  return [
    "eedadn",
    "drvtee",
    "eandsr",
    "raavrd",
    "atevrs",
    "tsrnev",
    "sdttsa",
    "rasrtv",
    "nssdts",
    "ntnada",
    "svetve",
    "tesnvt",
    "vntsnd",
    "vrdear",
    "dvrsen",
    "enarar"
  ]
}

extension Array where Element: Hashable
{
  var antiMode: Element?
  {
    return self.reduce([Element: Int]()) {
      var counts = $0
      counts[$1] = ($0[$1] ?? 0) + 1
      return counts
      }.min { $0.1 < $1.1 }?.0
  }

}

func day6()
{
  let pathAndFilename = basePath + "day6-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter({ !$0.isEmpty })
  //let lines = testInput()
  let messageLength = lines.first!.length
  var modes = [String]()
  var antiModes = [String]()
  
  for c in 0..<messageLength
  {
    let column = lines.map({ $0[c]! })
    modes.append(column.mode!)
    antiModes.append(column.antiMode!)
  }
  
  print ("Day 6 Part 1 = \(modes.joined())")
  print ("Day 6 Part 2 = \(antiModes.joined())")
  
}
