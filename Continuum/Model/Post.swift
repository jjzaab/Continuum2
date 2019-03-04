//
//  Post.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CloudKit

// MARK: - Keys
struct PostKeys {
    static let postTypeKey = "Post"
    static let timestampKey = "timestamp"
    static let captionKey = "caption"
    static let photoDataKey = "photoData"
    static let commentCountKey = "commentCount"
}

class Post {
    // MARK: - Properties
    var photoData: Data?
    let timestamp: Date
    let caption: String
    var comments: [Comment]
    var recordID: CKRecord.ID
    var commentCount: Int
    
    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error writing to temp url \(error) \(error.localizedDescription)") }
            return CKAsset(fileURL: fileURL) }
    }
    
    var photo: UIImage? {
        get {
            if let photoData = photoData {
                return UIImage(data: photoData)
            } else {
                return nil
            }
        }
        set {
            photoData = newValue?.jpegData(compressionQuality: 100)
        }
    }
    
    // MARK: - Initializers
    init(photo: UIImage, caption: String, comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int) {
        self.caption = caption
        self.timestamp = Date()
        self.comments = comments
        self.recordID = recordID
        self.commentCount = commentCount
        self.photo = photo
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let imageAsset = ckRecord[PostKeys.photoDataKey] as? CKAsset,
            let caption = ckRecord[PostKeys.captionKey] as? String
            else { return nil }
        
        do {
            let data = try Data.init(contentsOf: imageAsset.fileURL)
            guard let photo = UIImage(data: data) else { return nil }
            let recordID = ckRecord.recordID
            let comments: [Comment] = []
            
            self.init(photo: photo, caption: caption, comments: comments, recordID: recordID, commentCount: comments.count)
        } catch {
            print("Error creating Post from CKRecord: \(error.localizedDescription)")
            return nil
        }
    }
}

extension Post: SearchableRecord {
    func matchesSearchTerm(searchTerm: String) -> Bool {
        for comment in comments {
            if comment.text.contains(searchTerm) || caption.contains(searchTerm) {
                return true
            } else {
                return false
            }
        }
        return false
    }
}

extension CKRecord {
    convenience init(post: Post) {
        self.init(recordType: PostKeys.postTypeKey, recordID: post.recordID)
        
        self.setValue(post.imageAsset, forKey: PostKeys.photoDataKey)
        self.setValue(post.timestamp, forKey: PostKeys.timestampKey)
        self.setValue(post.caption, forKey: PostKeys.captionKey)
        self.setValue(post.commentCount, forKey: PostKeys.commentCountKey)
        
    }
}


