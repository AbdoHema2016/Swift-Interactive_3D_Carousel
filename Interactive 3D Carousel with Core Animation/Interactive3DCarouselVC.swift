//
//  ViewController.swift
//  Interactive 3D Carousel with Core Animation
//
//  Created by Abdelrhman on 6/19/19.
//  Copyright © 2019 Abdelrhman. All rights reserved.
//

import UIKit
func degreeToRadians (deg:CGFloat)->CGFloat{
    return (deg * CGFloat.pi)/180
}
class Interactive3DCarouselVC: UIViewController {
    
    
    var currentAngle: CGFloat = 0
    var currentOffset: CGFloat = 0
    let transformLayer = CATransformLayer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transformLayer.frame = self.view.bounds
        view.layer.addSublayer(transformLayer)
        for i in 1 ... 5 {
            addImageCard(name: "\(i).jpg")
        }
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,action:
            #selector(Interactive3DCarouselVC.performPanAction(recognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        turnCarosel()
    }
    
    func addImageCard(name:String){
        let imageCardSize = CGSize(width:200,height:300)
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: view.frame.size.width / 2 - imageCardSize.width / 2 , y: view.frame.size.height / 2 - imageCardSize.height / 2, width: imageCardSize.width, height: imageCardSize.height)
        imageLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        guard let imageCardImage = UIImage(named: name)?.cgImage else {return}
        imageLayer.contents = imageCardImage
        imageLayer.contentsGravity = "resizeAspectFill"
        imageLayer.borderColor = UIColor.lightGray.cgColor
        imageLayer.borderWidth = 3.0
        imageLayer.cornerRadius = 8
        imageLayer.masksToBounds = true
        imageLayer.isDoubleSided = true
        transformLayer.addSublayer(imageLayer)
        
    }
    func turnCarosel() {
        
        guard let transformSubLayers = transformLayer.sublayers else { return }
        
        let segmentForImageCard = CGFloat(360 / transformSubLayers.count)
        var angleOffset = currentAngle
        
        transformSubLayers.forEach { (layer) in
            
            var transform = CATransform3DIdentity
            transform.m34 = -1 / 500
            transform = CATransform3DRotate(transform, degreeToRadians(deg: angleOffset), 0, 1, 0)
            transform = CATransform3DTranslate(transform, 0, 0, 200)
            
            CATransaction.setAnimationDuration(0)
            
            layer.transform = transform
            
            angleOffset += segmentForImageCard
        }
    }
    
    @objc
    func performPanAction (recognizer:UIPanGestureRecognizer){
        
        let xOffset = recognizer.translation(in: view).x
        
        if recognizer.state == .began {
            currentOffset = 0
        }
        
        let xDifference = xOffset * 0.6 - currentOffset
        currentOffset += xDifference
        currentAngle += xDifference
        
        turnCarosel()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

