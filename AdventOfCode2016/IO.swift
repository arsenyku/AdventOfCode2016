//
//  IO.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

let basePath = "/Users/asu/dev/training/AdventOfCode2016/AdventOfCode2016/"

func read(pathAndFilename:String) -> String
{

  var result = ""
  
  do
  {
    result = try String(contentsOfFile: pathAndFilename)
  }
  catch
  {
  }

  return result
  
}


func readLines(pathAndFilename:String) -> [String]
{
  let contents = read(pathAndFilename: pathAndFilename)
  let result = contents.components(separatedBy: CharacterSet.newlines)
  return result
  
}
