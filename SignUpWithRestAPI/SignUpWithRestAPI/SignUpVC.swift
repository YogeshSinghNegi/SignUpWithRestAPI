//
//  SignUpVC.swift
//  SignUpWithRestAPI
//
//  Created by appinventiv on 13/09/17.
//  Copyright © 2017 yogesh singh negi. All rights reserved.
//

import UIKit
import Foundation

//=============================================================//
//MARK: SignUpVC Class
//=============================================================//

class SignUpVC: UIViewController {
    
//=============================================================//
//MARK: Defining Properties
//=============================================================//
    
    let userDetailsPlaceHolder = ["First Name","Middle Name","Last Name","UserName","email address","DOB","Phone","Department","Gender","City","State","Pin Code","Org ID","Height","Weight","10th Percentage","12th Percentage"]
    
    // To store the data coming from the URL
    var formData = [String:Any]()
    
    // To store the data provided by the user
    var storeDetails = [String]()
    
//=============================================================//
//MARK: Defining IBOutlets
//=============================================================//

    @IBOutlet weak var myLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var signUpDetails: UITableView!
    
//=============================================================//
//MARK: viewDidLoad() method
//=============================================================//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpDetails.delegate = self
        self.signUpDetails.dataSource = self
        
        self.navigationItem.title = "Account Details"
        
        let cell = UINib(nibName: "CustomCell", bundle: nil)
        self.signUpDetails.register(cell, forCellReuseIdentifier: "CustomCell_ID")
        
        // Setting blank initital value in storeDetails Array
        for tempIndex in 0..<self.userDetailsPlaceHolder.count {
            self.storeDetails.insert("", at: tempIndex)
        }
        
        self.stopLoader()
       
    }
    
//=============================================================//
//MARK: Defining IBAction
//=============================================================//
    
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        
        // If Table has some data then proceed else prompt message
        if self.checkForEmptyTable() {
            
            self.startLoader()
            
            self.restAPICall()
            
            // Small Delay while the data arrives
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
                
                // Navigating to the ShowSignUpDataVC View Controller
                guard let objectShowSignUpDataVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowSignUpDataVC_ID") as? ShowSignUpDataVC else { fatalError("ShowSignUpDataVC object failed to load") }
                
                objectShowSignUpDataVC.formData = self.formData
                
                self.navigationController?.pushViewController(objectShowSignUpDataVC, animated: true)
                
                self.stopLoader()
                
            }
            
        }
        
        else {
            
            let alert = UIAlertController(title: "Empty Table", message: "Please enter some data in the table", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
//=============================================================//
//MARK: restAPICall() Method: Hits API and gets data back
//=============================================================//
    
    func restAPICall() {
        
        // Defining Header
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "cache-control": "no-cache",
            "postman-token": "e34a2301-45c0-5e4c-83db-6345cff38888"
        ]
        
        // Defining Body of the Request
        let postData = NSMutableData(data: "\(self.userDetailsPlaceHolder[0])=\(self.storeDetails[0])".data(using: String.Encoding.utf8)!)
        
        for tempIndex in 1..<self.storeDetails.count {
            if self.storeDetails[tempIndex] != "" {
                postData.append("&\(self.userDetailsPlaceHolder[tempIndex])=\(self.storeDetails[tempIndex])".data(using: String.Encoding.utf8)!)
            }
        }
        
        // URL as Request
        let request = NSMutableURLRequest(url: NSURL(string: "https://httpbin.org/post")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        // Request sent and recieved Response
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let err = error {
                print(err)
            } else {
                
                // Returns a Foundation object from given JSON data(Dictionary or Array)
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
                
                 // Data is converted to get desired data
                guard let dict = json as? [String:Any] else { fatalError("dict failed to load") }
                self.formData = dict["form"] as! [String : Any]
            }
        })
        
        dataTask.resume()
        
    }
    
//=============================================================//
//MARK: checkForEmptyTable() Method : Checks for Empty Table
//=============================================================//
    
    func checkForEmptyTable() -> Bool {
        
        for tempIndex in 0..<self.storeDetails.count {
            
            if self.storeDetails[tempIndex] != "" {
                return true
            }
            
        }
        
        return false
    }
    
//=============================================================//
//MARK: myLoader Start and Stop Methods
//=============================================================//

    func startLoader() {
        
        self.myLoader.isHidden = false
        self.myLoader.startAnimating()
        self.myLoader.hidesWhenStopped = true
   
    }
    
    func stopLoader() {
    
        self.myLoader.isHidden = true
        self.myLoader.stopAnimating()
        
    }
    
    
    
}

//=============================================================//
//MARK: Extension of SignUpVC : for Delagates and DataSource
//=============================================================//

extension SignUpVC: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
//=============================================================//
//MARK: Setting the number of cell
//=============================================================//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.userDetailsPlaceHolder.count
        
    }
    
//=============================================================//
//MARK: Setting the cell view
//=============================================================//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell_ID") as? CustomCell else { fatalError("Cell Not Memorised") }
        cell.userDetailsTextField.placeholder = self.userDetailsPlaceHolder[indexPath.row]
        cell.userDetailsTextField.delegate = self
        cell.userDetailsTextField.text = self.storeDetails[indexPath.row]
        return cell
        
    }
    
//=============================================================//
//MARK: Setting the cell height
//=============================================================//
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }

//==================================================================================//
//MARK: shouldChangeCharactersIn() method for getting the changed string as user types
//==================================================================================//

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let cell = getCell(textField) as? CustomCell else { fatalError("Cell failed to load on getCell()") }
        guard let indexPath = self.signUpDetails.indexPath(for: cell) else { fatalError("IndexPath failed to load on getCell()") }
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        self.storeDetails[indexPath.row] = newString
        
        return true
        
    }
    
//=============================================================//
//MARK: User Define method to get Cell
//=============================================================//
    
    func getCell(_ textField: UITextField) -> UITableViewCell {
        
        var view: UIView = textField
        while !(view is CustomCell) {
            if let super_view = view.superview {
                view = super_view
            }
        }
        guard let tableCell = view as? CustomCell else { fatalError("Cell failed to load on getCell()") }
        
        return tableCell
    }
    
    
}
