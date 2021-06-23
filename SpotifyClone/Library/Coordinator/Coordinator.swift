import UIKit

protocol Coordinatable: AnyObject {
    func start()
}

class Coordinator: Coordinatable {
    private var childCoordinators: [Coordinatable] = []
    
    func start() {}
    
    deinit {
        removeAllChildCoordinators()
    }
}

extension Coordinator {
    func appendChildCoordinator(_ childCoordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === childCoordinator }) else { return }
        
        childCoordinators.append(childCoordinator)
    }
    
    func removeAllChildCoordinators() {
        childCoordinators.forEach { removeChildCoordinator($0) }
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinatable) {
        guard !childCoordinators.isEmpty else { return }
        
        if let childCoordinator = childCoordinator as? Coordinator {
            childCoordinator.childCoordinators.forEach { childCoordinator.removeChildCoordinator($0) }
        }
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
