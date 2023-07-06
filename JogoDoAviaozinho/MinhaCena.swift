//
//  MinhaCena.swift
//  JogoDoAviaozinho
//
//  Created by Thiago Pereira de Menezes on 04/07/23.
//

import UIKit
import SpriteKit

var pontos = 0;

class MinhaCena: SKScene {
    
    //MARK: LABELS
    let textoPontos:SKLabelNode = SKLabelNode(fontNamed: "True Crimes")
    let textoGame:SKLabelNode = SKLabelNode(fontNamed: "True Crimes")
    
    //MARK: AÇÕES
    let acaoMove = SKAction.moveTo(x: -100, duration: 5)
    let acaoRemove = SKAction.removeFromParent()

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        //Declarando fundo e métodos de dinâmica de fundo.
        var imagemFundo:SKSpriteNode = SKSpriteNode()
        let objetoDummy = SKNode() //Dummy é um termo usado para algo que está lá apenas como auxílio.

        let moveFundo = SKAction.moveBy(x: -self.size.width, y: 0, duration: 5) //move o fundo para a esquerda durante 5s.
        let reposicionaFundo = SKAction.moveBy(x: self.size.width, y: 0, duration: 0) //coloca a imagem movida para a esquerda no centro da tela.
        let repete = SKAction.repeatForever(SKAction.sequence([moveFundo, reposicionaFundo]))

        //MARK: Instância fundo e métodos dinâmicos & Faz com que sejam gerados 2 fundos
        for i in 0..<2 {
            imagemFundo = SKSpriteNode(imageNamed: "imagem_fundo")
            imagemFundo.anchorPoint = CGPoint(x: 0, y: 0)
            
            imagemFundo.size.width = self.size.width //isso gera uma responsividade pois independente do tamanho da tela, a imagem à ocupará toda.
            imagemFundo.size.height = self.size.height
            
            imagemFundo.position = CGPoint(x: self.size.width * CGFloat(i), y: 0)
            imagemFundo.zPosition = -1

            imagemFundo.run(repete)//chama a função
            
            
            objetoDummy.addChild(imagemFundo)
            
        }
        
        self.addChild(objetoDummy)
        objetoDummy.speed = 0
        
        let felpudo:ObjetoAnimado = ObjetoAnimado("aviao") //invocando class que instância animação
        felpudo.position = CGPoint(x: 100, y: 100)
        self.addChild(felpudo)
        
        //MARK: - CONFIGURAÇÃO DO TEXTO
        textoGame.text = "Toque para Iniciar"
        textoPontos.text = "Score: \(pontos)"
        
        textoPontos.horizontalAlignmentMode = .right
        textoPontos.verticalAlignmentMode = .top
        
        textoPontos.fontColor = .white
        textoGame.fontColor = .yellow
        
        textoPontos.position = CGPoint(x: self.frame.maxX-10, y: self.frame.maxY-10)
        textoGame.position = CGPoint(x: self.frame.midX, y: self.frame.midY)

        self.addChild(textoPontos)
        self.addChild(textoGame)
        
        let sorteiaItens = SKAction.run {
            let sorteio = Int.random(in: 0..<20)
            
            if(sorteio < 5) {
                self.criaInimigoA()
            } else if(sorteio >= 5 && sorteio < 10) {
                self.criaInimigoB()
            } else if (sorteio > 17) {
                self.criarPeninha()
            }
            
        }
        
        self.run(SKAction.repeatForever(SKAction.sequence([sorteiaItens, SKAction.wait(forDuration: 1.0)])))
        
    }
    
    //MARK: - ADICIONANDO INIMIGOS E AÇÕES
    func criaInimigoA() {
        let lesmo:ObjetoAnimado = ObjetoAnimado("lesmo")
        let py = Float.random(in:30..<120)
        lesmo.setScale(0.7)
        lesmo.position = CGPoint(x: self.size.width+100, y: CGFloat(py)
)
        lesmo.run(SKAction.sequence([acaoMove, acaoRemove]))
        self.addChild(lesmo)
    }
    
    func criaInimigoB() {
        let bugado:ObjetoAnimado = ObjetoAnimado("bugado")
        let py = Float.random(in: 150..<300)
        bugado.setScale(0.7)
        bugado.position = CGPoint(x: self.size.width+100, y: CGFloat(py))
        bugado.run(SKAction.sequence([acaoMove, acaoRemove]))
        self.addChild(bugado)
    }
    
    func criarPeninha() {
        let peninha:ObjetoAnimado = ObjetoAnimado("pena_dourada")
        let py = Float.random(in: 50..<250)
        peninha.setScale(0.7)
        peninha.position = CGPoint(x: self.size.width+100, y: CGFloat(py))
        peninha.run(SKAction.sequence([acaoMove, acaoRemove]))
        self.addChild(peninha)
    }
    
}
