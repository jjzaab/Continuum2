//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var resultsArray: [Post] = [] // Source of truth
    var isSearching = false
    var dataSource: [Post] {
        get {
            if isSearching {
                return resultsArray
            } else {
                return PostController.shared.posts
            }
        }
    }
    
    func sync(completion: ( () -> Void)? ) {
        
        PostController.shared.fetchPosts { (posts) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        sync(completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultsArray = PostController.shared.posts
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = dataSource[indexPath.row]
        cell.post = post

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDOO
        if segue.identifier == "detailSegue" {
            if let destinationVC = segue.destination as? PostDetailTableViewController {
                guard let indexPath = tableView.indexPathForSelectedRow else { return }
                destinationVC.post = PostController.shared.posts[indexPath.row]
            }
        }
    }
}
// MARK: - Extension for UISearchBarDelegate
extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.shared.posts.filter({$0.matchesSearchTerm(searchTerm: searchText)})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        DispatchQueue.main.async {
            searchBar.text = ""
            self.tableView.reloadData()
        }
        resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
}
