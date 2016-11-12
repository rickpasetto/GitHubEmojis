//
//  synchronize.swift
//  GitHubEmojis
//
//  Created by Rick Pasetto on 11/11/16.
//  Copyright © 2016 Rick Pasetto. All rights reserved.
//

import Foundation

/// Helper function to make synchronize look more like @synchronize
func synchronize(_ lock: Any, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
