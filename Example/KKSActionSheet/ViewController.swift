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
        
        
        let button = UIButton(frame: CGRectMake(10, 10, 50, 50));
        button.addTarget(self, action: #selector(self.press), forControlEvents: .TouchUpInside);
        button.backgroundColor = .yellowColor();
        self.view.addSubview(button)
        
        
        
        
        
        actionSheet.actionSheetData = [KKActionSheetData(image: UIImage(),title: "1",complitionHandler:nil),
                                             KKActionSheetData(image: UIImage(named:"picker_camera"),title:"2",complitionHandler:nil),
                                             KKActionSheetData(image: UIImage(named:"picker_close"),title: "3",complitionHandler: { Void in
                                                print("HAndler used")
                                                button.backgroundColor = .orangeColor();
                                             })]


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func press() {
        print("press")
        
        actionSheet.showActionSheetWithSender(sender:self)
    }
}

