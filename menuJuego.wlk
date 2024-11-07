import pokemon.menu

object menuJuego {

	method inicializar(){
		game.cellSize(45)
		game.height(27)
		game.width(51)
		game.boardGround("fondoInicio.png")
		keyboard.enter().onPressDo{menu.iniciarJuego()}
	}


}

