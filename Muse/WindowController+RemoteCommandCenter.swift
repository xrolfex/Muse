//
//  WindowController+RemoteCommandCenter.swift
//  Muse
//
//  Created by Marco Albera on 04/12/16.
//  Copyright © 2016 Edge Apps. All rights reserved.
//

import Foundation
import MediaPlayer

@available(OSX 10.12.1, *)
extension WindowController {
    
    func togglePlayPause(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        spotifyHelper.togglePlayPause()
        
        updateNowPlayingInfo()
        
        return .success
    }
    
    func changePlaybackPosition(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        self.song.playbackPosition = Float(event.positionTime.rounded())
        spotifyHelper.goTo(time: self.song.playbackPosition)
        
        updateNowPlayingInfo()
        
        return .success
    }
    
    func previousTrack(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        self.song.playbackPosition = 0
        spotifyHelper.previousTrack()
        
        updateNowPlayingInfo()
        
        return .success
    }
    
    func nextTrack(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        self.song.playbackPosition = 0
        spotifyHelper.nextTrack()
        
        updateNowPlayingInfo()
        
        return .success
    }
    
    func updateNowPlayingInfo() {
        // MediaPlayer nowPlayingInfo
        nowPlayingInfoCenter.nowPlayingInfo = [
            MPMediaItemPropertyTitle: self.song.name,
            MPMediaItemPropertyArtist: self.song.artist,
            MPMediaItemPropertyAlbumTitle: self.song.album,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: self.song.playbackPosition,
            MPMediaItemPropertyPlaybackDuration: self.song.duration,
            MPNowPlayingInfoPropertyMediaType: MPNowPlayingInfoMediaType.audio.rawValue
        ]
        
        // Update playbackState accordingly
        nowPlayingInfoCenter.playbackState = self.song.isPlaying ? .playing : .paused
    }
    
    func prepareRemoteCommandCenter() {
        // Play/pause toggle
        remoteCommandCenter.playCommand.isEnabled = true
        remoteCommandCenter.playCommand.addTarget(self, action: #selector(togglePlayPause(event:)))
        remoteCommandCenter.pauseCommand.isEnabled = true
        remoteCommandCenter.pauseCommand.addTarget(self, action: #selector(togglePlayPause(event:)))
        
        // Previous/next track toggle
        // Apparently these work only on 10.12.2+
        remoteCommandCenter.previousTrackCommand.isEnabled = true
        remoteCommandCenter.previousTrackCommand.addTarget(self, action: #selector(previousTrack(event:)))
        remoteCommandCenter.nextTrackCommand.isEnabled = true
        remoteCommandCenter.nextTrackCommand.addTarget(self, action: #selector(nextTrack(event:)))
        
        // Scrub bar control
        remoteCommandCenter.changePlaybackPositionCommand.isEnabled = true
        remoteCommandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPosition(event:)))
    }
    
}