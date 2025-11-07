//
//  PageScroller.swift
//  VideoInvitation
//
//  Created by IRIS STUDIO IOS on 27/01/25.
//

import UIKit
import SwiftUI


protocol PageScrollerInterface {
    
    var pagerHostingerViewController : UIHostingController<PagerControllerView>? { get set }
    
    func addPageScrollerView(parentView:UIView,actionStates: ActionStates)
    func removePageScrollerView()
   
    
}



class PageScrollerHandler : PageScrollerInterface {
    
    
    var pagerHostingerViewController: UIHostingController<PagerControllerView>?

    
    func addPageScrollerView(parentView: UIView, actionStates: ActionStates) {

       pagerHostingerViewController?.removeFromParent()

       pagerHostingerViewController = UIHostingController(rootView: PagerControllerView(currentActionState: actionStates))
       pagerHostingerViewController?.view.frame = parentView.bounds
       pagerHostingerViewController?.view.backgroundColor = .clear
       parentView.addSubview(pagerHostingerViewController!.view)
   }
   
   func removePageScrollerView(){
       pagerHostingerViewController?.removeFromParent()
   }

    
     
}
