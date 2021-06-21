import UIKit

class CustomViewController<CustomView: UIView>: UIViewController {
    var customView: CustomView {
        guard let view = view as? CustomView else {
            fatalError("view is not a CustomView instance")
        }
        
        return view
    }
    
    override func loadView() {
        view = CustomView()
    }
}
