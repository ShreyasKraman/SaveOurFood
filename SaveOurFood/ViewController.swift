//
//  ViewController.swift
//  SaveOurFood
//
//  Created by Aniket Kalkar on 11/12/18.
//  Copyright © 2018 Shreyas Kalyanaraman. All rights reserved.
//

import UIKit

import MaterialComponents

class ViewController: UIViewController {

//    let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false;
//        scrollView.backgroundColor = .white
//        scrollView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
//        return scrollView
//    }()
//
//    let titleLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.text = "Save Our Food"
//        titleLabel.sizeToFit()
//        return titleLabel
//    }()
//
//    let ClientButton: MDCRaisedButton = {
//        let clientButton = MDCRaisedButton()
//        clientButton.translatesAutoresizingMaskIntoConstraints = false
//        clientButton.setTitle("Client", for: .normal)
//        clientButton.addTarget(self, action: #selector(didTapClient(sender:)), for: .touchUpInside)
//        return clientButton
//    }()
//
//    let MemberButton: MDCRaisedButton = {
//        let memberButton = MDCRaisedButton()
//        memberButton.translatesAutoresizingMaskIntoConstraints = false
//        memberButton.setTitle("Member", for: .normal)
//        memberButton.addTarget(self, action: #selector(didTapMember(sender:)), for: .touchUpInside)
//        return memberButton
//    }()
//

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.tintColor = .black
//        scrollView.backgroundColor = .white
//
//        view.addSubview(scrollView)
//
//        NSLayoutConstraint.activate(
//            NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollView]|",
//                                           options: [],
//                                           metrics: nil,
//                                           views: ["scrollView" : scrollView])
//        )
//        NSLayoutConstraint.activate(
//            NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|",
//                                           options: [],
//                                           metrics: nil,
//                                           views: ["scrollView" : scrollView])
//        )
//
//
//        scrollView.addSubview(titleLabel)
//
//        scrollView.addSubview(ClientButton)
//        scrollView.addSubview(MemberButton)
//
//        // Constraints
//        var constraints = [NSLayoutConstraint]()
//
//        constraints.append(NSLayoutConstraint(item: titleLabel,
//                                              attribute: .top,
//                                              relatedBy: .equal,
//                                              toItem: scrollView,
//                                              attribute: .bottom,
//                                              multiplier: 1,
//                                              constant: 8))
//
//        // Buttons
//        constraints.append(NSLayoutConstraint(item: ClientButton,
//                                              attribute: .top,
//                                              relatedBy: .equal,
//                                              toItem: titleLabel,
//                                              attribute: .bottom,
//                                              multiplier: 1,
//                                              constant: 8))
//        constraints.append(NSLayoutConstraint(item: ClientButton,
//                                              attribute: .centerY,
//                                              relatedBy: .equal,
//                                              toItem: scrollView,
//                                              attribute: .centerY,
//                                              multiplier: 1,
//                                              constant: 0))
//        constraints.append(NSLayoutConstraint(item:ClientButton,
//                                              attribute: .centerX,
//                                              relatedBy: .equal,
//                                              toItem: titleLabel,
//                                              attribute: .centerX,
//                                              multiplier:1,
//                                              constant:0))
//
//        constraints.append(NSLayoutConstraint(item: MemberButton,
//                                              attribute: .bottom,
//                                              relatedBy: .equal,
//                                              toItem: scrollView.contentLayoutGuide,
//                                              attribute: .bottomMargin,
//                                              multiplier: 1,
//                                              constant: -20))
//
//        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc func didTapClient(sender:UIButton){
        
        let clientLogin = storyboard?.instantiateViewController(withIdentifier: "ClientLogin") as! UserLoginViewController
        
        self.present(clientLogin,animated: true)
    }
    
    @objc func didTapMember(sender:UIButton){
        let memberLogin = storyboard?.instantiateViewController(withIdentifier: "MemberLogin") as! MemberLoginViewController
        
        self.present(memberLogin,animated: true)
    }


}

