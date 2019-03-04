//
//  PostController.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

class PostController {

    // MARK: - Singleton
    static let shared = PostController()
    
    // MARK: - Properties
    // Source of truth
    var posts: [Post] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - Add Comment
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        
        post.commentCount += 1
        
        let comment = Comment(text: text, post: post)
        //post.comments.append(comment)
        
        let record = CKRecord(comment: comment)
        
        let modify = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        modify.savePolicy = .changedKeys
        
        publicDB.add(modify)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error saving to database: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let record = record else {
                completion(nil)
                return
            }
            
            guard let comment = Comment(record: record, post: post) else {
                completion(nil)
                return
            }
            post.comments.append(comment)
            completion(comment)
        }
    }
    
    // MARK: - Create Post
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        
        let post = Post(photo: image, caption: caption, commentCount: 0)
        let record = CKRecord(post: post)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error saving to database: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let record = record else {
                completion(nil)
                return
            }
            
            guard let post = Post(ckRecord: record) else {
                completion(nil)
                return
            }
            
            self.posts.append(post)
            completion(post)
        }
    }
    
    // MARK: - Fetch All Posts
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostKeys.postTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let records = records else {
                completion([])
                return
            }
            
            let newArray = records.compactMap({ Post(ckRecord: $0)})
            
            self.posts = newArray
            completion(newArray)
        }
    }
    
    // MARK: - Fetch Comments
    func fetchComments(for post: Post, completion: @escaping ([Comment]?) -> Void) {
        
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [CommentKeys.postReferenceKey, post.recordID])
        
//        let commentIDs = post.comments.compactMap({$0.recordID})
//
//        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
//
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        
        let query = CKQuery(recordType: CommentKeys.commentTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let records = records else {
                completion([])
                return
            }
            
            let newArray = records.compactMap({ Comment(record: $0, post: post) })
            
            post.comments = newArray
            completion(newArray)
        }
    }
    
}
