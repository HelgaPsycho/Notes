//
//  Observer.swift
//  Notes
//
//  Created by Ольга Егорова on 25.12.2022.
//

import Foundation

protocol Subscriber {
    func updateTableView()
}

extension DataStoreManager {
    
    func notifySuscribers () {
        
        for subscriber in DataStoreManager.subscribers {
            subscriber.updateTableView()
            
        }
    }
    
    func subscribe(subscriber: Subscriber){
        DataStoreManager.subscribers.append(subscriber)
        
    }
    
    func unsubscribe(subscriber: (Subscriber) -> (Bool)) {
        guard let index = DataStoreManager.subscribers.firstIndex(where: subscriber)
        else {return}
        DataStoreManager.subscribers.remove(at: index)
    }
    
}


extension MainViewController: Subscriber {
    func updateTableView() {
        
        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
        loadNotes()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
//    func updateTableViewWithFavorites () {
//        tableView.register(NoteCell.self, forCellReuseIdentifier: "cell")
//        loadFavoritesNotes()
//        
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//    }
//    
}
