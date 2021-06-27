//
//  ViewController.swift
//  testing-email
//
//  Created by Orlando Hoilett on 6/20/21.
//

import UIKit
import MessageUI


class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sendEmailButton(_ sender: Any) {
        sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["ohoilett@purdue.edu"])
            mail.setMessageBody("<p>Hi Dr. Hoilett,<br></br>I can send emails from my app!</p>", isHTML: true)
            mail.setSubject("iOS Milestone")

            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }


}

