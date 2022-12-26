//
//  MainViewControllerCoordinator.swift
//  Notes
//
//  Created by Ольга Егорова on 22.12.2022.
//

import Foundation
import UIKit

class MainViewCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    unowned let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    
    var mainViewController : MainViewController?
    
    func start() {
       
        mainViewController = MainViewController()
        mainViewController!.delegate = self
        self.navigationController.viewControllers = [mainViewController!]
        
    }
    
    
    func printMainViewCoordinator(){
    
    }

}

extension MainViewCoordinator: MainViewControllerDelegate {
  
    // Navigate to next page
    func navigateToNoteEditViewController() {
       
       let noteEditViewCoordinator = NoteEditViewCoordinator(navigationController: navigationController)
       noteEditViewCoordinator.delegate = self
        noteEditViewCoordinator.noteEditViewController.dataStoreManager = mainViewController?.dataStoreManager
        noteEditViewCoordinator.noteEditViewController.selectedNote = mainViewController?.selectedNote
        
       childCoordinators.append(noteEditViewCoordinator)
        noteEditViewCoordinator.start()
    }
    
    
}


public protocol MainViewControllerDelegate: AnyObject {
    func navigateToNoteEditViewController()
}

extension MainViewCoordinator: BackToMainViewControllerDelegate {
    
    // Back from second page
    func navigateBackToMainController(newOrderCoordinator: NoteEditViewCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
        mainViewController?.loadData()
        mainViewController?.tableView.reloadData()
    }
}
