# MegapanzasPrice - Turtle WoW 1.12

**Autor:** Holle (Addon & Interfaz/add functions html)
**Estructura Base HTML:** SpaceSoul
**Versión:** 2.0
**Servidor:** Turtle WoW (WoW vanilla 1.12.1)

---

## 📝 Descripción
**MegapanzasPrice** es un ecosistema de herramientas diseñado para auditar el consumo de una raid y cruzarlo con los precios reales del mercado. Combina un **Addon Lua** para el escaneo de la subasta y un **Analizador HTML** con gráficos dinámicos para la visualización de datos.

## 🛠 Instalación
1. **Cierra el juego** completamente.
2. Copia la carpeta `MegapanzasPrice` dentro de:  
   `World of Warcraft\Interface\AddOns\`.
3. Asegúrate de que el archivo `megapanzas_turtlewow_consumible_analyzer_v2.html` esté en la misma carpeta para fácil acceso.
4. Alternativamente puedes simplemente copiar el enlace de github en el launcher de turtle wow.

---

## 🔌 El Addon: MegapanzasPrice
El addon extrae la información económica directamente desde la Casa de Subastas (AH).

### Comandos de Chat
* `/mp`: Inicia el escaneo automático de los 66+ consumibles.

### ⚠️ Reglas Críticas de Escaneo
* **Ventana de Subasta:** Debes mantener la ventana de la subasta **ABIERTA**. Si la cierras, el motor de WoW interrumpirá el proceso y los datos serán inconsistentes.
* **No interrumpir:** El chat te avisará del progreso en tiempo real (ej. `[10/66]`).
* **Guardado de Datos:** Al terminar el escaneo, **DEBES** ejecutar el comando `/reload` o cerrar el juego. De lo contrario, WoW no escribirá los precios en el disco duro.

### 🔍 Estados de Integridad
El addon genera una etiqueta interna para que el HTML sepa si la data es fiable:

| Estado | Significado |
| :--- | :--- |
| **complete** | El escaneo terminó exitosamente los 66+ ítems. |
| **incomplete** | El escaneo se interrumpió o la ventana de AH se cerró antes de tiempo. |

---

## 📊 El Analizador: Consumible Analyzer (HTML)
Herramienta web interactiva para visualizar los costos de la raid procesando los logs de combate.

### Funcionalidades Principales
* **Gráficos Dinámicos:** Visualización de gastos por jugador mediante gráficos de barras horizontales y verticales.
* **Detección de Stock:** Si un ítem no estaba disponible en la subasta (valor `-1`), el editor de precios resaltará la fila en **AMARILLO** automáticamente.
* **Normalización de Nombres:** Corrección automática de apóstrofes y variaciones (ej: *Medivh's Merlot Blue Label* se sincroniza automáticamente con *Medivh's Merlot Blue*).

### ⚙️ Jerarquía de Precios
El sistema calcula el costo total siguiendo este orden de prioridad:
1. **Precio Manual:** El valor que tú escribas directamente en el HTML.
2. **Precio de Addon:** El valor recolectado con el comando `/mp`.
3. **Precio por Defecto:** Valores base preconfigurados en el código.

---

## 🔄 Guía de Sincronización

### Paso 1: En el Juego
Abre la Subasta y usa el comando `/mp`. Al terminar, usa `/reload` para asegurar el guardado de la tabla.

### Paso 2: Localizar el Archivo
Busca tu base de datos en la carpeta de tu cuenta:  
`WTF\Account\[TU_CUENTA]\SavedVariables\MegapanzasPrice.lua`

### Paso 3: Cargar en el HTML
1. Abre el archivo `.html` en tu navegador.
2. Carga tu **Log de combate** (`WoWCombatLog.txt`).
3. Arrastra el archivo `MegapanzasPrice.lua` al recuadro de "Cargar Datos del Addon".

---

## ❓ Solución de Problemas
* **El HTML no actualiza precios:** Asegúrate de haber hecho `/reload` en el juego antes de cargar el archivo `.lua`.
* **Items en Amarillo:** Significa que el addon no encontró ese objeto en la subasta durante el último escaneo (sin stock).
* **Error de Lectura:** Verifica que el archivo de log no esté vacío y que la carpeta del addon se llame exactamente `MegapanzasPrice`.

---
*MegapanzasPrice v2.0 - Hecho con ❤️ para la comunidad de Turtle WoW* uwu/
