//
//  NoteEditViewCoordinator.swift
//  Notes
//
//  Created by Ольга Егорова on 22.12.2022.
//

import Foundation
import UIKit


protocol BackToMainViewControllerDelegate: class {
    
    func navigateBackToMainController(newOrderCoordinator: NoteEditViewCoordinator)
    
}

class NoteEditViewCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    unowned let navigationController:UINavigationController
    
    // We use this delegate to keep a reference to the parent coordinator
    weak var delegate: BackToMainViewControllerDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    let noteEditViewController: NoteEditViewController = NoteEditViewController()
    
    func start() {
        noteEditViewController.delegate = self
        self.navigationController.pushViewController(noteEditViewController, animated: true)
    }
}

extension NoteEditViewCoordinator: NoteEditControllerDelegate {
    func navigateBackToMainController() {
        self.delegate?.navigateBackToMainController(newOrderCoordinator: self)
    }
    
//    // Navigate to third page
//    func navigateToMyCartController() {
//        let myCartCoordinator = MyCartViewCoordinator(navigationController: navigationController)
//        myCartCoordinator.delegate = self
//        childCoordinators.append(myCartCoordinator)
//        myCartCoordinator.start()
//    }
//
}


public protocol NoteEditControllerDelegate: class {
    func navigateBackToMainController()
  //  func navigateToMyCartController()
}

//extension NoteEditViewCoordinator: BackToProductsDetailsControllerDelegate {
//    func navigateBackToProductDetailsController(newOrderCoordinator: MyCartViewCoordinator){
//
//        newOrderCoordinator.navigationController.popViewController(animated: true)
//        childCoordinators.removeLast()
//
//    }
//}
