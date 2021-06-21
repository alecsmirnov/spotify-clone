import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {}
}

// MARK: - Child Coordinators Managing Methods

extension BaseCoordinator {
    func appendChildCoordinator(_ childCoordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === childCoordinator }) else { return }
        
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        
        if let childCoordinator = childCoordinator as? BaseCoordinator {
            childCoordinator.childCoordinators.forEach { childCoordinator.removeChildCoordinator($0) }
        }
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
