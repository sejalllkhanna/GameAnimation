//
//  CircularProgressBarView.swift
//  Reimbursement Game
//
//  Created by Apple on 22/10/21.
//

import UIKit

class CircularProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createCircularPath()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
        
    }
    
    func createCircularPath() {
        
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0), radius: frame.width/2.0, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 8
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor =  UIColor.blue.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    func progressAnimation(duration: TimeInterval, completion:@escaping(()->Void)) {
        CATransaction.begin()
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock{
               completion()
               print("again...")
           }
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}
