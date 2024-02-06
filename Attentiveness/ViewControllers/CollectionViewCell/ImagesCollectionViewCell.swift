//
//  ImagesCollectionViewCell.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    var delegate: GameViewControllerDelegate!
    
    private let picture = UIImageView()
    private var imageCell = String()
    private var imageSelect = String()
    private var indexCell = Int()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDesign()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageForCell(image: String, imageTap: String, index: Int) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        picture.image = UIImage(systemName: image, withConfiguration: size)
        picture.tintColor = .white
        setImages(image: image, imageTap: imageTap)
        setIndex(index: index)
    }
    
    private func setImages(image: String, imageTap: String) {
        imageCell = image
        imageSelect = imageTap
    }
    
    private func setIndex(index: Int) {
        indexCell = index
    }
    
    private func setupDesign() {
        backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        layer.cornerRadius = 12
        contentView.addSubview(picture)
        picture.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ImagesCollectionViewCell {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            picture.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            picture.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}

extension ImagesCollectionViewCell {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard imageCell == imageSelect else { return delegate.didWrondTapCell() }
        delegate.didTapCell(image: imageCell, index: indexCell)
    }
}
