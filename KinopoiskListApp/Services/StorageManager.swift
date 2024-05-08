//
//  StorageManager.swift
//  KinopoiskListApp
//
//  Created by Флоранс on 24.04.2024.
//

import CoreData

final class StorageManager {
    // MARK: - Properties
    static let shared = StorageManager()
    
    ///status changing flag
    var wasAnyStatusChanged: Bool {
        get {
            UserDefaults.standard.bool(forKey: "wasAnyStatusChanged")
        } set {
            UserDefaults.standard.set(newValue, forKey: "wasAnyStatusChanged")
        }
    }

    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Film")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }

    // MARK: - CRUD
    func add<T: NSManagedObject>(_ type: T.Type) -> T? {
        guard let entityName = T.entity().name else { return nil }
        guard let entity = NSEntityDescription.entity(
            forEntityName: entityName,
            in: viewContext
        ) else {
            return nil
        }
        let object = T(entity: entity, insertInto: viewContext)
        return object
    }
    
//    func create(_ movie: MovieServerModel) -> Film {
//        let film = Film(context: viewContext)
//        film.id = Int64(movie.id)
//        film.name = movie.name
//        film.poster = movie.poster.url
//        film.isFavorite = true
//        saveContext()
//        return film
//    }
    
    func update(_ film: Film) {
        film.isFavorite.toggle()
        saveContext()
    }
    
    func deleteFilmById(by id: Int64) -> Film? {
        let fetchRequest = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [id])
        do {
            let films = try viewContext.fetch(fetchRequest)
            films.forEach { delete($0) }
            return films.first
        } catch(let error) {
            print(error)
        }
        return nil
    }
    
    func delete(_ film: Film) {
        viewContext.delete(film)
        saveContext()
    }
    
    func checkIfItemExist(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Film")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "id == %d" ,id)

        do {
            let count = try viewContext.count(for: fetchRequest)
            if count > 0 {
                return true
            }else {
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }

    
    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Clear Database
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
    // MARK: - Fetching Data From Database
    func fetchData(predicate: NSPredicate? = nil, completion: (Result<[Film], Error>) -> Void) {
        let fetchRequest = Film.fetchRequest()
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do {
            let movies = try viewContext.fetch(fetchRequest)
            completion(.success(movies))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchFavorites() -> [Film] {
        let fetchRequest = Film.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite = true")
        do {
           let results = try viewContext.fetch(fetchRequest)
           return results
        } catch(let error) {
            print(error)
        }
        return []
    }
    
    func fetchSearchResults(predicate: NSPredicate? = nil) -> Film? {
        let fetchRequest = Film.fetchRequest()
        fetchRequest.fetchLimit =  1
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        do {
            let movies = try viewContext.fetch(fetchRequest)
            return movies.first
        } catch let error {
            return nil
        }
    }
    
    // MARK: - Categories of KPLists
    func getCategories() -> [String] {
        return [
            "Фильмы",
            "Онлайн-кинотеатр",
            "Сериалы",
            "Сборы",
            "Премии"
        ]
    }
}
