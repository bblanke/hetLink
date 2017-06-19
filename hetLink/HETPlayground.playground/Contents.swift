//: Playground - noun: a place where people can play

import UIKit
import CoreBluetooth

protocol Interpreter: class {
    static var service: CBUUID { get }
    
    func getService() -> CBUUID
}

class WatchInterpreter: Interpreter {
    static var service = CBUUID(string: "FFF0")
    
    static func getService() -> CBUUID {
        return self.service
    }
}

class AnotherClass: NSObject {
    var interpreter: Interpreter!
    
    override init(){
        super.init()
        
        interpreter = WatchInterpreter() as Interpreter
    }
    
    func doSomething(){
        var service = WatchInterpreter.service
    }
}