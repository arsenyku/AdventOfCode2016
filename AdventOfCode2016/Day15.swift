//
//  Day15.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-14.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class Simulator
{
  let startPositions:[(id:Int, position:Int, numberOfPositions:Int)]
  var discs:[(id:Int, position:Int, numberOfPositions:Int)]
  
  required init(discs:[(id:Int, position:Int, numberOfPositions:Int)])
  {
    self.startPositions = discs
    self.discs = discs
  }
  
  func reset()
  {
    discs = startPositions
  }
  
  func timeStep(by steps:Int)
  {
    for i in 0..<discs.count
    {
      let disc = discs[i]
      let position = (disc.position+steps) % disc.numberOfPositions
      discs[i] = (disc.id, position, disc.numberOfPositions)
    }
  }
  
  func timeStep()
  {
    timeStep(by:1)
  }
  
  func run(start:Int, finish:Int) -> Int?
  {
    var successfulRun:Int? = nil
    
    for pressTime in start...finish
    {
      reset()
      timeStep(by:pressTime)
      var passedDiscs = 0
      for timeStep in pressTime+1...pressTime+discs.count
      {
        self.timeStep()
        
        if (timeStep < pressTime+1)
        {
          // Haven't pressed the button yet so nothing to check for now.
          continue
        }
        
        if ( discs[timeStep-pressTime-1].position != 0 )
        {
          // print ("Pressing at time \(pressTime) results in FAILURE at step \(timeStep)")
          break
        }
        
        // Disc was at position 0 so the
        passedDiscs += 1
        
      }
      
      if (passedDiscs == discs.count)
      {
        successfulRun = pressTime
        break
      }
      
      if ((pressTime - start) % 200000 == 0)
      {
        print ("\(pressTime - start) simulations and counting..." )
      }
    }
    
    if (successfulRun != nil)
    {
      print ("Pressing at time \(successfulRun) results in SUCCESS")
    }
    
    return successfulRun
  }
}

func day15(realRun:Bool)
{
  if (!realRun)
  {
    print ("Day 15 Part 1 = 400589")
    print ("Day 15 Part 2 = 3045959")
    return
  }
  
  let discs1 = [(1,15,17),(2,2,3),(3,4,19),(4,2,13),(5,2,7),(6,0,5)]
  let discs2 = discs1 + [(7,0,11)]
  
  print (discs2)
  
  let sim1 = Simulator(discs:discs1)
  let run1 = sim1.run(start: 0, finish: 500000)
  
  let sim2 = Simulator(discs:discs2)
  let run2 = sim2.run(start: 400000, finish: 10000000)
  
  print ("Day 15 Part 1 = \(run1)")
  print ("Day 15 Part 2 = \(run2)")
}
