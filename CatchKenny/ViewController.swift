//
//  ViewController.swift
//  CatchKenny
//
//  Created by Mert Can on 6.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var score = 0
    var timer = Timer()
    var curpos = Timer()
    var counter = 0
    var kenny = UIImageView()
    var highscore = 0

    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check
        scoreLabel.text = "Score: \(score)"
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
        
        if storedHighScore == nil {
            highscore = 0
            highScoreLabel.text = "Highscore: \(highscore)"
        }
        if let newScore = storedHighScore as? Int {
            highscore = newScore
            highScoreLabel.text = "Highscore: \(highscore)"
        }
        counter = 10
        timeRemainingLabel.text = "\(counter)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        curpos = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(kennyposition), userInfo: nil, repeats: true)
        
        
        kenny.image = UIImage(named: "kenny")
        
        kenny.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        
        kenny.addGestureRecognizer(recognizer)
        
    }

    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    @objc func countdown() {
        counter -= 1
        timeRemainingLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            
            if self.score > self.highscore {
                self.highscore = self.score
                highScoreLabel.text = "Highscore: \(self.highscore)"
                UserDefaults.standard.set(self.highscore, forKey: "highscore")
            }
            
            let alert = UIAlertController(title: "Time's Up!", message: "Go for another one?", preferredStyle: UIAlertController.Style.alert)
            
            let okButton = UIAlertAction(title: "I'm done!", style: UIAlertAction.Style.default, handler: nil)
            
            let replayButton = UIAlertAction(title: "AGAIN!", style: UIAlertAction.Style.default) { UIAlertAction in
                
                self.kenny.isHidden = false
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeRemainingLabel.text = String(self.counter)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countdown), userInfo: nil, repeats: true)
                
                self.curpos = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.kennyposition), userInfo: nil, repeats: true)
                
                
            }
            
            alert.addAction(okButton)
            alert.addAction(replayButton)
            
            self.present(alert, animated: true, completion: nil)
            }
        }
    @objc func kennyposition(){
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let x: CGFloat = .random(in: 0...width-150)
        let y: CGFloat = .random(in: 120...height-250)
        
        let rect = CGRect(x: x, y: y, width: 80, height: 120)
        
        kenny.frame = rect
        self.view.addSubview(kenny)
        
        if counter == 0 {
            curpos.invalidate()
            kenny.isHidden = true
        }
        
    }
}


