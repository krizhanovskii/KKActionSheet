//
//  ActionSheetCell.swift
//  lico
//
//  Created by Krizhanovskii on 6/10/16.
//  Copyright © 2016 k.krizhanovskii. All rights reserved.
//

import UIKit

class ActionSheetCell: UITableViewCell {

    var viewContent = KKActionSheetCellView()
    
    var _textColor : UIColor?
    var _bgColor : UIColor?
    
    var _textHGColor : UIColor?
    var _bgHGColor : UIColor?



    
    
    
    func cellSetupView() {
        viewContent.frame = self.bounds
        self.contentView.addSubview(viewContent)
    }
    

    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        if(highlighted){
            self.viewContent.view.backgroundColor = _bgHGColor != nil ? _bgHGColor : .whiteColor()
            self.viewContent.lblTitle.textColor = _textHGColor != nil ? _textHGColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        } else{
            self.viewContent.view.backgroundColor = _bgColor != nil ? _bgColor : .whiteColor()
            self.viewContent.lblTitle.textColor = _textColor != nil ? _textColor : .lightGrayColor()
        }
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        if(selected){
            self.viewContent.view.backgroundColor = _bgHGColor != nil ? _bgHGColor : .whiteColor()
            self.viewContent.lblTitle.textColor = _textHGColor != nil ? _textHGColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)

        } else{
            self.viewContent.view.backgroundColor = _bgColor != nil ? _bgColor : .whiteColor()
            self.viewContent.lblTitle.textColor = _textColor != nil ? _textColor : .lightGrayColor()
            
        }
    }
}
