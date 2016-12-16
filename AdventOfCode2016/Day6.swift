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

func day6()
{
  let pathAndFilename = basePath + "day6-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter({ !$0.isEmpty })
  //let lines = testInput()
  let messageLength = lines.first!.length
  var modes = [String]()
  
  for c in 0..<messageLength
  {
    modes.append(lines.map({ $0[c]! }).mode!)
  }
  
  print ("Day 6 Part 1 = \(modes.joined())")
  
}
