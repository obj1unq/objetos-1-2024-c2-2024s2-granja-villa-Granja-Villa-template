import wollok.game.*
import hector.*

class Maiz { 
	var property position = null
	var property image = "corn_baby.png"

	method regarse() {
	  	if (self.esBebe()) {
			image = "corn_adult.png"
	  	}
	}

	method esBebe() {
	  	return image == "corn_baby.png"
	}

	method cosecharse() {
	  	game.removeVisual(self)
	}

	method puedeCosecharse() {
	  	return !self.esBebe()
	}

	method valor() {
	  	return 150
	}
}

class Trigo { 
	var property position = null
	var etapa = 0

	method image() {
		return "wheat_" + etapa + ".png"
	}

	method regarse() {
		if (etapa == 3) {etapa = 0}
		else {
			etapa += 1
		}
	}

	method cosecharse() {
	  	game.removeVisual(self)
	}

	method puedeCosecharse() {
	  	return etapa >= 2
	}

	method valor() {
	  	return (etapa - 1) * 100
	}
}

class Tomaco { 
	var property position = null
	var property localizacion = granja

	method image() {
		return "tomaco.png"
	} 

	method regarse() {
	  	if(self.puedeMoverseArriba()) {
			position = game.at(position.x(), position.y() + 1)
	  	}
	}

	method puedeMoverseArriba() {
	  	return position.y() <= game.height() - 2 and
				self.hayObjetosArriba()
	}

	method hayObjetosArriba() {
	  return localizacion.esCeldaVacia(game.at(position.x(), position.y() + 1))
	}

	method cosecharse() {
	  	game.removeVisual(self)
	}

	method puedeCosecharse() {
	  	return true
	}

	method valor() {
	  	return 80
	}
}

