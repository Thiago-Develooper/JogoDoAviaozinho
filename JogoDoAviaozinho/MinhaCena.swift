//
//  MinhaCena.swift
//  JogoDoAviaozinho
//
//  Created by Thiago Pereira de Menezes on 04/07/23.
//

import UIKit
import SpriteKit

var pontos = 0
var comecou = false
var acabou = false
var podeReiniciar = false

//Identificação das entidades
var idFelpudo:UInt32 = 1
var idInimigo:UInt32 = 2
var idItem:UInt32 = 3

class MinhaCena: SKScene, SKPhysicsContactDelegate {
    
    //MARK: PERSONAGENS
    let felpudo:ObjetoAnimado = ObjetoAnimado("aviao") //invocando class que instância animação
    
    //MARK: SONS
    let somPick = SKAction.playSoundFileNamed("PLIN.mp3", waitForCompletion: false)
    let somHit = SKAction.playSoundFileNamed("QUEBRA.mp3", waitForCompletion: false)
    
    //MARK: LABELS
    let textoPontos:SKLabelNode = SKLabelNode(fontNamed: "True Crimes")
    let textoGame:SKLabelNode = SKLabelNode(fontNamed: "True Crimes")
    
    //MARK: AÇÕES
    let acaoMove = SKAction.moveTo(x: -100, duration: 5)
    let acaoRemove = SKAction.removeFromParent()
    
    let objetoDummy = SKNode() //Dummy é um termo usado para algo que está lá apenas como auxílio.
    var sorteiaItens = SKAction()
    
    var inimigos:[ObjetoAnimado] = []

    override func didMove(to view: SKView) {
        self.backgroundColor = UIColor.black
        
        self.physicsWorld.contactDelegate = self
        
        //Reproduzindo música
        SKAudio.sharedInstance().backgroundMusicPlayer?.volume = 0.5
        SKAudio.sharedInstance().playBackgroundMusic("MUSICA.mp3")
        
        //Declarando fundo e métodos de dinâmica de fundo.
        var imagemFundo:SKSpriteNode = SKSpriteNode()

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
        
        felpudo.name = "Personagem"
        felpudo.setScale(0.7)
        felpudo.position = CGPoint(x: 100, y: 100)
        self.addChild(felpudo)
        
        //MARK: - FÍSICA DO JOGO
                
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
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
        
        //MARK: INSTANCIAÇÃO PROCEDURAL DE INIMIGOS
        sorteiaItens = SKAction.run {
            if(comecou && !acabou) {
                let sorteio = Int.random(in: 0..<20)
                
                if(sorteio < 5) {
                    self.criaInimigoA()
                } else if(sorteio >= 5 && sorteio < 10) {
                    self.criaInimigoB()
                } else if (sorteio > 17) {
                    self.criarPeninha()
                }

            }
                
        }
        
        
    }
    
