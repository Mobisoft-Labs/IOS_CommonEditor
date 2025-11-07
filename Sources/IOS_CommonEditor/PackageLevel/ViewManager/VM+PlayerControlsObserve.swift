//
//  VM+PlayerControlsObserve.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 23/01/25.
//

extension ViewManager {
    public func observePlayerControls() {
        
        guard let templateHandler = self.templateHandler else {
            logger.printLog("template handler nil")
            return }
        
        playerControlsCancellables.removeAll()
        logger.logVerbose("VM + PlayerControls listeners ON \(playerControlsCancellables.count)")
        
        
        templateHandler.playerControls?.$renderState.dropFirst().sink { [weak self] renderState in
            guard let self = self else { return }
            guard let currentActiveView = currentActiveView else { return }
            
            currentActiveView.enableStealthMode =  renderState == .Playing
            refreshControlBar = true 

        }.store(in: &playerControlsCancellables)
        
        
        templateHandler.playerControls?.$currentTime.dropFirst().sink {[weak self] currentTime in
            self?.refresh(currentTime: currentTime)
            
        }.store(in: &playerControlsCancellables)
        
    }
}
