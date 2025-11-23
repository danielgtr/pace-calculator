# Pace Calculator - Guía Completa de la Aplicación

## Descripción General

**Pace Calculator** es una aplicación nativa para iOS diseñada específicamente para corredores que necesitan calcular y planificar sus entrenamientos y carreras. La aplicación convierte entre pace (ritmo), velocidad y tiempo de manera bidireccional, permitiendo a los atletas planificar estratégicamente sus objetivos de carrera.

La app está completamente en español y está optimizada para corredores de todos los niveles, desde principiantes hasta atletas de competencia que buscan alcanzar tiempos específicos en carreras.

---

## Filosofía de Diseño

- **Simplicidad primero**: Interfaz limpia y directa, sin funciones redundantes
- **Flexibilidad de unidades**: Soporte completo para kilómetros y millas
- **Resultados inmediatos**: Cálculos instantáneos con animaciones fluidas
- **Enfoque práctico**: Diseñada para uso real durante planificación de entrenamientos

---

## Funcionalidades Principales

### 1. Convertidor de Pace (Tab Principal)

El **Convertidor de Pace** es una herramienta bidireccional que permite conversiones entre pace y velocidad en dos modos distintos:

#### Modo: Pace
**Entrada:**
- Minutos y segundos (selectores tipo rueda)
- Unidad de pace: min/km o min/mi

**Salida:**
- Pace en min/km
- Pace en min/mi (calculado automáticamente)
- Velocidad en km/h
- Velocidad en mph

**Ejemplo de uso:**
Si corres a un pace de 5:00 min/km, la app te mostrará:
- Pace min/km: 5:00
- Pace por milla: 8:03
- Velocidad: 12.0 km/h
- Velocidad: 7.5 mph

**Caso de uso práctico:**
Útil cuando conoces tu pace de entrenamiento y quieres saber a qué velocidad configurar la caminadora en el gimnasio.

#### Modo: Velocidad (km/h)
**Entrada:**
- Velocidad en km/h (campo de texto numérico grande para fácil lectura)

**Salida:**
- Pace en min/km
- Pace en min/mi
- Velocidad en km/h (confirmación)
- Velocidad en mph

**Ejemplo de uso:**
Si la caminadora del gimnasio está configurada a 12 km/h, la app te mostrará:
- Pace min/km: 5:00
- Pace por milla: 8:03
- Confirma la velocidad en km/h y mph

**Caso de uso práctico:**
Ideal cuando estás en el gimnasio y la caminadora solo muestra km/h, pero tú entrenas pensando en pace (min/km).

**Características especiales:**
- Cambio de modo mediante selector segmentado
- Teclado numérico optimizado para entrada rápida
- Dismissal automático del teclado al presionar "Convertir"
- Resultados con gradientes visuales llamativos
- Validación de entrada en tiempo real

---

### 2. Tiempo Meta → Pace (Tab Secundario)

El **Calculador de Tiempo Meta** es la herramienta más poderosa de la app. Te permite calcular el pace exacto que necesitas mantener para alcanzar un tiempo objetivo en cualquier distancia.

#### Entradas:

**Distancia:**
- Campo numérico personalizable
- Selector de unidad: km o mi
- Botón de distancias preestablecidas:
  - 5K (5.0 km / 3.1 mi)
  - 10K (10.0 km / 6.2 mi)
  - Media Maratón (21.0975 km / 13.1 mi)
  - Maratón (42.195 km / 26.2 mi)
  - 50K (50.0 km / 31.1 mi)
  - 100K (100.0 km / 62.1 mi)

**Tiempo Meta:**
- Selectores de rueda para horas, minutos y segundos
- Rango: 0-23 horas, 0-59 minutos, 0-59 segundos

**Unidad de Pace:**
- Selector para min/km o min/mi
- Determina en qué unidad se mostrará el pace necesario

#### Salidas:

**Pace Necesario (Display principal):**
- Número grande y destacado (48pt) en color verde
- Mostrado en la unidad seleccionada (min/km o min/mi)

**Información Adicional:**
- Distancia exacta en la unidad elegida
- Tiempo meta confirmado en formato HH:MM:SS
- **Velocidad caminadora**: km/h exactos (destacado) - crucial para entrenar en gimnasio
- Velocidad en mph

