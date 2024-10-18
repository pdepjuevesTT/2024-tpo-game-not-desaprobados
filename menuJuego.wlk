import pokemon.menu

object menuJuego {

	method inicializar(){
		game.height(20)
		game.width(37)
		game.boardGround("fondoInicio.png")
		keyboard.enter().onPressDo{menu.iniciarJuego()}
	}


}

