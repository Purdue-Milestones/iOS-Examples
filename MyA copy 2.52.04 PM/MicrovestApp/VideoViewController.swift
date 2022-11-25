//
//  VideoViewController.swift
//  MicrovestApp
//
//  Created by Carolina Solís on 2/13/22.
//

import UIKit
import AVKit
import MobileCoreServices

class VideoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //side menu button
    @IBOutlet weak var sideMenuBtn: UIBarButtonItem!
    //video switch (on or off)
    @IBOutlet weak var videoButton: UISwitch!
    @IBAction func videoSwitch(_ sender: UISwitch) {
        if sender.isOn{
            viewDidLoad()
            print("Video Switch On")
        }
        else{
            //VoltageAudioBox.clear()
            print("Video Switch Off")
        }
    }
    
    //Record and play videos
    var videoAndImageReview = UIImagePickerController()
    var videoURL : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //show side menu
        sideMenuBtn.image = UIImage(systemName: "text.justify")
        sideMenuBtn.target = revealViewController()
        sideMenuBtn.action = #selector(revealViewController()?.revealSideMenu)
    }
    
    // recording Video
    @IBAction func recordAct(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("Camera Available")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera Unavailable")
        }
    }
    
       
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? String,
                    mediaType == (UTType.movie.identifier),
              let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL,
                    UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
                    else {
                        return
                }
                // Handle a movie capture
                UISaveVideoAtPathToSavedPhotosAlbum(
                    url.path,
                    self,
                    #selector(video(_:didFinishSavingWithError:contextInfo:)),
                    nil)
       }
       
       @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
           let title = (error == nil) ? "Success" : "Error"
           let message = (error == nil) ? "Video was saved" : "Video failed to save"
           
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
           present(alert, animated: true, completion: nil)
       }
       
       // playing Video
    
       
    @IBAction func playAct(_ sender: UIButton) {
        videoAndImageReview.sourceType = .savedPhotosAlbum
        videoAndImageReview.delegate = self
        videoAndImageReview.mediaTypes = ["public.movie"]
        present(videoAndImageReview, animated: true, completion: nil)
    }
       
       func videoAndImageReview(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
           videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL
           print("\(String(describing: videoURL))")
           self.dismiss(animated: true, completion: nil)
       }
    
}
