//
//  RecordingManager.swift
//  hetLink
//
//  Created by Bailey Blankenship on 7/6/17.
//  Copyright © 2017 Bailey Blankenship. All rights reserved.
//

import UIKit
import CoreData

class RecordingManager: NSObject, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext!
    var canRecord: Bool = false
    
    fileprivate var openRecording: Recording?
    var fetchedRecordingsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    var presentedRecording: Recording?
    var presentedRecordingPackets: [HETPacket]?
    
    var recordingCount: Int {
        return (fetchedRecordingsController.sections?.first?.numberOfObjects)!
    }
    
    weak var delegate: RecordingManagerDelegate?
    
    override init(){
        super.init()
        let persistentContainer = NSPersistentContainer(name: "hetLink")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            self.managedObjectContext = persistentContainer.viewContext
            self.managedObjectContext.undoManager = nil
            self.initializeFetchedRecordingsController()
        }
    }
    
    func recording(at row: Int) -> Recording {
        return fetchedRecordingsController.object(at: IndexPath(row: row, section: 0)) as! Recording
    }
    
    func delete(recording: Recording) {
        managedObjectContext.delete(recording)
        saveContext()
    }
    
    func startRecording(type: HETDeviceType){ 
        canRecord = true
        
        openRecording = Recording(context: managedObjectContext)
        openRecording?.timestamp = Date() as NSDate
        openRecording?.deviceType = type.rawValue
    }
    
    func persist(packet: HETPacket){
        guard canRecord == true else {
            return
        }
        
        let recPacket = Packet(context: managedObjectContext)
        recPacket.timestamp = packet.timestamp as NSDate
        recPacket.parseType = packet.parser.rawValue
        recPacket.data = packet.rawData as NSData
        
        openRecording?.addToPackets(recPacket)
    }
    
    func endRecording(recordingTitle: String){
        canRecord = false
        openRecording?.title = recordingTitle
        saveContext()
        openRecording = nil
    }
    
    func selectRecordingAndStartMakingPacketArray(from recording: Recording){
        DispatchQueue.global(qos: .utility).async {
            var returnPackets: [HETPacket] = []
            let packets = recording.packets!.array as! [Packet]
            print("There are \(packets.count) packets")
            for packet in packets {
                switch HETParserType(rawValue: packet.parseType)!{
                case .chest:
                    returnPackets.append(HETChestPacket(data: packet.data! as Data, date: packet.timestamp! as Date)!)
                    break
                case .wristEnvironment:
                    returnPackets.append(HETWristEnvironmentECG(data: packet.data! as Data, date: packet.timestamp! as Date)!)
                    break
                case .wristOzone:
                    returnPackets.append(HETWristOzonePacket(data: packet.data! as Data, date: packet.timestamp! as Date)!)
                    break
                }
            }
            
            self.presentedRecording = recording
            self.presentedRecordingPackets = returnPackets
            
            DispatchQueue.main.async {
                self.delegate?.recordingManagerDidMakePacketArray(packetArray: self.presentedRecordingPackets!)
            }
        }
    }
    
}

private extension RecordingManager {
    
    func initializeFetchedRecordingsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recording")
        let timestampSort = NSSortDescriptor(key: "timestamp", ascending: false)
        request.sortDescriptors = [timestampSort]
        
        let moc = managedObjectContext
        fetchedRecordingsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedRecordingsController.delegate = self
        
        do {
            try fetchedRecordingsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func saveContext () {
        guard let context = managedObjectContext else {
            // FIXME: - Should have a way for this to fail with a message
            return
        }
        
        if context.hasChanges {
            do {
                try context.save()
                context.reset()
                delegate?.recordingManagerDidSaveRecording()
            } catch {
                // FIXME: – Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

protocol RecordingManagerDelegate: class {
    func recordingManagerDidSaveRecording()
    func recordingManagerDidMakePacketArray(packetArray: [HETPacket])
}
