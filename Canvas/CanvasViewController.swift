//
//  CanvasViewController.swift
//  Canvas
//
//  Created by AUNG PHYO on 10/22/18.
//  Copyright © 2018 AUNG PHYO. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    
    //create trayView outlet
    @IBOutlet weak var trayView: UIView!
    //create property for tray original positon
    var trayOriginalCenter: CGPoint!
    var trayDownOffSet: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trayDownOffSet = 250
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x, y: trayView.center.y + trayDownOffSet)
        remove(targetView: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let tray = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
    
        if(sender.state == .began){
            print("begin")
            trayOriginalCenter = trayView.center
        }else if(sender.state == .changed){
            print("change")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + tray.y)
        }else if(sender.state == .ended){
            print("end")
            if(velocity.y > 0){
                UIView.animate(withDuration: 0.3){
                    self.trayView.center = self.trayDown
                }
            }else{
                UIView.animate(withDuration: 0.3){
                    self.trayView.center = self.trayUp
                }
            }
        }
        
    }
    
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let face = sender.translation(in: view)
        
        if(sender.state == .began){
            print("face begin")
            
            var imageView = sender.view as! UIImageView
            self.newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(self.newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true
            moveFaceRecognizer(target: newlyCreatedFace)
        }else if(sender.state == .changed){
            print("face changed")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + face.x, y: newlyCreatedFaceOriginalCenter.y + face.y)
        }else if(sender.state == .ended){
            print("face end")
            
        }
    }
    
    @objc func didCanvas(sender: UIPanGestureRecognizer){
        
        let canvas = sender.translation(in: view)
        
        if(sender.state == .began){
            print("canvas began")
            
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            //change size when move
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }else if(sender.state == .changed){
            print("canvas changed")
            
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + canvas.x, y: newlyCreatedFaceOriginalCenter.y + canvas.y)
        }else if(sender.state == .ended){
            print("canvas ended")
            //change size back when drop
            newlyCreatedFace.transform = view.transform.scaledBy(x: 1.0, y: 1.0)
        }
    }
   
    func moveFaceRecognizer(target: UIImageView){
         let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didCanvas(sender: )))
         target.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func didTap(sender: UITapGestureRecognizer) {
        newlyCreatedFace.removeFromSuperview()
    }
    
    func remove(targetView: UIView){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        
        tapGestureRecognizer.numberOfTapsRequired = 2
        
        targetView.addGestureRecognizer(tapGestureRecognizer)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
