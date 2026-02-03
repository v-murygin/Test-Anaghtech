//
//  File.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import SwiftUI

extension View {
    func asBadge() -> some View {
        self.modifier(BadgeModifier())
    }
}
