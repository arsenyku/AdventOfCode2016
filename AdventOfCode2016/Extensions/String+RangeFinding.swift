//
//  String+RangeFinding.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension String
{
  
  func lastIndexOf(substring:String) -> Int?
  {
    guard let startOfSubstring = self.range(of: substring, options: .backwards)?.lowerBound
    else { return nil }
    
    return self.distance(from: self.startIndex, to: startOfSubstring)
  }
 
  func substring(from position:Int) throws -> String?
  {
    let startOfSubstring = self.index(self.startIndex, offsetBy: position)
    return self.substring(from: startOfSubstring)
  }
  
}
