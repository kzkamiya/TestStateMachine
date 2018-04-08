//
//  StateMachine.swift
//  TestStateMachine
//
//  Created by me on 2018/04/08.
//  Copyright © 2018年 me. All rights reserved.
//

import Foundation

class StateMachine<State, Event> {
    init(_ initial: State, routing:@escaping (State, Event) -> State?) {
        self.current = initial
        self.routing = routing
    }
    
    private(set) var current: State
    var delegate: StateMachineDelegate?
    
    private let routing: (State, Event) -> State?
    
    func transition(_ by: Event) {
        guard let next = routing(current, by) else {
            return
        }
        
        // Debug log.
        Logger.debug("transition. current = \(current). next = \(next) ")
        
        delegate?.stateMachine(self, notified: .willExit(current))
        current = next
        delegate?.stateMachine(self, notified: .didEnter(next))
    }
    
    func showDebugCurrentState() {
        // Debug log.
        Logger.debug("current state = \(current).")
    }
}

protocol StateMachineDelegate {
    func stateMachine<State, Event>(_ stateMachine: StateMachine<State, Event>, notified change: StateChange<State>)
}

enum StateChange<T> {
    case didEnter(T)
    case willExit(T)
}
