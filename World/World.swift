//
//  World.swift
//  Core
//
//  Created by Chris Nevin on 08/03/2019.
//  Copyright © 2019 Chris Nevin. All rights reserved.
//

import Foundation
import Core

public struct World {
    public let analytics: AnalyticsTracker
    public let database: Database
    public let download: Downloader
    public let disk: Disk
    public let executor: RequestExecutor
    public let navigate: Navigator
    public let sync: Sync

    public init(
        analytics: @escaping AnalyticsTracker,
        database: Database,
        download: @escaping Downloader,
        disk: Disk,
        executor: @escaping RequestExecutor,
        navigate: @escaping Navigator,
        sync: @escaping Sync) {
        self.analytics = analytics
        self.database = database
        self.download = download
        self.disk = disk
        self.executor = executor
        self.navigate = navigate
        self.sync = sync
    }
}

///sourcery:prism=chain
public enum WorldError {
    case database(FileIOError)
    case disk(FileIOError)
    case network(NetworkIOError)
}

public typealias WorldResult<T> = Result<T, WorldError>
public typealias WorldReader<T> = Reader<World, T>
public typealias WorldInterpreter<T> = Interpreter<World, T>
public typealias WorldInterpreterRecorder<T> = InterpreterRecorder<World, T>
public typealias WorldReducer<S, A> = Reducer<S, A, World>
public typealias WorldStore<S, A> = Store<S, A, World>
public typealias WorldSignal<T> = Signal<T, WorldError>

public func worldInterpreter<A>(world: World) -> WorldInterpreter<A> {
    return { method, dispatch -> Void in
        func void(_ effect: Effect<WorldReader<Void>>) {
            switch effect {
            case .background(let background):
                world.sync {
                    background.apply(world)
                }
            case .main(let main):
                main.apply(world)
            case .sequence(let sequence):
                sequence.forEach(void)
            }
        }

        func action(_ effect: Effect<WorldReader<A>>) {
            switch effect {
            case .background(let background):
                world.sync {
                    dispatch(background.apply(world))
                }
            case .main(let main):
                dispatch(main.apply(world))
            case .sequence(let sequence):
                sequence.forEach(action)
            }
        }

        func actions(_ effect: Effect<WorldReader<ErrorlessSignal<A>>>, disposedBy: CompositeDisposable) {
            switch effect {
            case .background(let background):
                world.sync {
                    disposedBy.add(background.apply(world).subscribe(onNext: dispatch))
                }
            case .main(let main):
                disposedBy.add(main.apply(world).subscribe(onNext: dispatch))
            case .sequence(let sequence):
                sequence.forEach { actions($0, disposedBy: disposedBy) }
            }
        }

        func handle(method: DispatchMethod<World, A>) {
            switch method {
            case .sequence(let methods): methods.forEach(handle)
            case .void(let effect): void(effect)
            case .action(let effect): action(effect)
            case .actions(let effect, let disposable): actions(effect, disposedBy: disposable)
            }
        }
        handle(method: method)
    }
}

public func >>>= <A, B>(a: WorldReader<WorldResult<A>>, f: @escaping (A) -> WorldReader<WorldResult<B>>) -> WorldReader<WorldResult<B>> {
    return a.flatMap { result -> WorldReader<WorldResult<B>> in
        switch result {
        case .success(let value): return f(value)
        case .failure(let error): return .pure(.failure(error))
        }
    }
}

