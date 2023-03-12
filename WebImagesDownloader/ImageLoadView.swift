//
//  ImageLoadView.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/03/12.
//

import UIKit

fileprivate enum ImageURL {
    private static let imageIds: [String] = [
        "europe-4k-1369012",
        "europe-4k-1318341",
        "europe-4k-1379801",
        "cool-lion-167408",
        "iron-man-323408"
    ]
    
    static subscript(index: Int) -> URL {
        let id = imageIds[index]
        return URL(string: "https://wallpaperaccess.com/download/"+id)!
    }
}

final class ImageLoadView: UIView {
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let progressView = UIProgressView()
    private let loadButton = UIButton()
    
    private let placeholderImage = UIImage(systemName: "photo.fill")
    private var urlString = ""
    private var loadComplete = true
    private var observation: NSKeyValueObservation!
    lazy var imageLoader = ImageDownLoadManager(url: ImageURL[tag])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        OperationQueue.main.addOperation { [weak self] in
            guard let self = self else { return }
            self.progressView.progress = 0
            self.imageView.image = self.placeholderImage
            self.loadButton.isSelected = false
            self.imageLoader.reset()
        }
    }
    
    func downloadImage() {
        let work = imageLoader.makeWork { [weak self] progress in
            guard let self = self else { return }
            self.observation = progress.observe(\.fractionCompleted) { process, _ in
                print(self.imageLoader.workItem.isCancelled)
                guard self.imageLoader.workItem.isCancelled == false else {
                    self.imageLoader.reset()
                    return }
                self.showProgress(progress: Float(process.fractionCompleted))
            }
        } completion: { [weak self] result in
            
            switch result {
            case .success(let image):
                self?.showImage(image: image)
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.reset()
            }
        }
        
        OperationQueue().addOperation(work)
    }
    
    func showProgress(progress: Float = 0) {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.progress = progress
        }
    }
    
    func showImage(image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
            self?.loadButton.isSelected = false
        }
    }
}

private extension ImageLoadView {
    @objc func loadButtonTapped(_ sender: UIButton) {
        imageView.image = placeholderImage
        sender.isSelected = !sender.isSelected
        guard sender.isSelected else {
            imageLoader.workItem.cancel()
            
            return
        }
        downloadImage()
    }
    
    func layout() {
        backgroundColor = .white
        
        addSubview(stackView)
        
        [
            imageView,
            progressView,
            loadButton
        ]
            .forEach {
                stackView.addArrangedSubview($0)
            }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        
        imageView.image = placeholderImage
        
        progressView.progress = 0
        progressView.progressTintColor = .blue
        
        loadButton.layer.cornerRadius = 5
        loadButton.setTitle("Load", for: .normal)
        loadButton.backgroundColor = .blue
        loadButton.setTitleColor(.white, for: .normal)
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        anchorUI()
    }
    
    func anchorUI() {
        
        NSLayoutConstraint
            .activate(
                [
                    stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                    stackView.topAnchor.constraint(equalTo: topAnchor),
                    stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                    stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        
        NSLayoutConstraint
            .activate([
                imageView.heightAnchor.constraint(equalToConstant: 80),
                imageView.widthAnchor.constraint(equalToConstant: 100)
            ])

        NSLayoutConstraint
            .activate([
                progressView.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            ])

        NSLayoutConstraint
            .activate([
                loadButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 75),
                loadButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}
