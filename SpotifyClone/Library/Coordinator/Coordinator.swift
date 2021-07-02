import UIKit

protocol Coordinatable: AnyObject {
    func start()
}

class Coordinator: Coordinatable {
    private var childCoordinators: [Coordinatable] = []
    
    func start() {}
}

// MARK: - Child Coordinators Managing Methods

extension Coordinator {
    func appendChildCoordinator(_ childCoordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === childCoordinator }) else { return }
        
        childCoordinators.append(childCoordinator)
    }
    
    func removeChildCoordinator(_ childCoordinator: Coordinatable?) {
        guard !childCoordinators.isEmpty, let childCoordinator = childCoordinator else { return }
        
        if let childCoordinator = childCoordinator as? Coordinator {
            childCoordinator.childCoordinators.forEach { childCoordinator.removeChildCoordinator($0) }
        }
        
        if let index = childCoordinators.firstIndex(where: { $0 === childCoordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}
