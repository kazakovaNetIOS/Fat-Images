//
//  ViewController.swift
//  Fat Images
//
//  Created by Natalia Kazakova on 05/07/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var photoView: UIImageView!
    
    // MARK: Actions
    
    // This method downloads a huge image, blocking the main queue and
    // the UI.
    // This si for instructional purposes only, never do this.
    @IBAction func synchronousDownload(_ sender: UIBarButtonItem) {
        guard let url = URL(string: BigImages.seaLion.rawValue) else { return }
        
        guard let imgData = try? Data(contentsOf: url) else { return }
        
        let image = UIImage(data: imgData)
        
        photoView.image = image
    }
    
    // This method avoids blocking by creating a new queue that runs
    // in the background, without blocking the UI.
    @IBAction func simpleAsynchronousDownload(_ sender: UIBarButtonItem) {
        guard let url = URL(string: BigImages.shark.rawValue) else { return }
        
        let downloadQueue = DispatchQueue(label: "download", attributes: [])
        
        downloadQueue.async {
            if let imgDate = try? Data(contentsOf: url) {
                let image = UIImage(data: imgDate)
                
                DispatchQueue.main.async(execute: {
                    self.photoView.image = image
                })
            }
        }
    }
    
    // This code downloads the huge image in a global queue and uses a completion
    // closure.
    @IBAction func asynchronousDownload(_ sender: UIBarButtonItem) {
        withBigImage { (image) in
            self.photoView.image = image
        }
    }
    
    func withBigImage(completionHandler handler: @escaping (_ image: UIImage) -> Void) {
        guard let url = URL(string: BigImages.whale.rawValue) else { return }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            if let imgDate = try? Data(contentsOf: url),
                let image = UIImage(data: imgDate) {
                
                DispatchQueue.main.async(execute: {
                    handler(image)
                })
            }
        }
    }
    
    // Changes the alpha value (transparency of the image). It's only purpose is to show if the
    // UI is blocked or not.
    @IBAction func setTransparencyOfImage(_ sender: UISlider) {
        photoView.alpha = CGFloat(sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}

// MARK: - BigImages: String

enum BigImages: String {
    case whale = "https://lh3.googleusercontent.com/16zRJrj3ae3G4kCDO9CeTHj_dyhCvQsUDU0VF0nZqHPGueg9A9ykdXTc6ds0TkgoE1eaNW-SLKlVrwDDZPE=s0#w=4800&h=3567"
    case shark = "https://lh3.googleusercontent.com/BCoVLCGTcWErtKbD9Nx7vNKlQ0R3RDsBpOa8iA70mGW2XcC76jKS09pDX_Rad6rjyXQCxngEYi3Sy3uJgd99=s0#w=4713&h=3846"
    case seaLion = "https://lh3.googleusercontent.com/ibcT9pm_NEdh9jDiKnq0NGuV2yrl5UkVxu-7LbhMjnzhD84mC6hfaNlb-Ht0phXKH4TtLxi12zheyNEezA=s0#w=4626&h=3701"
}
