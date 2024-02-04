//
//  GameViewController.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import UIKit

protocol GameViewControllerDelegate {
    func didTapCell(image: String, index: Int)
}

class GameViewController: UIViewController {
    private lazy var buttonClose: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTitle: UILabel = {
        setupLabel(title: "You have to find:", size: 32)
    }()
    
    private lazy var imageTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelName: UILabel = {
        setupLabel(title: "", size: 30)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var buttonReset: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "copperplate", size: 25)
        button.setTitle("RESET", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 8
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        return button
    }()
    
    var images: ([String], [String])!
    var theme: Themes!
    var count: Count!
    
    private var imageTap = String()
    private var isHidden: [Bool] = []
    private var countTap = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarButtons()
        setRandomImage()
        setHidden()
        setupConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1)
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: collectionView, labelTitle, imageTitle,
                      labelName, buttonReset, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    private func setupBarButtons() {
        let rightButton = UIBarButtonItem(customView: buttonClose)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setRandomImage() {
        guard !images.1.isEmpty else { return }
        let index = Int.random(in: 0...images.1.count - 1)
        let imageName = images.1[index]
        setPicture(image: imageName)
        imageTap = imageName
        images.1.remove(at: index)
    }
    
    private func setPicture(image: String) {
        let size = UIImage.SymbolConfiguration(pointSize: 55)
        imageTitle.image = UIImage(systemName: image, withConfiguration: size)
        let text = image.replacingOccurrences(of: ".", with: " ")
        labelName.text = "\(text.capitalized)"
    }
    
    private func setHidden() {
        images.0.forEach { _ in
            isHidden.append(false)
        }
    }
    
    private func resetIsHidden() {
        isHidden.removeAll()
        setHidden()
    }
    
    @objc private func backToMenu() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func reset() {
        buttonOnOff(isOn: false)
        countTap = 0
        images = getImages(theme: theme)
        resetIsHidden()
        setRandomImage()
        collectionView.reloadData()
    }
    
    private func getImages(theme: Themes) -> ([String], [String]) {
        switch theme {
        case .Devices: Images.getDevices(count: count)
        case .Nature: Images.getNature(count: count)
        default: Images.getSport(count: count)
        }
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.0.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagesCollectionViewCell
        let image = images.0[indexPath.item]
        cell.imageForCell(image: image, imageTap: imageTap, index: indexPath.item)
        cell.isHidden = isHidden[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension GameViewController {
    private func setupLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "copperplate", size: size)
        label.text = title
        label.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension GameViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            collectionView.widthAnchor.constraint(equalToConstant: 325),
            collectionView.heightAnchor.constraint(equalToConstant: height(count: count))
        ])
        
        NSLayoutConstraint.activate([
            labelName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelName.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            imageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageTitle.bottomAnchor.constraint(equalTo: labelName.topAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTitle.bottomAnchor.constraint(equalTo: imageTitle.topAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            buttonReset.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonReset.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            buttonReset.widthAnchor.constraint(equalToConstant: 300),
            buttonReset.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func height(count: Count) -> CGFloat {
        switch count {
        case .twelve: return 108
        case .twentyFour: return 215
        default: return 324
        }
    }
}

extension GameViewController: GameViewControllerDelegate {
    func didTapCell(image: String, index: Int) {
        isHidden[index] = true
        setRandomImage()
        collectionView.reloadData()
        isMoreTen()
    }
    
    private func isMoreTen() {
        countTap += 1
        guard countTap > 9 else { return }
        buttonOnOff(isOn: true)
    }
    
    private func buttonOnOff(isOn: Bool) {
        let color = isOn ? UIColor.systemGreen : UIColor.systemGray2
        buttonReset.isEnabled = isOn
        UIView.animate(withDuration: 0.5) {
            self.buttonReset.backgroundColor = color
        }
    }
}
