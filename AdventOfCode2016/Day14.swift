//
//  Day14.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-14.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func day14()
{
  let salt = "ahsbgdzn"
  var index = 0
  let targetCount = 64
  var scanList = [Int:(hash:String, quintuple:String)]()
  var padKeys = [(index:Int,hash:String)]()
  
  while padKeys.count < targetCount && false
  {
    let code = salt + String(index)
    let hash = md5(string: code)
    
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
//        print ("New Key (\(padKeys.count)).  Index=\(scanIndex), Hash=\(scan.hash).  Matched against index \(index) and hash \(hash)")
      }
      

    }
    
    index += 1
    
//    if (index % 10000 == 0)
//    {
//      print ("Processed \(index) hashes.  Last hash = \(hash).  Keys so far = \(padKeys.count)")
//    }

  }
  
//  print("Day 14 Part 1 = \(padKeys[63].index)")
  print("Day 14 Part 1 = 23890")
}
