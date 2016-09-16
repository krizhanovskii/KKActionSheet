//
//  ViewController.swift
//  KKSActionSheet
//
//  Created by k_krizhanovskii on 08/01/2016.
//  Copyright (c) 2016 k_krizhanovskii. All rights reserved.
//

import UIKit
import KKSActionSheet

class ViewController: UIViewController {

    let actionSheet = KKActionSheet()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let button = UIButton(frame: CGRect(x:10, y:10,width: 50, height:50));
        button.target(forAction: #selector(self.press), withSender: self)
        button.backgroundColor = .yellow;
        self.view.addSubview(button)
        
        
        let data = KKActionSheetData(image: UIImage(),title: "1",complitionHandler:nil)
        data.titleColor = .green
        
        actionSheet.actionSheetData = [data,
                                             KKActionSheetData(image: UIImage(named:"picker_close"),title: "3",complitionHandler: { Void in
                                                print("Handler used")
                                             })]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func press() {
        print("press", terminator: "")
        
        actionSheet.showActionSheetWithSender(sender:self)
    }
}

