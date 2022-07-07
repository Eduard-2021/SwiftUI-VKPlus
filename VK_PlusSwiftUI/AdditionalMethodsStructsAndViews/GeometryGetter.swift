//
//  GeometryGetter.swift
//  VK_PlusSwiftUI
//
//  Created by Eduard on 02.10.2021.
//

import SwiftUI

struct GeometryGetter: View {
    var completion: (CGRect) -> Void
    
    var body: some View {
        return GeometryReader { geometry in
            self.makeView(geometry: geometry, completion: completion)
        }
    }
    
    func makeView(geometry: GeometryProxy, completion: @escaping (CGRect) -> Void) -> some View {
        DispatchQueue.main.async {
            completion(geometry.frame(in: .global))
        }

        return Rectangle().fill(Color.clear)
    }
}