**Botón de Acción:**
- "Ver Splits de Carrera" → Navega a la calculadora de splits

#### Ejemplo Real:

**Objetivo: Correr un maratón sub-4 horas**

Entradas:
- Distancia: 42.195 km (seleccionado de preset "Maratón")
- Tiempo meta: 3h 59m 59s
- Mostrar pace en: min/km

Resultados:
- **Pace necesario: 5:41 min/km**
- Distancia: 42.19 km
- Tiempo meta: 3:59:59
- Velocidad caminadora: **10.5 km/h** ← configuración exacta para entrenar
- Velocidad: 6.5 mph

**Caso de uso:**
Con estos resultados, sabes que debes:
1. Mantener un pace de 5:41 min/km durante toda la carrera
2. Entrenar en la caminadora a 10.5 km/h para simular el pace de carrera
3. Poder dividir la carrera en splits específicos (ver siguiente sección)

**Características especiales:**
- Banner informativo verde con icono de objetivo
- Pills horizontales para distancias comunes
- Dismissal automático del teclado
- Gradientes visuales para resultados
- Validación automática de entradas

---

### 3. Splits de Carrera (Integrado en Tiempo Meta)

Los **Splits de Carrera** son una característica avanzada que te permite dividir tu carrera en segmentos iguales para monitorear tu progreso durante el evento.

**Acceso:**
- Desde el tab "Tiempo Meta", después de calcular un pace necesario
- Presionar el botón "Ver Splits de Carrera"

#### Configuración:

**Heredado automáticamente:**
- Distancia total de la carrera
- Pace calculado
- Unidad de pace (min/km o min/mi)
- Unidad de distancia (km o mi)

**Intervalo de Split:**
- **Automático por defecto**: 1 km o 1 milla (según unidad de distancia)
- **Personalizable**: Campo de texto para cambiar intervalo
- Opciones comunes sugeridas: 1, 5, o 10 unidades
- Sección colapsable "Cambiar intervalo" para mantener UI limpia

#### Tabla de Splits:

**Columnas:**
1. **Distancia**: Distancia acumulada hasta ese split (ej: 5.0 km, 10.0 km)
2. **Split**: Tiempo para completar ese segmento individual
3. **Acumulado**: Tiempo total transcurrido hasta ese punto (destacado en verde)

**Características visuales:**
- Filas alternadas (gris/blanco) para fácil lectura
- Números en fuente monoespaciada para alineación
- Header fijo con nombres de columnas
- Contador de splits total
- Gradiente de fondo verde/azul

#### Ejemplo: Maratón con splits cada 5K

**Configuración:**
- Distancia: 42.195 km
- Pace: 5:41 min/km
- Intervalo: 5 km

**Resultado de Splits:**

| Distancia | Split   | Acumulado |
|-----------|---------|-----------|
| 5.0 km    | 28:25   | 28:25     |
| 10.0 km   | 28:25   | 56:50     |
| 15.0 km   | 28:25   | 1:25:15   |
| 20.0 km   | 28:25   | 1:53:40   |
| 25.0 km   | 28:25   | 2:22:05   |
| 30.0 km   | 28:25   | 2:50:30   |
| 35.0 km   | 28:25   | 3:18:55   |
| 40.0 km   | 28:25   | 3:47:20   |
| 42.2 km   | 6:15    | 3:53:35   |

**Interpretación:**
- Cada 5K debes pasar en aproximadamente 28:25
- En el kilómetro 20 (mitad del maratón) deberías llevar 1:53:40
- El último segmento (2.2 km) debe completarse en 6:15

**Caso de uso práctico:**
Durante la carrera, al pasar cada marca de 5K, puedes verificar si tu tiempo acumulado coincide con el planificado. Si llevas retraso o adelanto, puedes ajustar tu pace en consecuencia.

**Características especiales:**
- Cálculo automático al abrir la vista
- Recalculación instantánea al cambiar intervalo
- Dismissal automático del teclado al recalcular
- Banner informativo azul con intervalo actual
- Animaciones suaves al expandir/colapsar opciones

---

## Precisión de Cálculos

### Fórmulas Utilizadas:

