//
//  ViewController.swift
//  SurfApp
//
//  Created by Valya on 10.02.2023.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.bounces = false
        v.showsVerticalScrollIndicator = false
        v.clipsToBounds = false
        return v
    }()
    
    private let header = {
        let h =  Header(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        h.imageView.image = UIImage(named: "surf")
        h.translatesAutoresizingMaskIntoConstraints = false
        return h
    }()
    
    private let scrollContent = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.alignment = .top
        v.distribution = .equalSpacing
        v.spacing = 0
        v.layer.cornerRadius = 25
        v.backgroundColor = .white
        return v
    }()
    
    private let surfTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let surfDescription = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let secondSurfDescription = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let question = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private let firstButtonContainerScroll = {
        let v = UIScrollView()
        v.clipsToBounds = false
        v.isScrollEnabled = true
        v.alwaysBounceHorizontal = true
        v.showsHorizontalScrollIndicator = false
        return v
    }()
    
    private let firstButtonContainer = {
        let v = UIStackView()
        v.spacing = 0
        v.distribution = .equalSpacing
        v.alignment = .fill
        v.axis = .horizontal
        return v
    }()
    
    private let footer = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    private let bottomSheetFillView = {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 400).isActive = true
        v.backgroundColor = .purple
        return v
    }()
    
    private let buttonsArray = [
        "IOS",
        "Android",
        "Design",
        "Flutter",
        "QA",
        "PM",
        "IOS",
        "Android",
        "Design",
        "Flutter",
        "QA",
        "PM"
    ]
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    private let questionButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .white
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 44, bottom: 20, trailing: 44)
        config.attributedTitle = AttributedString(
            "Отправить заявку",
            attributes: Foundation.AttributeContainer([
                NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Bold", size: 16)!
            ])
        )
        b.configuration = config
        b.addTarget(self, action: #selector(surfAlert), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(footer)
        view.addSubview(question)
        view.addSubview(questionButton)
        
        scrollView.delegate = self
        scrollView.addSubview(header)
        scrollView.addSubview(scrollContent)
        collectionView.delegate = self
        collectionView.dataSource = self
        configure()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
    }
    
    func configure() {
        
        scrollViewConctraints()
        headerConctraints2()
        scrollContentConctraints()
        
        initLabel(targetLabel: surfTitle, font: UIFont(name: "SFProDisplay-Bold", size: 24), color: .black)
        scrollContent.addArrangedSubview(surfTitle)
        surfTitleConstraint()
        surfTitle.text = "Стажировка в Surf"
        
        initLabel(targetLabel: surfDescription, font: UIFont(name: "SFProDisplay-Regular", size: 14), color: .darkGray)
        scrollContent.addArrangedSubview(surfDescription)
        surfDescriptionConstraint()
        surfDescription.text = "Работай над реальными задачами под руководством опытного наставника и получи возможность стать частью команды мечты."
        
        scrollContent.addArrangedSubview(firstButtonContainerScroll)
        firstButtonContainerScrollConstraint()
        
        firstButtonContainerScroll.addSubview(firstButtonContainer)
        firstButtonContainerConstraints()
        
        initLabel(targetLabel: secondSurfDescription, font: UIFont(name: "SFProDisplay-Regular", size: 14), color: .darkGray)
        scrollContent.addArrangedSubview(secondSurfDescription)
        secondSurfDescriptionnConstraint()
        secondSurfDescription.text = "Получай стипендию, выстраивай удобный график, работай на современном железе."
        
        initLabel(targetLabel: question, font: UIFont(name: "SFProDisplay-Regular", size: 14), color: .darkGray)
        questionConstraint()
        question.text = "Хочешь к нам?"
        
        questionButtonConstraint()
        scrollContent.addArrangedSubview(collectionView)
        collectionConstraint()
        
        footerConstraint()
        fillFirstContainer()
        surfAlert()
        scrollContent.addArrangedSubview(bottomSheetFillView)
    }
    
    private func initLabel(targetLabel: UILabel, font:UIFont?, alinment: NSTextAlignment = .left, color: UIColor) {
        targetLabel.textColor = color
        targetLabel.font = font
        targetLabel.textAlignment = alinment
        targetLabel.numberOfLines = 4
        targetLabel.lineBreakMode = .byTruncatingTail
        targetLabel.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            return
        }
        header.updateScroll(scrollView: scrollView)
    }
    
    func fillFirstContainer() {
        let radioButtons: [RadioButton] = buttonsArray.map { str in
            let button = RadioButton()
            
            var config = UIButton.Configuration.filled()
            config.attributedTitle =  AttributedString(str, attributes: Foundation.AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 14)!]))
            config.cornerStyle = .large
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
            button.configuration = config
            button.isSelected = false
            return button
        }
        
        for (i, button) in radioButtons.enumerated() {
            button.alternateButton = radioButtons.filter({ alternate in
                alternate != button
            })
            
            if i == 0 {
                firstButtonContainer.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0)))
            }
            
            firstButtonContainer.addArrangedSubview(button)
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            
            if i == radioButtons.count-1 {
                firstButtonContainer.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0)))
            }
        }
    }
    
    @objc private func surfAlert() {
        let alert = UIAlertController(title: "Поздравляем!",
                                      message: "Ваша заявка успешно отправлена!",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Закрыть",
                                      style: .default))
        
        present(alert, animated: true, completion: nil)
    }
    // MARK: - constraints
    func headerConctraints2(){
        header.leftAnchor.constraint(equalTo:  scrollView.contentLayoutGuide.leftAnchor).isActive = true
        header.topAnchor.constraint(equalTo:  scrollView.contentLayoutGuide.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo:  scrollView.contentLayoutGuide.rightAnchor).isActive = true
        header.bottomAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 120).isActive = true
        header.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: view.frame.height/1.5).isActive = true
    }
    
    func scrollViewConctraints(){
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func scrollContentConctraints(){
        scrollContent.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
        scrollContent.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        scrollContent.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor).isActive = true
        scrollContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 80).isActive = true
        scrollContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    private func surfTitleConstraint() {
        surfTitle.topAnchor.constraint(equalTo: scrollContent.topAnchor, constant: 24).isActive = true
        surfTitle.rightAnchor.constraint(equalTo: scrollContent.rightAnchor, constant: -20).isActive = true
        surfTitle.leftAnchor.constraint(equalTo: scrollContent.leftAnchor, constant: 20).isActive = true
    }
    
    private func surfDescriptionConstraint() {
        surfDescription.translatesAutoresizingMaskIntoConstraints = false
        surfDescription.topAnchor.constraint(equalTo: surfTitle.bottomAnchor, constant: 12).isActive = true
        surfDescription.rightAnchor.constraint(equalTo: scrollContent.rightAnchor, constant: -20).isActive = true
        surfDescription.leftAnchor.constraint(equalTo: scrollContent.leftAnchor, constant: 20).isActive = true
    }
    
    private func firstButtonContainerScrollConstraint() {
        firstButtonContainerScroll.translatesAutoresizingMaskIntoConstraints = false
        firstButtonContainerScroll.topAnchor.constraint(equalTo: surfDescription.bottomAnchor, constant: 12).isActive = true
        firstButtonContainerScroll.rightAnchor.constraint(equalTo: scrollContent.rightAnchor).isActive = true
        firstButtonContainerScroll.leftAnchor.constraint(equalTo: scrollContent.leftAnchor).isActive = true
        firstButtonContainerScroll.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func firstButtonContainerConstraints() {
        firstButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        firstButtonContainer.leftAnchor.constraint(equalTo: firstButtonContainerScroll.contentLayoutGuide.leftAnchor).isActive = true
        firstButtonContainer.topAnchor.constraint(equalTo: firstButtonContainerScroll.contentLayoutGuide.topAnchor).isActive = true
        firstButtonContainer.rightAnchor.constraint(equalTo: firstButtonContainerScroll.contentLayoutGuide.rightAnchor).isActive = true
        firstButtonContainer.bottomAnchor.constraint(equalTo: firstButtonContainerScroll.contentLayoutGuide.bottomAnchor).isActive = true
        firstButtonContainer.heightAnchor.constraint(equalTo: firstButtonContainerScroll.heightAnchor).isActive = true
    }
    
    private func secondSurfDescriptionnConstraint() {
        secondSurfDescription.translatesAutoresizingMaskIntoConstraints = false
        secondSurfDescription.topAnchor.constraint(equalTo: firstButtonContainerScroll.bottomAnchor, constant: 24).isActive = true
        secondSurfDescription.rightAnchor.constraint(equalTo: scrollContent.rightAnchor, constant: -20).isActive = true
        secondSurfDescription.leftAnchor.constraint(equalTo: scrollContent.leftAnchor, constant: 20).isActive = true
    }
    
    private func footerConstraint() {
        footer.translatesAutoresizingMaskIntoConstraints = false
        footer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        footer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        footer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        footer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func questionConstraint() {
        question.translatesAutoresizingMaskIntoConstraints = false
        question.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        question.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        question.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
    }
    
    private func questionButtonConstraint() {
        questionButton.translatesAutoresizingMaskIntoConstraints = false
        questionButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        questionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        questionButton.leftAnchor.constraint(equalTo: question.rightAnchor).isActive = true
        questionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        questionButton.topAnchor.constraint(equalTo: footer.topAnchor).isActive = true
    }
    
    private func collectionConstraint() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        collectionView.topAnchor.constraint(equalTo: secondSurfDescription.bottomAnchor, constant: 12).isActive = true
        collectionView.leftAnchor.constraint(equalTo: scrollContent.leftAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: scrollContent.rightAnchor, constant: -20).isActive = true
    }
    
}
// MARK: - extension

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionCell
        cell.setTitle(title: buttonsArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let q = NSAttributedString(string: buttonsArray[indexPath.row], attributes: ([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 14)!]))
        return CGSize(width: q.size().width, height: 44)
    }
}

class CollectionCell: UICollectionViewCell {
    
    private let collectionButton = {
        let button = RadioButton()
        var config = UIButton.Configuration.filled()
        
        config.attributedTitle =  AttributedString("", attributes: Foundation.AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 14)!]))
        config.cornerStyle = .large
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        button.configuration = config
        button.isSelected = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionButton)
        collectionButton.sizeToFit()
        collectionButton.translatesAutoresizingMaskIntoConstraints = false
        collectionButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitle(title: String) {
        collectionButton.configuration?.attributedTitle = AttributedString(title, attributes: Foundation.AttributeContainer([NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 14)!]))
    }
}
