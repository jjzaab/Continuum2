//
//  Comment.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation
import CloudKit

struct CommentKeys {
    static let commentTypeKey = "Comment"
    static let timestampKey = "timestamp"
    static let textKey = "text"
    static let postReferenceKey = "postReference"
}

class Comment {
    
    // MARK: - Properties
    let text: String
    let timestamp: Date
    var recordID: CKRecord.ID
    weak var post: Post?
    
    var postReference: CKRecord.Reference? {
        guard let post = post else { return nil }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    // MARK: - Initializers
    init(text: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.post = post
    }
    
    convenience init?(record: CKRecord, post: Post) {
        guard let text = record[CommentKeys.textKey] as? String,
            let timestamp = record[CommentKeys.timestampKey] as? Date else { return nil }
        
        self.init(text: text, timestamp: timestamp, recordID: record.recordID, post: post)
    }
    
}

extension Comment: SearchableRecord {
    func matchesSearchTerm(searchTerm: String) -> Bool {
        if self.text.contains(searchTerm) {
            return true
        } else {
            return false
        }
    }
}

extension CKRecord {
    convenience init(comment: Comment) {
        self.init(recordType: CommentKeys.commentTypeKey, recordID: comment.recordID)
        
        self.setValue(comment.text, forKey: CommentKeys.textKey)
        self.setValue(comment.timestamp, forKey: CommentKeys.timestampKey)
        self.setValue(comment.postReference, forKey: CommentKeys.postReferenceKey)
    }
    
}
