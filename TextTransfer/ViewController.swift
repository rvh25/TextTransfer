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
        
        self.textedit.delegate = self;
        
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
         
            
            let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
            let documentsDir = paths.firstObject as! NSString
            print("Path to the Documents directory\n\(documentsDir)")
        
            
            // List folder
            /*client.filesListFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }*/
            
            // List folder
            client.filesListFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                        self.filenames!.append(entry.name)
                        //print(self.filenames)
                    }
                    //print(self.filenames)

                } else {
                    print(error!)
                }
                print(self.filenames)
                
                
                TableViewController().files(self.filenames)
                func tableViewrows(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                print(self.filenames)
                return self.filenames!.count
                
                }
                
                func tableViewcells(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath)
                cell.textLabel?.text = self.filenames![indexPath.row]
                return cell
                }
                
                
                func tableViewselectedcell(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
                let indexPath = tableView.indexPathForSelectedRow
                let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell?
                if let name = currentCell!.textLabel!.text {
                //self.downloadfile("/\(name)")
                }
                }
            }

            
            /*func tableViewrows(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                print(self.filenames)
                return self.filenames!.count
                
            }
            
            func tableViewcells(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCellWithIdentifier("FileCell", forIndexPath: indexPath)
                cell.textLabel?.text = self.filenames![indexPath.row]
                return cell
            }
            
            
            func tableViewselectedcell(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
                let indexPath = tableView.indexPathForSelectedRow
                let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell?
                if let name = currentCell!.textLabel!.text {
                    self.downloadfile("/\(name)")
                }
            }*/
        }
    }
    func files(files: Array<String>) -> Array<String> {
        //print(self.filenames)
        return files
        
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
    
    
    
    @IBAction func listDirectory(sender: AnyObject) {
        // List Content of Path
        let isFileInDir = enumerateDirectory() ?? "Empty"
        print("Contents of Directory =  \(isFileInDir)")
        
        databaseURL()
    }
    
    func databaseURL() -> NSURL? {
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        
        // If array of path is empty the document folder not found
        guard urls.count == 0 else {
            let finalDatabaseURL = urls.first!.URLByAppendingPathComponent("test.txt")
            // Check if file reachable, and if reacheble just return path
            guard finalDatabaseURL.checkResourceIsReachableAndReturnError(nil) else {
                // Check if file is exists in bundle folder
                if let bundleURL = NSBundle.mainBundle().URLForResource("test", withExtension: "txt") {
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
    
    @IBAction func viewFileContent(sender: AnyObject) {
        //let isFileInDir = enumerateDirectory() ?? ""
        if let isFileInDir = enumerateDirectory() {

        /*let path = pathname().stringByAppendingPathComponent(isFileInDir)
        do {
            let contentsOfFile = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            print("Content of file = \(contentsOfFile)")
        } catch let error as NSError {
            print(error)
            print("No file found")
        }*/
        
        
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let path = documentDirectoryURL.URLByAppendingPathComponent(isFileInDir.URLString)

        
        do {
            let contentsOfFile = try NSString(contentsOfFile: path.URLString, encoding: NSUTF8StringEncoding)
            
            print("Content of file = \(contentsOfFile)")
        } catch let error as NSError {
            print(error)
            print("No file found")
        }
        }
    }
    
    func pathname() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! NSString
        print("Path to the Documents directory\n\(documentsDir)")
        return documentsDir
    }
    
    func pathname2(filename: String) -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        let documentsDir = paths.firstObject as! NSString
        let path = documentsDir.stringByAppendingPathComponent(filename)
        print("Path to the file\n\(path)")
        return path
    }
    
    func enumerateDirectory() -> String? {
        let fileManager = NSFileManager()
        do {
            let path = pathname()
            //let path = pathname()

            let filesInDirectory = try fileManager.contentsOfDirectoryAtPath(path as String)
            //let filesInDirectory = try fileManager.contentsOfDirectoryAtPath(path as String)


            if filesInDirectory.count > 0 {
                if filesInDirectory[0] == "test.txt"{
                    print("test.txt found")
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
    

    
    @IBAction func download(sender: AnyObject) {
        //downloadfile( "/Sample.txt")
        //downloadfile( "/test.txt")
        //pathname2("test.txt")
        //downloadfile( "/Untitled.rtf")
        downloadfile( "/Vocab1.docx")

    }
    
    func downloadfile(filename: String){
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
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
                        
                        
                        //self.modifyfile("\(self.textedit.text!)", filename: "/Untitled.rtf")
                        
                    } else {
                        print(error!)
                    }
            }
        }
    }
    
  

    
    //@IBOutlet var textedit: UITextView!
    @IBOutlet var textedit: UITextField!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func listoffiles(filepath: NSURL) {
        let filemgr = NSFileManager.defaultManager()
        do {
            let filelist = try filemgr.contentsOfDirectoryAtPath("\(filepath)")
            for filename in filelist {
                print(filename)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    

    @IBAction func listiffiles(sender: AnyObject) {
        listoffiles2( "test.txt")
    }
    
    func listoffiles2(filepath: String) {
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        //let path = filename.removeAtIndex(filename.startIndex)
        
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(filepath)")
        let filemgr = NSFileManager.defaultManager()
        do {
            let filelist = try filemgr.contentsOfDirectoryAtURL(fileDestinationUrl.absoluteURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            // let filelist = try filemgr.contentsOfDirectoryAtPath("\(fileDestinationUrl.path!)")
            
            for filename in filelist {
                print(filename)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    

    
    @IBAction func upload(sender: AnyObject) {
        createfile("text", filename: "/Sample.txt")
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
    
    
    @IBAction func Modify(sender: AnyObject) {
        files()
        check()
    }
    
    
    func files() {
        //let documentsURL =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let documentsURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsURL.absoluteURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    func check() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as NSString
        let myFilePath = documentDirectory.stringByAppendingPathComponent("test.txt")
        
        let manager = NSFileManager.defaultManager()
        if (manager.fileExistsAtPath(myFilePath)) {
            print("file found")
        }
        else {
            print("none")
        }
    }
    
    func deleteFile() {
        let fileManager = NSFileManager()

        if let isFileInDir = enumerateDirectory() {
            let path = pathname().stringByAppendingPathComponent(isFileInDir)
            do {
                try fileManager.removeItemAtPath(path)
                
            } catch let error as NSError {
                print(error)
            }
        } else {
            print("No file found")
        }
        
    }
    
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
    func modifyfile(text: String, filename: String) {
        //print("Working")
        if let client = Dropbox.authorizedClient {
            //let text = String()
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

    func write() {
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("test.txt")
        print(fileDestinationUrl)
        
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

