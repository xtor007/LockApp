//
//  CoreDataManager.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation
import CoreData

class CoreDataManager: DB {
    
    static let shared = CoreDataManager()
    
    private let coreData = CoreDataStack()
    
    private init() {}
    
    func save() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            try? coreData.managedObjectContext.save()
        }
    }
    
    // MARK: - Enter
    
    func getAllEnters() -> [EnterDBModel] {
        let enters = fetchEnters()
        return enters.compactMap { enter in
            guard let id = enter.id,
                  let employerId = enter.employerID,
                  let time = enter.time else {
                return nil
            }
            return EnterDBModel(id: id, employerId: employerId, time: time, isOn: enter.isOn)
        }
    }
    
    private func fetchEnters() -> [CDEnter] {
        let fetchRequest = NSFetchRequest<CDEnter>(entityName: "CDEnter")
        do {
            return try coreData.managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func addEnter(_ enter: EnterDBModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let newEnter = CDEnter(context: coreData.managedObjectContext)
            newEnter.id = enter.id
            newEnter.employerID = enter.employerId
            newEnter.time = enter.time
            newEnter.isOn = enter.isOn
        }
    }
    
    func removeEnter(_ id: UUID) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let enters = fetchEnters()
            guard let enter = enters.first(where: { $0.id == id }) else { return }
            coreData.managedObjectContext.delete(enter)
        }
    }
    
    // MARK: - Employer
    
    func getAllEmployers() -> [EmployerDBModel] {
        let employers = fetchEmployers()
        return employers.map { employer in
            EmployerDBModel(
                employer: EmployerModel(
                    id: employer.id,
                    isAdmin: employer.isAdmin,
                    name: employer.name,
                    surname: employer.surname,
                    department: employer.department,
                    email: employer.email
                ),
                average: employer.average
            )
        }
    }
    
    private func fetchEmployers() -> [CDEmployer] {
        let fetchRequest = NSFetchRequest<CDEmployer>(entityName: "CDEmployer")
        do {
            return try coreData.managedObjectContext.fetch(fetchRequest)
        } catch {
            print(error)
            return []
        }
    }
    
    func addEmployer(_ employer: EmployerDBModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let newEmployer = CDEmployer(context: coreData.managedObjectContext)
            newEmployer.id = employer.employer.id
            newEmployer.name = employer.employer.name
            newEmployer.surname = employer.employer.surname
            newEmployer.isAdmin = employer.employer.isAdmin
            newEmployer.department = employer.employer.department
            newEmployer.email = employer.employer.email
            newEmployer.average = employer.average
        }
    }
    
    func removeEmployer(_ id: UUID) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let employers = fetchEmployers()
            guard let employer = employers.first(where: { $0.id == id }) else { return }
            coreData.managedObjectContext.delete(employer)
        }
    }
    
}
