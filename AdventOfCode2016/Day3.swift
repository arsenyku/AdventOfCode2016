//
//  Day3.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func possibleTriangle(lengths:[Int]) -> Bool
{
  if (lengths.count != 3) { return false }
  
  return lengths[0]+lengths[1]>lengths[2] &&
         lengths[1]+lengths[2]>lengths[0] &&
         lengths[0]+lengths[2]>lengths[1];

}

func day3()
{
  let pathAndFilename = basePath + "day3-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename)
  var possibleTriangleCount = 0

  for line in lines
  {
    if (line == "") { continue }
  
    let lengths = line.components(separatedBy: CharacterSet.whitespaces)
                  .filter({ !$0.isEmpty })
                  .map({ Int($0)! })
    
    possibleTriangleCount += possibleTriangle(lengths:lengths) ? 1 : 0

  }
  
  print ("Day 3 Part 1 = \(possibleTriangleCount)")

  var triples:[[Int]] = [[Int](),[Int](),[Int]()]
  
  for line in lines
  {
    if (line == "") { continue }

    let lengths = line.components(separatedBy: CharacterSet.whitespaces)
      .filter({ !$0.isEmpty })
      .map({ Int($0)! })

    if (triples.last!.count == 3)
    {
      triples.append([Int]())
      triples.append([Int]())
      triples.append([Int]())
    }
    
    triples[triples.count-3].append( lengths[0] )
    triples[triples.count-2].append( lengths[1] )
    triples[triples.count-1].append( lengths[2] )
  }
  
  possibleTriangleCount = 0
  for triple in triples
  {
    possibleTriangleCount += possibleTriangle(lengths:triple) ? 1 : 0
  }
  
  print ("Day 3 Part 2 = \(possibleTriangleCount)")

}
