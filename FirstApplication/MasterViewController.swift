//
//  MasterViewController.swift
//  XMLApplication
//
//  Created by Kevin Miyata on 9/21/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, XMLParserDelegate {
    
    var urlForMusic = "https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/10/explicit.rss"
    
    var parser = XMLParser()

    var detailViewController: DetailViewController? = nil
    var objects = [Song]()
    var objs = [Album]()
    var downloader = Downloader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        // XML parsing
        let urlString = URL(string: urlForMusic)
        self.parser = XMLParser(contentsOf: urlString!)!
        self.parser.delegate = self
        let success: Bool = self.parser.parse()
        if success {
            print("XML Data parsed!")
        } else {
            print("Failed to parse XML data.")
        }
        
        parseXml()
        
        // downloadData()
    }
    
    func parseXml() {
        weak var weakSelf = self
        
        weakSelf!.objs = albums
        weakSelf!.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    // Download JSON data, decode it, and populate table view
    func downloadData() {
        
        weak var weakSelf = self
        
        downloader.downloadData(urlString: urlForMusic) {
            (data) in
            
            guard let jsonData = data else {
                weakSelf!.presentAlert(title: "Error", message: "Unable to download JSON data")
                return
            }
            
            do {
                let showData = try JSONDecoder().decode(ShowData.self, from: jsonData)
                weakSelf!.objects = showData.feed.results
                weakSelf!.tableView.reloadData()
            } catch {
                weakSelf!.presentAlert(title: "Error", message:                    "Invalid JSON downloaded")
            }
        }
    }

//    @objc
//    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objs[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.downloader = downloader
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let object = objs[indexPath.row]
        cell.textLabel!.text = object.title
        // cell.detailTextLabel!.text = object.artistName
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - XML Parser functions
    
    var albums = [Album]()
    
    var aTitle = ""
    var aPubDate = ""
    var aCategory = ""
    var aDescription = ""
    var aLink = ""
    
    var inTitle = false
    var inPubDate = false
    var inCategory = false
    var inDescription = false
    var inLink = false
    
    var album = Album(title: "", link: "", category: "", description: "")
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        // TODO: insert code from XMLParserExample playground file
        print("Start of element: \(elementName)")
        
        if (elementName == "title") {
            inTitle = true
            aTitle = ""
        } else if (elementName == "link") {
            inLink = true
            aLink = ""
        } else if (elementName == "category") {
            inCategory = true
            aCategory = ""
        } else if (elementName == "pubDate") {
            inPubDate = true
            aPubDate = ""
        } else if (elementName == "description") {
            inDescription = true
            aDescription = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("End of element: \(elementName)")
        
        if (elementName == "title") {
            albums.append(Album(title: aTitle, link: aLink, category: aCategory, description: aDescription))
        } else if (elementName == "title") {
            inTitle = false
        } else if (elementName == "link") {
            inLink = false
        } else if (elementName == "category") {
            inCategory = false
        } else if (elementName == "description") {
            inDescription = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("Found characters: \(string)")
        
        if inTitle {
            aTitle = aTitle + string
        } else if inPubDate {
            aPubDate = aPubDate + string
        } else if inCategory {
            aCategory = aCategory + string
        } else if inLink {
            aLink = aLink + string
        } else if inDescription {
            aDescription = aDescription + string
        }
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML data failed to be parsed: ", parseError)
    }
    
    // MARK: - Object Structures
    
//    struct Album {
//        var title: String = ""
//        var link: String = ""
//        var category: String = ""
//        var description: String = ""
//    }

}

