//
//  Day12.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-12.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class Computer
{
  enum Instruction:String
  {
    case Copy      = "cpy"
    case Increment = "inc"
    case Decrement = "dec"
    case Jump      = "jnz"
  }
  
  enum Register:String
  {
    case A = "a"
    case B = "b"
    case C = "c"
    case D = "d"
  }
  
  var registers:[Register:Int] = [Register:Int]()
  var tape:[String]
  var readHead = 0
  
  required init(instructions:[String])
  {
    registers[.A] = 0
    registers[.B] = 0
    registers[.C] = 0
    registers[.D] = 0
    
    tape = instructions
  }
  
  func cpy(value:Int?, target:Register)
  {
    guard let value = value
    else { return }
  
    registers[target] = value
  
    readHead += 1
  }
  
  func inc(register:Register)
  {
    registers[register] = registers[register]! + 1
    readHead += 1

  }
  
  func dec(register:Register)
  {
    registers[register] = registers[register]! - 1
    readHead += 1
  }
  
  func jnz(okToJump:Bool?, distance:Int)
  {
    guard let okToJump = okToJump
    else { return }
  
    if (okToJump)
    {
      readHead += distance
    }
    else
    {
      readHead += 1
    }
  }
  
  
  func extractIntValue(input:String) -> Int?
  {
    let lowercaseInput = input.lowercased()
    switch lowercaseInput {
      
    case Register.A.rawValue,
         Register.B.rawValue,
         Register.C.rawValue,
         Register.D.rawValue:
    
      return registers[Register(rawValue: lowercaseInput)!]
    
    default:
      
      guard let intValue = Int(lowercaseInput)
      else { return nil }
      
      return intValue
    }
  }
  
  func extractBoolValue(input:String) -> Bool?
  {
    let lowercaseInput = input.lowercased()
    switch lowercaseInput {
      
    case Register.A.rawValue,
         Register.B.rawValue,
         Register.C.rawValue,
         Register.D.rawValue:
      
      return registers[Register(rawValue: lowercaseInput)!] != 0
      
    default:
      
      guard let intValue = Int(lowercaseInput)
      else { return nil }
      
      return intValue != 0
    }

  }
  
  func doNext()
  {
    guard !done
    else { return }
    
    let tokens = tape[readHead].components(separatedBy: CharacterSet.whitespaces)
    
//    print ("\(readHead) : \(tokens)")
    
    guard let instruction = Instruction(rawValue:tokens.first!)
    else { return }
    
    switch instruction {
    case Instruction.Copy:
      
      guard let valueToCopy = extractIntValue(input: tokens[1]),
            let targetRegister = Register(rawValue: tokens[2])
      else { return }
      
      cpy(value: valueToCopy, target: targetRegister)
      
    case Instruction.Increment:
      
      guard let targetRegister = Register(rawValue: tokens[1])
      else { return }
      
      inc(register: targetRegister)
      
    case Instruction.Decrement:
      
      guard let targetRegister = Register(rawValue: tokens[1])
      else { return }
      
      dec(register: targetRegister)
      
    case Instruction.Jump:
      
      guard let okToJump = extractBoolValue(input: tokens[1]),
            let distance = extractIntValue(input: tokens[2])
      else { return }
      
      jnz(okToJump: okToJump, distance: distance)
    }

  }
  
  var done:Bool
  {
    return readHead >= tape.count || readHead < 0
  }
  
  func run()
  {
    while (!done)
    {
      doNext()
    }
  }
  
}

func day12(realRun:Bool)
{
  if(!realRun)
  {
    print ("Day 12 Part 1 = 318003")
    print ("Day 12 Part 2 = 9227657")
    return
  }
  
  let pathAndFilename = basePath + "day12-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter { !$0.isEmpty }

  let computer = Computer(instructions: lines)
  computer.run()
  
  print ("Day 12 Part 1 = \(computer.registers[.A])")
  
  let computer2 = Computer(instructions: lines)
  computer2.registers[.C] = 1
  computer2.run()
  
  print ("Day 12 Part 2 = \(computer2.registers[.A])")

}
