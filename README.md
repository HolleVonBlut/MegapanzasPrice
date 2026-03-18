🛡️ Megapanzas Raid & Economy Analyzer
Megapanzas es un ecosistema de herramientas diseñado para Turtle WoW (o servidores 1.12.1) que permite auditar el consumo de una raid y cruzarlo con los precios reales del mercado mediante un escaneo de la Casa de Subastas.

👨‍💻 Créditos y Desarrollo
Addon Lua: Desarrollado íntegramente por Holle.

Analizador HTML: Estructura base por SpaceSoul.

Gráficos e Interfaz: Lógica de visualización (barras horizontales/verticales), actualización de datos y sincronización de precios desarrollada por Holle.

🔌 El Addon: MegapanzasPrice (Lua)
Este componente se encarga de extraer la información económica directamente desde el juego.

⌨️ Comandos
/mp scan - Inicia el escaneo automático de los consumibles.

⚠️ Reglas críticas para un escaneo exitoso
Ventana de Subasta: Debes mantener la ventana de la Casa de Subastas ABIERTA. Si la cierras, el motor de WoW detendrá el escaneo y los datos serán inconsistentes.

No interrumpir: El addon procesa más de 66 ítems uno por uno. El chat te avisará el progreso (ej. [10/66]).

Guardado de datos: Al terminar, el chat mostrará "Escaneo finalizado". ES OBLIGATORIO ejecutar el comando /reload o cerrar el juego para que WoW escriba la tabla de precios en el disco duro.

🔍 Control de Integridad
El addon genera una etiqueta de estado dentro del archivo de datos:

status = "complete": El escaneo terminó correctamente.

status = "incomplete": El escaneo fue interrumpido (el HTML te avisará de esto).

📊 El Analizador: Consumible Analyzer (HTML)
Una herramienta web interactiva para visualizar los costos de la raid.

Funcionalidades Principales:
Gráficos Dinámicos: Visualización de gastos por jugador mediante gráficos de barras (Chart.js).

Jerarquía de Precios: El sistema calcula el oro total siguiendo este orden de prioridad:

Precio Manual: (Editado por ti en el HTML).

Precio de Addon: (Escaneado con /mp).

Precio por Defecto: (Base de datos interna).

Detección de Stock: Si el addon detectó que un ítem no estaba disponible en la subasta (valor -1), la fila se resaltará en AMARILLO automáticamente en el editor.

🔄 Guía de Sincronización
En WoW: Realiza el escaneo con /mp scan y guarda con /reload.

Archivo de Datos: Localiza tu base de datos en:

Directorio_WoW > WTF > Account > [TU_CUENTA] > SavedVariables > MegapanzasPrice.lua

En el HTML:

Carga tu log de combate (Wow.txt).

Arrastra o selecciona el archivo MegapanzasPrice.lua en la sección de "Cargar Datos del Addon".

Resultado: Los precios se actualizarán al valor real de tu servidor y los gráficos se recalcularán al instante.

Nota técnica: El sistema incluye normalización de nombres para corregir errores comunes en logs como los apóstrofes en objetos tipo Medivh's Merlot o consumibles personalizados de Turtle WoW.
