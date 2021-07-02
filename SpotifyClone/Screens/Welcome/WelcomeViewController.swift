//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import UIKit

final class WelcomeViewController: CustomViewController<WelcomeView> {
    // MARK: Properties
    
    var onWelcomeCompletion: ((Bool) -> Void)?
    
    private let viewModel: WelcomeViewModelProtocol
    
    // MARK: Init
    
    init(viewModel: WelcomeViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWelcomeViewActions()
    }
}

// MARK: - WelcomeView Actions

private extension WelcomeViewController {
    func setupWelcomeViewActions() {
        customView.didTapSignInButtonCompletion = { [weak self] in
            self?.viewModel.signIn { success in
                self?.onWelcomeCompletion?(success)
            }
        }
    }
}
