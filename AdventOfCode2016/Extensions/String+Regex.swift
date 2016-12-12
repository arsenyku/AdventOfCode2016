//
//  String+Regex.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension String
{
  func capturedGroups(withRegex pattern: String) -> [String]? {
    var regex: NSRegularExpression
    do {
      regex = try NSRegularExpression(pattern: pattern, options: [])
    } catch {
      return nil
    }
    
    let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.characters.count))
    
    guard let match = matches.first else { return nil }
    
    // Note: Index 1 is 1st capture group, 2 is 2nd, ..., while index 0 is full match which we don't use
    let lastRangeIndex = match.numberOfRanges - 1
    guard lastRangeIndex >= 1 else { return nil }
    
    var results = [String]()
    
    for i in 1...lastRangeIndex {
      let capturedGroupIndex = match.rangeAt(i)
      let matchedString = (self as NSString).substring(with: capturedGroupIndex)
      results.append(matchedString)
    }
    
    return results
  }
}
