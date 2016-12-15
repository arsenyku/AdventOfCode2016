//
//  Day14.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-14.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func generatePadKeys(salt:String, targetCount:Int, stretch:Int) -> [(index:Int,hash:String)]
{
  var index = 0
  var scanList = [Int:(hash:String, quintuple:String)]()
  var padKeys = [(index:Int,hash:String)]()
  
  while padKeys.count < targetCount
  {
    let code = salt + String(index)
    var hash = code.md5()
    
    if (stretch > 0)
    {
      for _ in 1...stretch
      {
        hash = hash.md5()
      }
    }
    
    if let triple = hash.firstMatch(ofRegex: "([0-9a-f])\\1{2}")
    {
      scanList[index] = (hash,String(repeating: triple[0]!, count: 5))
    }
    
    let scanKeys = scanList.keys.sorted()
    
    for scanIndex in scanKeys
    {
      if (scanIndex+1000 < index)
      {
        scanList[scanIndex] = nil
      }
      
      if let scan = scanList[scanIndex],
        let _ = hash.firstMatch(ofRegex: scan.quintuple),
        scanIndex != index
      {
        scanList[scanIndex] = nil
        padKeys.append((scanIndex, scan.hash))
        print ("New Key (\(padKeys.count)).  Index=\(scanIndex), Hash=\(scan.hash).  Matched against index \(index) and hash \(hash)")
      }
      
      
    }
    
    index += 1
    
    //    if (index % 10000 == 0)
    //    {
    //      print ("Processed \(index) hashes.  Last hash = \(hash).  Keys so far = \(padKeys.count)")
    //    }
    
  }
  
  return padKeys

}

func day14()
{
//  let salt = "ahsbgdzn"
//  let targetCount = 64
//  
//  let padKeys1 = generatePadKeys(salt: salt, targetCount: targetCount, stretch: 0)
//  print("Day 14 Part 1 = \(padKeys1[targetCount-1].index)")
//
//  let padKeys2 = generatePadKeys(salt: salt, targetCount: targetCount, stretch: 2016)
//  print("Day 14 Part 2 = \(padKeys2[targetCount-1].index)")
  
    print("Day 14 Part 1 = 23890")
    print("Day 14 Part 2 = 22696")
  
}
