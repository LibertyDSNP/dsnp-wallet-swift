//
//  SeedPhraseViewController.swift
//  DSNP-Wallet
//
//  Created by Ryan Sheh on 1/5/23.
//

import Foundation
import UIKit

class SeedPhraseViewController: UIViewController {
    
    private enum SeedPhraseCreationState {
        case viewSeedPhrase
        case confirmSeedPhrase
    }
    
    private var viewModel: SeedPhraseViewModel?
    private var selectedWords: [String] = [] {
        didSet {
            topCollectionView?.reloadData()
            bottomCollectionView?.reloadData()
        }
    }
    private var remainingWords: [String] = [] {
        didSet {
            topCollectionView?.reloadData()
            bottomCollectionView?.reloadData()
        }
    }
    
    private var stackView: UIStackView?
    private let sharedSpacer = SharedSpacer(height: 4.0)
    private var titleLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var nextBtn = SharedButton()
    
    private var topCollectionView: UICollectionView?
    private var bottomCollectionView: UICollectionView?
    private let collectionViewSpacing = 10.0
    private let collectionViewCellHeight = 20
    
    private var state: SeedPhraseCreationState = .viewSeedPhrase {
        didSet {
            selectedWords = []
            remainingWords = viewModel?.seedPhraseWords.shuffled() ?? []
            
            setLabels()
            setBtns()
            
            self.handleBottomCollectionView(hide: state == .viewSeedPhrase)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = SeedPhraseViewModel()
        remainingWords = viewModel?.seedPhraseWords.shuffled() ?? []
        
        view.backgroundColor = .white
        setLabels()
        setBtns()
        setCollectionViews()
        setStackView()
        setAccessibilityIds()
    }
    
    //MARK: UI
    func setStackView() {
        stackView = UIStackView()
        
        guard let stackView = stackView else { return }
        
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(sharedSpacer)
            
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(sharedSpacer)
        
        if let topCollectionView = topCollectionView {
            stackView.addArrangedSubview(topCollectionView)
            stackView.addArrangedSubview(sharedSpacer)
        }
        
        if let bottomCollectionView = bottomCollectionView {
            handleBottomCollectionView(hide: true)
            stackView.addArrangedSubview(bottomCollectionView)
            stackView.addArrangedSubview(sharedSpacer)
        }
        
        stackView.addArrangedSubview(nextBtn)
        stackView.addArrangedSubview(sharedSpacer)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: (view.frame.height * 0.6)).isActive = true
    }
    
    private func setLabels() {
        titleLabel.text = state == .viewSeedPhrase ? "There will be a test" : "This is the test"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = state == .viewSeedPhrase ? "Please carefully write down these 12 words below in numerical order (1-12) and store your secret phrase securely. You will confirm them in order on the next screen." : "Tap the words in numerical order (1-12) to verify your recovery phrase"
    }
    
