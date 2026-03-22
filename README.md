# Tic-Tac-Toe (Juego del Gato) - Tarea 08

## Descripción de la aplicación
Esta es una aplicación móvil del clásico juego de mesa Tic-Tac-Toe (también conocido como el juego del Gato o Tres en raya). Permite a los jugadores interactuar en un tablero de 3x3 con el objetivo de alinear tres de sus símbolos (X o O). 

El proyecto fue desarrollado utilizando Flutter, incluye lógica para detectar victorias, empates y reiniciar el tablero.

---

## Tecnologías utilizadas

* **Flutter** - Framework principal utilizado para el desarrollo multiplataforma de la interfaz móvil.
* **Dart (SDK ^3.10.0-195.0.dev)** - Lenguaje de programación base en el que está construida la lógica de la aplicación.
* **Firebase Core (^4.5.0)** - Para la inicialización y conexión del proyecto con los servicios en la nube de Google Firebase.
* **Firebase Auth (^6.2.0)** - Implementado para la autenticación y gestión de usuarios dentro de la aplicación.
* **Cloud Firestore (^6.1.3)** - Base de datos NoSQL en la nube utilizada para almacenar y sincronizar la información del juego o de los jugadores.
* **Cupertino Icons (^1.0.8)** - Paquete de iconografía para la interfaz de usuario.

---

## Pantallas de la Aplicación

### 1. Autenticación (Inicio de Sesión y Registro)
Es la pantalla inicial de la aplicación. Los usuarios nuevos pueden crear una cuenta proporcionando sus datos, mientras que los usuarios recurrentes pueden iniciar sesión con sus credenciales validadas a través de Firebase Auth.


### 2. Lobby (Menú Principal)
Una vez autenticado, el usuario ingresa a esta sala de espera. Desde aquí, los jugadores pueden prepararse para iniciar una nueva partida, buscar oponentes y navegar hacia otras secciones de la aplicación.

### 3. Tablero de Juego (La Partida)
Es la vista central interactiva donde se desarrolla el juego en una cuadrícula de 3x3. En esta pantalla se indica claramente de quién es el turno actual (Jugador X o Jugador O) junto con el nombre del usuario.

### 4. Game Over (Fin del Juego)
Pantalla que interrumpe la partida cuando un jugador logra alinear tres de sus símbolos o cuando todas las casillas se llenan sin un ganador. Muestra el resultado final y ofrece opciones para continuar o salir.

### 5. Rankings
Una vista dedicada a mostrar los mejores puntajes y estadísticas de los jugadores. Esta pantalla consulta y despliega los datos almacenados en tiempo real desde Cloud Firestore, fomentando la competitividad.

---

## 🕹️ Instrucciones del Juego

El objetivo del juego es ser el primer jugador en conseguir alinear tres de tus símbolos (X o O) en el tablero.

**¿Cómo jugar?**
1. **Inicio de la partida:** El juego comienza con el tablero vacío. El Jugador 1 utiliza la "X" y es el primero en tirar.
2. **Turnos:** Los jugadores se turnan para tocar una casilla vacía en la cuadrícula de 3x3. Al tocar la casilla, esta se marcará con el símbolo del jugador en turno.
3. **Condición de Victoria:** Un jugador gana si logra colocar tres de sus símbolos en una línea continua. Esta línea puede ser:
   * Horizontal (en cualquiera de las 3 filas).
   * Vertical (en cualquiera de las 3 columnas).
   * Diagonal (de esquina a esquina).
4. **Empate:** Si las 9 casillas del tablero se llenan y ningún jugador ha logrado alinear tres símbolos, el juego termina en empate.
