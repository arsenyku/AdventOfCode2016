//
//  Day7.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-15.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func supportsTLS(address:String) -> Bool
{
  let abbaPattern = "(([a-z])(?!\\2)([a-z])\\3\\2)"
  let textInBracketsPattern = "\\[[^\\]]*\\]"

  let hasAbba = address.firstMatch(ofPattern: abbaPattern) != nil
  
  if (!hasAbba)
  {
    return false
  }
 
  let textInBrackets = address.matches(ofPattern: textInBracketsPattern)
  
  for matchedText in textInBrackets
  {
    let hasAbbaInBrackets = matchedText.1.firstMatch(ofPattern: abbaPattern) != nil
    
    if (hasAbbaInBrackets)
    {
      return false
    }
  }
  
  return true
}

func supportsSSL(address:String) -> Bool
{
  let textInsideBracketsPattern = "\\[[^\\]]*\\]"
  let textOutsideBracketsPattern = "(?<=(\\]|^))[^\\[]*(?=($|\\[))"
  let abaWithOverlapPattern = "(([a-z])(?!\\2)[a-z](?=\\2))"
  
  let hypernet = address.matches(ofPattern: textInsideBracketsPattern).map({$0.1}).joined()
  let supernet = address.matches(ofPattern: textOutsideBracketsPattern).map({$0.1}).joined(separator: "#")
  
//  print ("HYP: ", hypernet)
//  print ("SUP: ", supernet)
  
  let abaInSupernet = supernet.matches(ofPattern: abaWithOverlapPattern).map({ $0.1 + $0.1[0]! })
  
//  print (abaInSupernet)
  
  for abaMatch in abaInSupernet
  {
    let babMatch = abaMatch[1]! + abaMatch[0]! + abaMatch[1]!
    
    if (hypernet.contains(babMatch))
    {
//      print ("IN SUPERNET:", abaInSupernet)
//      print ("ACCEPT(\(babMatch)):", address)
      return true
    }
  }
  
  print ("IN SUPERNET:", abaInSupernet)
  print ("REJECT:", address)
  return false
}


func day7()
{
  let pathAndFilename = basePath + "day7-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename)
  let result1 = lines.filter({ supportsTLS(address: $0) }).count
  
  print ("Day 7 Part 1 = \(result1)")
  
//  let lines2 =
//    ["aba[aba]bab[cat]dog"]
//    ["mqxqhcpalwycdxw[fkwhjscfmgywhtxqxqvdb]khadwvhkxygtxqx"]
//    ["uxtugntiubziynpzbju[onxffxfoxibzzzd]wineojjetzitpemflx[jlncrpyrujpoxluwyc]fxvfnhyqsiwndzoh[lkwwatmiesspwcqulnc]cbimtxmazbbzlvjf"]
//    ["emzopymywhhxulxuctj[dwwvkzhoigmbmnf]nxgbgfwqvrypqxppyq[qozsihnhpztcrpbdc]rnhnakmrdcowatw[rhvchmzmyfxlolwe]uysecbspabtauvmixa"]

//  let result2 = lines2.filter({ supportsSSL2(address: $0) }).count
  let result2 = lines.filter({ supportsSSL(address: $0) }).count

  print ("Day 7 Part 2 = \(result2)")
}
