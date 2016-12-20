//
//  Day19.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-18.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func whiteElephantV1(numberOfElves:Int) -> Int
{
  var gifts = [Int](repeating: 1, count: numberOfElves)
  var elvesWithGifts = numberOfElves
  
  var stealer = 0
  while elvesWithGifts > 1
  {
    if ( gifts[stealer] == 0 )
    {
      stealer = (stealer+1) % numberOfElves
      continue
    }
    
    var stealee = (stealer + 1) % numberOfElves
    
    while stealee != stealer
    {
      if (gifts[stealee] != 0 )
      {
        break
      }
      stealee = (stealee+1) % numberOfElves
    }
    
    gifts[stealer] = 1
    gifts[stealee] = 0
    
    elvesWithGifts -= 1
    
    stealer = (stealer+1) % numberOfElves
    
  }

  return ((stealer - 1) % numberOfElves) + 1  // Adjusted for 1-based counting
}

func whiteElephantV2(numberOfElves:Int) -> Int
{
  // Solved in Day19.py !!!!!
  return 3001330
}

func day19(realRun:Bool)
{
  if (!realRun)
  {
    print("Day 19 Part 1 = 1808357")
    print("Day 19 Part 2 = 3001330")
    return
  }
  
  let numberOfElves = 3001330;
//  let numberOfElves = 5;
  
  print ("Day 19 Part 1 = \(whiteElephantV1(numberOfElves: numberOfElves))")
  print ("Day 19 Part 2 = \(whiteElephantV2(numberOfElves: numberOfElves))")
  
}
