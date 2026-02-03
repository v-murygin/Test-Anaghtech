//
//  BadgeModifier.swift
//  TestAnaghtech
//
//  Created by Vladislav Murygin on 1/30/26.
//

import SwiftUI

struct BadgeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.purple.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .foregroundStyle(.purple)
    }
}
