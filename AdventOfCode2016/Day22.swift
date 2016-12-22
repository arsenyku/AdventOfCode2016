//
//  Day22.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-21.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

typealias NodeMetaData = (x:Int, y:Int, size:Int, used:Int, avail:Int, percentUsed:Int)

func countViablePairs(nodes:[NodeMetaData]) -> Int
{
  var nodesGroupedByAvail = [Int:[NodeMetaData]]()
  var nodesGroupedByUsed = [Int:[NodeMetaData]]()
  nodes.forEach({
    var availGroup = nodesGroupedByAvail[ $0.avail ]
    if (availGroup == nil) { availGroup = [NodeMetaData]() }
    availGroup?.append( $0 )
    nodesGroupedByAvail[ $0.avail ] = availGroup!
    
    var usedGroup = nodesGroupedByUsed[ $0.used ]
    if (usedGroup == nil) { usedGroup = [NodeMetaData]() }
    usedGroup?.append( $0 )
    nodesGroupedByUsed[ $0.used ] = usedGroup!
  })

  let availKeys = nodesGroupedByAvail.keys.sorted()
  let usedKeys = nodesGroupedByUsed.keys.filter({ $0 != 0 }).sorted()
  
//  print (availKeys)
//  print (usedKeys)
  
  var used = usedKeys.min()!
  var usedIndex = 0
  var numberOfViablePairs = 0
  
  for avail in availKeys
  {
    if (avail < used)
    {
      continue
    }
    
    while used <= avail
    {
      // a=#avail, u=#used, k=#common
      // (a-k)*u  +  k*(u-1)
      // = au - ku + ku - k
      // = au - k

      let nodesWithSameUsedValue = nodesGroupedByUsed[ used ]!
      let nodesWithSameAvailValue = nodesGroupedByAvail[ avail ]!
      let nodesToExclude = nodesWithSameUsedValue.filter({ $0.avail == $0.used })
      numberOfViablePairs += ( (nodesWithSameAvailValue.count * nodesWithSameUsedValue.count) - nodesToExclude.count )
      
      usedIndex += 1
      used = usedKeys[ usedIndex ]
    }
    
  }
  
  return numberOfViablePairs
  
}

func testData() -> [String]
{
  return [
    "Filesystem            Size  Used  Avail  Use%",
    "/dev/grid/node-x0-y0   10T    8T     2T   80%",
    "/dev/grid/node-x0-y1   11T    6T     5T   54%",
    "/dev/grid/node-x0-y2   32T   28T     4T   87%",
    "/dev/grid/node-x1-y0    9T    7T     2T   77%",
    "/dev/grid/node-x1-y1    8T    0T     8T    0%",
    "/dev/grid/node-x1-y2   11T    7T     4T   63%",
    "/dev/grid/node-x2-y0   10T    6T     4T   60%",
    "/dev/grid/node-x2-y1    9T    8T     1T   88%",
    "/dev/grid/node-x2-y2    9T    6T     3T   66%"]
}



func day22()
{
  let pathAndFilename = basePath + "day22-input.txt"
  let linePattern = "^.*-x([0-9]+)-y([0-9]+)[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*([0-9]+)[^0-9]*$"

  let clusterNodes = readLines(pathAndFilename: pathAndFilename)
//  let clusterNodes = testData()
    .filter({$0.hasPrefix("/")})
    .map({ line -> NodeMetaData in
      let components = line.capturedGroups(withRegex:linePattern)!
      return (Int(components[0])!, Int(components[1])!, Int(components[2])!, Int(components[3])!, Int(components[4])!, Int(components[5])! )
    })

  let viablePairCount = countViablePairs(nodes: clusterNodes)
  
  print ("Day 22 Part 1 = \(viablePairCount)")
  
  // Part 2 - manually solved
  print ("Day 22 Part 2 = 198")
  
}
