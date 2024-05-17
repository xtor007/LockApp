//
//  DB.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 17.05.2024.
//

import Foundation

enum DBField {
    case enters
}

protocol DB {
    func save()
    
    func getAll(_ field: DBField) -> [Any]
    func addElement(for field: DBField, _ element: Any)
    func removeElement(_ id: UUID, on field: DBField)
    
    func getAllEnters() -> [EnterDBModel]
    func addEnter(_ enter: EnterDBModel)
    func removeEnter(_ id: UUID)
}

extension DB {
    func getAll(_ field: DBField) -> [Any] {
        switch field {
        case .enters:
            getAllEnters()
        }
    }
    
    func addElement(for field: DBField, _ element: Any) {
        switch field {
        case .enters:
            guard let enter = element as? EnterDBModel else { return }
            addEnter(enter)
        }
    }
    
    func removeElement(_ id: UUID, on field: DBField) {
        switch field {
        case .enters:
            removeEnter(id)
        }
    }
}
