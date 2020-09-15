//
//  ViewController.swift
//  vlckitSwiftSample
//
//  Created by Mark Knapp on 11/18/15.
//  Copyright © 2015 Mark Knapp. All rights reserved.
//

import UIKit

@objc protocol VLCRendererDiscovererManagerDelegate {
    @objc optional func removedCurrentRendererItem(_ item: VLCRendererItem)
    @objc optional func addedRendererItem()
    @objc optional func removedRendererItem()
}

class ViewController: UIViewController, VLCMediaPlayerDelegate, VLCRendererDiscovererManagerDelegate, VLCRendererDiscovererDelegate {

    var movieView: UIView!

    // Enable debugging
    //var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer(options: ["-vvvv"])

    var mediaPlayer: VLCMediaPlayer = VLCMediaPlayer()
    var discoverers: [VLCRendererDiscoverer] = [VLCRendererDiscoverer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        start()
        getAllRenderers()

        //Add rotation observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)

        //Setup movieView
        self.movieView = UIView()
        self.movieView.backgroundColor = UIColor.gray
        self.movieView.frame = UIScreen.screens[0].bounds

        //Add tap gesture to movieView for play/pause
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.movieViewTapped(_:)))
        self.movieView.addGestureRecognizer(gesture)

        //Add movieView to view controller
        self.view.addSubview(self.movieView)
    }

    override func viewDidAppear(_ animated: Bool) {

        //Playing multicast UDP (you can multicast a video from VLC)
        //let url = NSURL(string: "udp://@225.0.0.1:51018")

        //Playing HTTP from internet
        //let url = NSURL(string: "http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4")

        //Playing RTSP from internet
        let url = URL(string: "http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_30fps_normal.mp4")

        if url == nil {
            print("Invalid URL")
            return
        }

        let media = VLCMedia(url: url!)

        // Set media options
        // https://wiki.videolan.org/VLC_command-line_help
        //media.addOptions([
        //    "network-caching": 300
        //])

        mediaPlayer.media = media

        mediaPlayer.delegate = self
        mediaPlayer.drawable = self.movieView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func rotated() {

        let orientation = UIDevice.current.orientation

        if (UIDeviceOrientationIsLandscape(orientation)) {
            print("Switched to landscape")
        }
        else if(UIDeviceOrientationIsPortrait(orientation)) {
            print("Switched to portrait")
        }

        //Always fill entire screen
        self.movieView.frame = self.view.frame

    }

    @objc func movieViewTapped(_ sender: UITapGestureRecognizer) {

        if mediaPlayer.isPlaying {
            mediaPlayer.pause()

            let remaining = mediaPlayer.remainingTime
            let time = mediaPlayer.time

            print("Paused at \(time?.stringValue ?? "nil") with \(remaining?.stringValue ?? "nil") time remaining")
        }
        else {
            mediaPlayer.play()
            print("Playing")
        }
        
    }
    
    func getAllRenderers() -> [VLCRendererItem] {
        return discoverers.flatMap { $0.renderers }
    }
    
   func start() {
        
        /*
        // Gather potential renderer discoverers
        guard let tmpDiscoverersDescription: [VLCRendererDiscovererDescription] = VLCRendererDiscoverer.list() else {
            print("VLCRendererDiscovererManager: Unable to retrieve list of VLCRendererDiscovererDescription")
            return
        }
        for discovererDescription in tmpDiscoverersDescription where !isDuplicateDiscoverer(with: discovererDescription) {
            print(discovererDescription.name)
            guard let rendererDiscoverer = VLCRendererDiscoverer(name: discovererDescription.name) else {
                print("VLCRendererDiscovererManager: Unable to instanciate renderer discoverer with name: \(discovererDescription.name)")
                continue
            }
            guard rendererDiscoverer.start() else {
                print("VLCRendererDiscovererManager: Unable to start renderer discoverer with name: \(rendererDiscoverer.name)")
                continue
            }
            rendererDiscoverer.delegate = self
            discoverers.append(rendererDiscoverer)
        }*/
    
        guard let rendererDiscoverer = VLCRendererDiscoverer(name: "Bonjour_renderer")
        else {
            print("VLCRendererDiscovererManager: Unable to instanciate renderer discoverer with name: Bonjour_renderer")
            return
        }
        guard rendererDiscoverer.start() else {
            print("VLCRendererDiscovererManager: Unable to start renderer discoverer with name: Bonjour_renderer")
            return
        }
        rendererDiscoverer.delegate = self
        discoverers.append(rendererDiscoverer)
    }
    
    func isDuplicateDiscoverer(with description: VLCRendererDiscovererDescription) -> Bool {
        for discoverer in discoverers where discoverer.name == description.name {
            return true
        }
        return false
    }
    
    
    func rendererDiscovererItemDeleted(_ rendererDiscoverer: VLCRendererDiscoverer, item: VLCRendererItem) {
        //for break points
        print(item.name)
        var i = 1
    }
    
    func rendererDiscovererItemAdded(_ rendererDiscoverer: VLCRendererDiscoverer, item: VLCRendererItem) {
        //for break points
        print(item.name)
        var i = 1
        }

      
        
    
   
    




}

