//
//  PopUpView.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 07.02.2024.
//

import UIKit

class PopUpView: UIView {
    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "copperplate", size: 26)
        label.text = "Are you sure want to reset game?"
        label.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonYes: UIButton = {
        setupButton(title: "Yes", color: .systemGreen, action: #selector(pressYes))
    }()
    
    private lazy var buttonNo: UIButton = {
        setupButton(title: "No", color: .systemRed, action: #selector(pressNo))
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonYes, buttonNo])
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var delegate: PopUpViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1)
        layer.cornerRadius = 15
        layer.borderWidth = 1.5
        setSubviews(subviews: labelTitle, stackView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
    
    @objc private func pressYes() {
        delegate.pressButtonYes()
    }
    
    @objc private func pressNo() {
        delegate.pressButtonNo()
    }
}

extension PopUpView {
    private func setupButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "copperplate", size: 26)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}

extension PopUpView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            labelTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            labelTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
}
