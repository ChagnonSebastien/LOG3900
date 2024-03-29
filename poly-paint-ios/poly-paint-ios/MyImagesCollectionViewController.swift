import UIKit

final class MyImagesCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "MyImageCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0);
    fileprivate var searches = [Image]();
    fileprivate let itemsPerRow: CGFloat = 3 ;
    var images:[Image]?
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    func getPrivateImageUrl() -> String{
        
        return SERVER.URL.rawValue + "v2/imagesByOwnerId/" + UserDefaults.standard.string(forKey: "id")!
        //return SERVER.URL.rawValue + "v2/imagesByOwnerId/" + "694caab3-c611-4331-9e8a-7d0737d578a9" //Can be used for testing purposes while if no images are created for current logged in user
    }
    func fetchPrivateImages() {
        guard let url = URL(string: getPrivateImageUrl()) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                
                self.images = [Image]()
                
                for dictionary in json as! [[String: AnyObject]] {
                    
                    let image = Image()
                    image.id = dictionary["id"] as? String
                    image.ownerId = dictionary["ownerId"] as? String
                    image.title = dictionary["title"] as? String
                    image.protectionLevel = dictionary["protectionLevel"] as? String
                    image.password = dictionary["password"] as? String
                    image.thumbnailUrl = dictionary["thumbnailUrl"] as? String
                    image.fullImageUrl = dictionary["fullImageUrl"] as? String
                    guard let url = image.getFullImageUrl(),
                        let imageData = try? Data(contentsOf: url as URL) else {
                            break
                    }
                    if let downloadedImage = UIImage(data: imageData){
                        image.fullImage = downloadedImage
                        self.images?.append(image)
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    override func viewDidLoad(){
        if UserDefaults.standard.string(forKey: "id") != nil {
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.center = self.collectionView!.center
            self.activityIndicator.startAnimating() //For Start Activity Indicator
            self.view.addSubview(activityIndicator)
            fetchPrivateImages()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! PrivateImageCell
        cell.imageView.image = images?[indexPath.item].fullImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPrivateImage" {
            let PrivateImageVC = segue.destination as! PrivateImageViewController
            if let cell = sender as? PrivateImageCell,
                let indexPath = self.collectionView?.indexPath(for: cell) {
                PrivateImageVC.image = images?[indexPath.item]
            }
        }
    }
}

