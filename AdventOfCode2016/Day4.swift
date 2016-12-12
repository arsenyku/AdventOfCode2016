//
//  Day4.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func calculateChecksum(encryptedName:String) -> String
{
  var occurrences = [Character:Int]()
  for c in encryptedName.replacingOccurrences(of: "-", with: "").characters
  {
    if (occurrences[c] == nil)
    {
      occurrences[c] = 1
    }
    else
    {
      occurrences[c]! += 1
    }
  }

  let sorted = occurrences.keys.sorted(by: { (c1, c2) -> Bool in
    if (occurrences[c1]! != occurrences[c2]!)
    {
      return occurrences[c2]! < occurrences[c1]!
    }
    else
    {
      return c1 < c2
    }
    
  })

  let checksum = Array(sorted[0...4]).map({ String($0) }).joined(separator: "")

  return checksum
}

func decryptCharacter(c:Character, sectorId:Int) -> Character
{
  if (c == "-") { return " " }
  
  let alphabet = "abcdefghijklmnopqrstuvwxyz"
  
  let positionInAlphabet = (alphabet.lastIndexOf(substring: String(c))! + sectorId) % alphabet.characters.count
  return alphabet[positionInAlphabet]!.characters.first!
  
}

func decryptName(encryptedName:String, sectorId:Int) -> String
{
  var decryptedName = ""
  for c in encryptedName.characters
  {
    let d = decryptCharacter(c: c, sectorId: sectorId)
    decryptedName.append(d)
  }
  return decryptedName
}

func day4()
{
  let pathAndFilename = basePath + "day4-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename)
  
  var realSectorTotal = 0
  var decryptedNames = [String:Int]()
  
  for line in lines
  {
    guard let captures = line.capturedGroups(withRegex: "^(.*)\\-(.*)\\[(.*)\\]"),
          captures.count == 3,
          let sectorId = Int(captures[1])
    else { continue }

    let encryptedName = captures[0]
    let checksum = captures[2]
    let calculatedChecksum = calculateChecksum(encryptedName: encryptedName)
    
    if (calculatedChecksum == checksum)
    {
      realSectorTotal += sectorId
    }
    
    let decryptedName = decryptName(encryptedName:encryptedName, sectorId:sectorId)
    decryptedNames[decryptedName] = sectorId
    
  }
  
  print ("Day 4 Part 1 = \(realSectorTotal)")
  print ("Day 4 Part 2 = \(decryptedNames["northpole object storage"])")
  
}
