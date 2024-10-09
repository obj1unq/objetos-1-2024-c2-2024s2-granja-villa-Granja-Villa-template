import wollok.game.*
import hector.*

class Aspersor {
	var property position = null
	var property image = "aspersor.png"
	const localizacion = granja

	method comenzarARegar() {
	  	game.onTick(1000, self.identity().toString(), {self.regar()})
	}

	method dejarDeRegar() {
	  game.removeTickEvent(self.identity().toString())
	}

	method regar() {
	  self.posicionesARegar().forEach(
		{posicion => self.regarSiDebo(
			game.at(posicion.first(), posicion.last()))})
	}

	method regarSiDebo(posicion) {
	  return if(localizacion.hayCultivoEn(posicion)) {
				localizacion.cultivoEn(posicion).regarse()}
	}
	
	method posicionesARegar() {
	  return [[position.x(), position.y() + 1], [position.x() + 1, position.y()],
			  [position.x(), position.y() - 1], [position.x() - 1, position.y()],
			  [position.x() - 1, position.y() + 1], [position.x() + 1, position.y() - 1],
			  [position.x() + 1, position.y() + 1], [position.x() - 1, position.y() - 1]
			]
	}
}