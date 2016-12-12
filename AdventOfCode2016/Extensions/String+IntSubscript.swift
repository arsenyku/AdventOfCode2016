//
//  String+IntSubscript.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-11.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

extension String {
  
  subscript (i: Int) -> String?
  {
    guard let index = self.index(self.startIndex, offsetBy: i, limitedBy: self.endIndex)
    else
    {
      return nil
    }
    return String(self[index])
  }
  
  func from(substringStart:Int) -> String?
  {
    guard let substringStartIndex = self.index(self.startIndex, offsetBy: substringStart, limitedBy: self.endIndex)
    else
    {
      return nil
    }
    return self.substring(from: substringStartIndex)
  }
}
