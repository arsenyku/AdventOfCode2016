//
//  Day9.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func day9()
{
  let pathAndFilename = basePath + "day9-input.txt"
  let compressedText = readLines(pathAndFilename: pathAndFilename).first!

  var workingText = compressedText
  var decryptedText = ""

//  print(workingText.firstMatch(ofRegex: "^\\([0-9]+x[0-9]+\\)"))
  
  
  let s = "abcdefgh"

  guard let s2 = try? s.substring(from: 33)
  else {print("badd")
    return}
  
  print (s2)
//  while(workingText.characters.count > 0)
//  {
//    let c = workingText.characters.first!
//    
//    if(c == "(")
//    {
//      
//      
//    }
//    else
//    {
//      decryptedText.append(c)
//    }
//
//    workingText.substring(from: workingText.index(workingText.startIndex, offsetBy: 1))
//  }

  
}
