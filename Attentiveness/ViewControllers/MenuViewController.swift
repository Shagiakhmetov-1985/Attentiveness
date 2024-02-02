//
//  MenuViewController.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import UIKit

class MenuViewController: UIViewController {
    private lazy var titleName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "copperplate", size: 40)
        label.text = "Attentiveness"
        label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonStart: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "copperplate", size: 25)
        button.setTitle("START GAME", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1)
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: titleName, buttonStart, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    @objc private func startGame() {
        navigationController?.pushViewController(GameViewController(), animated: false)
    }
}

extension MenuViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleName.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            buttonStart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStart.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStart.widthAnchor.constraint(equalToConstant: 250),
            buttonStart.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
