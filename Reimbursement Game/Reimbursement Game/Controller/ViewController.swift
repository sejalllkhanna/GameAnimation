//
//  ViewController.swift
//  Reimbursement Game
//
//  Created by Apple on 22/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var CavityPlane: UIImageView!
    @IBOutlet weak var circularProgressBarView: CircularProgressBarView!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var ScoreView: UIView!
    @IBOutlet weak var ParentView: UIView!
    @IBOutlet weak var MovingViewThree: UIImageView!
    @IBOutlet weak var MovingViewTwo: UIImageView!
    @IBOutlet weak var MovingViewOne: UIImageView!
    @IBOutlet weak var BackgroundView: UIView!
    
    var ScoreArray = [ScoreUpdation]()
    
    var ViewsArray = [UIView]()
    var increment = 0
    var tapBool = false
    var isFinished = false
    
    var animator = UIViewPropertyAnimator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ScoreArray = [ ScoreUpdation(id: 1,views: MovingViewOne,scoringIncrement: 0),
                       ScoreUpdation(id: 1,views: MovingViewTwo,scoringIncrement: 1),
                       ScoreUpdation(id: 1,views: MovingViewThree,scoringIncrement: 0)]
        
        ViewsArray = [self.MovingViewOne,self.MovingViewTwo,self.MovingViewThree]
        
        circularProgressBarView.layer.cornerRadius = circularProgressBarView.frame.width/2
        ParentView.layer.cornerRadius = ParentView.frame.width/2
        BackgroundView.center.x = BackgroundView.center.x/2 + 50
    
        SetPositionForViews(ImageView: MovingViewOne)
        SetPositionForViews(ImageView: MovingViewTwo)
        SetPositionForViews(ImageView: MovingViewThree)
        
        ViewMovementAnimation()
        ScoreView.isHidden = true
        circularProgressBarView.progressAnimation(duration: 30) { [self] in
            isFinished = true
            self.animator.stopAnimation(false)
            self.animator.finishAnimation(at: .start)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        circularProgressBarView.addGestureRecognizer(tap)
        circularProgressBarView.isUserInteractionEnabled = true
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    
    func SetPositionForViews(ImageView:UIView){
        ImageView.frame = CGRect(x: 0, y: 0, width: CavityPlane.frame.width, height: CavityPlane.frame.height )
        ImageView.frame.origin.x = circularProgressBarView.frame.origin.x+circularProgressBarView.frame.width
        ImageView.frame.origin.y = (circularProgressBarView.frame.origin.y+(circularProgressBarView.frame.width/2)) - MovingViewTwo.frame.height/2
    }
    
    func ViewMovementAnimation(){
        if isFinished{
            return
        }
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: { [self] in
            
            self.ViewsArray[increment].frame.origin.x = circularProgressBarView.frame.origin.x + circularProgressBarView.frame.width
            self.ViewsArray[increment].frame.origin.y = (circularProgressBarView.frame.origin.y + (circularProgressBarView.frame.height/2)) - self.ViewsArray[increment].frame.height/2
            
            self.ViewsArray[self.increment].transform = CGAffineTransform(translationX: -400, y: 0)
            
        })
        
        animator.startAnimation()
        let completion: (UIViewAnimatingPosition) -> () = { [self]position in
            self.ViewsArray[increment].transform = CGAffineTransform.identity
            
            self.ViewsArray[increment].frame.origin.x = circularProgressBarView.frame.origin.x + circularProgressBarView.frame.width
            self.ViewsArray[increment].frame.origin.y = (circularProgressBarView.frame.origin.y + (circularProgressBarView.frame.height/2)) - self.ViewsArray[increment].frame.height/2
            
            if increment == ViewsArray.count-1{
                increment = 0
            }else{
                increment = increment+1
            }
            ViewMovementAnimation()
            tapBool = false
            
        }
        animator.addCompletion(completion)
        
    }
    
    func ScoreAnimation(){
        ScoreView.isHidden = false
        UIView.animate(withDuration: 1) {
            self.ScoreView.transform = CGAffineTransform(translationX: 0, y: -270)
            self.ScoreView.backgroundColor = .clear
        }completion: { [self] _ in
            self.ScoreView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.tapBool = false
            ScoreView.isHidden = true
        }
    }
    
    func OverlapFraction(fractionCompleted: Double) -> Int {
        
        var portionOverLapPercentage = 0.0
        let planeCavity = CavityPlane.frame.width
        let totalDistanceTravelled = CavityPlane.frame.width + ParentView.frame.width
        
        if fractionCompleted <= 0.16667{
            portionOverLapPercentage = 0
        }
        
        else if fractionCompleted <= 0.5 && fractionCompleted > 0.1667 {
            let value = fractionCompleted - 0.1667
            let portion = value * totalDistanceTravelled
            portionOverLapPercentage = portion/planeCavity
        }
        
        else if fractionCompleted > 0.5 && fractionCompleted <= 0.8333 {
            let value = fractionCompleted - 0.5
            let portion = abs(value * totalDistanceTravelled - planeCavity)
            portionOverLapPercentage = portion/planeCavity
        }
        
        else {
            portionOverLapPercentage = 0
        }
        
        let percentage =  round(Double(portionOverLapPercentage*100))
        return Int(percentage)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if tapBool == false{
            
            animator.pauseAnimation()
            if  ScoreArray[increment].scoringIncrement > 0 {
                ScoreLabel.text = "Score: \(String(OverlapFraction(fractionCompleted: animator.fractionComplete) * ScoreArray[increment].scoringIncrement))"
                ScoreAnimation()
                tapBool = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.animator.startAnimation()
            }
            
        }
    }
}


