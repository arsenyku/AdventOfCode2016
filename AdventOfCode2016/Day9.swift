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

  guard let rangeOfMarker = compressedText.rangeOfFirstMatch(ofPattern: "\\([0-9]+x[0-9]+\\)")
    else
  {
    return compressedText.length
  }

  let stringBeforeMarker = compressedText[compressedText.startIndex..<rangeOfMarker.lowerBound]
  let marker = compressedText[rangeOfMarker]
//  let stringAfterMarker = compressedText.substring(from: rangeOfMarker.upperBound)

  let startOfSlice = rangeOfMarker.upperBound
  
  guard let captures = marker.capturedGroups(withRegex: "\\(([0-9]+)x([0-9]+)\\)"),
    let left = captures[safe: 0],
    let right = captures[safe: 1],
    let lengthToRepeat = Int(left),
    let numberOfRepetitions = Int(right)
  else
  {
      assert(false, "Failed to parse Marker \(marker)")
  }
  
  let endOfSlice = compressedText.index(startOfSlice, offsetBy: lengthToRepeat)
  let sliceToRepeat = compressedText[startOfSlice..<endOfSlice]
  let stringAfterRepeatedSlice = compressedText.substring(from: endOfSlice)
  
  let result = decompressV2(compressedText: stringBeforeMarker) +
               numberOfRepetitions * decompressV2(compressedText: sliceToRepeat) +
               decompressV2(compressedText: stringAfterRepeatedSlice)

//  print (stringBeforeMarker, marker ,stringAfterMarker, stringAfterRepeatedSlice, lengthToRepeat, numberOfRepetitions)
//  print ("RETURNING \(result)")

  return result
  
}


func day9()
{
  let pathAndFilename = basePath + "day9-input.txt"
  let compressedText = readLines(pathAndFilename: pathAndFilename).first!
  
  let decompressedText = decompressV1(compressedText: compressedText);
  
  print ("Day 9 Part 1 = \(decompressedText.length)")
  
  let decompressedLengthV2 = decompressV2(compressedText: compressedText)
//  let decompressedLengthV2 = decompressV2(compressedText: "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
//  let decompressedLengthV2 = decompressV2(compressedText: "(27x12)(20x12)(13x14)(7x10)(1x12)A")
//  let decompressedLengthV2 = decompressV2a(compressedText: "(10x3)XY(3x3)ABC")

  print ("Day 9 Part 2 = \(decompressedLengthV2)")

}
