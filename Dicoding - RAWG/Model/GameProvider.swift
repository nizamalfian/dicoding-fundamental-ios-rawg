//
//  GameProvider.swift
//  Dicoding - RAWG
//
//  Created by Amirul Nizam Alfian on 15/10/20.
//  Copyright © 2020 Amirul Nizam Alfian. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameEntity")
        container.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }

    func getAllGames(completion: @escaping(_ games: [GameItem]) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameItem] = []
                for result in results {

                    if let id = result.value(forKey: "id") as? Int,
                        let imgUrl = result.value(forKey: "image_url") as? String,
                        let name = result.value(forKey: "name") as? String,
                        let rating = result.value(forKey: "rating") as? Double,
                        let releaseDate = result.value(forKey: "release_date") as? String {
                        let game = GameItem(
                            id: id,
                            imgUrl: imgUrl,
                            name: name,
                            rating: rating,
                            releaseDate: releaseDate
                        )
                        games.append(game)
                    }
                }
                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func getGame(_ id: Int, completion: @escaping(_ game: GameItem) -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    if let id = result.value(forKey: "id") as? Int,
                        let imgUrl = result.value(forKey: "image_url") as? String,
                        let name = result.value(forKey: "name") as? String,
                        let rating = result.value(forKey: "rating") as? Double,
                        let releaseDate = result.value(forKey: "release_date") as? String {
                        let game = GameItem(
                            id: id,
                            imgUrl: imgUrl,
                            name: name,
                            rating: rating,
                            releaseDate: releaseDate
                        )
                        completion(game)
                    }
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func createGame(_ id: Int, _ imgUrl: String, _ name: String, _ rating: Double, _ releaseDate: String, completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)
                game.setValue(id, forKeyPath: "id")
                game.setValue(imgUrl, forKeyPath: "image_url")
                game.setValue(name, forKeyPath: "name")
                game.setValue(rating, forKeyPath: "rating")
                game.setValue(releaseDate, forKeyPath: "release_date")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func updateMember(_ id: Int, _ imgUrl: String, _ name: String, _ rating: Double, _ releaseDate: String, completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            if let result = try? taskContext.fetch(fetchRequest), let game = result.first as? GameEntity {
                game.setValue(imgUrl, forKeyPath: "image_url")
                game.setValue(name, forKeyPath: "name")
                game.setValue(rating, forKeyPath: "rating")
                game.setValue(releaseDate, forKeyPath: "release_date")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not asve. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func deleteGame(_ id: Int, completion: @escaping() -> ()) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GameEntity")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult, batchDeleteResult.result != nil {
                completion()
            }
        }
    }
    
    func addGame(game: GameItem, completion: @escaping() -> ()) {
        self.createGame(game.id, game.imgUrl, game.name, game.rating, game.releaseDate, completion: completion)
    }
}
