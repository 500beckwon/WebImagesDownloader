//
//  ImageDownLoadCollectionCell.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/02/17.
//

import UIKit

final class ImageDownLoadCollectionCell: UICollectionViewCell {
    
    static let cellID = "ImageDownLoadCollectionCell"
    
    private let imageView = UIImageView()
    private let progressView = UIProgressView()
    private let loadButton = UIButton()
    
    private let placeholderImage = UIImage(systemName: "photo.fill")
    private var urlString = ""
    private var loadComplete = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        loadComplete = true
        urlString = ""
    }
    
    func configureCell(urlString: String, loadNow: Bool = false) {
        self.urlString = urlString
        if loadNow {
            downloadImage(urlString: urlString)
        }
    }
    
    private func downloadImage(urlString: String) {
        imageView.image = placeholderImage
        ImageDownLoad()
            .downloadImage(urlString: urlString) { [weak self] result in
                switch result {
                case .success(let imageData):
                    self?.setImage(imageData: imageData)
                case .failure:
                    break
                }
            }
    }
    
    private func setImage(imageData: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let image = UIImage(data: imageData)
            self.imageView.image = image
            self.loadComplete = true
        }
    }
}

private extension ImageDownLoadCollectionCell {
    @objc func loadButtonTapped(_ sender: UIButton) {
        guard loadComplete == true else { return }
        loadComplete = false
        downloadImage(urlString: urlString)
    }
    
    func layout() {
        contentView.backgroundColor = .white
        [
            imageView,
            progressView,
            loadButton
        ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview($0)
            }
        
        imageView.image = placeholderImage
        
        progressView.progress = 0.5
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
            .activate([
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 140)
            ])
        
        NSLayoutConstraint
            .activate([
                progressView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: 3),
                progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                progressView.widthAnchor.constraint(equalToConstant: 150)
            ])
        
        NSLayoutConstraint
            .activate([
                loadButton.leadingAnchor.constraint(equalTo: progressView.trailingAnchor),
                loadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                loadButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                loadButton.heightAnchor.constraint(equalToConstant: 40)
            ])
    }
}
