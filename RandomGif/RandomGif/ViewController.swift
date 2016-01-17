import UIKit
import FLAnimatedImage

class ViewController: UIViewController {

    @IBOutlet weak var imageView: FLAnimatedImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    
    var state: RandomGif.State? {
        didSet {
            guard let state = state else { return }
            // apply changes
        }
    }
    
    var dispatch: (RandomGif.Action -> ())?
    
    // MARK: - Actions
    
    @IBAction func didClickNext() {
    
    }
}

