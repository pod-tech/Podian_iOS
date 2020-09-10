//
//  BaseViewController.swift
//  POD
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit



class BaseViewController: UIViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
        func showSpinner() {
            startAnimating()
    //              let spinnerView = UIView.init(frame: onView.bounds)
    //               spinnerView.tag = -100
    //              spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    //              let ai = UIActivityIndicatorView.init(style: .whiteLarge)
    //              ai.startAnimating()
    //              ai.center = spinnerView.center
    //
    //              DispatchQueue.main.async {
    //                  spinnerView.addSubview(ai)
    //                  onView.addSubview(spinnerView)
    //              }
                  
              }
              
              func removeSpinner() {
                stopAnimating()
    //              DispatchQueue.main.async {
    //               let v = onView.viewWithTag(-100)
    //               if(v != nil){
    //                   v?.removeFromSuperview()
    //               }
    //              }
              }
}

extension Dictionary {

    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }

    func printJson() {
        print(json)
    }

}

//MARK:- UIViewcontroller Extention
extension UIViewController : UITextFieldDelegate,UITextViewDelegate{
    
    @IBAction func btnBack_Click(){
        self.navigationController?.popViewController(animated: true);
    }
    
    @IBAction func btnLogout_Click(){
        self.navigationController?.popToRootViewController(animated: true);
    }
    
    public func SetStatusBarColor(color:UIColor=UIColor.init(red: 249/255, green: 178/255, blue: 18/255, alpha: 1)){
        UIApplication.shared.statusBarUIView?.backgroundColor = color
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        Constant.txtglobal = textField;
        return true;
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true;
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false;
        }
        else{
            return true;
        }
    }
    
    
    
    func InitializeKeyBoardNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil); NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        let endFrameY = keyboardFrame.origin.y
        if(Constant.txtglobal?.tag != 0 && Constant.txtglobal?.tag != 1){
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= (keyboardFrame.height/1.5)-35
        }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
         guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        _ = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0 && self.view.frame.origin.y < 0{
            self.view.frame.origin.y = 0
        }
    }
    
    public func ShowAlertMessage(message:String,buttonTitle:String = "OK"){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        if #available(iOS 13.0, *) {
                   alert.overrideUserInterfaceStyle = .light
               } else {
                   // Fallback on earlier versions
               }
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
//    func showSpinner(onView : UIView) {
//           let spinnerView = UIView.init(frame: onView.bounds)
//            spinnerView.tag = -100
//           spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
//           let ai = UIActivityIndicatorView.init(style: .whiteLarge)
//           ai.startAnimating()
//           ai.center = spinnerView.center
//
//           DispatchQueue.main.async {
//               spinnerView.addSubview(ai)
//               onView.addSubview(spinnerView)
//           }
//
//       }
       
//       func removeSpinner(onView : UIView) {
//           DispatchQueue.main.async {
//            let v = onView.viewWithTag(-100)
//            if(v != nil){
//                v?.removeFromSuperview()
//            }
//           }
//       }
    
}

protocol JSONAble {}

extension JSONAble {
    func toDict() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
}

//MARK:- TextField Extention
extension UITextField{
    open override func awakeFromNib() {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder ?? "",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])


    }
    //MARK:- To add toobar done button do dismiss keyboard
    func addDoneButtonOnKeyboard(view:UIView)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = UIColor.init(hexString:"#F9B212")
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    //MARK:- To add date picker in input field
    func setInputViewDatePicker(target: Any, selector: Selector) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        self.inputView = datePicker //3
        
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
         cancel.tintColor = UIColor.init(hexString:"#F9B212")
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
         barButton.tintColor = UIColor.init(hexString:"#F9B212")
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func setInputViewDatePicker(target: Any, selector: Selector,IsPreviousDisable:Bool) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        self.inputView = datePicker //3
        if(IsPreviousDisable == true){
            datePicker.minimumDate = Date.init()
        }
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
         cancel.tintColor = UIColor.init(hexString:"#F9B212")
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
         barButton.tintColor = UIColor.init(hexString:"#F9B212")
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func setInputViewDatePicker(target: Any, selector: Selector,IsFutureDisable:Bool) {
        // Create a UIDatePicker object and assign to inputView
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
        datePicker.datePickerMode = .date //2
        self.inputView = datePicker //3
        if(IsFutureDisable == true){
            datePicker.maximumDate = Date.init()
        }
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
        cancel.tintColor = UIColor.init(hexString:"#F9B212")
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
        barButton.tintColor = UIColor.init(hexString:"#F9B212")
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func setInputViewTimePicker(target: Any, selector: Selector) {
           // Create a UIDatePicker object and assign to inputView
           let screenWidth = UIScreen.main.bounds.width
           let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))//1
           datePicker.datePickerMode = .time //2
           self.inputView = datePicker //3
           
           // Create a toolbar and assign it to inputAccessoryView
           let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
           let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
         cancel.tintColor = UIColor.init(hexString:"#F9B212")
           let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector) //7
         barButton.tintColor = UIColor.init(hexString:"#F9B212")
           toolBar.setItems([cancel, flexible, barButton], animated: false) //8
           self.inputAccessoryView = toolBar //9
       }
    
    func setDismissToolBar(target: Any) {
        let screenWidth = UIScreen.main.bounds.width
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
         cancel.tintColor = UIColor.init(hexString:"#F9B212")
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: #selector(self.tapCancel)) //7
         barButton.tintColor = UIColor.init(hexString:"#F9B212")
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    func setDismissToolBar(target: Any,selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        // Create a toolbar and assign it to inputAccessoryView
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0)) //4
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) //5
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(self.tapCancel)) // 6
         cancel.tintColor = UIColor.init(hexString:"#F9B212")
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: nil, action: selector) //7
         barButton.tintColor = UIColor.init(hexString:"#F9B212")
        toolBar.setItems([cancel, flexible, barButton], animated: false) //8
        self.inputAccessoryView = toolBar //9
    }
    
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}

//MARK:- TextView Extention
extension UITextView{
    
    open override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func leftSpace() {
        self.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 4, right: 10)
    }
    
    func addDoneButtonOnKeyboard(view:UIView)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = UIColor.init(hexString:"#F9B212")
       
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
    
    @IBInspectable var placeholder:String {
           set {
               
                self.text = newValue
           }
           get{
                return "";
           }
       }
}

//MARK:- UIApplication Extention
extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}
extension UILabel {
    func halfTextColorChange (fullText : String? , changeText : String,color:UIColor ) {
        let strNumber: NSString = fullText as! NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText!)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
        self.attributedText = attribute
    }
    
    func halfTextColorChange (fullText : String , changeText : [String],color:UIColor ) {
           let strNumber: NSString = fullText as NSString
         let attribute = NSMutableAttributedString.init(string: fullText)
        for tx in changeText {
           
           let range = (strNumber).range(of: tx)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
           
        }
        self.attributedText = attribute
    }
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir Next Medium", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Avenir Next Medium", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

