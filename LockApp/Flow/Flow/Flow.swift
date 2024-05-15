//
//  Flow.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

class Flow {
    
    weak var executor: FlowExecutor!
    
    private let factory = FlowFactory()
    
    func start() {
        executor.showVC(factory.makeEnterServerVC())
    }
    
}
