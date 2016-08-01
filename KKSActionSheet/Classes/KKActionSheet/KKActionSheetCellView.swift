//
//  ActionSheetCellView.swift
//  lico
//
//  Created by Krizhanovskii on 6/10/16.
//  Copyright © 2016 k.krizhanovskii. All rights reserved.
//

import UIKit

class KKActionSheetCellView: UIView {
    let nibName = "KKActionSheetCellView"
    var view: UIView!
    
    @IBOutlet var constraintImg: NSLayoutConstraint!
    
    //MARK: outlets
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgIcon: UIImageView!
    

    
    
    //MARK: METHODS for init view
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        self.lblTitle.textColor = .lightGrayColor()
        self.imgIcon.backgroundColor = .clearColor()
        
        self.imgIcon.layer.masksToBounds = true
        
        view.frame = bounds
        view.backgroundColor = .whiteColor()
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
    }
    
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

  
}
