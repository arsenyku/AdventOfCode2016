//
//  Day16.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-15.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class Disk
{
  let capacity:Int
  var bytes:String
  
  required init(capacity:Int, initialBytes:String)
  {
    self.capacity = capacity
    self.bytes = initialBytes
  }
  
  var checksum:String
  {
    var result = ""
    var data = bytes
    while result.length % 2 == 0
    {
      result = calculateChecksum(data:data)
      data = result
    }
    return result
    
  }

}

func flip(_ zeroOrOne:Character) -> String
{
  return zeroOrOne == "0" ? "1" : "0"
}

func dragonCurve(data:String) -> String
{
  return data + "0" + data.characters.reversed().map({ flip($0) }).reduce("", { $0 + $1 })
}

func calculateChecksum(data:String) -> String
{
  var result = ""
//  let end = data.length-1
  
  data.characters.enumerated().forEach({ (offset, element) in
    if (offset % 2 != 0)
    {
      return
    }
    
    let index = data.characters.index(data.characters.startIndex, offsetBy: offset+1)
    let next = data.characters[index]
    
    
    result += (element == next) ? "1" : "0"
    
  })
  return result
}

//func calcChecksum()
//{
//  
//  
//  
//  1.stride(to: stringArray.count, by: 2).map { stringArray[$0] }
//}

func fillDisk(disk:inout Disk)
{
  var filler = disk.bytes
  
  while filler.length < disk.capacity
  {
    filler = dragonCurve(data: filler)
  }
  
  filler = filler[0..<disk.capacity]!
  
  disk.bytes = filler
  
}

func day16()
{
  let initialState = "01110110101001000"
  var disk1 = Disk(capacity: 272, initialBytes: initialState)
  fillDisk(disk: &disk1)

  print("Day 16 Part 1 = \(disk1.checksum)")

  var disk2 = Disk(capacity: 35651584, initialBytes: initialState)
  fillDisk(disk: &disk2)
  
  print("Day 16 Part 2 = \(disk2.checksum)")

}
