import menuJuego.menuJuego

object mapaJuego {
    var property fondo = true
    var property position = game.origin()
    
    method saludar() = ""
    method image() = "MAPA_TIERRA.png"
}

object menu {
    method iniciarJuego(){
        game.addVisual(mapaJuego)
        game.addVisual(manzana)
        game.addVisualCharacter(charmander)
        game.addVisual(llaveMapa1)
        game.onCollideDo(charmander, {elemento => charmander.agregarInventario(elemento)})

        // CONTROLES DE PELEA

        keyboard.num(1).onPressDo{charmander.araniazo()}
        keyboard.num(2).onPressDo{charmander.lanzallamas()}
        keyboard.num(3).onPressDo{charmander.giroFuego()}
        keyboard.num(4).onPressDo{charmander.dragoAliento()}

        // JUEGO

		keyboard.e().onPressDo{
            const manzanasInventario = new Textos(fondo = true,texto = "Manzanas x " + charmander.manzanas(), posicion = game.at(34,14))

            game.addVisual(inventario)
            game.addVisual(manzanasInventario)
            game.schedule(3000, {
                game.removeVisual(inventario)
                game.removeVisual(manzanasInventario)
            })}

        game.addVisual(venusaur)
        game.whenCollideDo(venusaur,{elemento => game.say(venusaur, venusaur.interactuar())})

        keyboard.d().onPressDo{
            charmander.subir()
            const pantallaCharla = new FondoPelea(imagen = "PREGUNTA_PELEA_UNO.jpg")
            game.addVisual(pantallaCharla)

            keyboard.n().onPressDo{game.removeVisual(pantallaCharla)}

            keyboard.y().onPressDo{
                const pantallaPelea = new FondoPelea(imagen = "PANTALLA_PELEA_UNO.jpg")
                game.addVisual(pantallaPelea)
                game.schedule(3000, {
                game.removeVisual(pantallaPelea)
                const arena = new FondoPelea(imagen = "PELEA_UNO.jpg")
                game.addVisual(arena)})
                charmander.establecerRival(venusaur)
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

class Pokemon{
    var property energia
    var property position
    var imagen

    method image() = imagen

    method restarVida(cantidad){
        energia -= cantidad
    }
}

object nadie{
}

object charmander inherits Pokemon(energia = 1000, position = game.origin(),imagen = "charmanderV3.png"){

    var rival = nadie

    method establecerRival(nuevoRival){
        rival = nuevoRival
    }

    const inventario = []

    method manzanas() = inventario.filter{n => n == manzana}.size()

    method agregarInventario(item){
        if (not (item.fondo())){
        game.removeVisual(item)
        inventario.add(item)
        game.say(self, "Objeto agregado al inventario")
        }
    }
    
    method araniazo(){
        rival.restarVida(50)
        rival.atacar(self)
    }

    method lanzallamas(){
        rival.restarVida(120)
        rival.atacar(self)
    }

    method giroFuego(){
        rival.restarVida(150)
        rival.atacar(self)
    }

    method dragoAliento(){
        rival.restarVida(200)
        rival.atacar(self)
    }

    override method restarVida(cantidad){
        super(cantidad)
        if(self.energia() <= 0){
            const pantallaDerrota = new FondoPelea(imagen = "PANTALLA_DERROTA_UNO.jpg")
            game.addVisual(pantallaDerrota)
        }else{
            if(rival.energia() <= 0){
                const pantallaVictoria = new FondoPelea(imagen = "PANTALLA_VICTORIA_UNO.jpg")
                game.addVisual(pantallaVictoria)
            }
        }
    }

    method subir() {
      position = position.up(3)
    }
}

object venusaur inherits Pokemon(energia = 850,imagen = "venusaur.png",position = game.at(11, 10)){
    var property fondo = true
    method interactuar() = "D para interactuar"

    method atacar(rival){
        const x = (1..4).anyOne()
        if(x==1)
            rival.restarVida(130)
        if(x==2)
            rival.restarVida(170)
        if(x==3)
            rival.restarVida(40)
        if(x==4)
            rival.restarVida(200)
    }
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

const manzana = new Comida(fondo = false,energia = 20,imagen = "manzana.png",posicion = game.at(25, 10))

class Llaves {
    var property fondo = false
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method image() = imagen
}

const llaveMapa1 = new Llaves(fondo = true,imagen = "llaveV1.png",posicion = game.at(8,10))

class Textos {
    var property fondo = true
    var texto = ""
    var posicion = game.center()
    var property position = posicion

    method text() = texto
}