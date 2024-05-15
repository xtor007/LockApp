//
//  LoadingViewModel.swift
//  LockApp
//
//  Created by Anatoliy Khramchenko on 15.05.2024.
//

import Foundation

class LoadingViewModel: ObservableObject {
    
    let task: () -> Void
    
    init(task: @escaping () -> Void) {
        self.task = task
    }
    
    func didLoad() {
        Task {
            task()
        }
    }
    
}
