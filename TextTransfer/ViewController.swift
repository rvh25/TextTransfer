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
                        print(self.filenames)
                    }
                } else {
                    print(error!)
                }
            }
            
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
                    self.downloadfile("/\(name)")
                }
            }
        }
    }
    func array(var files: Array<String>) -> Array<String> {
        files = files + self.filenames
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
    
    
    /*func filesindropbox() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }*/
    
    
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
    
    func enumerateDirectory() -> String? {
        let fileManager = NSFileManager()
        do {
            let path = pathname()
            let filesInDirectory = try fileManager.contentsOfDirectoryAtPath(path as String)

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
    
    /*func enumerateDirectory() -> NSURL? {
        let fileManager = NSFileManager()
        do {
            
            let path = pathname()
            let filesInDirectory2 = try fileManager.contentsOfDirectoryAtPath(path as String)
            print(filesInDirectory2)
            
            let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)

            //var filesInDirectory = try fileManager.contentsOfDirectoryAtURL(documentDirectoryURL.absoluteURL, includingPropertiesForKeys:  nil, options: NSDirectoryEnumerationOptions())
            
            var filesInDirectory = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentDirectoryURL as NSURL, includingPropertiesForKeys:  nil, options: NSDirectoryEnumerationOptions())

            
            print(documentDirectoryURL)
            print(filesInDirectory)
            
            let other = documentDirectoryURL.absoluteURL.URLByAppendingPathComponent("hello.txt")
            print(other)
            if filesInDirectory.count > 0 {
                print(filesInDirectory[0])
                if filesInDirectory[0] == documentDirectoryURL.URLByAppendingPathComponent("hello.txt"){
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
    }*/
    
    
    
    @IBAction func download(sender: AnyObject) {
        var files = [String]()
        files = []
        //filenames(files)
        //entries(files)
        
        //downloadfile( "/Sample.txt")
        //downloadfile( "/test.txt")
        downloadfile( "/Untitled.rtf")


        //write()
        
    }
    
    /*func downloadfile(filename: String){
        
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
    }*/
    
    func downloadfile(var filename: String){
        
        //listoffiles()
        
        
        if let client = Dropbox.authorizedClient {
            client.filesDownload(path: filename).response { response, error in
                if let (metadata, data) = response {
                    print("*** Download file ***")
                    print("Downloaded file name: \(metadata.name)")
                    print("Downloaded file data: \(data)")

                    
                    self.modifyfile("\(self.textedit.text!)", filename: "/Untitled.rtf")

                } else {
                    print(error!)
                }
            }
            client.filesGetPreview(path: filename)
        }
        
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        //let path = filename.removeAtIndex(filename.startIndex)
        let path = String(filename.characters.dropFirst())
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(path)")
        //print(fileDestinationUrl)
        //self.listoffiles(fileDestinationUrl)
        
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
    
    /*func listoffiles2(filepath: String) {
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        //let path = filename.removeAtIndex(filename.startIndex)
        
        // create the destination url for the text file to be saved
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("\(filepath)")
        let filemgr = NSFileManager.defaultManager()
        do {
            let filelist = try filemgr.contentsOfDirectoryAtPath("\(fileDestinationUrl.absoluteString)")
           // let filelist = try filemgr.contentsOfDirectoryAtPath("\(fileDestinationUrl.path!)")

            for filename in filelist {
                print(filename)
            }
        } catch let error as NSError {
            print(error)
        }
    }*/
    
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
    
    @IBAction func upload(sender: AnyObject) {
        createfile("text", filename: "/Sample.txt")
    }
    
    func createfile(text: String, filename: String) {
        //print("Working")
        if let client = Dropbox.authorizedClient {
            // Upload a file
            //let fileData = "This is a test file!".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            let fileData = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            print(fileData)
            
            //client.filesUpload(path:"/1.txt", body: fileData!).response { response, error in
            //client.filesUpload(path:filename, body: fileData!).response { response, error in
                
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
        //listoffiles()
        files()
        check()
        //deleteFile()
        
        //Select files
        //Modify text
        //Save file
        //Upload file 
    }
    
    /*func files() {
        // We need just to get the documents folder url
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }*/
    
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
    
    
    /*func write() {
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
    }*/
    
    
    func check() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as! NSString
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
        var error: NSError?
        let fileManager = NSFileManager()

        if let isFileInDir = enumerateDirectory() {
            let path = pathname().stringByAppendingPathComponent(isFileInDir)
            do {
                let df = try fileManager.removeItemAtPath(path)
                
            } catch let error as NSError {
                print(error)
            }
        } else {
            print("No file found")
        }
        
    }
    
    /*func deleteFile() {
        var error: NSError?
        let fileManager = NSFileManager()
        
        let documentDirectoryURL = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        // create the destination url for the text file to be saved
        //let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("hello.txt")
        
        
        if let isFileInDir = enumerateDirectory() {
            //let path = pathname().stringByAppendingPathComponent(isFileInDir)
            //let path = documentDirectoryURL.URLByAppendingPathComponent(isFileInDir.URLString)

            do {
                //let df = try fileManager.removeItemAtURL(path)
                let df = try fileManager.removeItemAtURL(isFileInDir)

                
            } catch let error as NSError {
                print(error)
            }
        } else {
            print("No file found")
        }
        
    }*/

    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }
    
    @IBAction func download2(segue:UIStoryboardSegue) {
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
    @IBAction func write(sender: AnyObject) {
        //write()
        //deleteFile()
        
    }
    
    

}

