//
//  ViewController.swift
//  Bundle Example
//
//  Created by Mikhail Rakhmalevich on 29.03.2021.
//

import UIKit
import AVFoundation
import Bundle_Example_Framework

class ViewController: UIViewController {
    
    var player: AVPlayer?

    @IBAction func playPiano(_ sender: Any) {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "piano.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        play(url: url)
    }
    
    @IBAction func playOrgan(_ sender: Any) {
        let bundle = Bundle(for: BundleFrameworkClass.self)
        let path = bundle.path(forResource: "organ.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        play(url: url)
    }
    
    @IBAction func copyPianoToDocuments(_ sender: Any) {
        let bundle = Bundle.main
        let path = bundle.path(forResource: "piano.mp3", ofType: nil)!
        let pianoUrl = URL(fileURLWithPath: path)
        
        let documentsDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let pianoDocumentsPath = documentsDirectory.appendingPathComponent("piano.mp3")
        if !FileManager.default.fileExists(atPath: pianoDocumentsPath.path) {
            try? FileManager.default.copyItem(at: pianoUrl, to: pianoDocumentsPath)
        } else {
            print("File already exists")
        }
        
        let documentsContent = try? FileManager.default.contentsOfDirectory(atPath: documentsDirectory.path)
        documentsContent?.forEach { item in
            let itemFullPath = documentsDirectory.appendingPathComponent(item)
            print(itemFullPath)
        }
    }
    
    private func play(url: URL) {
        if let player = player {
            player.pause()
        }
        player = AVPlayer(url: url)
        player!.play()
    }
}

