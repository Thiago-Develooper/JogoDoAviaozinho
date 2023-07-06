//
//  MinhaViewController.swift
//  JogoDoAviaozinho
//
//  Created by Thiago Pereira de Menezes on 04/07/23.
//
// É a MinhaViewController que carrega as cenas do SpriteKit.

import UIKit
import SpriteKit

class MinhaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.landscape)

        //Temos que criar uma view:SKView para a nossa View Controller.
        let minhaView:SKView = SKView(frame: self.view.frame)
        self.view = minhaView
        
        let minhaCena:MinhaCena = MinhaCena(size: self.view.frame.size)
        minhaView.contentMode = .scaleToFill
        minhaView.presentScene(minhaCena)
        minhaView.ignoresSiblingOrder = false //Quando está como falso os objetos são instanciados na ordem lógica, em vez de uma forma randômica.
        minhaView.showsFPS = true
        minhaView.showsNodeCount = true
        minhaView.showsPhysics = true
    }
}

struct AppUtility {
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTorotateOrientation: UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(andRotateTorotateOrientation.rawValue, forKey: "orientation")
    }
}
