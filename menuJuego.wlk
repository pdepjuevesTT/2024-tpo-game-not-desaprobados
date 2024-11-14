import pokemon.menu

object menuJuego {

	method inicializar(){
		game.cellSize(50)
		game.height(20)
		game.width(39)
		game.boardGround("fondoInicio.png")
		keyboard.enter().onPressDo{menu.iniciarJuego()}
	}
}

