//
//  ImageDownloadViewController.swift
//  WebImagesDownloader
//
//  Created by ByungHoon Ann on 2023/02/17.
//

import UIKit

final class ImageDownloadViewController: UIViewController {
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        let cView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cView
    }()
    
    private let loadAllImageButton = UIButton()
    private var loadNow = false
    
    private let imageURLStringList = [
        "https://images.unsplash.com/photo-1563713665854-e72327bf780e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
        "https://i2.wp.com/beebom.com/wp-content/uploads/2016/01/Reverse-Image-Search-Engines-Apps-And-Its-Uses-2016.jpg",
        "https://images.pexels.com/photos/2825578/pexels-photo-2825578.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "https://picsum.photos/id/237/200/300",
        "https://picsum.photos/1200/600"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    @objc func loadAllButtonTapped(_ sender: UIButton) {
       loadNow = true
        collectionView.reloadData()
    }
}

extension ImageDownloadViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLStringList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageDownLoadCollectionCell.cellID,
            for: indexPath) as? ImageDownLoadCollectionCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(urlString: imageURLStringList[indexPath.item], loadNow: loadNow)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

extension ImageDownloadViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width
        let height = 100.0
        return CGSize(width: width, height: height)
    }
}

private extension ImageDownloadViewController {
    func layout() {
        view.backgroundColor = .white

        [
            collectionView,
            loadAllImageButton
        ]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        
        
        collectionView.register(
            ImageDownLoadCollectionCell.self,
            forCellWithReuseIdentifier: ImageDownLoadCollectionCell.cellID
        )

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadAllImageButton.setTitle("Load All Images", for: .normal)
        loadAllImageButton.backgroundColor = .blue
        loadAllImageButton.setTitleColor(.white, for: .normal)
        loadAllImageButton.layer.cornerRadius = 3
        loadAllImageButton.clipsToBounds = true
        loadAllImageButton.addTarget(self, action: #selector(loadAllButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint
            .activate([
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        NSLayoutConstraint
            .activate([
                loadAllImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                loadAllImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                loadAllImageButton.heightAnchor.constraint(equalToConstant: 40),
                loadAllImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -150)
            ])
    }
}
