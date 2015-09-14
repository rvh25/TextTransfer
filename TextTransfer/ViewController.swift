//
//  ViewController.swift
//  TextTransfer
//
//  Created by Rohaine Hsu on 9/12/15.
//  Copyright © 2015 Rohaine Hsu. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Verify user is logged into Dropbox
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.usersGetCurrentAccount().response { response, error in
                if let account = response {
                    print("Hello \(account.name.givenName)")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.filesListFolder(path: "/Docs").response { response, error in
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
           
            
            // Upload a file
            let fileData = "Hello!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            client.filesUpload(path:"/1.txt", body: fileData!).response { response, error in
                if let metadata = response {
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
                    client.filesGetMetadata(path: "/1.txt").response { response, error in
                        if let metadata = response {
                            print("Name: \(metadata.name)")
                            if let file = metadata as? Files.FileMetadata {
                                print("This is a file.")
                                print("File size: \(file.size)")
                            } else if let folder = metadata as? Files.FolderMetadata {
                                print("This is a folder.")
                            }
                        } else {
                            print(error!)
                        }
                    }

                    // Download a file
                    client.filesDownload(path: "/1.txt").response { response, error in
                        if let (metadata, data) = response {
                            print("Downloaded file name: \(metadata.name)")
                            print("Downloaded file data: \(data)")
                        } else {
                            print(error!)
                        }
                    }
                    
                } else {
                    print(error!)
                }
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
    
    
    func download2(filename: String){
        
        if let client = Dropbox.authorizedClient {
            client.filesDownload(path: filename).response { response, error in
                if let (metadata, data) = response {
                    print("Downloaded file name: \(metadata.name)")
                    print("Downloaded file data: \(data)")
                } else {
                    print(error!)
                }
            }
        }
    }
    
    
    @IBAction func download(sender: AnyObject) {
        download2( "/1.txt")
    }
    

    

}

