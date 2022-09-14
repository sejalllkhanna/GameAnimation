////
////  BackgroundCurveView.swift
////  Reimbursement Game
////
////  Created by Apple on 11/11/21.
////
//
//import UIKit
//
//class BackgroundView: UIView {
//
//    var semiCirleLayer: CAShapeLayer = CAShapeLayer()
//
//       override func layoutSubviews() {
//           super.layoutSubviews()
//           let arcCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
//           let circleRadius = bounds.size.width / 2
//           let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: false)
//
//           semiCirleLayer.path = circlePath.cgPath
//           semiCirleLayer.fillColor = UIColor.white.cgColor
//
//           semiCirleLayer.name = "RedCircleLayer"
//           
//           if !(layer.sublayers?.contains(where: {$0.name == "RedCircleLayer"}) ?? false) {
//               layer.addSublayer(semiCirleLayer)
//           }
//           // Make the view color transparent
//           backgroundColor = UIColor.clear
//       }
//
//}
