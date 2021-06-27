//
//  WelcomeView.swift
//  SpotifyClone
//
//  Created by Admin on 23.06.2021.
//

import UIKit

final class WelcomeView: UIView {
    // MARK: Properties
    
    var didTapSignInButtonCompletion: (() -> Void)?
    
    // MARK: Subviews
    
    private let signInButton: UIButton = {
        let signInButton = UIButton(type: .system)
        
        signInButton.setTitle("Sign In", for: .normal)
        
        return signInButton
    }()
    
    // MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupAppearance()
        setupActions()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Appearance

private extension WelcomeView {
    func setupAppearance() {
        backgroundColor = .systemBackground
    }
}

// MARK: - Actions

private extension WelcomeView {
    func setupActions() {
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
    }
    
    @objc func didTapSignInButton() {
        didTapSignInButtonCompletion?()
    }
}

// MARK: - Layout

private extension WelcomeView {
    func setupLayout() {
        addSubviews()
        
        setupSignInButtonLayout()
    }
    
    func addSubviews() {
        addSubview(signInButton)
    }
    
    func setupSignInButtonLayout() {
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            signInButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
