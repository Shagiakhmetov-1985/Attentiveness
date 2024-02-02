//
//  GameViewController.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import UIKit

protocol GameViewControllerDelegate {
    func didTapCell(image: String)
}

class GameViewController: UIViewController {
    private lazy var leftButton: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "arrowshape.backward.fill", withConfiguration: size)
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
        setupLabel(title: "You have to find:", size: 25)
    }()
    
    private lazy var imageTitle: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private var images = Images.getDevices()
    private var imageTap = String()
    private var indexes: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarButtons()
        getRandomName()
        setupConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1)
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: collectionView, labelTitle, imageTitle, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    private func setupBarButtons() {
        let leftButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func setImage() {
        let size = UIImage.SymbolConfiguration(pointSize: 40)
        let image = images[Int.random(in: 0...images.count - 1)]
        imageTitle.image = UIImage(systemName: image, withConfiguration: size)
    }
    
    private func getRandomName() {
        let imageName = images[Int.random(in: 0...images.count - 1)]
        setPicture(image: imageName)
        imageTap = imageName
    }
    
    private func setPicture(image: String) {
        let size = UIImage.SymbolConfiguration(pointSize: 55)
        imageTitle.image = UIImage(systemName: image, withConfiguration: size)
    }
    /*
    private func isThereIndex(index: Int) -> Float {
        
    }
    */
    @objc private func backToMenu() {
        navigationController?.popViewController(animated: false)
    }
}

extension GameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImagesCollectionViewCell
        let image = images[indexPath.item]
        cell.imageForCell(image: image, imageTap: imageTap)
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
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.widthAnchor.constraint(equalToConstant: 325),
            collectionView.heightAnchor.constraint(equalToConstant: 215)
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -40),
            labelTitle.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -80)
        ])
        
        NSLayoutConstraint.activate([
            imageTitle.centerYAnchor.constraint(equalTo: labelTitle.centerYAnchor),
            imageTitle.leadingAnchor.constraint(equalTo: labelTitle.trailingAnchor, constant: 10)
        ])
    }
}

extension GameViewController: GameViewControllerDelegate {
    func didTapCell(image: String) {
        getRandomName()
//        collectionView.reloadData()
    }
}
