//
//  Store+Extensions.swift
//  POC
//
//  Created by Chris Nevin on 09/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import World

typealias AppStore = WorldStore<AppState, AppAction>

func makeStore() -> AppStore {
    guard let _ = NSClassFromString("XCTest") else {
        return realWorldStore
    }
    return automationWorldStore
}

extension Store {
    func subscribe<T>(_ screen: Screen, to keyPath: KeyPath<S, T>, callback: @escaping (T) -> Void) {
        disposal(for: screen)().add(observe().map(keyPath).subscribe(onNext: callback))
    }
}

extension Store {
    func timed(interval: TimeInterval = 5, closure: @escaping () -> AppAction) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            store.dispatch(closure())
        }
    }
}
