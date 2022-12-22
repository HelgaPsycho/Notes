//
//  Coordinator.swift
//  Notes
//
//  Created by Ольга Егорова on 22.12.2022.
//

import Foundation

import Foundation
import UIKit

public protocol Coordinator : AnyObject {

    var childCoordinators: [Coordinator] { get set }

    // All coordinators will be initilised with a navigation controller
    init(navigationController:UINavigationController)

    func start()
}
