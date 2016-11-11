AOC Final Practice
Course 2016/2017

Día 25 de octubre de 2016:

Visualizando las 3 posibilidades nos hemos dado cuenta que una vez conseguido realizar la primera opción, las otras dos restantes no suponen mucho más trabajo a parte.
Al tener los días que han pasado de una fecha a otra (opción uno), aplicando el módulo de 7 se puede ver cuantos días de la semana han pasado, y, por tanto, se sabría en qué día de la semana se está (opción 2). Implementando esto, se puede obtener la opción 3, de imprimir el mes entero, partiendo de una fecha ya conocida y almacenada.
Para comenzar, se ha implementado una función que imprime el mes dependiendo el número introducido. Este método se aprovechará para imprimir también el día de la semana (Lunes -> Viernes).
Esta basado en guardar los meses ocupando un total de 13 espacios en memoria, de forma que si el mes tiene 6 letras (enero) se le asigna después 7 espacios mediante la declaración space. Para imprimirlo, se accede al mes restando 1 y después multiplicando por 13 a la dirección inicial donde se guardan los meses. 
Enero = 1; Se imprime desde posición 0 = (1-1)*13
El bucle termina de imprimir en el momento que se encuentra el valor ASCII 0, ya que indica que ahí hay un espacio nulo, y por tanto, se ha acabado lo que se deseaba imprimir.


Día 8 de noviembre de 2016:

Como se explicó la semana pasada, nuestra idea es hacer tres programas en uno. Es decir, que imprima tres datos. 
A lo largo de estas dos semanas se han ido añadiendo pequeños fragmentos al programa hasta completar el primer apartado, la distancia entre dos fechas. 
El algoritmo para ello es totalmente de nuestra invención, no se ha consultado ninguna página ni seguido ningún método matemático concreto. Pongamos un ejemplo:
Fecha 1: 25/5/1995		Fecha 2: 2/2/2000
Lo primero es calcular la distancia entre la primera fecha y el 31 de diciembre de ese mismo año, es decir, entre 25/5/1995 y 31/12/1995. Para ello se ha definido un vector que contiene los días de cada mes. Se van sumando esos días desde el mes 5 hasta el 12. Finalmente se resta 25, por los días que ya tenía la primera fecha.
Para la segunda fecha se calcula los días de la misma manera, pero esta vez desde 1/1/2000 hasta 2/2/2000. Restando al resultado final los días máximos del mes + los días introducidos, es decir, resultado-(28+2).
Hay que tener en cuenta si alguna de las dos fechas es un año bisiesto y si llega a febrero, por ejemplo, la segunda fecha es un año bisiesto, pero no llega al 28 de febrero, asi que no influye. Esto en un principio fue un problema porque sumábamos “1” al resultado sólo con ver si el año era bisiesto.
Por ultimo sólo queda sumar los años que haya de por medio. Se hace mediante un bucle que recorre cada año de por medio comprobando si es bisiesto, si lo es suma 366 al resultado, si no, 365.
Tuvimos un problema en la función “bisiesto” porque dividíamos el año entre 10, no entre 100, por lo que cuando se introducían fechas muy separadas daba unos días de menos en el resultado. Tuvimos que ir ejecutando el programa paso a paso viendo el valor de los registros hasta que dimos con el fallo.
El usuario puede introducir una fecha más reciente como primera fecha ya que el programa lo comprobará y si es así las intercambiará. El resultado siempre será un número positivo. Se ha considerado que una distancia siempre es positiva.
Lo último que se ha añadido ha sido la entrada de datos y la detección de errores. El usuario puede introducir la fecha 2/2/1999 como 02/02/1999 o 0002/0002/1999. Funcionará igual. Lo importante es que el separador sea una barra lateral. Es importante decir que el programa traduce la entrada (dia, mes, año) introducida en string a entero y lo guarda en tres registros. Da igual lo que el usuario introduzca, se guardará en los registros. Será aquí donde se compruebe si realmente todos los datos son válidos. Si no lo son se imprime un mensaje y se acaba el programa.
Respecto a la introducción de datos por el usuario tuvimos un problema porque cada carácter ocupa 8 bits, pero por ejemplo, el año 1999 no entra en 8 bits. La solución fue leer la entraba mediante “lb” y almacenarlo en memoria mediante “lw”.
Se pretende mejorar en futuras semanas el programa para arreglar el cambio de calendario juliano a gregoriano.
