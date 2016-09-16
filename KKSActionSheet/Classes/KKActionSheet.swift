//
//  CustomActionSheet.swift
//  lico
//
//  Created by Krizhanovskii on 6/10/16.
//  Copyright © 2016 k.krizhanovskii. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


public class KKActionSheetData: NSObject {
    fileprivate var _image: UIImage?
    fileprivate var _title: String?

    /* table cell image */
    var image : UIImage? {
        get {
            return self._image
        }
    }
    
    
    /* table cell title */
    var title : String? {
        get {
            return self._title
        }
    }
    
    
    public var titleColor : UIColor?
    
    /* complition handler */
    fileprivate  var _complitionHandler:(()->Void)?

    
    /* init */
    public init(image:UIImage?,title:String, complitionHandler:(() -> Void)?) {
        self._image = image
        self._title = title
        self._complitionHandler = complitionHandler
    }
    
}

/* main class */
public class KKActionSheet: UIView, UITableViewDelegate, UITableViewDataSource {
    /* outlets */
    fileprivate let nibName = "KKActionSheet"
    fileprivate var view: UIView!
    @IBOutlet fileprivate var viewForTap: UIView!
    @IBOutlet fileprivate var constraintHeight: NSLayoutConstraint!
    @IBOutlet fileprivate var tableView: UITableView!
    
    
    
    /* action sheet data */
    public var actionSheetData : Array<KKActionSheetData>? {
        willSet(newData) {
            self.actionSheetData = newData
            self.constraintHeight.constant = CGFloat(newData!.count) * self.actionSheetItemHeight + 5
            self.layoutIfNeeded()
            
            if self.actionSheetData?.count < 10 {
                self.tableView.isScrollEnabled = false
            }
            self.tableView.reloadData()
        }
    }

    /* action sheet height min(50) max(100) */
    public var actionSheetItemHeight : CGFloat = 50 {
        didSet {
            if self.actionSheetItemHeight != 50  {
                self.actionSheetItemHeight = max(CGFloat(50), min(CGFloat(100),self.actionSheetItemHeight))
                if (self.actionSheetData != nil) {
                    self.constraintHeight.constant = CGFloat(self.actionSheetData!.count) * self.actionSheetItemHeight + 5
                }
                self.layoutIfNeeded()
                self.tableView.reloadData()
               
            }
        }
    }
    
    
    /* Colors */
    /* textColor for Normal state */
    public var actionSheetCellTextColorNormal : UIColor? {
        willSet(newValue) {
            self.actionSheetCellTextColorNormal = newValue
        }
    }
    
    /* backgroundColor for Normal state */
    public var actionSheetCellBGColorNormal : UIColor? {
        willSet(newValue) {
            self.actionSheetCellBGColorNormal = newValue
        }
    }
    
    /* textColor for Highlighted state */
    public var actionSheetCellTextColorHighlighted : UIColor? {
        willSet(newValue) {
            self.actionSheetCellTextColorHighlighted = newValue
        }
    }
    
    /* backgroundColor for Highlighted state */
    public var actionSheetCellBGColorHighlighted : UIColor? {
        willSet(newValue) {
            self.actionSheetCellBGColorHighlighted = newValue
        }
    }
    
    
    //MARK: init Methods
    convenience init () {
        self.init(frame:UIScreen.main.bounds)
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
    
        view.frame = bounds
        view.backgroundColor = UIColor(red: 25.0/255.0, green: 31.0/255.0, blue: 40.0/255.0, alpha: 0.85)
        
        self.tableView.backgroundColor = .clear
        self.tableView.register(ActionSheetCell.self, forCellReuseIdentifier: "action_cell")
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
        
        self.registerTapGesture()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    
    /* register tap gesture for closing */
    fileprivate func registerTapGesture() {
        self.viewForTap.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewForTap.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.closeActionSheet()
    }
    
    //MARK: Table View delegate
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.actionSheetItemHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "action_cell") as? ActionSheetCell
        cell?._bgColor = self.actionSheetCellBGColorNormal
        cell?._textColor = self.actionSheetCellTextColorNormal
        
        cell?._bgHGColor = self.actionSheetCellBGColorHighlighted
        cell?._textHGColor = self.actionSheetCellTextColorHighlighted
        
        cell!.cellSetupView()
        
        if self.actionSheetData![indexPath.row].titleColor != nil {
            cell?._textColor = self.actionSheetData![indexPath.row].titleColor!
        }

        cell?.viewContent.lblTitle.text = self.actionSheetData![(indexPath as NSIndexPath).row].title
        cell?.viewContent.imgIcon.image = self.actionSheetData![(indexPath as NSIndexPath).row].image
        
        if self.actionSheetData![(indexPath as NSIndexPath).row].image == nil {
            cell?.viewContent.constraintImg.constant = -16;
        } else {
            cell?.viewContent.constraintImg.constant = 10;
        }

        cell?.layoutIfNeeded()
        return cell!
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if  self.actionSheetData![(indexPath as NSIndexPath).row]._complitionHandler != nil {
            self.actionSheetData![(indexPath as NSIndexPath).row]._complitionHandler!()
        }
        self.closeActionSheet()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionSheetData == nil ? 0 : actionSheetData!.count
    }
    
    //MARK: func for show\dissmis it
    public func showActionSheetWithSender(sender cntr:UIViewController) {
        if cntr.navigationController != nil {
            self.alpha = 0
            cntr.navigationController?.view.addSubview(self)
        } else {
            self.alpha = 0
            cntr.view.addSubview(self)
        }
        self.fadeIn()
    }
    public func closeActionSheet() {
        self.fadeOut()
    }
    
    /* animation show \ close */
    fileprivate func fadeIn() {
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.alpha = 1
        }, completion: { (complection) -> Void in
        }) 
    }
    
    fileprivate func fadeOut() {
        UIView.animate(withDuration: 0.35, animations: { () -> Void in
            self.alpha = 0

        }, completion: { (complection) -> Void in
            self.removeFromSuperview()
        }) 
    }
}
