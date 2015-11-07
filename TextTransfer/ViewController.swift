//
//  ViewController.swift
//  TextTransfer
//
//  Created by Rohaine Hsu on 9/12/15.
//  Copyright © 2015 Rohaine Hsu. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController, UITextFieldDelegate {

    var filenames: Array<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filename.delegate = self;
        self.filetext.delegate = self;
        self.fileextension.delegate = self;
        
        self.filenames = []
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.usersGetCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.filesListFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                        self.filenames!.append(entry.name)
                    }

                } else {
                    print(error!)
                }
                print(self.filenames)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
            //Dropbox.unlinkClient()
        }
    }
    
    @IBAction func viewFileContent(sender: AnyObject) {
        filecontent("test.txt")
    }
    
    func filecontent(filepath: String) {
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(filepath)")
        do {
            let contentsOfFile = try NSString(contentsOfFile: fileDestinationUrl.path!, encoding: NSUTF8StringEncoding)
            print("Content of file = \(contentsOfFile)")
        } catch let error as NSError {
            print(error)
            print("No file found")
        }
    }
    
    func downloadfile(filename: String){
        if let client = Dropbox.authorizedClient {
            
            let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
                (temporaryURL, response) in
                
                if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                    let path = directoryURL.URLByAppendingPathComponent("\(filename)")
                    return path
                }
                return temporaryURL
            }
            client.filesDownload(path: filename, destination: destination).response { response, error in

                    if let (metadata, data) = response {
                        print("*** Download file ***")
                        print("Downloaded file name: \(metadata.name)")
                        //print("Downloaded file data: \(data)")
                    } else {
                        print(error!)
                    }
            }
            
        }
    }
    
    
    @IBOutlet var filename: UITextField!
    
    @IBOutlet var filetext: UITextField!
    
    @IBOutlet var fileextension: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func upload(sender: AnyObject) {
        //createfile("text", filename: "/Sample.txt")
        self.createfile("\(self.filetext.text!)", filename: ("/\(self.filename.text!).\(self.fileextension.text!)"))
    }
    
    func createfile(text: String, filename: String) {
        if let client = Dropbox.authorizedClient {
            // Upload a file

            let fileData = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            print(fileData)
                
            client.filesUpload(path:filename, body: fileData!).response { response, error in
                
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
                    client.filesGetMetadata(path: "/test.txt").response { response, error in
                        print("*** Get file metadata ***")
                        if let metadata = response {
                            //print("Name: \(metadata.name)")
                            if let file = metadata as? Files.FileMetadata {
                                //print("This is a file.")
                                print("This is a file with path: \(file.pathLower)")
                                print("File size: \(file.size)")
                            } else if let folder = metadata as? Files.FolderMetadata {
                                //print("This is a folder.")
                                print("This is a folder with path: \(folder.pathLower)")
                            }
                        } else {
                            print(error!)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func Check(sender: AnyObject) {
        files()
        check("test.txt")
    }
    
    
    func files() {
        let documentsURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsURL.absoluteURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    
    func check(filepath: String) {
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(filepath)")
        let filemgr = NSFileManager.defaultManager()
        if (filemgr.fileExistsAtPath(fileDestinationUrl.path!)) {
            print("file found")
        }
        else {
            print("none")
        }
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestViewController = (segue.destinationViewController as! UINavigationController).topViewController as! TableViewController
        DestViewController.data = self.filenames
    }
}

