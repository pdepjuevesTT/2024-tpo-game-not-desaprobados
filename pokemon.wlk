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
    }
}

object charmander {
    var property position = game.origin()

    method image() = "charmanderV1.png"
}

class Comida {
    var energia = 0
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method energia() = energia

    method image() = imagen    
}

const manzana = new Comida(energia = 20,imagen = "manzana.png",posicion = game.at(10, 10))
