//
//  WaitAndExecute.swift
//  WaitAndExecute
//
//  Created by 曾文志 on 2021/9/7.
//

import Foundation

func wait(interval: TimeInterval = 1, execute block: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: block)
}
