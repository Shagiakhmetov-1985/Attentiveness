//
//  MenuViewController.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import UIKit

class MenuViewController: UIViewController {
    private lazy var titleName: UILabel = {
        setupLabel(title: "Attentiveness", size: 40)
    }()
    
    private lazy var buttonStart: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "copperplate", size: 29)
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
    
    private lazy var labelTheme: UILabel = {
        setupLabel(title: "Theme", size: 25)
    }()
    
    private lazy var pickerViewTheme: UIPickerView = {
        setupPickerView()
    }()
    
    private lazy var labelCount: UILabel = {
        setupLabel(title: "Count of images", size: 25)
    }()
    
    private lazy var pickerViewCount: UIPickerView = {
        setupPickerView(tag: 1)
    }()
    
    let themes = Themes.allCases
    let count = Count.allCases
    var theme = Themes.Devices
    var countOfImages = Count.twelve
    
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
        setupSubviews(subviews: titleName, buttonStart, labelTheme, 
                      pickerViewTheme, labelCount, pickerViewCount, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    @objc private func startGame() {
        let gameVC = GameViewController()
        gameVC.images = getImages(theme: theme)
        gameVC.theme = theme
        gameVC.count = countOfImages
        navigationController?.pushViewController(gameVC, animated: false)
    }
    
    private func getImages(theme: Themes) -> ([String], [String]) {
        switch theme {
        case .Devices: Images.getDevices(count: countOfImages)
        case .Nature: Images.getNature(count: countOfImages)
        case .Sport: Images.getSport(count: countOfImages)
        case .House: Images.getHouse(count: countOfImages)
        default: Images.getTools(count: countOfImages)
        }
    }
}

extension MenuViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.tag == 0 ? themes.count : count.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        var title = String()
        var attributed = NSAttributedString()
        
        title = pickerView.tag == 0 ? themes[row].rawValue : "\(count[row].rawValue)"
        attributed = attributedText(text: title)
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.tag == 0 ? setTheme(row: row) : setCountOfImages(row: row)
    }
    
    private func setTheme(row: Int) {
        switch row {
        case 0: theme = .Devices
        case 1: theme = .Nature
        case 2: theme = .Sport
        case 3: theme = .House
        default: theme = .Tools
        }
    }
    
    private func setCountOfImages(row: Int) {
        switch row {
        case 0: countOfImages = .twelve
        case 1: countOfImages = .twentyFour
        default: countOfImages = .thirtySix
        }
    }
}

extension MenuViewController {
    private func setupLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "copperplate", size: size)
        label.text = title
        label.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension MenuViewController {
    private func setupPickerView(tag: Int? = nil) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .systemGreen
        pickerView.layer.cornerRadius = 10
        pickerView.tag = tag ?? 0
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }
    
    private func attributedText(text: String) -> NSAttributedString {
        NSAttributedString(string: text, attributes: [
            .font: UIFont(name: "copperplate", size: 27) ?? "",
            .foregroundColor: UIColor.white])
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
            buttonStart.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            buttonStart.widthAnchor.constraint(equalToConstant: 300),
            buttonStart.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            labelTheme.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTheme.topAnchor.constraint(equalTo: buttonStart.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            pickerViewTheme.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerViewTheme.topAnchor.constraint(equalTo: labelTheme.bottomAnchor, constant: 5),
            pickerViewTheme.widthAnchor.constraint(equalToConstant: 300),
            pickerViewTheme.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            labelCount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelCount.topAnchor.constraint(equalTo: pickerViewTheme.bottomAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            pickerViewCount.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerViewCount.topAnchor.constraint(equalTo: labelCount.bottomAnchor, constant: 5),
            pickerViewCount.widthAnchor.constraint(equalToConstant: 300),
            pickerViewCount.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}
