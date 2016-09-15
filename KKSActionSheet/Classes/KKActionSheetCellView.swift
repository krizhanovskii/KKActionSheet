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
    

    @IBOutlet var constraintImgWidth: NSLayoutConstraint!
    
    
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
        
        self.lblTitle.textColor = .lightGray
        self.imgIcon.backgroundColor = .clear
        
        self.imgIcon.layer.masksToBounds = true
        
        view.frame = bounds
        view.backgroundColor = .white
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
    }
    
    
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

  
}
