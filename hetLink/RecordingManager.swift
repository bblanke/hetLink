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
    var isRecording: Bool = false
    
    var openRecording: Recording?
    var fetchedRecordingsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override init(){
        super.init()
        let persistentContainer = NSPersistentContainer(name: "hetLink")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            self.managedObjectContext = persistentContainer.viewContext
            self.initializeFetchedRecordingsController()
        }
    }
    
    func initializeFetchedRecordingsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Recording")
        let timestampSort = NSSortDescriptor(key: "timestamp", ascending: true)
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("updated the recordings")
    }
    
    func startRecording(){
        print("creating a parent object")
        isRecording = true
        
        openRecording = Recording(context: managedObjectContext)
        openRecording?.timestamp = Date() as NSDate
    }
    
    func persist(packet: HETPacket){
        guard isRecording == true else {
            return
        }
        
        let recPacket = Packet(context: managedObjectContext)
        recPacket.timestamp = packet.timestamp as NSDate
        recPacket.deviceType = packet.device.rawValue
        recPacket.parseType = packet.parser.rawValue
        recPacket.data = packet.rawData as NSData
        
        openRecording?.addToPackets(recPacket)
    }
    
    func endRecording(recordingTitle: String){
        isRecording = false
        
        openRecording?.title = recordingTitle
        
        saveContext()
        
        openRecording = nil
        
        print("closing everything out")
    }
    
    private func saveContext () {
        guard let context = managedObjectContext else {
            // FIXME: - Should have a way for this to fail with a message
            return
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // FIXME: – Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