**Pace a Velocidad:**
```
velocidad (km/h) = 3600 / pace (segundos por km)
```

**Velocidad a Pace:**
```
pace (segundos por km) = 3600 / velocidad (km/h)
```

**Conversión km ↔ millas:**
```
1 milla = 1.609344 km
1 km = 0.621371 millas
```

**Pace de Tiempo Meta:**
```
pace por km = tiempo total (segundos) / distancia (km)
```

**Tiempo de Split:**
```
tiempo de split = distancia del segmento (km) × pace (segundos por km)
```

### Precisión:
- Cálculos en punto flotante de 64 bits (Double)
- Velocidades redondeadas a 1 decimal (ej: 12.0 km/h)
- Tiempos en formato MM:SS o HH:MM:SS
- Conversiones de unidades con constantes precisas

---

## Casos de Uso Reales

### Caso 1: Preparación para Maratón
**Situación:** Quieres correr un maratón en menos de 4 horas.

**Pasos:**
1. Ir a "Tiempo Meta"
2. Seleccionar "Maratón" (42.195 km) de los presets
3. Configurar tiempo: 3h 59m 59s
4. Seleccionar "min/km"
5. Presionar "Calcular Pace"

**Resultado:** Pace necesario de 5:41 min/km

**Siguiente paso:**
6. Presionar "Ver Splits de Carrera"
7. Configurar intervalo de 5 km
8. Imprimir o fotografiar la tabla de splits para llevar el día de la carrera

---

### Caso 2: Entrenamiento en Caminadora
**Situación:** Tu plan de entrenamiento dice "correr 10K a pace 5:30 min/km" pero la caminadora solo muestra km/h.

**Pasos:**
1. Ir a "Convertidor"
2. Modo "Pace"
3. Configurar 5 minutos, 30 segundos
4. Unidad: min/km
5. Presionar "Convertir"

**Resultado:** Velocidad caminadora: 10.9 km/h

**Acción:** Configurar la caminadora a 10.9 km/h y correr durante el tiempo planificado.

---

### Caso 3: Análisis de Carrera Pasada
**Situación:** Corriste un 10K en 52 minutos y quieres saber tu pace promedio.

**Pasos:**
1. Ir a "Tiempo Meta"
2. Seleccionar "10K" o ingresar 10 km
3. Configurar tiempo: 0h 52m 00s
4. Seleccionar "min/km"
5. Presionar "Calcular Pace"

**Resultado:** Tu pace promedio fue 5:12 min/km a una velocidad de 11.5 km/h

---

### Caso 4: Comparación de Velocidades
**Situación:** Estás en un gimnasio en EE.UU. donde la caminadora muestra mph, pero tú estás acostumbrado a pensar en km/h.

**Pasos:**
1. Ir a "Convertidor"
2. Modo "Velocidad"
3. Ingresar tu velocidad preferida: 12 km/h
4. Presionar "Convertir"

**Resultado:**
- Pace: 5:00 min/km
- Velocidad mph: 7.5 mph ← configurar la caminadora a esto

---

## Unidades y Flexibilidad

### Sistema de Unidades:

La app maneja dos conceptos de unidad independientes:

1. **Unidad de Distancia** (DistanceUnit)
   - Kilómetros (km)
   - Millas (mi)
   - Usado para: distancias de carrera, intervalos de splits

2. **Unidad de Pace** (PaceUnit)
   - Minutos por kilómetro (min/km)
   - Minutos por milla (min/mi)
   - Usado para: mostrar el ritmo de carrera

### Independencia de Unidades:

**Importante:** Puedes mezclar unidades como desees.

**Ejemplos válidos:**
- Distancia en **millas**, pace mostrado en **min/km**
- Distancia en **km**, pace mostrado en **min/mi**

**Por qué es útil:**
Si vives en EE.UU. y corres carreras en millas, pero entrenas pensando en min/km, puedes usar ambas unidades simultáneamente.

---

## Detalles Técnicos

### Arquitectura:
- **Framework:** SwiftUI
- **Plataforma:** iOS 16.0+
- **Patrón:** MVVM ligero con @State
- **Navegación:** TabView + NavigationView/NavigationLink

