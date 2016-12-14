//
//  Day5.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-13.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

func md5(string: String) -> String {
  guard let messageData = string.data(using:String.Encoding.utf8)
    else { return "" }
  
  var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
  
  _ = digestData.withUnsafeMutableBytes
    { digestBytes in messageData.withUnsafeBytes
      { messageBytes in CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
      }
    }
  
  return digestData.map { String(format: "%02hhx", $0) }.joined()

}


func day5()
{
 
  let doorId = "reyedfim"
  var password1 = ""
  var password2 = "________"
  var hashIndex = 0
  var foundCharacters = 0

  while foundCharacters < 8 && false
  {
    let code = doorId + String(hashIndex)
    let hash = md5(string: code)
    if (hash.hasPrefix("00000"))
    {
      let sixth = hash[5]!

      if(password1.characters.count < 8)
      {
        password1 = password1 + sixth
        print("\(hashIndex): \(hash) -> PW1:\(password1)")
      }
      
      if let position = Int(sixth),
         position >= 0 && position <= 7,
         password2[position] == "_"
      {
        let passwordChar = hash[6]!.characters.first!
        password2 = password2.replace(at: position, with: passwordChar)
        print("\(hashIndex): \(hash) -> PW2:\(password2)")
        foundCharacters += 1
      }
      
    }

    hashIndex += 1
    
    if (hashIndex % 100000 == 0)
    {
      print ("Processed \(hashIndex) hashes.  Last hash = \(hash)")
    }
  }
  
  print ("Day 5 Part 1 = f97c354d")
  print ("Day 5 Part 2 = 863dde27")
    
}
