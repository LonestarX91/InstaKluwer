//
//  AlbumCell.swift
//  InstaKluwer
//
//  Created by Daniel on 08.11.2022.
//

import UIKit
import SDWebImage

class AlbumCell: UITableViewCell {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var albumDescription: UILabel!
    @IBOutlet weak var albumDate: UILabel!
    @IBOutlet weak var albumIndicator: UIImageView!
    
    var photosArray = Array<Photo>() {
        didSet {
            albumIndicator.alpha = photosArray.count > 1 ? 1 : 0
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension AlbumCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.imageView.sd_setImage(with: URL(string: photosArray[indexPath.item].media_url), placeholderImage: UIImage())
        return cell
    }
}

