import menuJuego.menuJuego

object mapaJuego {
    var property fondo = true
    var property position = game.origin()
    
    method saludar() = ""
    method image() = "MAPA_UNO.png" 
}

const vida = new Textos(fondo = true,texto = "" + venusaur.energia() + "/850", posicion = game.at(34,18))
const vidaCharmander = new Textos(fondo = true,texto = "" + charmander.energia() + "/1000", posicion = game.at(5,10))
const ambiente = game.sound("ambiente.mp3")
const peleaMusica = game.sound("soundPeleaUno.mp3")

object menu {
    method iniciarJuego(){
        ambiente.play()

        game.addVisual(mapaJuego)
        game.addVisual(manzana)
        game.addVisual(puerta)
        game.addVisualCharacter(charmander)
        game.addVisual(llave)
        game.onCollideDo(charmander, {elemento => charmander.agregarInventario(elemento)})

        // CONTROLES DE PELEA

        keyboard.num(1).onPressDo{charmander.araniazo()}
        keyboard.num(2).onPressDo{charmander.lanzallamas()}
        keyboard.num(3).onPressDo{charmander.giroFuego()}
        keyboard.num(4).onPressDo{charmander.dragoAliento()}

        // JUEGO

		keyboard.e().onPressDo{
            const manzanasInventario = new Textos(fondo = true,texto = "Manzanas x " + charmander.manzanas(), posicion = game.at(34,14))

            const llavesInventario = new Textos(fondo = true,texto = "Llaves x " + charmander.llavesP(), posicion = game.at(34,13))

            game.addVisual(inventario)
            game.addVisual(manzanasInventario)
            game.addVisual(llavesInventario)
            game.schedule(3000, {
                game.removeVisual(inventario)
                game.removeVisual(manzanasInventario)
                game.removeVisual(llavesInventario)
            })}

        game.addVisual(venusaur)
        game.whenCollideDo(venusaur,{elemento => game.say(venusaur, venusaur.interactuar())})
        

        game.whenCollideDo(puerta,{
            elemento => 
            if(charmander.llavesP() >= 1)
                game.say(charmander, "K para usar la llave")
            else
                game.say(charmander, "No tengo llaves")
        })

        keyboard.d().onPressDo{
            self.peleaUno()
        }

        keyboard.k().onPressDo{ 
            if(charmander.llavesP()>=1){
                game.removeVisual(charmander)
                ambiente.pause()
                const final = new FondoPelea(imagen = "FINAL.jpg")
                game.addVisual(final)
            }
        }

        keyboard.b().onPressDo{
            charmander.comer()
        }
    }

    method peleaUno(){
        charmander.subir()
            const pantallaCharla = new FondoPelea(imagen = "PREGUNTA_PELEA_UNO.jpg")
            game.addVisual(pantallaCharla)

            keyboard.n().onPressDo{game.removeVisual(pantallaCharla)}

            keyboard.y().onPressDo{
                ambiente.pause()
                peleaMusica.play()
                game.removeVisual(pantallaCharla)
                const pantallaPelea = new FondoPelea(imagen = "PANTALLA_PELEA_UNO.jpg")
                game.addVisual(pantallaPelea)
                game.schedule(3000, {
                game.removeVisual(pantallaPelea)
                const arena = new FondoPelea(imagen = "PELEA_UNO_V1.jpg")
                charmander.establecerRival(venusaur)
                charmander.contra(arena)
                game.addVisual(arena)
                game.addVisual(vida)
                game.addVisual(vidaCharmander)
                })
            }
    }

    method ganarPelea(alguien){
        const pantallaVictoria = new FondoPelea(imagen = "PANTALLA_VICTORIA_UNO.jpg")
        game.addVisual(pantallaVictoria)
        game.schedule(5000, {
            peleaMusica.stop()
            ambiente.resume()
            game.removeVisual(pantallaVictoria)
            game.removeVisual(alguien)
            game.removeVisual(venusaur)
            game.removeVisual(vida)
            game.removeVisual(vidaCharmander)
            llave.cambiarEstado(false)
        })
    }

    method terminarJuego(){
        game.clear()
        const pantallaDerrota = new FondoPelea(imagen = "PANTALLA_DERROTA_UNO.jpg")
        game.addVisual(pantallaDerrota)
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
    var property arena = new FondoPelea()
    var rival = nadie

    method establecerRival(nuevoRival){
        rival = nuevoRival
    }

    method contra(alguien){
        arena = alguien
    }

    const inventario = []

    method manzanas() = inventario.filter{n => n == manzana}.size()

    method llavesP() = inventario.filter{n => n == llave}.size()

    method comer(){
        if(self.manzanas()>=1){
            inventario.remove(manzana)
            energia += manzana.energia()
            vidaCharmander.cambiarTexto("" + self.energia() + "/1000")

        }
        else
            game.say(self,"No tengo manzanas")
    }

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
            menu.terminarJuego()
        }else{
            if(rival.energia() <= 0){
                menu.ganarPelea(self.arena())
            }
        }
        vidaCharmander.cambiarTexto("" + self.energia() + "/1000")
    }

    method subir() {
      position = position.up(2)
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
            rival.restarVida(150)
        if(x==3)
            rival.restarVida(40)
        if(x==4)
            rival.restarVida(180)
    }

    override method restarVida(cantidad){
        super(cantidad)
        vida.cambiarTexto("" + self.energia() + "/850")
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

const manzana = new Comida(fondo = false,energia = 150,imagen = "manzana.png",posicion = game.at(25, 10))

class Llaves {
    var property fondo
    var imagen = ""
    var posicion = game.center()
    var property position = posicion

    method image() = imagen

    method cambiarEstado(estado){
        fondo = estado
    }
}

const llave = new Llaves(fondo = true,imagen = "llaveV1.png",posicion = game.at(8,10))

const puerta = new Llaves(fondo = true,imagen = "PUERTA.png",posicion = game.at(36,13))

class Textos {
    var property fondo = true
    var texto = ""
    var posicion = game.center()
    var property position = posicion

    method text() = texto

    method cambiarTexto(nuevo){
        texto = nuevo
    }
}