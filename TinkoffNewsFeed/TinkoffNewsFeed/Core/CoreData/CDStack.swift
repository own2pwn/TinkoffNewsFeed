//
// Created by Evgeniy on 22.07.17.
// Copyright (c) 2017 supreme. All rights reserved.
//

import Foundation
import CoreData

final class CDStack: ICDStack {

    // MARK: - ICDStack

    var managedObjectModel: NSManagedObjectModel {
        return objectModel
    }

    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        return storeCoordinator
    }

    // MARK: - ICDContextManager

    func performSave(context: NSManagedObjectContext, completion: ((Error?) -> Void)? = nil) {
        guard context.hasChanges else {
            completion?(nil)
            return
        }
        context.perform { [weak self] in
            do {
                try context.save()
            } catch {
                log.error("Context [\(context)] hasn't saved data! Error: \(error)")
                completion?(error)
            }
            if let parent = context.parent {
                self?.performSave(context: parent, completion: completion)
            } else {
                completion?(nil)
            }
        }
    }

    private lazy var masterContext: NSManagedObjectContext = {
        self.initMasterContext()
    }()

    lazy var mainContext: NSManagedObjectContext = {
        self.initMainContext()
    }()

    lazy var saveContext: NSManagedObjectContext = {
        self.initSaveContext()
    }()

    // MARK: - CDStack

    init(storeType: String = NSSQLiteStoreType) {
        initStack(with: storeType)
    }

    // MARK: - Constants

    private let model: String = .TNF_CD_MODEL_NAME
    private let storeName: String = .TNF_CD_STORE_NAME
    private let modelExt = "momd"

    // MARK: - Instance members

    private var objectModel: NSManagedObjectModel!
    private var storeCoordinator: NSPersistentStoreCoordinator!

    // MARK: - Methods

    private func initStack(with storeType: String) {
        initObjectModel()
        initStoreCoordinator(with: storeType)
    }

    private func initObjectModel() {
        if let url = Bundle.main.url(forResource: model, withExtension: modelExt) {
            let model = NSManagedObjectModel(contentsOf: url)

            objectModel = model
        } else {
            let e = "Can't obtain URL for model!"
            log.error(e)
        }
    }

    private func initStoreCoordinator(with storeType: String) {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        do {
            var storePath: URL?
            if storeType == NSSQLiteStoreType {
                storePath = constructStorePath()
            }

            try coordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: storePath, options: nil)
            storeCoordinator = coordinator
        } catch {
            assertionFailure("Can't add persistent store to coordinator. Error: \(error)")
        }
    }

    private func initMasterContext() -> NSManagedObjectContext {
        let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        ctx.persistentStoreCoordinator = storeCoordinator
        ctx.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        ctx.undoManager = nil

        return ctx
    }

    private func initMainContext() -> NSManagedObjectContext {
        let ctx = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        ctx.parent = masterContext
        ctx.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        ctx.undoManager = nil

        return ctx
    }

    private func initSaveContext() -> NSManagedObjectContext {
        let ctx = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        ctx.parent = mainContext
        ctx.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        ctx.undoManager = nil

        return ctx
    }

    // MARK: - Helping methods

    private func constructStorePath() -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storePath = docDir.appendingPathComponent(storeName)
        log.info("DB store path: \(storePath)")

        return storePath
    }
}
