//
//  Day23.swift
//  AdventOfCode2016
//
//  Created by asu on 2016-12-24.
//  Copyright © 2016 ArsenykUstaris. All rights reserved.
//

import Foundation

class ComputerV2:Computer
{
  var iterations = 0
  
  enum InstructionV2:String {
    case Toggle = "tgl"
  }
  
  func tgl(distance:String)
  {
    guard let distanceNumber = extractIntValue(input: distance)
    else
    {
      readHead += 1
      return
    }

    tgl(distance:distanceNumber)
    readHead += 1
    
  }
  
  func tgl(distance:Int)
  {
    let toggleIndex = readHead + distance

    guard toggleIndex < tape.count
      else { return  }
    
    var tokens = tape[toggleIndex].components(separatedBy: .whitespaces)

    if let instruction = Instruction(rawValue: tokens.first!)
    {
      switch instruction {
      case Instruction.Jump:
        tokens[0] = Instruction.Copy.rawValue
        
      case Instruction.Increment:
        tokens[0] = Instruction.Decrement.rawValue
        
      case Instruction.Copy:
        tokens[0] = Instruction.Jump.rawValue
        
      case Instruction.Decrement:
        tokens[0] = Instruction.Increment.rawValue
        
      }
    }
    else if let instruction = InstructionV2(rawValue: tokens.first!)
    {
      switch instruction {
      case InstructionV2.Toggle:
        tokens[0] = Instruction.Increment.rawValue
      }
    }
    else
    {
      return
    }

    tape[toggleIndex] = tokens.joined(separator: " ")
  }
  
  override func doNext()
  {
    guard !done
      else { return }
    
    let tokens = tape[readHead].components(separatedBy: CharacterSet.whitespaces)

    iterations += 1
    if (iterations % 100000 == 0)
    {
      print ("\(iterations): \(registers.sorted(by: { $0.0.rawValue < $1.0.rawValue }).map({$0.1}))")
    }
//    print ("\(readHead): \(tokens)")
//    print ("REGISTERS: \(registers.sorted(by: { $0.0.rawValue < $1.0.rawValue }).map({$0.1}))")
    
    if let instruction = InstructionV2(rawValue: tokens.first!)
    {
      switch instruction {
      case .Toggle:
        tgl(distance:tokens[1])
      }
    }
    else
    {
      super.doNext()
    }
    
  }
  
}

func day23()
{
  
  let pathAndFilename = basePath + "day23-input.txt"
  let lines = readLines(pathAndFilename: pathAndFilename).filter { !$0.isEmpty }
  
//  let lines = ["cpy 2 a", "tgl a", "tgl a", "tgl a", "cpy 1 a", "dec a", "dec a"]
  
  let computer = ComputerV2(instructions: lines)
  computer.registers[.A] = 7
  computer.run()

  print ("Day 23 Part 1 = \(computer.registers[.A])")

  let computer2 = ComputerV2(instructions: lines)
  computer2.registers[.A] = 12

  print ("Day 23 Part 2 = \((UInt)(computer2.registers[.A]!)~! + (77*73))")
}