### Estructura del Código:

**Models:**
- `PaceCalculator.swift`: Lógica de cálculo pura (funciones estáticas)
  - `convertPace()`: pace → velocidad
  - `convertSpeedToPace()`: velocidad → pace
  - `calculatePaceFromGoalTime()`: distancia + tiempo → pace
  - `calculateSplits()`: genera tabla de splits

**Views:**
- `ContentView.swift`: TabView principal (2 tabs)
- `PaceConverterView.swift`: Convertidor bidireccional
- `GoalTimeView.swift`: Calculador de tiempo meta
- `RaceSplitsView.swift`: Tabla de splits de carrera

**Components:**
- `ResultRow`: Componente reutilizable para mostrar resultados clave-valor

### Gestión de Estado:
- `@State`: Para datos locales de cada vista
- `@FocusState`: Para manejo de teclado
- Navegación por valor (no por referencia)

### UX Features:
- Animaciones suaves (spring animations)
- Gradientes visuales para destacar resultados
- Teclado numérico optimizado (.decimalPad)
- Dismissal automático de teclado en botones de acción
- Pickers tipo rueda para tiempo
- Pills horizontales para distancias comunes

---

## Limitaciones Actuales

1. **Sin historial:** No guarda cálculos previos
2. **Sin perfiles:** No permite guardar configuraciones de usuario
3. **Sin integración:** No se conecta con apps de fitness (Strava, Garmin, etc.)
4. **Solo offline:** No requiere internet, pero tampoco sincroniza datos

**Nota:** Estas limitaciones son intencionales para mantener la app simple y directa.

---

## Próximas Mejoras Potenciales

1. **Guardado de carreras favoritas**
   - Guardar configuraciones de carrera
   - Historial de cálculos

2. **Exportación de splits**
   - Exportar tabla como imagen
   - Compartir por WhatsApp/Email

3. **Calculadora de pace ajustado**
   - Calcular pace equivalente en terreno inclinado
   - Ajustes por altitud

4. **Modo oscuro**
   - Ya soportado por SwiftUI
   - Requiere testing de colores

5. **Widget iOS**
   - Conversión rápida desde home screen
   - Complicación para Apple Watch

---

## Público Objetivo

### Corredores Principiantes:
- Aprenden a entender pace vs. velocidad
- Planifican su primera carrera 5K o 10K
- Descubren cómo entrenar en caminadora

### Corredores Intermedios:
- Planifican tiempos meta realistas
- Usan splits para estrategia de carrera
- Entrenan con precisión en gimnasio

### Corredores Avanzados/Competitivos:
- Calculan paces exactos para BQ (Boston Qualifier)
- Planifican estrategias de negative splits
- Ajustan entrenamientos según zonas de ritmo

### Entrenadores:
- Asignan paces específicos a atletas
- Crean planes de entrenamiento con velocidades exactas
- Enseñan conceptos de pace a corredores nuevos

---

## Ventajas sobre Otras Apps

1. **Simplicidad brutal:** Solo hace lo esencial, sin distracciones
2. **Offline completo:** No requiere cuenta, login, ni internet
3. **Bidireccional:** Convierte en ambas direcciones (pace ↔ velocidad)
4. **Splits integrados:** No necesitas otra app para calcular splits
5. **Español nativo:** Diseñada para mercado hispanohablante
6. **Velocidad caminadora:** Enfoque en utilidad práctica de gimnasio
7. **Sin anuncios:** Experiencia limpia y profesional

---

## Resumen Ejecutivo

**Pace Calculator** es una herramienta de cálculo de pace para corredores que elimina la fricción entre diferentes sistemas de medición (pace, velocidad, tiempo, distancia).

**Valor principal:** Responde instantáneamente preguntas como:
- ¿A qué velocidad configuro la caminadora para mi pace objetivo?
- ¿Qué pace necesito para lograr mi tiempo meta?
- ¿Cada cuánto debo pasar las marcas de kilómetros en mi carrera?

**Diferenciador:** Simplicidad extrema con cálculos precisos, sin funciones innecesarias que compliquen la experiencia.

**Target:** Cualquier corredor que entrene con objetivos de tiempo específicos, desde 5K hasta ultramaratones.
