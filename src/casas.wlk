class Casa{
	const habitaciones = #{}
	const familia
	
	method habitacionesOcupadas() = habitaciones.filter({h => not h.estaVacia()})
	
	method responsablesDeLaCasa() = habitaciones.filter({h => h.edadDeOcupantes().max()})

}