    private func setAccessibilityIds() {
        titleLabel.accessibilityIdentifier = "pageTitle"
        descriptionLabel.accessibilityIdentifier = "pageDescriptionLabel"
        topCollectionView?.accessibilityIdentifier = "selectionGridResult"
        bottomCollectionView?.accessibilityIdentifier = "selectionGridInput"
    }
    
    
    private func setBtns() {
        let nextBtnTitle = state == .viewSeedPhrase ? "I've written it down" : "Continue"
        nextBtn.setTitle(nextBtnTitle, for: .normal)
        nextBtn.addTarget(self, action: #selector(didTapBtn(selector:)), for: .touchUpInside)
    }
    
    private func setCollectionViews() {
        let topCollectionViewLayout = SeedPhraseColumnFlowLayout(
            cellsPerRow: 2,
            cellHeight: collectionViewCellHeight,
            minimumInteritemSpacing: collectionViewSpacing,
            minimumLineSpacing: collectionViewSpacing,
            sectionInset: UIEdgeInsets(top: collectionViewSpacing, left: collectionViewSpacing, bottom: collectionViewSpacing, right: collectionViewSpacing))
        
        let bottomCollectionViewLayout = SeedPhraseColumnFlowLayout(
            cellsPerRow: 3,
            cellHeight: collectionViewCellHeight,
            minimumInteritemSpacing: collectionViewSpacing,
            minimumLineSpacing: collectionViewSpacing,
            sectionInset: UIEdgeInsets(top: collectionViewSpacing, left: collectionViewSpacing, bottom: collectionViewSpacing, right: collectionViewSpacing)
        )
        
        topCollectionView = {
            let cv = UICollectionView(frame: .zero,
                                      collectionViewLayout: topCollectionViewLayout)
            cv.delegate = self
            cv.dataSource = self
            cv.contentInsetAdjustmentBehavior = .always
            cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SeedPhraseCollectionViewCell.cellId)
            
            cv.collectionViewLayout = SeedPhraseColumnFlowLayout(
                cellsPerRow: 2,
                cellHeight: collectionViewCellHeight,
                minimumInteritemSpacing: collectionViewSpacing,
                minimumLineSpacing: collectionViewSpacing,
                sectionInset: UIEdgeInsets(top: collectionViewSpacing, left: collectionViewSpacing, bottom: collectionViewSpacing, right: collectionViewSpacing))
            
            let topCollectionViewNumCol = (viewModel?.seedPhraseWords.count ?? 0)/topCollectionViewLayout.cellsPerRow
            let topCollectionViewHeight = (topCollectionViewNumCol * collectionViewCellHeight) + ((topCollectionViewNumCol + 1) * Int(collectionViewSpacing))
            cv.heightAnchor.constraint(equalToConstant: CGFloat(topCollectionViewHeight)).isActive = true
            
            cv.register(SeedPhraseCollectionViewCell.self, forCellWithReuseIdentifier: SeedPhraseCollectionViewCell.cellId)
            
            return cv
        }()
        
        bottomCollectionView = {
            let cv = UICollectionView(frame: .zero,
                                      collectionViewLayout: bottomCollectionViewLayout)
            cv.delegate = self
            cv.dataSource = self
            cv.contentInsetAdjustmentBehavior = .always
            cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: SeedPhraseCollectionViewCell.cellId)
            
            let bottomCollectionViewNumCol = (viewModel?.seedPhraseWords.count ?? 0)/bottomCollectionViewLayout.cellsPerRow
            let bottomCollectionViewHeight = (bottomCollectionViewNumCol * collectionViewCellHeight) + ((bottomCollectionViewNumCol + 1) * Int(collectionViewSpacing))
            cv.heightAnchor.constraint(equalToConstant: CGFloat(bottomCollectionViewHeight)).isActive = true
            
            cv.register(SeedPhraseCollectionViewCell.self, forCellWithReuseIdentifier: SeedPhraseCollectionViewCell.cellId)
            
            return cv
        }()
    }
    
    private func handleBottomCollectionView(hide: Bool) {
        bottomCollectionView?.alpha = hide ? 0.0 : 1.0
        bottomCollectionView?.isUserInteractionEnabled = hide ? false : true
    }
    
    //MARK: Outlets
    @objc func didTapBtn(selector: UIButton?) {
        if state == .viewSeedPhrase {
            let alert = UIAlertController(title: "Written the Secret Phrase down?",
                                          message: "Without the secret recovery phrase you will not able to access your key or any assets associated with it.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.state = .confirmSeedPhrase
            }))
            alert.addAction(UIAlertAction(title: "Check Again", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            let isValidSeedPhrase = viewModel?.seedPhraseWords == selectedWords
            
            let alert = UIAlertController(title: isValidSeedPhrase ? "Valid" : "Invalid",
                                          message: nil,
                                          preferredStyle: .alert)
            
            if isValidSeedPhrase {
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
                    self.dismiss(animated: true)
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { _ in
                    self.state = .viewSeedPhrase
                }))
            }
            
            self.present(alert, animated: true)
        }
    }
    
    private func presentVC() {
        let vc: UIViewController?
        
        vc = ViewControllerFactory.restoreDsnpIdViewController.instance()
        
        guard let vc = vc else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension SeedPhraseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.seedPhraseWords.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vertIndex = convertToVerticalIndex(from: indexPath.row, totalCount: viewModel?.seedPhraseWords.count ?? 0) else { return UICollectionViewCell() }
        let index = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeedPhraseCollectionViewCell.cellId, for: indexPath) as? SeedPhraseCollectionViewCell
        
        if collectionView == topCollectionView {
            cell?.number = vertIndex
            cell?.accessibilityIdentifier = "resultCell"
            if state == .viewSeedPhrase {
                cell?.word = viewModel?.seedPhraseWords[vertIndex]
            } else if state == .confirmSeedPhrase {
                let validIndex = selectedWords.indices.contains(vertIndex)
                cell?.word = validIndex ? selectedWords[vertIndex] : nil
            }
        }
        
        if collectionView == bottomCollectionView {
            let validIndex = remainingWords.indices.contains(index)
            cell?.word = validIndex ? remainingWords[index] : nil
            cell?.isDeselected = !validIndex
        }
    
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vertIndex = convertToVerticalIndex(from: indexPath.row, totalCount: viewModel?.seedPhraseWords.count ?? 0) else { return }
        let index = indexPath.row
        
        let _ = collectionView.dequeueReusableCell(withReuseIdentifier: SeedPhraseCollectionViewCell.cellId, for: indexPath) as? SeedPhraseCollectionViewCell
        
        if collectionView == topCollectionView {
            guard selectedWords.indices.contains(vertIndex) else { return }
            
            let selectedWord = selectedWords[vertIndex]
            remainingWords.append(selectedWord)
            selectedWords.remove(at: vertIndex)
        }
        
        if collectionView == bottomCollectionView {
            guard remainingWords.indices.contains(index) else { return }
            
            let selectedWord = remainingWords[index]
            selectedWords.append(selectedWord)
            remainingWords.remove(at: index)
        }
        
        return
    }
    
    private func convertToVerticalIndex(from horizontalIndex: Int, totalCount: Int) -> Int? {
        var newIndex: Int?
         
        //even indices = left column
        if horizontalIndex % 2 == 0 {
            newIndex = horizontalIndex/2
        } else if horizontalIndex % 2 == 1  { //odd indices = right column
            newIndex = horizontalIndex + ((totalCount - horizontalIndex)/2)
        }
        
        return newIndex ?? nil
    }
}