    //MARK: - ADICIONANDO INIMIGOS E AÇÕES
    func criaInimigoA() {
        let lesmo:ObjetoAnimado = ObjetoAnimado("lesmo")
        let py = Float.random(in:30..<120)
        lesmo.name = "Inimigo"
        lesmo.setScale(0.7)
        lesmo.position = CGPoint(x: self.size.width+100, y: CGFloat(py))
        
        lesmo.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: lesmo.size.width - 10, height: 30), center: CGPoint(x: 0, y: -lesmo.size.height / 2 + 25))
        lesmo.physicsBody?.isDynamic = false
        lesmo.physicsBody?.allowsRotation = false
        
        lesmo.physicsBody?.categoryBitMask = idInimigo
                
        lesmo.run(SKAction.sequence([acaoMove, acaoRemove]))
        
        self.addChild(lesmo)
    }
    
    func criaInimigoB() {
        let bugado:ObjetoAnimado = ObjetoAnimado("bugado")
        let py = Float.random(in: 150..<300)
        bugado.name = "Inimigo"
        bugado.setScale(0.7)
        bugado.position = CGPoint(x: self.size.width+100, y: CGFloat(py))
        
        bugado.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bugado.size.width - 30, height: 50), center: CGPoint(x: -10, y: -bugado.size.height / 2 + 25))
        bugado.physicsBody?.isDynamic = false
        bugado.physicsBody?.allowsRotation = false
        
        bugado.physicsBody?.categoryBitMask = idInimigo
        
        inimigos.append(bugado)

        bugado.run(SKAction.sequence([acaoMove, acaoRemove, SKAction.run {
            self.inimigos.remove(at: 0)
        }]))
        
        self.addChild(bugado)
    }
    
    func criarPeninha() {
        let peninha:ObjetoAnimado = ObjetoAnimado("pena_dourada")
        let py = Float.random(in: 50..<250)
        peninha.name = "Item"
        peninha.setScale(0.7)
        peninha.position = CGPoint(x: self.size.width+100, y: CGFloat(py))
        
        peninha.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: peninha.size.width - 30, height: 30), center: CGPoint(x: 0, y: -peninha.size.height / 2 + 25))
        peninha.physicsBody?.isDynamic = false
        peninha.physicsBody?.allowsRotation = false
        
        peninha.physicsBody?.categoryBitMask = idItem
                
        peninha.run(SKAction.sequence([acaoMove, acaoRemove]))
        self.addChild(peninha)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(!acabou) {
            if(!comecou) {
                comecou = true
            
                //Adicione física ao felpudo
                self.felpudo.physicsBody = SKPhysicsBody(circleOfRadius: felpudo.size.height / 2.5, center: CGPoint(x: 10, y: 0))
                self.felpudo.physicsBody?.isDynamic = true
                self.felpudo.physicsBody?.allowsRotation = false
                
                self.felpudo.physicsBody?.categoryBitMask = idFelpudo
                self.felpudo.physicsBody?.collisionBitMask = 0
                self.felpudo.physicsBody?.contactTestBitMask = idInimigo | idItem //quando falamos que o .contactTestBitMask é esses 2, dizemos que o sk só vai calcular as colissões com os objetos que tiverem estes .categoryBitMask.
                
                                                
                textoGame.isHidden = true
                objetoDummy.speed = 1
                self.run(SKAction.repeatForever(SKAction.sequence([sorteiaItens, SKAction.wait(forDuration: 1.5)])))
            }
            
            
            self.felpudo.physicsBody?.velocity = CGVector.zero
            self.felpudo.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 75))
            
        } else {
            
            if(podeReiniciar) {
                self.felpudo.position = CGPoint(x: frame.maxX * 0.2, y: frame.midY)
                self.felpudo.physicsBody?.velocity = CGVector.zero
                self.felpudo.physicsBody?.isDynamic = false
                self.felpudo.zRotation = 0
                comecou = false
                acabou = false
                podeReiniciar = false
                textoGame.isHidden = true
                objetoDummy.speed = 1
                pontos = 0
                textoPontos.text = "Score: \(pontos)"
                SKAudio.sharedInstance().backgroundMusicPlayer?.volume = 0.5
            }
        }
    }
    
    override func didSimulatePhysics() {
        if(comecou) { // se comecou for == true faca:
            self.felpudo.zRotation = (self.felpudo.physicsBody?.velocity.dy)! * 0.0005
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //percorre toda a lista de inimigos e atualiza a senoide deles.
        for e in inimigos {
            e.atualizaSenoide()
        }
        
        if(!acabou && comecou) {
            if(felpudo.position.y < (felpudo.size.height / 2 + 10)) {
                fimDeJogo()
            }
            
            if(felpudo.position.y > self.size.height + 10) {
                fimDeJogo()
            }

        }
    }
    
    func fimDeJogo() {
        print("Game Over!")
        acabou = true
        self.felpudo.physicsBody?.velocity = CGVector.zero
        self.felpudo.physicsBody?.applyImpulse(CGVector(dx: -80, dy: 50)) //q problema é esse????!?
        objetoDummy.speed = 0
        textoGame.isHidden = false
        textoGame.text = "Fim de jogo!"
        self.run(somHit)
        
        SKAudio.sharedInstance().backgroundMusicPlayer?.volume = 0.1
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.run {
            self.textoGame.text = "Toque para Reiniciar"
            podeReiniciar = true
            
            let children = self.children
            for child in children {
                if(child.name != nil) {
                    if(child.name! == "Item" || child.name! == "Inimigo") { //pq tá tendo !? n precisamos de desempacotar nd aq
                        
                        self.criaExplosao(child.position)
                        child.removeFromParent()
                    }
                }
            }
            
        }]))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(contact.bodyA.node?.name == "Inimigo") {
            fimDeJogo()
        }
        
        if(contact.bodyA.node?.name == "Item") {
            
            let px = CGFloat(contact.bodyA.node?.position.x ?? 0)
            let py = CGFloat(contact.bodyB.node?.position.y ?? 0)
            
            contact.bodyA.node?.removeFromParent()
            
            criaParticulasPenas(CGPoint(x: px, y: py))

            pontos += 1
            textoPontos.text = "Score: \(pontos)"
            self.run(somPick)
        }

    }
    
    func criaParticulasPenas(_ pos: CGPoint) {
        let peninha:SKTexture = SKTexture(imageNamed: "estrela")
        let minhaParticula:SKEmitterNode = SKEmitterNode()
        minhaParticula.particleTexture = peninha
        minhaParticula.position = pos //posição das partículas
        minhaParticula.particleSize = CGSize(width: 8, height: 8)
        minhaParticula.particleBirthRate = 25
        minhaParticula.numParticlesToEmit = 10 // múmero de partículas emitidas
        minhaParticula.particleLifetime = 0.5 //tempo de vida da partícula
        minhaParticula.particleTexture?.filteringMode = .nearest
        minhaParticula.xAcceleration = 0
        minhaParticula.yAcceleration = 0
        minhaParticula.particleSpeed = 200
        minhaParticula.particleSpeedRange = 100
        minhaParticula.particleRotationSpeed = -3
        minhaParticula.particleRotationRange = 3
        minhaParticula.emissionAngle = CGFloat(Double.pi * 2)
        minhaParticula.emissionAngleRange = CGFloat(Double.pi * 2)
        minhaParticula.particleColorAlphaSpeed = 0.1
        minhaParticula.particleColorAlphaRange = 1
        minhaParticula.particleAlphaSequence = SKKeyframeSequence(keyframeValues: [1,0], times: [0,1])
        minhaParticula.particleScaleSequence = SKKeyframeSequence(keyframeValues: [3, 0.5], times: [0,1])
        self.addChild(minhaParticula)
        minhaParticula.run(SKAction.move(by: CGVector(dx: -10, dy: 5), duration: 1.0))
        minhaParticula.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.removeFromParent()]))
    }
    
    func criaExplosao(_ pos: CGPoint) {
        let explosao = ObjetoAnimado("explosao")
        explosao.position = CGPoint(x: pos.x, y: pos.y)
        explosao.run(SKAction.move(by: CGVector(dx: -10, dy: 5), duration: 1.0))
        explosao.run(SKAction.sequence([SKAction.fadeOut(withDuration: 1.0), SKAction.removeFromParent()]))
        self.addChild(explosao)
    }
    
}
