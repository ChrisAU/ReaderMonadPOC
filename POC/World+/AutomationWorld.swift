//
//  AppWorld.swift
//  POC
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core
import World

let automationWorld = World(
    analytics: { _ in },
    database: RealmDatabase(),
    download: URLSession.shared.download,
    disk: FileManager(),
    executor: URLSession.shared.execute,
    navigate: navigate,
    sync: backgroundSync)

let automationWorldStore = Store(
    reducer: appReducer,
    interpreter: worldInterpreter(world: automationWorld),
    initialState: AppState())
