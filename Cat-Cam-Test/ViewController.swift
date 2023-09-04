//
//  ViewController.swift
//  Cat-Cam-Test
//
//  Created by Jacob Zeisel on 9/2/23.
//

import UIKit
import Foundation

let url_up = URL(string: "http://jakespi.local:3333/up")!
let url_down = URL(string: "http://jakespi.local:3333/down")!
let url_left = URL(string: "http://jakespi.local:3333/left")!
let url_right = URL(string: "http://jakespi.local:3333/right")!

let username = "jzeisel"
let password = ""
let loginString = String(format: "\(username):\(password)", username, password)
let loginData = loginString.data(using: String.Encoding.utf8)!
let base64LoginString = loginData.base64EncodedString()

let headers = [
    "Authorization": "Basic \(base64LoginString)"
]

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        /* make sure left and right buttons are aligned */
        
        
        
        /*
        let imageName = "Image"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        imageView.frame = CGRect(x: 100, y: 500, width: 150, height: 100)
        view.addSubview(imageView)
        */
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
        button.configuration = createConfig()
        view.addSubview(button)
        
        return button
    }
    
    func createConfig() -> UIButton.Configuration {
        var config: UIButton.Configuration = .filled()
        config.baseBackgroundColor = UIColor.darkGray
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
}

