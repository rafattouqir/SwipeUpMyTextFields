//
//  TextfieldSwipeUpViewController.swift
//  KeyboardSwipeMyWay
//
//  Created by Rafsun@BScheme on 6/29/16.
//  Copyright © 2016 Rafsun@Github. All rights reserved.
//

import UIKit

class TextfieldSwipeUpViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField:UITextField?
    let keyboardExtraPadding:CGFloat = 5
    var GlobalMainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    func dispatchTimeInSecond(delayInSeconds seconds:Double = 0.0) -> dispatch_time_t{
            return dispatch_time(DISPATCH_TIME_NOW,
                                 Int64(seconds * Double(NSEC_PER_SEC)))
    }
    
    @IBOutlet weak var textfield_1: UITextField!
    
    @IBOutlet weak var textfield_2: UITextField!
    
    @IBOutlet weak var textfield_3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textfield_1.delegate = self
        textfield_2.delegate = self
        textfield_3.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tap Gesture selector/action
    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
}


extension TextfieldSwipeUpViewController:UITextFieldDelegate{
    
    //App related delegate implementation here
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch textField {
        case textfield_1:
            textfield_2.becomeFirstResponder()
        case textfield_2:
            textfield_3.becomeFirstResponder()
        case textfield_3:
            textfield_3.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    
    
    //keyboard slide up implementation start here
    func textFieldDidBeginEditing(textField: UITextField){
        activeTextField = textField
        
        if let activeTextField = activeTextField{
            let rectToScroll = CGRect(x: activeTextField.frame.origin.x, y: activeTextField.frame.origin.y , width: activeTextField.frame.size.width, height: activeTextField.frame.size.height + keyboardExtraPadding)
            
            //Patch to work the scroll with padding
            let popUpTime = dispatchTimeInSecond(delayInSeconds: 0.1)
            dispatch_after(popUpTime, GlobalMainQueue) {
                self.scrollView.scrollRectToVisible(rectToScroll, animated: true)
            }
            
        }
        
    }
    
    
    
    func textFieldDidEndEditing(textField: UITextField){
        activeTextField = nil
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unRegisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unRegisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size{
            
            
            let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            
            if let activeTextField = activeTextField{
                let rectToScroll = CGRect(x: activeTextField.frame.origin.x, y: activeTextField.frame.origin.y , width: activeTextField.frame.size.width, height: activeTextField.frame.size.height + keyboardExtraPadding)
                dispatch_async(dispatch_get_main_queue(), {
                    self.scrollView.scrollRectToVisible(rectToScroll, animated: true)
                    
                })
                
            }
        }
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
}

