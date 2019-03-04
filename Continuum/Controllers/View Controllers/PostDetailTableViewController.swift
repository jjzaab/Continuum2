//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photoImageView: UIImageView!
    
    // Landing pad
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let post = post else { return }
        PostController.shared.fetchComments(for: post) { (comments) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - IBActions
    @IBAction func commentButtonTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Add New Comment", message: "Enter your new comment", preferredStyle: .alert)
        alert.addTextField { (textField) in
             textField.placeholder = "Enter..."
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            guard let text = alert.textFields?[0].text, text != "", let post = self.post else { return }
            PostController.shared.addComment(text: text, post: post, completion: { (comment) in
                DispatchQueue.main.async {
                    print("reloading inside")
                    self.tableView.reloadData()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let post = self.post else { return }
        let activity = UIActivityViewController(activityItems: [post.photo, post.caption], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    @IBAction func followButtonTapped(_ sender: UIButton) {
        
    }
    
    func updateViews() {
        guard let post = post else { return }

        DispatchQueue.main.async {
            self.photoImageView.image = post.photo
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post?.comments.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        guard let post = post else { return UITableViewCell() }
        cell.textLabel?.text = post.comments[indexPath.row].text
        cell.detailTextLabel?.text = "\(post.comments[indexPath.row].timestamp)"
        return cell
    }

}
