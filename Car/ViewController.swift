//
//  ViewController.swift
//  Car
//
//  Created by Konstantyn Koroban on 21/07/2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var dividingStripView = makeDividingStrip()
    private lazy var carImageView = makeCarView()
    private lazy var sheepImageView = makeSheepView()
    
    private lazy var timer = Timer.scheduledTimer(
        timeInterval: 1,
        target: self,
        selector: #selector(handleTimer),
        userInfo: nil,
        repeats: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        view.addSubview(dividingStripView)
        view.addSubview(carImageView)
        
        moveCarToLeft()
        moveCarToRight()
        
        makeLinesSidesView(with: CGPoint(x: 0, y: 0))
        makeLinesSidesView(with: CGPoint(x: view.frame.maxX - 8, y: 0))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animatedDividingStrip(for: dividingStripView)
        setSheepPositionInView(view: carImageView, x: dividingStripView.center.x, y: view.frame.height - carImageView.frame.height - 15)
        timer.tolerance = 0.1
        timer.fire()
    }
    
    private func makeDividingStrip() -> UIView {
        let dividingStrip = UIView()
        dividingStrip.frame.size = CGSize(width: view.frame.width / 40,
                                     height: view.frame.height / 5)
        dividingStrip.frame.origin = CGPoint(
            x: view.frame.maxX / 2 - dividingStrip.frame.width / 2,
            y: 0 - dividingStrip.frame.height)
        dividingStrip.backgroundColor = .white
        return dividingStrip
    }
    
    private func makeLinesSidesView(with point: CGPoint) {
        let linesSidesView = UIView()
        linesSidesView.frame.size = CGSize(width: view.frame.origin.x + 7,
                                     height: view.frame.height)
        linesSidesView.frame.origin = point
        linesSidesView.backgroundColor = .systemGreen
        view.addSubview(linesSidesView)
    }
    
    private func animatedDividingStrip(for view: UIView) {
        UIView.animate(
            withDuration: 1,
            delay: 0,
            options: [.repeat, .curveLinear] ,
            animations: {
                view.frame.origin = CGPoint(
                    x: self.view.frame.maxX / 2 - self.dividingStripView.frame.width / 2,
                    y: self.view.frame.height)},
            completion: nil
        )
    }
    
    private func makeCarView() -> UIView {
        let carView = UIImageView(image: UIImage(named: "1"))
        carView.frame.size = CGSize(width: 120, height: 120)
        carView.center = CGPoint(x: view.frame.width / 2 , y: view.frame.height - carView.frame.height)
        view.addSubview(carView)
        return carView
    }
    
    private func makeSheepView() -> UIView {
        let sheepView = UIImageView(image: UIImage(named: "5"))
        sheepView.frame.size = CGSize(width: makeRandomSizeSheep(), height: makeRandomSizeSheep())
        return sheepView
    }
    
    private func moveCarToLeft(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    private func moveCarToRight(){
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    
    private func makeRandomPositionSheep(positionX: CGFloat, positionY: CGFloat) -> CGPoint {CGPoint(x: .random(in: 0...view.frame.width - positionX), y: 0 - positionY)
    }
    
    private func makeRandomSizeSheep() -> CGFloat {
        CGFloat.random(in: 50...100)
    }
    
    private func setSheepPositionInView(view: UIView, x: CGFloat, y: CGFloat) {
        view.frame.origin = CGPoint(x: x, y: y)
    }
    
    private func moveCarImageView(for direction: Direction) {
        let carPosition = carImageView.frame.origin
        UIView .animate(
            withDuration: 0.2,
            delay: 0,
            options: [.curveLinear],
            animations: {
                switch direction {
                case .left:
                    self.carImageView.frame.origin = CGPoint(x: carPosition.x - 50, y: carPosition.y)
                    if self.carImageView.frame.origin.x < self.view.frame.origin.x {
                        self.carImageView.frame.origin = CGPoint(x: self.view.frame.origin.x, y: carPosition.y)
                    }
                case .right:
                    self.carImageView.frame.origin = CGPoint(x: carPosition.x + 50, y: carPosition.y)
                    if self.carImageView.frame.origin.x > self.view.frame.maxX - self.carImageView.frame.width{
                        self.carImageView.frame.origin = CGPoint(x: self.view.frame.maxX - self.carImageView.frame.width, y: carPosition.y)
                    }
                }
            },
            completion: nil)
    }
    
    @objc
    private func handleTimer (_ sender: Timer) {
        let sheepView = makeSheepView()
        let randomPositionSheep = makeRandomPositionSheep(positionX: sheepView.frame.width, positionY: sheepView.frame.height)
        setSheepPositionInView(view: sheepView, x: randomPositionSheep.x, y: randomPositionSheep.y)
        
        view.addSubview(sheepView)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
            sheepView.frame.origin.y = self.view.frame.height + sheepView.frame.height },
                       completion: {_ in sheepView.removeFromSuperview()})
    }
    
    @objc
    private func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            moveCarImageView(for: .left)
        case .right:
            moveCarImageView(for: .right)
        default:
            break
        }
    }
}

