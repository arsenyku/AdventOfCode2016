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
    let hasAbbaInBrackets = matchedText.firstMatch(ofPattern: abbaPattern) != nil
    
    if (hasAbbaInBrackets)
    {
      return false
    }
  }
  
  return true
}

func day7()
{
  let pathAndFilename = basePath + "day7-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename)
  let result1 = lines.filter({ supportsTLS(address: $0) }).count
  
  print ("Day 7 Part 1 = \(result1)")
}
