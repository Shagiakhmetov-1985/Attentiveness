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

protocol PopUpViewDelegate {
    func pressButtonYes()
    func pressButtonNo()
}

class GameViewController: UIViewController {
    private lazy var labelTime: UILabel = {
        setupLabel(title: "", size: 150, opacity: 1)
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
        setupStackView(spacing: 10, first: buttonYes, second: buttonNo)
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
    
    private lazy var stackViewImages: UIStackView = {
        setupStackView(spacing: -5, first: imageFirst, second: imageSecond, third: imageThird)
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
    
    private lazy var labelCountdown: UILabel = {
        setupLabel(title: "", size: 35)
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
            action: #selector(pressReset),
            isEnabled: false)
    }()
    
    private lazy var viewReset: UIView = {
        let view = PopUpView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    private var springCollectionView: NSLayoutConstraint!
    private let shapeLayer = CAShapeLayer()
    
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
        setupSubviews(subviews: stackViewImages, labelCountdown, labelTime,
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
    
    private func enableOnOff(subviews: UIView..., isOn: Bool) {
        subviews.forEach { subview in
            subview.isUserInteractionEnabled = isOn
        }
    }
    
    private func darkScreenOnOff(isOn: Bool) {
        let opacity: Float = isOn ? 0.4 : 1
        opacityOnOff(subviews: imageFirst, imageSecond, imageThird, labelCountdown,
                     buttonClose, labelTitle, imageTitle, labelName, collectionView,
                     buttonReset, opacity: opacity)
        enableOnOff(subviews: buttonClose, collectionView, buttonReset, isOn: !isOn)
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
        timer.invalidate()
        seconds > 0 ? stopAnimationCircleCountdown() : ()
        let title = wrong < 3 ? titleVictory() : titleDefeat()
        subviewsOnOff(isOn: false)
        setTitle(labelTime, "\(title)", 32)
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
        setTitle(labelTime, "\(seconds)", 150)
        showTime(time: 1, scale: 1.5)
        timer = runTimer(time: 1, action: #selector(runTime), repeats: true)
    }
    
    @objc private func runTime() {
        seconds -= 1
        hideTime()
        seconds > 0 ? showTime(time: 1, scale: 1.5) : showTime(time: 0.3, scale: 1)
        seconds > 0 ? setTitle(labelTime, "\(seconds)", 150) : setTitle(labelTime, "GO!", 150)
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
    
    private func setTitle(_ label: UILabel, _ title: String, _ size: CGFloat) {
        label.text = title
        label.font = UIFont(name: "copperplate", size: size)
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        subviewsOnOff(isOn: true)
        setCircleCountdown()
        setTitleCountdown()
        timer = runTimer(time: 0.6, action: #selector(runCountdown), repeats: false)
    }
    
    private func setCircleCountdown() {
        circularShadow()
        circular(strokeEnd: 0)
        animationCircleCountdownReset()
    }
    
    private func setTitleCountdown() {
        seconds = timeCoundown(count: count)
        labelCountdown.text = "\(seconds)"
    }
    
    private func subviewsOnOff(isOn: Bool) {
        opacityOnOff(subviews: imageFirst, imageSecond, imageThird, labelCountdown,
                     buttonClose, labelTitle, imageTitle, labelName, collectionView,
                     buttonReset, opacity: isOn ? 1 : 0)
        opacityOnOff(subviews: labelTime, opacity: isOn ? 0 : 1)
    }
    
    @objc private func runCountdown() {
        timer.invalidate()
        shapeLayer.strokeEnd = 1
        animationRunCircleCountdown()
        timer = runTimer(time: 1, action: #selector(setTitleTime), repeats: true)
    }
    
    @objc private func setTitleTime() {
        seconds -= 1
        labelCountdown.text = "\(seconds)"
        guard seconds == 0 else { return }
        timer.invalidate()
        wrong = 3
        endGame()
    }
    
    @objc private func backToMenu() {
        timer.invalidate()
        navigationController?.popViewController(animated: false)
    }
    
    @objc private func pressReset() {
        setupSubviews(subviews: viewReset, on: view)
        setupConstraintsView()
        darkScreenOnOff(isOn: true)
        
        viewReset.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        viewReset.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            view.backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1).withAlphaComponent(0.4)
            viewReset.alpha = 1
            viewReset.transform = .identity
        }
    }
    
    @objc private func reset() {
        buttonOnOff(isOn: false)
        countTap = 0
        wrong = 0
        seconds = 3
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
        opacityOnOff(subviews: imageFirst, imageSecond, imageThird, labelCountdown,
                     buttonClose, labelTitle, imageTitle, labelName, collectionView,
                     buttonReset, opacity: 1)
        shapeLayer.strokeEnd = 0
        animationCircleCountdownReset()
        setTitleCountdown()
        timer = runTimer(time: 0.6, action: #selector(runCountdown), repeats: false)
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
    private func setupStackView(spacing: CGFloat, first: UIView, second: UIView, 
                                third: UIView? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.spacing = spacing
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if let third = third {
            stackView.addArrangedSubview(third)
        }
        return stackView
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
            stackViewImages.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -37.5),
            stackViewImages.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            labelCountdown.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelCountdown.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
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
        
        springCollectionView = NSLayoutConstraint(
            item: collectionView, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(springCollectionView)
        NSLayoutConstraint.activate([
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
    
    private func setupConstraintsView() {
        NSLayoutConstraint.activate([
            viewReset.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewReset.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewReset.heightAnchor.constraint(equalToConstant: 150),
            viewReset.widthAnchor.constraint(equalToConstant: 320)
        ])
    }
}

extension GameViewController {
    private func circularShadow() {
        let center = CGPoint(x: labelCountdown.center.x, y: labelCountdown.center.y + 17.5)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 33,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 8
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.layer.addSublayer(trackShape)
    }
    
    private func circular(strokeEnd: CGFloat) {
        let center = CGPoint(x: labelCountdown.center.x, y: labelCountdown.center.y + 17.5)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 33,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.lineCap = CAShapeLayerLineCap.butt
        shapeLayer.strokeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1).cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animationRunCircleCountdown() {
        let timer = timeCoundown(count: count)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationCircleCountdownReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func stopAnimationCircleCountdown() {
        let fullTime = timeCoundown(count: count)
        let time = CGFloat(seconds) / CGFloat(fullTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
    
    private func timeCoundown(count: Count) -> Int {
        switch count {
        case .twelve: return 20
        case .twentyFour: return 40
        default: return 60
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
        setAnimation()
        switch wrong {
        case 1: opacityOnOff(subviews: imageThird, opacity: 0)
        case 2: opacityOnOff(subviews: imageSecond, opacity: 0)
        default: 
            opacityOnOff(subviews: imageFirst, opacity: 0)
            endGame()
        }
    }
    
    private func setAnimation() {
        animation(duration: 0.07, delay: 0, constant: 40)
        animation(duration: 0.07, delay: 0.07, constant: -80)
        animation(duration: 0.07, delay: 0.14, constant: 40)
    }
    
    private func animation(duration: CGFloat, delay: CGFloat, constant: CGFloat) {
        UIView.animate(withDuration: duration, delay: delay) { [self] in
            springCollectionView.constant += constant
            view.layoutIfNeeded()
        }
    }
}

extension GameViewController: PopUpViewDelegate {
    func pressButtonYes() {
        closeView()
        timer = runTimer(time: 0.6, action: #selector(dataReset), repeats: false)
    }
    
    func pressButtonNo() {
        closeView()
    }
    
    private func closeView() {
        darkScreenOnOff(isOn: false)
        removeView()
    }
    
    @objc private func dataReset() {
        timer.invalidate()
        subviewsOnOff(isOn: false)
        hideTime()
        timer = runTimer(time: 0.6, action: #selector(startReset), repeats: false)
    }
    
    @objc private func startReset() {
        timer.invalidate()
        reset()
        startGame()
    }
    
    private func removeView() {
        UIView.animate(withDuration: 0.5) { [self] in
            viewReset.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            viewReset.alpha = 0
            view.backgroundColor = #colorLiteral(red: 0.8025280833, green: 0.9857317805, blue: 0.6650850177, alpha: 1)
        } completion: { [self] _ in
            viewReset.removeFromSuperview()
        }
    }
}
