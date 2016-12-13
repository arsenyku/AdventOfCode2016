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
  var factory:Factory
  
  var identifier:String = ""
  
  var chips = [Int]()
  
  var commandQueue = [String]()
  
  required init(identifier:String?, factory:Factory)
  {
    self.factory = factory
    
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
      if (chips[0] == factory.testSamples.0 && chips[1] == factory.testSamples.1)
      {
        factory.testBot = self
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
      let lowBot = factory.bot(withIdentifier: lowDetails[1])
      giveLowChip(to: lowBot)
    }
    else
    {
      _ = removeLowChip()
    }
    
    if (highDetails[0] == "bot")
    {
      let highBot = factory.bot(withIdentifier: highDetails[1])
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
  var bots = [String:Bot]()
  
  let testSamples = (17,61)
  
  var testBot:Bot? = nil
  
  func bot(withIdentifier identifier:String) -> Bot
  {
    var bot = bots[identifier]
    if (bot == nil)
    {
      bot = Bot(identifier: identifier, factory:self)
      bots[identifier] = bot
    }
    
    return bot!
  }
  
  
  func process(command:String)
  {
    if (command.hasPrefix("bot"))
    {
      guard let botNumbers = command.capturedGroups(withRegex: "bot ([0-9]+) gives low to [a-z]+ [0-9]+ and high to [a-z]+ [0-9]+"),
            let source = botNumbers[safe: 0]
      else { return }

      let sourceBot = bot(withIdentifier: source)
      
      sourceBot.enqueue(command: command)
    }
    else
    {
      guard let details = command.capturedGroups(withRegex: "value ([0-9]+) goes to bot ([0-9]+)"),
            let chip = Int(details[safe: 0]!),
            let botId = details[safe: 1]
      else { return }
      
      let targetBot = bot(withIdentifier: botId)
      
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
  
  let factory = Factory()
  
  for line in lines
  {
    factory.process(command: line)
  }
  
  print ("Day 10 Part 1 \(factory.testBot?.identifier)")
}
