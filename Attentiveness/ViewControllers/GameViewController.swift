//
//  GameViewController.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import UIKit

protocol GameViewControllerDelegate {
    func didTapCell(image: String, index: Int)
    func didWrondTapCell()
}

class GameViewController: UIViewController {
    private lazy var labelTime: UILabel = {
        setupLabel(title: "\(seconds)", size: 150, opacity: 1)
    }()
    
    private lazy var buttonYes: UIButton = {
        setupButton(
            title: "Yes",
            color: .systemGreen,
            action: #selector(pressYes),
            isEnabled: true)
    }()
    
    private lazy var buttonNo: UIButton = {
        setupButton(
            title: "No",
            color: .systemRed,
            action: #selector(pressNo),
            isEnabled: true)
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonYes, buttonNo])
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var imageFirst: UIImageView = {
        setupImage(image: "heart.fill")
    }()
    
    private lazy var imageSecond: UIImageView = {
        setupImage(image: "heart.fill")
    }()
    
    private lazy var imageThird: UIImageView = {
        setupImage(image: "heart.fill")
    }()
    
    private lazy var buttonClose: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.layer.opacity = 0
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
        imageView.layer.opacity = 0
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
        collectionView.layer.opacity = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var buttonReset: UIButton = {
        setupButton(
            title: "RESET",
            color: .systemGray2,
            action: #selector(reset),
            isEnabled: false)
    }()
    
    var images: ([String], [String])!
    var theme: Themes!
    var count: Count!
    
    private var imageTap = String()
    private var isHidden: [Bool] = []
    private var countTap = 0
    private var timer = Timer()
    private var seconds = 3
    private var wrong = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarSubviews()
        setRandomImage()
        setHidden()
        setupConstraints()
        startGame()
    }
    
    private func setupDesign() {
        view.backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1)
        navigationItem.hidesBackButton = true
        hideTime()
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: imageFirst, imageSecond, imageThird, labelTime,
                      stackView, collectionView, labelTitle, imageTitle,
                      labelName, buttonReset, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    private func opacityOnOff(subviews: UIView..., opacity: Float) {
        UIView.animate(withDuration: 0.6) {
            subviews.forEach { subview in
                subview.layer.opacity = opacity
            }
        }
    }
    
    private func setupBarSubviews() {
        let rightButton = UIBarButtonItem(customView: buttonClose)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setRandomImage() {
        guard !images.1.isEmpty else { return endGame() }
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
    
    private func endGame() {
        let title = wrong < 3 ? titleVictory() : titleDefeat()
        subviewsOnOff(isOn: false)
        setTitleTimer(time: "\(title)")
        labelTime.font = UIFont(name: "copperplate", size: 32)
        opacityOnOff(subviews: buttonYes, buttonNo, opacity: 1)
    }
    
    private func titleVictory() -> String {
        """
        Congratulations!
        You managed to find everything.
        Would you like start a new game?
        """
    }
    
    private func titleDefeat() -> String {
        """
        Unfortunately, you couldn't handle it.
        Would you like to try again?
        """
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
    
    private func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    
    private func startGame() {
        showTime(time: 1, scale: 1.5)
        timer = runTimer(time: 1, action: #selector(runTime), repeats: true)
    }
    
    @objc private func runTime() {
        seconds -= 1
        hideTime()
        seconds > 0 ? showTime(time: 1, scale: 1.5) : showTime(time: 0.3, scale: 1)
        seconds > 0 ? setTitleTimer(time: "\(seconds)") : setTitleTimer(time: "GO!")
        guard seconds == 0 else { return }
        timer.invalidate()
        timer = runTimer(time: 0.6, action: #selector(showSubviews), repeats: false)
    }
    
    private func showTime(time: CGFloat, scale: CGFloat) {
        UIView.animate(withDuration: time) {
            self.labelTime.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    private func hideTime() {
        labelTime.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    private func setTitleTimer(time: String) {
        labelTime.text = time
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        subviewsOnOff(isOn: true)
    }
    
    private func subviewsOnOff(isOn: Bool) {
        opacityOnOff(subviews: imageFirst, imageSecond, imageThird, buttonClose,
                     labelTitle, imageTitle, labelName, collectionView,
                     buttonReset, opacity: isOn ? 1 : 0)
        opacityOnOff(subviews: labelTime, opacity: isOn ? 0 : 1)
    }
    
    @objc private func backToMenu() {
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func reset() {
        buttonOnOff(isOn: false)
        countTap = 0
        wrong = 0
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
    
    @objc private func pressYes() {
        opacityOnOff(subviews: labelTime, buttonYes, buttonNo, opacity: 0)
        reset()
        timer = runTimer(time: 0.6, action: #selector(startNewGame), repeats: false)
    }
    
    @objc private func startNewGame() {
        timer.invalidate()
        opacityOnOff(subviews: imageFirst, imageSecond, imageThird, buttonClose,
                     labelTitle, imageTitle, labelName, collectionView,
                     buttonReset, opacity: 1)
    }
    
    @objc private func pressNo() {
        navigationController?.popViewController(animated: false)
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
    private func setupLabel(title: String, size: CGFloat, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "copperplate", size: size)
        label.text = title
        label.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        label.layer.opacity = opacity ?? 0
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension GameViewController {
    private func setupButton(title: String, color: UIColor, action: Selector, 
                             isEnabled: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont(name: "copperplate", size: 25)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 4
        button.isEnabled = isEnabled
        button.layer.opacity = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}

extension GameViewController {
    private func setupImage(image: String) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 28)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .systemRed
        imageView.layer.opacity = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension GameViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageFirst.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -37.5),
            imageFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            imageSecond.centerYAnchor.constraint(equalTo: imageFirst.centerYAnchor),
            imageSecond.leadingAnchor.constraint(equalTo: imageFirst.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            imageThird.centerYAnchor.constraint(equalTo: imageSecond.centerYAnchor),
            imageThird.leadingAnchor.constraint(equalTo: imageSecond.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            labelTime.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTime.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            labelTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5)
        ])
        
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

extension GameViewController {
    func didWrondTapCell() {
        wrong += 1
        switch wrong {
        case 1: opacityOnOff(subviews: imageThird, opacity: 0)
        case 2: opacityOnOff(subviews: imageSecond, opacity: 0)
        default: 
            opacityOnOff(subviews: imageFirst, opacity: 0)
            endGame()
        }
    }
}
