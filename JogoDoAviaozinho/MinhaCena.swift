//
//  MinhaCena.swift
//  JogoDoAviaozinho
//
//  Created by Thiago Pereira de Menezes on 04/07/23.
//

import UIKit
import SpriteKit

class MinhaCena: SKScene {

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        //Declarando fundo e métodos de dinâmica de fundo.
        var imagemFundo:SKSpriteNode = SKSpriteNode()

        let moveFundo = SKAction.moveBy(x: -self.size.width, y: 0, duration: 5) //move o fundo para a esquerda durante 5s.
        let reposicionaFundo = SKAction.moveBy(x: self.size.width, y: 0, duration: 0) //coloca a imagem movida para a esquerda no centro da tela.
        let repete = SKAction.repeatForever(SKAction.sequence([moveFundo, reposicionaFundo]))

        //Instância fundo e métodos dinâmicos & Faz com que sejam gerados 2 fundos
        
        for i in 0..<2 {
            imagemFundo = SKSpriteNode(imageNamed: "imagem_fundo")
            imagemFundo.anchorPoint = CGPoint(x: 0, y: 0)
            
            imagemFundo.size.width = self.size.width //isso gera uma responsividade pois independente do tamanho da tela, a imagem à ocupará toda.
            imagemFundo.size.height = self.size.height
            
            imagemFundo.position = CGPoint(x: self.size.width * CGFloat(i), y: 0)
            imagemFundo.zPosition = -1

            imagemFundo.run(repete)
            
            
            self.addChild(imagemFundo)
        }
        

    }
    
}
