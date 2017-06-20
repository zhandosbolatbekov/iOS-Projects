//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mac on 6/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

func toString(_ value: Double) -> String {
    let formatter = NumberFormatter()
    formatter.maximumSignificantDigits = 10
    return formatter.string(from: value as NSNumber)!
}

struct CalculatorBrain {
    
    private var accumulator: Double? = nil
    private var pbo: PendingBinaryOperation? = nil
    private var resultIsPending: Bool = false
    private var lastExpression: String? = nil
    private var description: String = ""
    
    private var random: (Double, String) {
        let value = Double(arc4random_uniform(1000)) / 1000.0
        return(value, toString(value))
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    private enum Operation {
        case constant(Double, String)
        case unaryOperation((Double, String) -> (Double, String))
        case binaryOperation((Double, Double) -> Double)
        case random
        case result
    }
    
    private var operations: [String: Operation] = [
        "π": Operation.constant(Double.pi, "π"),
        "℮": Operation.constant(M_E, "℮"),
        "Rand": Operation.random,
        "±": Operation.unaryOperation { (-$0, "-(\($1))") },
        "1/x": Operation.unaryOperation { (1.0 / $0, "1/(\($1))") },
        "sin": Operation.unaryOperation { (sin($0), "sin(\($1))") },
        "cos": Operation.unaryOperation { (cos($0), "cos(\($1))") },
        "√": Operation.unaryOperation { (sqrt($0), "√(\($1))") },
        "+": Operation.binaryOperation(+),
        "−": Operation.binaryOperation(-),
        "×": Operation.binaryOperation(*),
        "÷": Operation.binaryOperation(/),
        "=": Operation.result
    ]
    
    struct PendingBinaryOperation {
        var firstOperand: Double
        var function: (Double, Double) -> Double
        var operationType: String
        
        mutating func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
                
            case .constant(let value, let expression):
                accumulator = value
                lastExpression = expression
                
            case .random:
                accumulator = random.0
                lastExpression = random.1
                
            case .unaryOperation(let function):
                if resultIsPending && accumulator == nil {
                    let functionReturn = function(pbo!.firstOperand, description)
                    accumulator = functionReturn.0
                    lastExpression = functionReturn.1
                } else if resultIsPending && accumulator != nil {
                    if lastExpression == nil {
                        lastExpression = toString(accumulator!)
                    }
                    let functionReturn = function(accumulator!, lastExpression!)
                    accumulator = functionReturn.0
                    if pbo != nil && resultIsPending {
                        description.append(pbo!.operationType)
                        description.append(functionReturn.1)
                        resultIsPending = false
                    }
                } else if accumulator != nil {
                    let functionReturn = function(accumulator!, description)
                    accumulator = functionReturn.0
                    description = functionReturn.1
                }
                
            case .binaryOperation(let function):
                if accumulator != nil {
                    if pbo == nil {
                        if description == "" {
                            description = toString(accumulator!)
                        }
                        pbo = PendingBinaryOperation(firstOperand: accumulator!, function: function, operationType: symbol)
                    } else {
                        if resultIsPending {
                            description.append(pbo!.operationType)
                            description.append(toString(accumulator!))
                        }
                        description = "(" + description + ")"
                        
                        pbo = PendingBinaryOperation(firstOperand: pbo!.perform(with: accumulator!), function: function, operationType: symbol)
                    }
                    lastExpression = nil
                    accumulator = nil
                }
                resultIsPending = true
                pbo?.function = function
                pbo?.operationType = symbol
                
            case .result:
                if pbo != nil {
                    if accumulator == nil {
                        accumulator = pbo!.firstOperand
                    } else {
                        if resultIsPending {
                            description.append(pbo!.operationType)
                            if lastExpression == nil {
                                lastExpression = toString(accumulator!)
                            }
                            description.append(lastExpression!)
                        }
                        accumulator = pbo!.perform(with: accumulator!)
                    }
                    lastExpression = nil
                    pbo = nil
                    resultIsPending = false
                }
            }
        }
    }
    
    var result: (Double?, String?) {
        return (accumulator, description + (resultIsPending ? pbo!.operationType + "..." : "="))
    }
    
    mutating func clear() -> Void {
        accumulator = 0
        pbo = nil
        description = ""
    }
}
