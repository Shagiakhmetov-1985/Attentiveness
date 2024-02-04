//
//  Images.swift
//  Attentiveness
//
//  Created by Marat Shagiakhmetov on 02.02.2024.
//

import Foundation

class Images {
    static func getDevices(count: Count) -> ([String], [String]) {
        var images: [String] = []
        for image in Devices.allCases.shuffled() {
            images.append(image.rawValue)
            if images.count == count.rawValue {
                break
            }
        }
        return (images, images)
    }
    
    static func getNature(count: Count) -> ([String], [String]) {
        var images: [String] = []
        for image in Nature.allCases.shuffled() {
            images.append(image.rawValue)
            if images.count == count.rawValue {
                break
            }
        }
        return (images, images)
    }
    
    static func getSport(count: Count) -> ([String], [String]) {
        var images: [String] = []
        for image in Sport.allCases.shuffled() {
            images.append(image.rawValue)
            if images.count == count.rawValue {
                break
            }
        }
        return (images, images)
    }
}

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
    case magicmouse
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
    case applewatch
    case earbuds
    case airpods
    case homepodmini
    case hifispeaker
    case appletv
    case mediastick
    case tv
    case car
    case gamecontroller
    case avremote = "av.remote"
}

enum Nature: String, CaseIterable {
    case sun = "sun.max"
    case sunrise
    case sunset
    case sundust = "sun.dust"
    case sunhaze = "sun.haze"
    case moon
    case cloud
    case clouddrizzle = "cloud.drizzle"
    case cloudrain = "cloud.rain"
    case cloudheavyrain = "cloud.heavyrain"
    case cloudfog = "cloud.fog"
    case cloudhail = "cloud.hail"
    case cloudsnow = "cloud.snow"
    case cloudsleet = "cloud.sleet"
    case cloudbolt = "cloud.bolt"
    case cloudboltrain = "cloud.bolt.rain"
    case cloudsun = "cloud.sun"
    case cloudsunrain = "cloud.sun.rain"
    case wind
    case snowflake
    case tornado
    case rainbow
    case waterwaves = "water.waves"
    case flame
    case bolt
    case mountain2 = "mountain.2"
    case leaf
    case laurelleading = "laurel.leading"
    case tree
    case carrot
    case atom
    case fossilshell = "fossil.shell"
    case fish
    case ant
    case ladybug
    case humidity
}

enum Sport: String, CaseIterable {
    case figurewalk = "figure.walk"
    case figurerun = "figure.run"
    case figureroll = "figure.roll"
    case figurearchery = "figure.archery"
    case figurebadminton = "figure.badminton"
    case figurebarre = "figure.barre"
    case figurebaseball = "figure.baseball"
    case figurebasketball = "figure.basketball"
    case figurebowling = "figure.bowling"
    case figureboxing = "figure.boxing"
    case figureclimbing = "figure.climbing"
    case figurecooldown = "figure.cooldown"
    case figurecricket = "figure.cricket"
    case figurecurling = "figure.curling"
    case figuredance = "figure.dance"
    case figurediscsports = "figure.disc.sports"
    case figureelliptical = "figure.elliptical"
    case figurefencing = "figure.fencing"
    case figurefishing = "figure.fishing"
    case figureflexibility = "figure.flexibility"
    case figuregolf = "figure.golf"
    case figuregymnastics = "figure.gymnastics"
    case figurehandball = "figure.handball"
    case figurehiking = "figure.hiking"
    case figurehockey = "figure.hockey"
    case figurehunting = "figure.hunting"
    case figurejumprope = "figure.jumprope"
    case figurekickboxing = "figure.kickboxing"
    case figurelacrosse = "figure.lacrosse"
    case figurepilates = "figure.pilates"
    case figureplay = "figure.play"
    case figurepoolswim = "figure.pool.swim"
    case figureracquetball = "figure.racquetball"
    case figurerolling = "figure.rolling"
    case figurerugby = "figure.rugby"
    case figuresoccer = "figure.soccer"
}
