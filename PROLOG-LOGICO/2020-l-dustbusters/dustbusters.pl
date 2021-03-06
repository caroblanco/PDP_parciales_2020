herramientasRequeridas(ordenarCuarto, [[aspiradora(100),escoba], trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).


%PUNTO 1
tiene(egon,aspiradora(200)).
tiene(egon,trapeador).
tiene(peter,trapeador).
tiene(winston,varitaNeutrones).

%PUNTO 2
satisfaceHerramienta(Persona,Herramienta):-
    tiene(Persona,Herramienta).

satisfaceHerramienta(Persona,aspiradora(Potencia)),
    tiene(Persona,aspiradora(POtT)),
    between(0, Potencia, PotenciaRequerida).

satisfaceHerramienta(Persona,ListaReemplazables):-
    member(Herramienta,ListaReemplazables),
    satisfaceHerramienta(Persona,Herramienta).

%PUNTO 3
puedeRealizarTarea(Persona,_):-
    tiene(Persona,varitaNeutrones).

puedeRealizarTarea(Persona,Tarea):-
    tiene(Persona,_),
    herramientasRequeridas(Tarea,Herramientas),
    forall(member(Herramienta,Herramientas),satisfaceHerramienta(Herramienta,Persona)).

%PUNTO 4
%tareaPedida(tarea, cliente, metrosCuadrados).
tareaPedida(caro,ordenarCuarto,  20).
tareaPedida(caro,cortarPasto,  50).
tareaPedida(eze,limpiarTecho,  70).
tareaPedida(fran,limpiarBanio,  15).

%precio(tarea, precioPorMetroCuadrado).
precio(ordenarCuarto, 13).
precio(limpiarTecho, 20).
precio(limpiarBanio, 55).
precio(cortarPasto, 10).
precio(encerarPisos, 7).

cuantoCobrar(Cliente,Dinero):-
    tareaPedida(Cliente,_,_),
    findall(Precio,precioPorTarea(Cliente,_,Precio),Precios),
    sum_list(Precios, Dinero).

precioPorTarea(Cliente,Tarea,Precio):-
    tareaPedida(Cliente,Tarea,Metros),
    precio(Tarea,Pre),
    Precio is Pre*Metros.

%PUNTO 5
esCompleja(limpiarTecho).
esCompleja(Tarea):-
    herramientasRequeridas(Tarea,ListaH),
    length(ListaH, CantH),
    CantH>2.
    

quienAcepta(ray,Cliente):-
    not(tareaPedida(Cliente,limpiarTecho,_)),
    puedeRealizarTodo(ray,Cliente).

puedeRealizarTodo(Persona,Cliente):-
    forall(tareaPedida(Cliente,Tarea,_),puedeRealizarTarea(Persona,Tarea)).

quienAcepta(winston,Cliente):-
    puedeRealizarTodo(ray,Cliente),
    cuantoCobrar(Cliente,Dinero),
    Dinero>500.

quienAcepta(egon,Cliente):-
    puedeRealizarTodo(egon,Cliente),
    tareaPedida(Cliente,Tarea,_),
    not(esCompleja(Tarea)).

quienAcepta(peter,_).

%PUNTO 6
/*
Por qu?? para este punto no bastaba s??lo con agregar un nuevo 
hecho?
Con nuestra definici??n de puedeHacerTarea verificabamos con un 
forall que una persona posea todas las herramientas que requer??a
una tarea; pero s??lo ligabamos la tarea. Entonces Prolog hubiera
matcheado con ambos hechos que encontraba, y nos hubiera devuelto
las herramientas requeridas presentes en ambos hechos.
Una posible soluci??n era, dentro de puedeHacerTarea, tambi??n ligar
las herramientasRequeridas antes del forall, y as?? asegurarnos que
el predicado matcheara con una ??nica tarea a la vez.
Cual es la desventaja de esto? Para cada nueva herramienta remplazable
deber??amos contemplar todos los nuevos hechos a generar para que 
esta soluci??n siga funcionando como queremos.
Se puede hacer? En este caso s??, pero con el tiempo se volver??a costosa.
La alternativa que planteamos en esta soluci??n es agrupar en una lista
las herramientas remplazables, y agregar una nueva definici??n a 
satisfaceNecesidad, que era el predicado que usabamos para tratar
directamente con las herramientas, que trate polimorficamente tanto
a nuestros hechos sin herramientas remplazables, como a aquellos que 
s?? las tienen. Tambi??n se podr??a haber planteado con un functor en vez
de lista.
Cual es la ventaja? Cada vez que aparezca una nueva herramienta
remplazable, bastar?? s??lo con agregarla a la lista de herramientas
remplazables, y no deber?? modificarse el resto de la soluci??n.
Notas importantes:
I) Este enunciado ped??a que todos los predicados fueran inversibles
Recordemos que un predicado es inversible cuando 
no necesit??s pasar el par??metro resuelto (un individuo concreto), 
sino que pod??s pasar una inc??gnita (variable sin unificar).
As?? podemos hacer tanto consultas individuales como existenciales.
II) No siempre es conveniente trabajar con listas, no abusar de su uso.
	En general las listas son ??tiles s??lo para contar o sumar muchas cosas
	que est??n juntas.
III) Para usar findall es importante saber que est?? compuesto por 3 cosas:
		1. Qu?? quiero encontrar
		2. Qu?? predicado voy a usar para encontrarlo
		3. Donde voy a poner lo que encontr??
IV) Todo lo que se hace con forall podr??a tambi??n hacerse usando not.
*/