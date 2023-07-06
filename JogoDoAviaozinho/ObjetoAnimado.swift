//
//  ObjetoAnimado.swift
//  JogoDoAviaozinho
//
//  Created by Thiago Pereira de Menezes on 04/07/23.
//

import UIKit
import SpriteKit

class ObjetoAnimado: SKSpriteNode {
    
    var nome:String?
    
    init(_ nome: String) {
        
        self.nome = nome
        let textura = SKTexture(imageNamed: "\(nome)1")
        
        super.init(texture: textura, color: .red, size: textura.size())
        self.setup() //chama função criada que anima os frames.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() { //aqui dentro que será feito o carregamento das imagens.
        
        var imagens:[SKTexture] = []
        let atlas:SKTextureAtlas = SKTextureAtlas(named: nome!)

        for i in 1...atlas.textureNames.count {
            imagens.append(SKTexture(imageNamed: "\(self.nome!)\(i)"))
        }
        
        let animacao:SKAction = SKAction.animate(with: imagens, timePerFrame: 0.1, resize: true, restore: true)

        self.run(SKAction.repeatForever(animacao))
    }
}
