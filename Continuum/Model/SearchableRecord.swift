//
//  SearchableRecord.swift
//  Continuum
//
//  Created by XMS_JZhan on 2/26/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matchesSearchTerm(searchTerm: String) -> Bool
}
