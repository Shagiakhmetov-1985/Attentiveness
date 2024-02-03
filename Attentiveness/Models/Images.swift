//
//  Images.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import Foundation

enum Devices: String, CaseIterable {
    case keyboard
    case printer
    case scanner
    case faxmachine
    case display
    case macbook
    case ipod
    case flipphone
    case iphone
    case iphonegen1 = "iphone.gen1"
    case ipad
    case ipadgen1 = "ipad.gen1"
    case visionpro
    case computermouse
    case display2 = "display.2"
    case pc
    case macprogen1 = "macpro.gen1"
    case macprogen2 = "macpro.gen2"
    case macprogen3 = "macpro.gen3"
    case macprogen3server = "macpro.gen3.server"
    case serverrack = "server.rack"
    case candybarphone
    case applepencil
    case headphones
}

class Images {
    static func getDevices() -> ([String], [String]) {
        var images: [String] = []
        for image in Devices.allCases.shuffled() {
            images.append(image.rawValue)
        }
        return (images, images)
    }
}
