//
//  CustomActionSheet.swift
//  lico
//
//  Created by Krizhanovskii on 6/10/16.
//  Copyright © 2016 k.krizhanovskii. All rights reserved.
//

import UIKit

class KKActionSheetData: NSObject {
    private var _image: UIImage?
    private var _title: String?

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
    
    /* complition handler */
    private  var _complitionHandler:(()->Void)?

    
    /* init */
    init(image:UIImage?,title:String, complitionHandler:(() -> Void)?) {
        self._image = image
        self._title = title
        self._complitionHandler = complitionHandler
    }
    
}

/* main class */
class KKActionSheet: UIView, UITableViewDelegate, UITableViewDataSource {
    /* outlets */
    private let nibName = "KKActionSheet"
    private var view: UIView!
    @IBOutlet private var viewForTap: UIView!
    @IBOutlet private var constraintHeight: NSLayoutConstraint!
    @IBOutlet private var tableView: UITableView!
    
    
    
    /* action sheet data */
    var actionSheetData : Array<KKActionSheetData>? {
        willSet(newData) {
            self.actionSheetData = newData
            self.constraintHeight.constant = CGFloat(newData!.count) * self.actionSheetItemHeight + 5
            self.layoutIfNeeded()
            
            if self.actionSheetData?.count < 10 {
                self.tableView.scrollEnabled = false
            }
            self.tableView.reloadData()
        }
    }

    /* action sheet height min(50) max(100) */
    var actionSheetItemHeight : CGFloat = 50 {
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
    var actionSheetCellTextColorNormal : UIColor? {
        willSet(newValue) {
            self.actionSheetCellTextColorNormal = newValue
        }
    }
    
    /* backgroundColor for Normal state */
    var actionSheetCellBGColorNormal : UIColor? {
        willSet(newValue) {
            self.actionSheetCellBGColorNormal = newValue
        }
    }
    
    /* textColor for Highlighted state */
    var actionSheetCellTextColorHighlighted : UIColor? {
        willSet(newValue) {
            self.actionSheetCellTextColorHighlighted = newValue
        }
    }
    
    /* backgroundColor for Highlighted state */
    var actionSheetCellBGColorHighlighted : UIColor? {
        willSet(newValue) {
            self.actionSheetCellBGColorHighlighted = newValue
        }
    }
    
    
    //MARK: init Methods
    convenience init () {
        self.init(frame:UIScreen.mainScreen().bounds)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
    
        view.frame = bounds
        view.backgroundColor = UIColor(red: 25.0/255.0, green: 31.0/255.0, blue: 40.0/255.0, alpha: 0.85)
        
        self.tableView.backgroundColor = .clearColor()
        self.tableView.registerClass(ActionSheetCell.self, forCellReuseIdentifier: "action_cell")
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
        
        self.registerTapGesture()
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    
    /* register tap gesture for closing */
    private func registerTapGesture() {
        self.viewForTap.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.viewForTap.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.closeActionSheet()
    }
    
    //MARK: Table View delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.actionSheetItemHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("action_cell") as? ActionSheetCell
        cell?._bgColor = self.actionSheetCellBGColorNormal
        cell?._textColor = self.actionSheetCellTextColorNormal
        
        cell?._bgHGColor = self.actionSheetCellBGColorHighlighted
        cell?._textHGColor = self.actionSheetCellTextColorHighlighted
        
        cell!.cellSetupView()

        cell?.viewContent.lblTitle.text = self.actionSheetData![indexPath.row].title
        cell?.viewContent.imgIcon.image = self.actionSheetData![indexPath.row].image
        
        if self.actionSheetData![indexPath.row].image == nil {
            cell?.viewContent.constraintImg.constant = -16;
        } else {
            cell?.viewContent.constraintImg.constant = 10;
        }

        cell?.layoutIfNeeded()
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if  self.actionSheetData![indexPath.row]._complitionHandler != nil {
            self.actionSheetData![indexPath.row]._complitionHandler!()
        }
        self.closeActionSheet()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionSheetData == nil ? 0 : actionSheetData!.count
    }
    
    //MARK: func for show\dissmis it
    func showActionSheetWithSender(sender cntr:UIViewController) {
        if cntr.navigationController != nil {
            self.alpha = 0
            cntr.navigationController?.view.addSubview(self)
        } else {
            self.alpha = 0
            cntr.view.addSubview(self)
        }
        self.fadeIn()
    }
    func closeActionSheet() {
        self.fadeOut()
    }
    
    /* animation show \ close */
    private func fadeIn() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.alpha = 1
        }) { (complection) -> Void in
        }
    }
    
    private func fadeOut() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.alpha = 0

        }) { (complection) -> Void in
            self.removeFromSuperview()
        }
    }
}
