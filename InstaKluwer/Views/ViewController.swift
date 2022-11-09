//
//  ViewController.swift
//  InstaKluwer
//
//  Created by Daniel on 03.11.2022.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var photoDetailView: UIVisualEffectView!
    @IBOutlet weak var photoDetailImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    private var albumsArray = Array<Photo>()
    @IBOutlet weak var photoDetailScrollViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var photoDetailScrollView: UIScrollView!
    var lastTappedCellHeight: Double = 0
    
    func getStoredItemsDEBUG() {
        do {
            let storedObjAlbums = UserDefaults.standard.object(forKey: "albums")
            let storedAlbums = try JSONDecoder().decode([Photo].self, from: storedObjAlbums as! Data)
            self.albumsArray = storedAlbums

        } catch let err {
            print(err)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RESTManager().getAlbumsData { albums, error in
            if let albums = albums {
                //TO BE USED ONLY AS DEBUG WHEN INSTAGRAM API LIMIT IS REACHED
                if let encoded = try? JSONEncoder().encode(albums) {
                    UserDefaults.standard.set(encoded, forKey: "albums")
                    self.albumsArray = albums
                    DispatchQueue.main.async { [unowned self] in
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.getStoredItemsDEBUG()
                DispatchQueue.main.async { [unowned self] in
                    self.tableView.reloadData()
                }
            }
        }
        let dismissZoomView = UITapGestureRecognizer(target: self, action: #selector(dismissZoom))
        dismissZoomView.delegate = self
        photoDetailView.addGestureRecognizer(dismissZoomView)
    }
    
   @objc func dismissZoom() {
       self.photoDetailScrollViewTopConstraint.constant = lastTappedCellHeight
       UIView.animate(withDuration: 0.5) {
           self.photoDetailView.effect = nil
           self.photoDetailScrollView.zoomScale = 1
           self.view.layoutIfNeeded()
       } completion: { done in
           self.photoDetailView.alpha = 0
       }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.photosCollectionView.delegate = self
        cell.photosCollectionView.dataSource = cell
        cell.photosCollectionView.decelerationRate = .fast
        cell.photosArray = albumsArray[indexPath.row].children!.count > 0 ? albumsArray[indexPath.row].children! : [albumsArray[indexPath.row]]
        cell.photosCollectionView.reloadData()
        cell.albumDescription.text = albumsArray[indexPath.row].caption
        cell.albumDate.text = Utils().formattedDate(from: albumsArray[indexPath.row].timestamp) 
        return cell
    }
}

extension ViewController:  UICollectionViewDelegate, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        let realCenter = collectionView.convert(cell.imageView!.frame, to: collectionView.superview?.superview?.superview?.superview)
        photoDetailScrollViewTopConstraint.constant = realCenter.minY - view.safeAreaInsets.top + cell.frame.origin.y
        if let snap = cell.snapshot() {
            photoDetailView.alpha = 1
            photoDetailView.effect = nil
            photoDetailImageView.image = snap
            lastTappedCellHeight = self.photoDetailScrollViewTopConstraint.constant
            self.photoDetailScrollViewTopConstraint.constant = self.view.bounds.size.height/2 - cell.bounds.size.height/2
            UIView.animate(withDuration: 0.5) {
                self.photoDetailView.effect = UIBlurEffect(style: .regular)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return self.photoDetailImageView.frame.contains(touch.location(in: photoDetailView))
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoDetailImageView
    }
}

