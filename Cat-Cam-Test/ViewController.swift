//
//  ViewController.swift
//  Cat-Cam-Test
//
//  Created by Jacob Zeisel on 9/2/23.
//

import UIKit
import Foundation

let ip_addr = "76.136.200.69"
let port_addr = "3333"
var secret_key = ""
let url_up = URL(string: "http://" + ip_addr + ":" + port_addr + "/" + secret_key + "/up")!
let url_down = URL(string: "http://" + ip_addr + ":" + port_addr + "/" + secret_key + "/down")!
let url_left = URL(string: "http://" + ip_addr + ":" + port_addr + "/" + secret_key + "/left")!
let url_right = URL(string: "http://" + ip_addr + ":" + port_addr + "/" + secret_key + "/right")!

let url_image = URL(string: "http://" + ip_addr + ":" + port_addr + "/" + secret_key + "/image")!

let username = "jzeisel"
let password = ""
let loginString = String(format: "\(username):\(password)", username, password)
let loginData = loginString.data(using: String.Encoding.utf8)!
let base64LoginString = loginData.base64EncodedString()

let headers = [
    "Authorization": "Basic \(base64LoginString)"
]

let passwordTextField = UITextField()
let button_enter = UIButton(type: .system)

class ViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /* create a rectangle */
        let rectImageBG = RectangleView()
        rectImageBG.set_vals(red: 0.0, green: 0.698, blue: 1.0, alpha: 0.9)
        let rect_width = Int(self.view.frame.size.width)
        let rect_height = Int(self.view.frame.size.height / 2)
        rectImageBG.frame = CGRect(x: 0, y: Int(self.view.frame.size.height/8), width: rect_width, height: rect_height)
        view.addSubview(rectImageBG)
        
        /* create buttons */
        let button_up = createButton(x: 2, y: 16, mult_x: 1, mult_y: 12, shift_x: 0, shift_y: 0)
        button_up.tag = 0
        button_up.addTarget(self,action:#selector(buttonClicked),
                            for:.touchDown)
        button_up.addTarget(self,action:#selector(buttonExpander),
                            for:.touchDown)
        button_up.addTarget(self,action:#selector(buttonDeflator),
                            for:.touchUpInside)
        let button_down = createButton(x: 2, y: 16, mult_x: 1, mult_y: 14, shift_x: 0, shift_y: 0)
        button_down.tag = 1
        button_down.addTarget(self,action:#selector(buttonClicked),
                            for:.touchDown)
        button_down.addTarget(self,action:#selector(buttonExpander),
                            for:.touchDown)
        button_down.addTarget(self,action:#selector(buttonDeflator),
                            for:.touchUpInside)
        let button_left = createButton(x: 8, y: 16, mult_x: 2, mult_y: 13, shift_x: 13, shift_y: 0)
        button_left.tag = 2
        button_left.addTarget(self,action:#selector(buttonClicked),
                            for:.touchDown)
        button_left.addTarget(self,action:#selector(buttonExpander),
                            for:.touchDown)
        button_left.addTarget(self,action:#selector(buttonDeflator),
                            for:.touchUpInside)
        let button_right = createButton(x: 8, y: 16, mult_x: 6, mult_y: 13, shift_x: -6, shift_y: 2)
        button_right.tag = 3
        button_right.addTarget(self,action:#selector(buttonClicked),
                            for:.touchDown)
        button_right.addTarget(self,action:#selector(buttonExpander),
                            for:.touchDown)
        button_right.addTarget(self,action:#selector(buttonDeflator),
                            for:.touchUpInside)
        
        /* create text field to get password */
        passwordTextField.placeholder = "Enter Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.frame = CGRect(x: 60, y: (self.view.frame.size.height / 12) - 15, width: 150, height: 40)
        passwordTextField.borderStyle = UITextField.BorderStyle.roundedRect
        view.addSubview(passwordTextField)
        passwordTextField.delegate = self
        
        
        /* create submit button next to the get password field */
        button_enter.setTitle("", for: .normal)
        button_enter.layer.borderColor = CGColor.init(red: 0.322, green: 0.8, blue: 1.0, alpha: 0.8)
        button_enter.layer.borderWidth  = 3.0
        button_enter.frame = CGRect(x: 20, y: (self.view.frame.size.height / 12) - 10, width: 30, height: 30)
        button_enter.tintColor = UIColor.white
        button_enter.configuration = createConfig(type: "black")
        self.view.addSubview(button_enter)
        button_enter.addTarget(self,action:#selector(buttonEnterClicked), for:.touchDown)
        button_enter.addTarget(self,action:#selector(buttonEnterUnclicked), for:.touchUpInside)
        button_enter.addTarget(self,action:#selector(buttonSubmitted), for:.touchDown)
        
        /* make it so that a tap will get rid of keyboard */
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        /* get images in a loop */
        let timer = Timer(timeInterval: 0.2, repeats: true) { _ in
            self.getImage(input: url_image)
            { image in DispatchQueue.main.async
                {
                    if let image = image {
                        print("got image")
                        let imageView = UIImageView(image: image)
                        
                        imageView.frame = CGRect(x: 0 + 20, y: Int(self.view.frame.size.height/8) + 20, width: rect_width - 40, height: rect_height - 40)
                        self.view.addSubview(imageView)
                    } else {
                        print("error grabbing image")
                    }
                }
            }
        }
        // Add the timer to the main run loop
        RunLoop.main.add(timer, forMode: .default)

        // Start the timer immediately
        timer.fire()
    }
    
    func createButton(x: Int, y: Int, mult_x: Int, mult_y: Int, shift_x: Int, shift_y: Int) -> UIButton {
        /* creates a button where x and y are the divisors of the width and height */
        let x_center = (Int(self.view.frame.size.width) / x) * mult_x
        let y_center = (Int(self.view.frame.size.height) / y) * mult_y
        let button_width = 50
        let button_height = 50
        let button = UIButton(frame: CGRect(x: x_center - button_width/2 + shift_x,
                                            y: y_center - button_height/2 + shift_y,
                                            width: button_width,
                                            height: button_height))
        //button.center = view.center
        button.tintColor = UIColor.white
        button.configuration = createConfig(type: "blue")
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 5.0
        view.addSubview(button)
        
        return button
    }
    
    func createConfig(type: String) -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        switch type {
            case "blue":
                config.baseBackgroundColor = UIColor.init(red: 0.322, green: 0.8, blue: 1.0, alpha: 0.8)
            case "black":
                config.baseBackgroundColor = UIColor.darkGray
            default:
                config.baseBackgroundColor = UIColor.darkGray
        }
        return config
    }
    
    func sendRequest(input: URL) {
        let request = URLRequest(url: input)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                let str = String(data: data, encoding: .utf8)
                print(str ?? "")
            }
        }

        task.resume()
    }
    
    func getImage(input: URL, completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(url: input)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
            } else if let data = data {
                //print(data.map { String(format: "%02x", $0) }.joined())
                
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder() // Dismiss the keyboard
            buttonSubmitted(button_enter)
            return true
        }
        return false
    }
    
    @objc func buttonClicked(sender:UIButton)
    {
        switch sender.tag {
        case 0:
            sendRequest(input: url_up)
        case 1:
            sendRequest(input: url_down)
        case 2:
            sendRequest(input: url_left)
        case 3:
            sendRequest(input: url_right)
        default:
            sendRequest(input: url_up)
        }
    }
    
    @IBAction func buttonExpander(_ sender: UIButton) {
        UIView.animate(withDuration: 0.05,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        })
    }
    
    @IBAction func buttonDeflator(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction func buttonEnterClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
    }
    
    @IBAction func buttonEnterUnclicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    @IBAction func buttonSubmitted(_ sender: UIButton) {
        secret_key = passwordTextField.text!
        passwordTextField.text = ""
    }
}

class RectangleView: UIView {
    private var red: CGFloat = 0.0
    private var green: CGFloat = 0.0
    private var blue: CGFloat = 0.0
    private var alpha_0: CGFloat = 0.0
    
    func set_vals(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha_0 = alpha
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Define the blue color
        let color = UIColor.init(red: self.red, green: self.green, blue: self.blue, alpha: self.alpha_0)
        
        // Set the fill color to blue
        color.setFill()
        
        // Create a rectangle path
        let rectanglePath = UIBezierPath(rect: rect)
        
        // Fill the rectangle with the blue color
        rectanglePath.fill()
    }
}
