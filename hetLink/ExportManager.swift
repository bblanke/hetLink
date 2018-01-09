//
//  ExportManager.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/10/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import Foundation
import UIKit

class ExportManager: NSObject{
    
    weak var delegate: ExportManagerDelegate!
    
    init(delegate: ExportManagerDelegate){
        super.init()
        
        self.delegate = delegate
    }
    
    func beginExporting(packetArray: [HETPacket], associatedRecording: Recording){
        DispatchQueue.global(qos: .utility).async {
            let deviceType = HETDeviceType(rawValue: associatedRecording.deviceType)!
            
            guard var filename = associatedRecording.title else {
                fatalError("Recordings must have unique titles")
            }
            filename.append(".csv")
            
            let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(filename)
            
            var csvText = ""
            csvText.append(self.csvHeaderFor(device: deviceType))
            csvText.append("\n")
            
            for packet in packetArray {
                csvText.append(self.csvLineFor(packet: packet, device: deviceType))
                csvText.append("\n")
            }
            
            do {
                try csvText.write(to: path, atomically: true, encoding: .utf8)
            } catch {
                print("File could not be written")
            }
            
            DispatchQueue.main.async {
                self.delegate.exportManager(didFinishExporting: path)
            }
        }
    }
    
    private func csvLineFor(packet: HETPacket, device: HETDeviceType) -> String {
        var line = ""
        line.append("\(packet.timestamp.timeIntervalSince1970),")
        switch device {
        case .chest:
            switch packet.parser {
            case .chest:
                line.append(packet.toCSV())
                break
            case .wristOzone:
                break
            case .wristEnvironment:
                break
            }
        case .watch:
            switch packet.parser {
            case .chest:
                break
            case .wristOzone:
                line.append(packet.toCSV())
                break
            case .wristEnvironment:
                line.append(",,,,,")
                line.append(packet.toCSV())
                break
            }
        }
        return line
    }
    
    private func csvHeaderFor(device: HETDeviceType) -> String {
        switch device{
        case .chest:
            return "Timestamp, Battery, ECG 1, ECG 2, ECG 3, Wave 1, Wave 2, Wave 3, X, Y, Z"
        case .watch:
            return "Timestamp, Oz 1, Oz 2, Oz 3, Oz 4, Battery, Wave 1, Wave 2, Wave 3, X, Y, Z, Temp, Humidity"
        }
    }
}

protocol ExportManagerDelegate: class {
    func exportManager(didFinishExporting file: URL)
}
