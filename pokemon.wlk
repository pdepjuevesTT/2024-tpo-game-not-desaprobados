object mapaJuego {
    var property fondo = true
    var property position = game.origin()
    
    method saludar() = ""
    method image() = "prueba10.png"
}

object menu {
    method iniciarJuego(){
        game.clear()
        game.addVisual(mapaJuego)
        game.addVisual(manzana)
        game.addVisualCharacter(charmander)
        game.addVisual(llaveMapa1)
        game.onCollideDo(charmander, {elemento => charmander.agregarInventario(elemento)})

		keyboard.e().onPressDo{
            game.addVisual(inventario)
            game.addVisual(manzanasInventario)
            game.addVisual(esmeraldasInventario)}

        keyboard.f().onPressDo{
            game.removeVisual(inventario)
            game.removeVisual(manzanasInventario)
            game.removeVisual(esmeraldasInventario)}

        game.addVisual(venusaur)
        game.whenCollideDo(venusaur,{elemento => game.say(venusaur, venusaur.saludar())})

        keyboard.y().onPressDo{
            const pantallaPelea = new FondoPelea(imagen = "charVSvenu.jpg")
            game.addVisual(pantallaPelea)

            keyboard.space().onPressDo{
                game.removeVisual(pantallaPelea)
                const pantallaPelea = new FondoPelea(imagen = "p4.jpg")
                game.addVisual(pantallaPelea)
            }

        }
    }
}

class FondoPelea{
    var property fondo = true
    var property position = game.origin()
    var imagen = ""
    
    method image() = imagen
}

object charmander {
    var property energia = 100
    var property position = game.origin()

    method image() = "charmanderV1.png"

    const inventario = []

    method agregarInventario(item){
        if (not (item.fondo())){
        game.removeVisual(item)
        inventario.add(item)
        game.say(self, "Objeto agregado al inventario")
        }
    }
}

class PokemonEnemigo{
    var property energia = 100
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method image() = imagen
}

object venusaur inherits PokemonEnemigo(imagen = "venusaur.png",posicion = game.at(11, 10)){
    var property fondo = true
    method saludar() = "Si quieres la llave tendras que pelear (Y para iniciar pelea)"
    //movimientos
}

object inventario {
    var property fondo = true
    var property position = game.at(32,10)

    method image() = "inventario.png"
}

class Comida {
    var property fondo = false
    var energia = 0
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method energia() = energia

    method image() = imagen    
}

const manzana = new Comida(fondo = false,energia = 20,imagen = "manzana.png",posicion = game.at(15, 10))

class Llaves {
    var property fondo = false
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method image() = imagen
}

const llaveMapa1 = new Llaves(fondo = true,imagen = "llaveV1.png",posicion = game.at(10,10))

class Textos {
    var property fondo = true
    var texto = ""
    var posicion = game.center()
    var property position = posicion

    method text() = texto
}

const manzanasInventario = new Textos(fondo = true,texto ="x Manzanas", posicion = game.at(34,14))

const esmeraldasInventario = new Textos(fondo = true,texto ="x Esmeraldas", posicion = game.at(34,13))