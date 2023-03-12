//
//  ImageLoadViewController.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/03/12.
//

import UIKit




final class ImageLoadViewController: UIViewController {
    private let stackView = UIStackView()
    private let allLoadButton = UIButton()
    
    lazy var loadViews = stackView.arrangedSubviews as? [ImageLoadView]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        reset()
    }
    
    func reset() {
        guard let loadViews = loadViews else { return }
        loadViews.forEach { $0.reset() }
    }
    
    func allLoad() {
        guard let loadViews = loadViews else { return }
        loadViews.forEach { $0.downloadImage() }
    }
    
    @objc func allLoadButtonTapped(_ sender: UIButton) {
        allLoad()
    }
}

private extension ImageLoadViewController {
    func layout() {
        view.backgroundColor = .white
        [
            stackView,
            allLoadButton
        ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        (0...4).forEach {
            let size = view.bounds.size
            let imageLoadView = ImageLoadView(frame: CGRect(origin: .zero, size: CGSize(width: size.width, height: 80)))
            imageLoadView.tag = $0
            stackView.addArrangedSubview(imageLoadView)
        }
        
        allLoadButton.setTitle("All Load Imaeg", for: .normal)
        allLoadButton.backgroundColor = .systemBlue
        allLoadButton.tintColor = .clear
        allLoadButton.addTarget(self, action: #selector(allLoadButtonTapped), for: .touchUpInside)
        anchorUI()
    }
    
    func anchorUI() {
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
        )
        
        NSLayoutConstraint.activate(
            [
                allLoadButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
                allLoadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
                allLoadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                allLoadButton.heightAnchor.constraint(equalToConstant: 44)
            ]
        )
    }
}


