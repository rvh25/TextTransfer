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
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)")
                } else {
                    print(error!)
                }
            }
         
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDir = paths.firstObject as! NSString
            print("Path to the Documents directory\n\(documentsDir)")
        
            
            // List folder
            client.filesListFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
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
    
    
    /*func downloadfile(filename: String){
        
        //listoffiles()
        
        if let client = Dropbox.authorizedClient {
            client.filesDownload(path: filename).response { response, error in
                if let (metadata, data) = response {
                    print("*** Download file ***")
                    print("Downloaded file name: \(metadata.name)")
                    print("Downloaded file data: \(data)")
                } else {
                    print(error!)
                }
            }
        }
    }*/
    
    func downloadfile(filename: String){
        
        //listoffiles()
        
        
        if let client = Dropbox.authorizedClient {
            client.filesDownload(path: filename).response { response, error in
                if let (metadata, data) = response {
                    print("*** Download file ***")
                    print("Downloaded file name: \(metadata.name)")
                    print("Downloaded file data: \(data)")
                    
                    if let file = metadata as? Files.FileMetadata {
                        //print("This is a file.")
                        print("This is a file with path: \(file.pathLower)")
                        print("File size: \(file.size)")
                    }
                } else {
                    print(error!)
                }
            }
        }
        //listoffiles2()
        
    }
    
 
    
    
    func downloadfile2(filename: String){
    
        if let client = Dropbox.authorizedClient {
    
            client.filesListFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
            
            
            client.filesDownload(path: filename).response { response, error in
                if let (metadata, data) = response {
                    print("*** Download file ***")
                    print("Downloaded file name: \(metadata.name)")
                    print("Downloaded file data: \(data)")
                } else {
                    print(error!)
                }
            }
        }
    }
    

   /* func checkentries() {
        for entry in response!.entries {
            //print(entry.name)
            //
            files.append(entry.name)
            //let filenames = ["\(entry.name)"]
            //dump(files)
        }
    }*/
    
    func entries(var files: Array<String>)-> Array<String> {

        dump(files)
        return files
    }

   /* func filenames2(var files: Array<String>) -> Array<String> {
        if let client = Dropbox.authorizedClient {
            //var files = [String]()
            //files = []
            
            client.filesListFolder(path: "").response { response, error in
                if let result = response {
                    for entry in result.entries {
                        if let entry  {
                            break
                        }
                        //
                        else {
                            files.append(entry.name)
                        }
                        //files.append(entry.name)
                        //return files
                        //let filenames = ["\(entry.name)"]
                        //dump(files)
                        //TableViewController().entries(files)
                    }
                    //dump(files)
                    //self.entries(files)
                }
                    
                else {
                    print(error!)
                }
            }
            //self.entries(files)
            
        }
        
        if files.isEmpty{
            print("empty")
        }
        dump(files)
        return files
    }*/
    
    
    /*func filenames(var files: Array<String>) -> Array<String> {
        //if let client = Dropbox.authorizedClient {
        //var files = [String]()
        //files = []
        
        var results = [String]()
        results = []
        
        //Dropbox.authorizedClient!.filesListFolder(path: "").response { response, error in
        Dropbox.authorizedClient!.filesListFolder(path: "").response { (response) -> Array<String> in

            for entry in response!.entries {
                files.append(entry.name)
            }
            let results = files
        }
        dump(results)
        dump(files)
        return files
        
        

//            else {
//            print(error!)
//            }
        //}
    }*/
    
    /*
    func dropboxlist() -> NSArray {
        if let client = Dropbox.authorizedClient {

        // List folder
        client.filesListFolder(path: "").response { response, error in
            print("*** List folder ***")
            if let result = response {
                print("Folder contents:")
                for entry in result.entries {
                    print(entry.name)
                    //
                    let filenames = ["\(entry.name)"]
                }
                
        }
        }
        //return filenames
    }*/
    
    /*func dropboxlist() -> NSArray {
        if let client = Dropbox.authorizedClient {
            
            // List folder
            //client.filesListFolder(path: "User/Docs").response { response, error in
            client.filesListFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                        //
                        let filenames = [""]
                    }
                } else {
                    print(error!)
                }
            }
        }
        return filenames
    }*/
    
    
    
    func files() {
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func listoffiles() {
        let filemgr = NSFileManager.defaultManager()
        do {
            let filelist = try filemgr.contentsOfDirectoryAtPath("/")
                for filename in filelist {
                    print(filename)
                }
            
        } catch let error as NSError {
            print(error)
        }
        

    }
    
    func listoffiles2() {
        let filemgr = NSFileManager.defaultManager()
        do {
            let filelist = try filemgr.contentsOfDirectoryAtPath("/hello.txt")
            for filename in filelist {
                print(filename)
            }
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    /*func filesindropbox() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    
    }*/
    
    
    
    
    func pathname() -> NSString {
        //print("pathname function working")
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! NSString
        print("Path to the Documents directory\n\(documentsDir)")
        return documentsDir
    }
    
    func check() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as! NSString
        let myFilePath = documentDirectory.stringByAppendingPathComponent("hello.txt")
        
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            print("file found")
        }
        else {
            print("none")
        }
    }
    
    @IBAction func listDirectory(sender: AnyObject) {
        // List Content of Path
        let isFileInDir = enumerateDirectory() ?? "Empty"
        print("Contents of Directory =  \(isFileInDir)")
        
        databaseURL()

    }
    
    @IBAction func viewFileContent(sender: AnyObject) {
        let isFileInDir = enumerateDirectory() ?? ""
        
        let path = pathname().stringByAppendingPathComponent(isFileInDir)
        do {
            let contentsOfFile = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            print("Content of file = \(contentsOfFile)")
            
            
            /*if let content = contentsOfFile {
            print("Content of file = \(content)")
            } else {
            print("No file found")
            }*/
        } catch let error as NSError {
            print(error)
            print("No file found")
            
        }
    }
    
    func enumerateDirectory() -> String? {
        //var tmpDir = NSTemporaryDirectory() as NSString
        let fileManager = NSFileManager()

        let error: NSError?
        do {
            //let filesInDirectory = try fileManager.contentsOfDirectoryAtPath(tmpDir as String)
            let path = pathname()
            let filesInDirectory = try fileManager.contentsOfDirectoryAtPath(path as String)

            if filesInDirectory.count > 0 {
                if filesInDirectory[0] == "Sample.txt"{
                    print("Sample.txt found")
                    return filesInDirectory[0]
                } else {
                    print("File not found")
                    return nil
                }
            }
            
            return nil
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
    
    func createfile(text: String, filename: String) {
        //print("Working")
        if let client = Dropbox.authorizedClient {
        // Upload a file
        //let fileData = "This is a test file!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let fileData = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
        //client.filesUpload(path:"/1.txt", body: fileData!).response { response, error in
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
    
    
    @IBAction func download(sender: AnyObject) {
        var files = [String]()
        files = []
        //filenames(files)
        //entries(files)
        
        downloadfile( "/Sample.txt")
        write()
        
    }
    
    @IBAction func upload(sender: AnyObject) {
        createfile("text", filename: "/Sample.txt")
        
    }
    
    @IBAction func Modify(sender: AnyObject) {
        //listoffiles()
        files()
        
        check()
        //Select files
        //Modify text
        //Save file
        //Upload file 
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
    @IBAction func download2(segue:UIStoryboardSegue) {
    }
    
    func modifyfile(filename: String) {
        //print("Working")
        if let client = Dropbox.authorizedClient {
            // Upload a file
            //let fileData = "This is a test file!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let text = String()
            let fileData = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            
            //client.filesUpload(path:"/1.txt", body: fileData!).response { response, error in
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
    
    func databaseURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // If array of path is empty the document folder not found
        guard urls.count == 0 else {
            let finalDatabaseURL = urls.first!.URLByAppendingPathComponent("Sample.txt")
            // Check if file reachable, and if reacheble just return path
            guard finalDatabaseURL.checkResourceIsReachableAndReturnError(nil) else {
                // Check if file is exists in bundle folder
                if let bundleURL = NSBundle.mainBundle().URLForResource("Sample", withExtension: "txt") {
                    // if exist we will copy it
                    do {
                        try fileManager.copyItemAtURL(bundleURL, toURL: finalDatabaseURL)
                    } catch _ {
                        print("File copy failed!")
                    }
                } else {
                    print("file does not exist in bundle folder")
                    return nil
                }
                return finalDatabaseURL
            }
            return finalDatabaseURL
        }
        return nil
    }
    
    func write() {
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("hello.txt")
        
        let text = "some text"
        do{
            // writing to disk
            try text.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding)
            
            // saving was successful. any code posterior code goes here
            
            // reading from disk
            do {
                let mytext = try String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding)
                print(mytext)   // "some text\n"
            } catch let error as NSError {
                print("error loading from url \(fileDestinationUrl)")
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print("error writing to url \(fileDestinationUrl)")
            print(error.localizedDescription)
        }

    }

}

