//
//  Day20.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-19.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func day20()
{
  let pathAndFilename = basePath + "day20-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter({!$0.isEmpty})

//  let lines = ["15-30","45-60", "13-16", "0-10", "9-12"]
  
  var blockedIPs = [(start:Int, end:Int)]()
  
//  var highestFromBottom = 0
  let maxIp = 4294967295
  
  var lineNumber = 0
  for line in lines
  {
    let blocked = line.components(separatedBy: "-").map({Int($0)!})
    var newBlock = (start:blocked[0], end:blocked[1])
//    print ("\(newBlock)")
    
    var newBlockedIPs = [(start:Int, end:Int)]()
    var index = 0

    for ipRange in blockedIPs
    {
      if ( ipRange.end < newBlock.start-1 )
      {
        newBlockedIPs.append(ipRange)
        index += 1
        continue
      }
      
      if ( ipRange.start > newBlock.end+1 )
      {
        break
      }
      
      let newRangeStart = min(ipRange.start, newBlock.start)
      let newRangeEnd = max(ipRange.end, newBlock.end)
      
      newBlock = (newRangeStart, newRangeEnd)
      index += 1

    }

    lineNumber += 1
    
    newBlockedIPs.append(newBlock)
    if (index < blockedIPs.count)
    {
      newBlockedIPs.append(contentsOf: blockedIPs[index..<blockedIPs.count])
    }
    
    blockedIPs = newBlockedIPs
    
//    print ("\(blockedIPs)")
//    print ("\(lineNumber): Lowest blocked range = \(blockedIPs.first!).  \(blockedIPs.count) separate ranges.")
  }

  let firstBlockedRange = blockedIPs.first!
  print ("Day 20 Part 1 = \(firstBlockedRange.start > 0 ? 0 : firstBlockedRange.end+1)")
  
  var unblockedCount = 0
  for i in 0..<blockedIPs.count-1
  {
    let unblocked = (start:blockedIPs[i].end+1, end:blockedIPs[i+1].start-1)
    unblockedCount += (unblocked.end-unblocked.start+1)
  }
  
  if (blockedIPs.last!.end < maxIp)
  {
    let unblocked = (start:blockedIPs.last!.end, end:maxIp)
    unblockedCount += (unblocked.end - unblocked.start + 1)
  }
  
  print ("Day 20 Part 2 = \(unblockedCount)")
  

}
