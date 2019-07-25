//
//  TableViewController.swift
//  Social_Timeline
//
//  Created by Daniel.Meneses on 6/18/19.
//  Copyright © 2019 Daniel.Meneses. All rights reserved.
//

import Foundation
import UIKit

class GenericTableViewController<T, Cell: UITableViewCell>: UITableViewController {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var items: [T]
    var configure: (Cell, T) -> Void
    var selectHandler: (T) -> Void
    var coordinator: PostsCoordinator?
    var counter:Int
    
    private let _refreshControl = UIRefreshControl()
    
    init(items: [T], coordinator: PostsCoordinator, configure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        self.items = items
        self.configure = configure
        self.selectHandler = selectHandler
        self.coordinator = coordinator
        self.counter = 7
        super.init(style: .plain)
        self.tableView.register(Cell.self, forCellReuseIdentifier: "Cell")
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(refreshHandler), for: UIControl.Event.valueChanged)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //MARK:- ROW USER ACTIONS
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let item = items[indexPath.row]
        configure(cell, item)
        return cell
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
        selectHandler(item)
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
    
    func appendItemToArray(item: T){
        items.append(item)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func eliminateAllRows() {
        self.items = [T]()
        tableView.reloadData()
        refreshControl!.endRefreshing()
    }
    
    func fetchOldPosts() {
        counter += 7
        let noPost = UInt(bitPattern: counter)
       coordinator?.getMorePosts(noPosts: noPost)
    }

}


