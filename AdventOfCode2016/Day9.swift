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
  
  while(unprocessedText.length > 0)
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

func decompressV2(compressedText:String) -> Int
{
  var workingCopy = compressedText
  var decompressedLength = 0
  var iterations = 0
  
  print ("Working Copy Length:", workingCopy.length)
  
  while(workingCopy.length > 0)
  {
    guard let rangeOfMarker = workingCopy.rangeOfFirstMatch(ofPattern: "\\([0-9]+x[0-9]+\\)")
      else
    {
      decompressedLength += workingCopy.length
      break
    }
    
    //    print ("ONE: ", unprocessedText.length)
    
    let stringBeforeMarker = workingCopy[workingCopy.startIndex..<rangeOfMarker.lowerBound]
    let marker = workingCopy[rangeOfMarker]
    workingCopy = workingCopy.substring(from: rangeOfMarker.upperBound)
    
    //    print ("TWO:", stringBeforeMarker)
    //    print ("THREE:", marker)
    //    print ("FOUR:", unprocessedText.length, decompressedText.length)
    
    decompressedLength += stringBeforeMarker.length
    
    guard let captures = marker.capturedGroups(withRegex: "\\(([0-9]+)x([0-9]+)\\)"),
      let left = captures[safe: 0],
      let right = captures[safe: 1],
      let lengthToRepeat = Int(left),
      let numberOfRepetitions = Int(right),
      let substringToRepeat = workingCopy[0..<lengthToRepeat]
      else
    {
      break
    }
    
    //    print ("FIVE:", lengthToRepeat, numberOfRepetitions)
    //    print ("SIX:", substringToRepeat)
    
    let repeatedText = String(repeating: substringToRepeat, count: numberOfRepetitions-1)
    workingCopy = repeatedText + workingCopy
    
    //    print (decompressedText)
    //    print (unprocessedText)
    
    iterations += 1
    
    if (iterations % 1000 == 0)
    {
      print ("-- \(iterations) iterations and counting... --")
      print ("Recently repeated: \(substringToRepeat) (length=\(lengthToRepeat)) for \(numberOfRepetitions) times")
      print ("Decompressed so far:", decompressedLength)
      print ("Working Copy Length:", workingCopy.length)
    }
  }
  
  return decompressedLength
}





func day9(realRun:Bool)
{
  if (!realRun)
  {
    print ("Day 9 Part 1 = 183269")
//    print ("Day 9 Part 2 = \(decompressedText.length)")
    return
  }
  
  let pathAndFilename = basePath + "day9-input.txt"
  let compressedText = readLines(pathAndFilename: pathAndFilename).first!
  
  let decompressedText = decompressV1(compressedText: compressedText);
  
  print ("Day 9 Part 1 = \(decompressedText.length)")
  
  let decompressedLengthV2 = decompressV2(compressedText: compressedText)
//  let decompressedLengthV2 = decompressV2(compressedText: "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
//  let decompressedLengthV2 = decompressV2(compressedText: "(27x12)(20x12)(13x14)(7x10)(1x12)A")

  print ("Day 9 Part 2 = \(decompressedLengthV2)")

}
