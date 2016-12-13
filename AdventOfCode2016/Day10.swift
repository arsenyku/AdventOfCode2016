//
//  Day10.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class Bot: CustomStringConvertible
{
  var identifier:String = ""
  
  var chips = [Int]()
  
  var commandQueue = [String]()
  
  required init(identifier:String?)
  {
    if (identifier != nil)
    {
      self.identifier = identifier!
    }
  }

  func receiveChip(chip:Int)
  {
    chips.append(chip)
    chips.sort()
  
    if (chips.count == 2)
    {
//      print ("BOT \(identifier) is comparing \(chips[0]) AND \(chips[1])")
      if (chips[0] == Factory.testSamples.0 && chips[1] == Factory.testSamples.1)
      {
        Factory.testBot = self
      }
      
      execute()
    }
  
  }
  
  func removeLowChip() -> Int
  {
    return chips.removeFirst()
  }
  
  func removeHighChip() -> Int
  {
    return chips.removeLast()
  }
  
  func giveLowChip(to otherBot:Bot)
  {
    let lowChip = removeLowChip()
    otherBot.receiveChip(chip: lowChip)
  }
  
  func giveHighChip(to otherBot:Bot)
  {
    let highChip = removeHighChip()
    otherBot.receiveChip(chip: highChip)
  }
 
  func execute()
  {
    guard commandQueue.count > 0
    else { return }
    
    let command = commandQueue.removeFirst()
    
    guard let botNumbers = command.capturedGroups(withRegex: "bot [0-9]+ gives low to ([a-z]+ [0-9]+) and high to ([a-z]+ [0-9]+)"),
      let lowDetails = botNumbers[safe: 0]?.components(separatedBy: CharacterSet.whitespaces),
      let highDetails = botNumbers[safe: 1]?.components(separatedBy: CharacterSet.whitespaces)
    else { return }
    
    if (chips.count != 2)
    {
      return
    }
    
    if (lowDetails[0] == "bot")
    {
      let lowBot = Factory.bot(withIdentifier: lowDetails[1])
      giveLowChip(to: lowBot)
    }
    else
    {
      _ = removeLowChip()
    }
    
    if (highDetails[0] == "bot")
    {
      let highBot = Factory.bot(withIdentifier: highDetails[1])
      giveHighChip(to: highBot)
    }
    else
    {
      _ = removeHighChip()
    }
    
  }
  
  func enqueue(command: String)
  {
    commandQueue.append(command)
    if (chips.count == 2)
    {
      execute()
    }
  }
  
  var description:String
  {
    return "[\(identifier)->\(chips)]"
  }
  
}

class Factory
{
  static var bots = [String:Bot]()
  
  static let testSamples = (17,61)
  
  static var testBot:Bot? = nil
  
  class func bot(withIdentifier identifier:String) -> Bot
  {
    var bot = bots[identifier]
    if (bot == nil)
    {
      bot = Bot(identifier: identifier)
      bots[identifier] = bot
    }
    
    return bot!
  }
  
  
  class func process(command:String)
  {
    if (command.hasPrefix("bot"))
    {
      guard let botNumbers = command.capturedGroups(withRegex: "bot ([0-9]+) gives low to [a-z]+ [0-9]+ and high to [a-z]+ [0-9]+"),
            let source = botNumbers[safe: 0]
      else { return }

      let sourceBot = Factory.bot(withIdentifier: source)
      
      sourceBot.enqueue(command: command)
    }
    else
    {
      guard let details = command.capturedGroups(withRegex: "value ([0-9]+) goes to bot ([0-9]+)"),
            let chip = Int(details[safe: 0]!),
            let botId = details[safe: 1]
      else { return }
      
      let targetBot = Factory.bot(withIdentifier: botId)
      
      if (targetBot.chips.count == 2)
      {
        return
      }
      
      targetBot.receiveChip(chip: chip)
    }
  }
}

func day10()
{
  let pathAndFilename = basePath + "day10-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter { !$0.isEmpty }
  
  for line in lines
  {
    Factory.process(command: line)
  }
  
  print ("Day 10 Part 1 \(Factory.testBot?.identifier)")
}
