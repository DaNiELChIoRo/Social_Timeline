//
//  PostTableViewControlelr.swift
//  Social_Timeline
//
//  Created by Daniel Meneses on 7/31/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import UIKit

class PostTableViewCellController: UITableViewController {
    
    var items:[Post] = [Post]()
    var realtimeDB: RealtimeDatabase!
    var fireStorage: FireStorage!
    var coordinator: PostsCoordinator?
    var timestamp: Double?
    var content: String?
    var counter:Int?
    
    override func viewDidLoad(){
        super.viewDidLoad()
//        navigationController.coordinator = self
        self.realtimeDB = RealtimeDatabase(delegate: self)
        self.fireStorage = FireStorage(delegate: self)
        tableView.register(MultimediaTableViewCell.self, forCellReuseIdentifier: "MultimediaCell")
        tableView.register(FlatMultimediaTableViewCell.self, forCellReuseIdentifier: "FlatCell")
        
        startFecthingAllPosts()
    }

    init(coordinator: PostsCoordinator) {
        super.init(style: .plain)
        self.coordinator = coordinator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCells(_ Cells:[UITableViewCell], _ post: Post) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if let multimedia = post.multimedia as? NSDictionary {
            if let cell = Cells[0] as? MultimediaTableViewCell {
                self.realtimeDB.fetchAuthorInfo(authorID: post.title, action: { (username, userimage) in
                    cell.titleLabel?.text = username
                    cell.setImage(imageURL: userimage)
                    
                    if let multimediaContent = multimedia["location"] as? String  {                        
                        cell.postMultimedia?.contentImageView.downloadImageFromFireStorage(imageURL: multimediaContent)
                    }
                    
                    cell.publishDateLabel?.text = "published: \(self.setCellDate(date: post.publishDate))"
                    cell.contentLabel?.text = post.content
                })
                return cell
            }
        } else {
            if let cell = Cells[1] as? FlatMultimediaTableViewCell {
                self.realtimeDB.fetchAuthorInfo(authorID: post.title, action: { (username, userimage) in
                    cell.titleLabel?.text = username
                    cell.setImage(imageURL: userimage)
                })
                
                cell.publishDateLabel?.text = "published: \(self.setCellDate(date: post.publishDate))"
                cell.contentLabel?.text = post.content
                tableViewCell = cell
                return cell
            }
        }
        return tableViewCell
    }
    
    func startFecthingAllPosts(){
        realtimeDB.fetchPosts(action: onAllPostsFetched)
    }

    func onAllPostsFetched(_ username: String, _ userimage: String, _ content:String, _ timestamp:Double, _ multimedia: Any?) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
        let userImage = UIImage(contentsOfFile: userimage) ?? UIImage(named: "avatar" )
        if let multimedia = multimedia as? NSDictionary {
            print(multimedia)
            let fetchPost = Post(title: username, publishDate: timestamp, content: content, multimedia: multimedia, userimage: userImage!)
            self.appendItemToArray(item: fetchPost)
            return
        }
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, multimedia: false, userimage: userImage!)
        self.appendItemToArray(item: fetchPost)
    }
    
    func setCellDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: Double(date))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale(identifier: "ES-mx")
        dateFormatter.dateFormat = "EEE MMM dd HH:mm yyyy"
        let stringDate = dateFormatter.string(from: date)
        return stringDate
    }
    
    @objc func refreshHandler() {
        print("refresHandler")
        
        refreshControl!.attributedTitle = NSAttributedString(string: "Fetching Data.... ")
        eliminateAllRows()
        fetchOldPosts()
    }
    
    func eliminateItemFromArray(index: Int){
        items.remove(at: index)
        let indexPath = IndexPath(row: index, section: 0)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func appendItemToArray(item: Post){
        items.append(item)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func eliminateAllRows() {
        self.items = [Post]()
        tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    func fetchOldPosts() {
        guard var counter = counter else { return }
        counter += 7
        let noPost = UInt(bitPattern: counter)
        getMorePosts(noPosts: noPost)
//        createNewestButton()
    }
    
    func getMorePosts(noPosts: UInt) {
        realtimeDB.fetchMorePosts(noPosts: noPosts)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //MARK:- ROW USER ACTIONS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let flatCell = tableView.dequeueReusableCell(withIdentifier: "FlatCell", for: indexPath) as! FlatMultimediaTableViewCell
        let multimediaCell = tableView.dequeueReusableCell(withIdentifier: "MultimediaCell", for: indexPath) as! MultimediaTableViewCell
        let item = items[indexPath.row]
        return configureCells([multimediaCell, flatCell], item)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, index) in
            print("remove button tapped of the cell in the positio \(index.row), tableview count: \(self.tableView.numberOfRows(inSection: 0))")
            //            self.coordinator?.eliminatePost(row: index.row)
            print("the cell is wanted to be remove!")
        }
        
        return [remove]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        print(item.self)
//        selectHandler(item)
    }
    
}

extension PostTableViewCellController: realtimeDelegate {
    
    func onSuccess() {
        eliminateAllRows()
    }
    
    func onPostFetched(_ username: String, _ userimage: String, _ content: String, _ timestamp: Double) {
        print("***** ALL POSTS CALLED: username: \(username), userimage: \(userimage), content: \(content), timestamp: \(timestamp)")
        let userImage = UIImage(contentsOfFile: userimage) ?? UIImage(named: "avatar" )
        let fetchPost = Post(title: username, publishDate: timestamp, content: content, multimedia: false, userimage: userImage!)
        appendItemToArray(item: fetchPost)
    }
    
    func onError(_ error: String) {
        self.navigationController?.createAlertDesctructive("Error", error, .alert, "Entendido")
    }
    
}

extension PostTableViewCellController: FireStorageDelegate {
    
    func onFileUploaded(_ filePath: String) {
        guard let timestamp = self.timestamp,
            let content = self.content else { return }
        let multimediaStuff:NSDictionary = ["type": "iamge", "location": filePath]
        do {
            try realtimeDB.setUserPost(timestamp: timestamp, content: content, multimedia: multimediaStuff)
        } catch {
            print("Error while trying to saving the post on DB")
        }
    }
    
    func onDBError(_ error: String) {
        print("Some error trying to upload a file via FireStorageService")
    }
}

