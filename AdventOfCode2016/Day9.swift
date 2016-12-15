//
//  Day9.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func decompressV1(compressedText:String) -> String
{
  var unprocessedText = compressedText
  var decompressedText = ""
  
  while(unprocessedText.characters.count > 0)
  {
    guard let rangeOfMarker = unprocessedText.rangeOfFirstMatch(ofPattern: "\\([0-9]+x[0-9]+\\)")
      else
    {
      break
    }
    
//    print ("ONE: ", unprocessedText.length)
    
    let stringBeforeMarker = unprocessedText[unprocessedText.startIndex..<rangeOfMarker.lowerBound]
    let marker = unprocessedText[rangeOfMarker]
    unprocessedText = unprocessedText.substring(from: rangeOfMarker.upperBound)
    
//    print ("TWO:", stringBeforeMarker)
//    print ("THREE:", marker)
//    print ("FOUR:", unprocessedText.length, decompressedText.length)
    
    decompressedText += stringBeforeMarker
    
    guard let captures = marker.capturedGroups(withRegex: "\\(([0-9]+)x([0-9]+)\\)"),
      let left = captures[safe: 0],
      let right = captures[safe: 1],
      let lengthToRepeat = Int(left),
      let numberOfRepetitions = Int(right),
      let substringToRepeat = unprocessedText[0..<lengthToRepeat]
      else
    {
      break
    }
    
//    print ("FIVE:", lengthToRepeat, numberOfRepetitions)
//    print ("SIX:", substringToRepeat)
    
    let repeatedText = String(repeating: substringToRepeat, count: numberOfRepetitions)
    decompressedText += repeatedText
    unprocessedText = unprocessedText.substring(from: lengthToRepeat)
    
    //    print (decompressedText)
    //    print (unprocessedText)
  }

  return decompressedText
}

func day9()
{
  let pathAndFilename = basePath + "day9-input.txt"
  let compressedText = readLines(pathAndFilename: pathAndFilename).first!
  
  let decompressedText = decompressV1(compressedText: compressedText);
  
  print ("Day 9 Part 1 = \(decompressedText.length)")
  
}
