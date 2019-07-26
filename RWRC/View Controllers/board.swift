//
//  board.swift
//  RWRC
//
//  Created by Krisha Jivani on 5/20/19.
//  Copyright © 2019 Razeware. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class board: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  //Drawing
  private lazy var drawRef: DatabaseReference = Database.database().reference(withPath: "Drawing")
  private var drawRefHandle: DatabaseHandle?
  
  var imagePickerController : UIImagePickerController!
  var imagePicker: UIImagePickerController!
  
  var lastPoint = CGPoint.zero
  var opacity: CGFloat = 1.0
  var swiped = false
  
  var red:CGFloat = 44/255
  var green:CGFloat = 62/255
  var blue:CGFloat = 80/255
  
  var currentColor:NSNumber = 7;
  var imageView = UIImageView()
  var tempImageView = UIImageView()
  
  var timer: Timer?
  
  enum ImageSource {
    case photoLibrary
    case camera
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
    //imgView.image = UIImage(named: "yourimagename")//Assign image to ImageView
    view.addSubview(imageView)//Add image to our view
    
    tempImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
    view.addSubview(tempImageView)//Add image to our view
    
    let button = UIButton(frame: CGRect(x: 10, y: 20, width: 100, height: 50))
    button.backgroundColor = .black
    button.setTitle("Reset", for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    self.view.addSubview(button)
    
    let divider = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 10, y: 0, width: 10, height: UIScreen.main.bounds.height))
    divider.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
    divider.addTarget(self, action: #selector(divideAction), for: .touchUpInside)
    self.view.addSubview(divider)
    
    let camImg = UIImage(named: "cam")
    let myButtonc = UIButton(type: UIButton.ButtonType.custom)
    myButtonc.frame = CGRect.init(x: 400, y: 20, width: 65, height: 50)
    myButtonc.setImage(camImg, for: .normal)
    myButtonc.addTarget(self, action: #selector(camAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButtonc)
    
    let img = UIImage(named: "Red")
    let myButton = UIButton(type: UIButton.ButtonType.custom)
    myButton.frame = CGRect.init(x: 10, y: 650, width: 30, height: 100)
    myButton.setImage(img, for: .normal)
    myButton.addTarget(self, action: #selector(redAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton)
    
    let img2 = UIImage(named: "DarkOrange")
    let myButton2 = UIButton(type: UIButton.ButtonType.custom)
    myButton2.frame = CGRect.init(x: 60, y: 650, width: 30, height: 100)
    myButton2.setImage(img2, for: .normal)
    myButton2.addTarget(self, action: #selector(orangeAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton2)
    
    let img3 = UIImage(named: "Yellow")
    let myButton3 = UIButton(type: UIButton.ButtonType.custom)
    myButton3.frame = CGRect.init(x: 110, y: 650, width: 30, height: 100)
    myButton3.setImage(img3, for: .normal)
    myButton3.addTarget(self, action: #selector(yellowAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton3)
    
    let img4 = UIImage(named: "LightBlue")
    let myButton4 = UIButton(type: UIButton.ButtonType.custom)
    myButton4.frame = CGRect.init(x: 160, y: 650, width: 30, height: 100)
    myButton4.setImage(img4, for: .normal)
    myButton4.addTarget(self, action: #selector(blueAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton4)
    
    let img5 = UIImage(named: "LightGreen")
    let myButton5 = UIButton(type: UIButton.ButtonType.custom)
    myButton5.frame = CGRect.init(x: 210, y: 650, width: 30, height: 100)
    myButton5.setImage(img5, for: .normal)
    myButton5.addTarget(self, action: #selector(greenAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton5)
    
    let img6 = UIImage(named: "Blue")
    let myButton6 = UIButton(type: UIButton.ButtonType.custom)
    myButton6.frame = CGRect.init(x: 260, y: 650, width: 30, height: 100)
    myButton6.setImage(img6, for: .normal)
    myButton6.addTarget(self, action: #selector(purpleAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton6)
    
    let img7 = UIImage(named: "Grey")
    let myButton7 = UIButton(type: UIButton.ButtonType.custom)
    myButton7.frame = CGRect.init(x: 310, y: 650, width: 30, height: 100)
    myButton7.setImage(img7, for: .normal)
    myButton7.addTarget(self, action: #selector(grayAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton7)
    
    let img8 = UIImage(named: "Black")
    let myButton8 = UIButton(type: UIButton.ButtonType.custom)
    myButton8.frame = CGRect.init(x: 360, y: 650, width: 30, height: 100)
    myButton8.setImage(img8, for: .normal)
    myButton8.addTarget(self, action: #selector(blackAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton8)
    
    let img9 = UIImage(named: "Eraser")
    let myButton9 = UIButton(type: UIButton.ButtonType.custom)
    myButton9.frame = CGRect.init(x: 410, y: 650, width: 30, height: 100)
    myButton9.setImage(img9, for: .normal)
    myButton9.addTarget(self, action: #selector(eraseAction), for: UIControl.Event.touchUpInside)
    self.view.addSubview(myButton9)
    
    observeNewPoints()
    observeReset()
    let notificationCenter = NotificationCenter.default
    
    startTimer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    appdelegate.shouldSupportAllOrientation = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    swiped = false
    if let touch = touches.first {
      lastPoint = touch.location(in: self.view)
    }
  }
  
  func drawLine(fromPoint: CGPoint, toPoint: CGPoint) {
    UIGraphicsBeginImageContext(self.view.frame.size)
    imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    var context = UIGraphicsGetCurrentContext()
    context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
    context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
    context?.setBlendMode(CGBlendMode.normal)
    context?.setLineCap(CGLineCap.round)
    context?.setLineWidth(5)
    context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor)
    
    context?.strokePath()
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let newDrawRef = drawRef.childByAutoId()
    
    let fromPointX = NSNumber(value: Float(fromPoint.x))
    let fromPointY = NSNumber(value: Float(fromPoint.y))
    let toPointX = NSNumber(value: Float(toPoint.x))
    let toPointY = NSNumber(value: Float(toPoint.y))
    let drawInfo = Draw(fromPointX: fromPointX, fromPointY: fromPointY, toPointX: toPointX, toPointY: toPointY, color: currentColor)
    
    
    newDrawRef.setValue(drawInfo.toAnyObject())
  }
  
  func drawLineObserve(fromPoint: CGPoint, toPoint: CGPoint, color: NSNumber) {
    setRGB(color: color)
    UIGraphicsBeginImageContext(self.view.frame.size)
    imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    var context = UIGraphicsGetCurrentContext()
    context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
    context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
    context?.setBlendMode(CGBlendMode.normal)
    context?.setLineCap(CGLineCap.round)
    context?.setLineWidth(5)
    context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1).cgColor)
    
    context?.strokePath()
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    swiped = true
    if let touch = touches.first{
      var currentPoint = touch.location(in: self.view)
      drawLine(fromPoint: lastPoint, toPoint: currentPoint)
      
      lastPoint = currentPoint
    }
  }
  
  @objc func buttonAction(sender: UIButton!) {
    print("Button tapped")
    self.imageView.image = nil
    drawRef.removeValue()
  }
  
  @objc func camAction(sender: UIButton!) {
    print("camera!")
    //    imagePickerController = UIImagePickerController()
    //    imagePickerController.view.sizeToFit()
    //    imagePickerController.delegate = self
    //
    //    imagePickerController.sourceType = .camera
    ////    imagePickerController.viewWillAppear(true)
    ////    self.view.addSubview(imagePickerController.view)
    //
    //    present(imagePickerController, animated: true, completion: nil)
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      imageView.contentMode = .scaleToFill
      imageView.image = pImage
      print("IT GOT IN HERE")
    }
    //viewWillAppear(true)
    picker.dismiss(animated: true, completion: nil)
  }
  
  @objc func eraseAction(sender: UIButton!) {
    print("Eraser")
    currentColor = 8;
    red = 255/255
    green = 255/255
    blue = 255/255
    
  }
  
  @objc func divideAction(sender: UIButton!) {
    print("Button tapped")
    
  }
  
  
  @objc func redAction(sender: UIButton!) {
    print("red")
    currentColor = 0;
    red = 231/255
    green = 76/255
    blue = 60/255
  }
  
  @objc func orangeAction(sender: UIButton!) {
    print("orange")
    currentColor = 1;
    red = 230/255
    green = 136/255
    blue = 34/255
  }
  
  @objc func yellowAction(sender: UIButton!) {
    print("yellow")
    currentColor = 2;
    red = 241/255
    green = 196/255
    blue = 15/255
  }
  
  @objc func blueAction(sender: UIButton!) {
    print("blue")
    currentColor = 3;
    red = 52/255
    green = 152/255
    blue = 219/255
  }
  
  @objc func greenAction(sender: UIButton!) {
    print("green")
    currentColor = 4;
    red = 46/255
    green = 204/255
    blue = 113/255
  }
  
  @objc func purpleAction(sender: UIButton!) {
    print("purple")
    currentColor = 5;
    red = 155/255
    green = 89/255
    blue = 182/255
  }
  
  @objc func grayAction(sender: UIButton!) {
    print("gray")
    currentColor = 6;
    red = 149/255
    green = 165/255
    blue = 166/255
  }
  
  @objc func blackAction(sender: UIButton!) {
    print("black")
    currentColor = 7;
    red = 44/255
    green = 62/255
    blue = 80/255
  }
  
  func setRGB(color: NSNumber){
    if (color == 0){
      red = 231/255
      green = 76/255
      blue = 60/255
    }
    if (color == 1){
      red = 230/255
      green = 136/255
      blue = 34/255
    }
    if (color == 2){
      red = 241/255
      green = 196/255
      blue = 15/255
    }
    if (color == 3){
      red = 52/255
      green = 152/255
      blue = 219/255
    }
    if (color == 4){
      red = 46/255
      green = 204/255
      blue = 113/255
    }
    if (color == 5){
      red = 155/255
      green = 89/255
      blue = 182/255
    }
    if (color == 6){
      red = 149/255
      green = 165/255
      blue = 166/255
    }
    if (color == 7){
      red = 44/255
      green = 62/255
      blue = 80/255
    }
    if (color == 8){
      red = 255/255
      green = 255/255
      blue = 255/255
    }
    
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped{
      drawLine(fromPoint: lastPoint, toPoint: lastPoint)
    }
    
    UIGraphicsBeginImageContext(imageView.frame.size)
    imageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
  
  private func observeNewPoints(){
    drawRefHandle = drawRef.observe(.childAdded, with: { snapshot in
      let drawData = snapshot.value as! Dictionary<String, Double>
      
      let id = snapshot.key
      let fromPointX = drawData["fromPointX"]
      let fromPointY = drawData["fromPointY"]
      let toPointX = drawData["toPointX"]
      let toPointY = drawData["toPointY"]
      let fromPoint = CGPoint(x: fromPointX!, y: fromPointY!)
      let toPoint = CGPoint(x: toPointX!, y: toPointY!)
      let colorFromData = drawData["color"]
      let nsColor = NSNumber(value: colorFromData!)
      
      self.drawLineObserve(fromPoint: fromPoint, toPoint: toPoint, color: nsColor)
    })
  }
  
  private func observeReset(){
    drawRefHandle = drawRef.observe(.childRemoved, with: { snapshot in
      self.imageView.image = nil
    })
  }
  
  func startTimer(){
    timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true, block: {[weak self] _ in
      print("Hello")
    })
  }
  
  func stopTimer(){
    timer?.invalidate()
  }
  
  
  
  
}
