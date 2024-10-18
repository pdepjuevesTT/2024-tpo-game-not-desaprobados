object mapaJuego {
    var property position = game.origin()
    
    method image() = "mapaJuego.png"
}

object menu {
    method iniciarJuego(){
        game.clear()
        game.addVisual(mapaJuego)
        game.addVisual(manzana)
        game.addVisualCharacter(charmander)
        game.whenCollideDo(charmander, { pokemon =>
        pokemon.ataca()  } )
        game.whenCollideDo(manzana, { pokemon =>
        pokemon.come(manzana)  } )
    }
}

object charmander {
    var property energia = 0
    const dieta = []
    
    method come(comida) {
        energia = energia + comida.energia() && dieta.add(comida)
        comida.desparece()
    }//el inventario lo hago siempre que come y desaparece la comida
    
    method restoenergia(danio)= energia - danio

    var property position = game.origin()

    method image() = "charmanderV1.png"
}

object lapras{
    const foto=""
    method desaparece()=game.removeVisual(foto)
    method ataca(adversario)=adversario.restoenergia(100) && self.desaparece()
    
}
class Comida {
    var energia = 0
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method energia() = energia

    method image() = imagen    
    method desparece(){
        game.removeVisual(self)
    }
}

const manzana = new Comida(energia = 20,imagen = "manzana.png",posicion = game.at(10, 10))
