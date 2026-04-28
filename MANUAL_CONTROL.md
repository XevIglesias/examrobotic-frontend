# 🛠️ Manual de Control y Credenciales: ExamRobotic

Este documento contiene la información crítica necesaria para administrar y mantener la plataforma **ExamRobotic**. Como profesional de la Automatización Industrial, este es tu "cuadro de mando" técnico.

---

## 🌐 1. URLs de Acceso y Gestión

| Recurso | URL / Ruta | Propósito |
| :--- | :--- | :--- |
| **Plataforma Web** | [https://examrobotic.com](https://examrobotic.com) | Acceso público para usuarios y realización de tests. |
| **Repositorio GitHub** | [XevIglesias/examrobotic-frontend](https://github.com/XevIglesias/examrobotic-frontend) | Control de código fuente, historial de cambios y despliegue. |
| **API Backend** | `https://api.examrobotic.com/api` | Punto de conexión para guardar intentos, usuarios y estadísticas. |
| **Panel de Perfil** | `/perfil.html` | Visualización de progreso y estadísticas del usuario actual. |

---

## 🗄️ 2. Estructura de la "Base de Datos"

La plataforma utiliza un sistema híbrido para gestionar los datos:

### A. Banco de Preguntas (Estático)
Las preguntas de los tests NO están en una base de datos SQL tradicional, sino en archivos JavaScript para garantizar **velocidad máxima** y carga offline.
- **Ubicación en el código:** `data/`
- **Organización:** Cada carpeta representa una asignatura (ej: `adiple/`, `dt/`) y cada archivo un tema (`t1.js`, `t2.js`).
- **Cómo editar:** Puedes abrir estos archivos con cualquier editor de texto para añadir o corregir preguntas.

### B. Datos de Usuario y Progreso (Dinámico)
- **Persistencia Local:** El progreso de los temas (candados) se guarda en el `localStorage` del navegador del usuario.
- **Sincronización Cloud:** Los resultados de los exámenes se envían a la API para que no se pierdan si el usuario cambia de dispositivo.

---

## 🔑 3. Credenciales Sugeridas

> [!IMPORTANT]
> Por seguridad, nunca guardes contraseñas en texto plano. Utiliza un gestor de contraseñas.

*   **Administración GitHub:** Acceso con tu cuenta de XevIglesias.
*   **Dominio/Hosting:** Gestionado a través de tu proveedor de DNS/Hosting.
*   **API / Base de Datos Cloud:** Gestionada bajo el dominio `examrobotic.com`.

---

## 📂 4. Directorios Clave del Proyecto

Si necesitas realizar cambios estructurales, estas son las carpetas que debes conocer:

1.  `/assets/css/`: Estilos globales y específicos del quiz.
2.  `/assets/js/`: Lógica del motor de exámenes (`quiz-engine.js`) y conexión con servidor (`api.js`).
3.  `/asignaturas/`: Páginas HTML que contienen la interfaz de cada asignatura.
4.  `/data/`: **El corazón de la plataforma.** Aquí residen las miles de preguntas.

---

## 🚀 5. Flujo de Trabajo Profesional

Para subir cambios a la web, siempre sigue estos pasos en tu terminal:

1.  `git add .` (Prepara los cambios)
2.  `git commit -m "Descripción del cambio"` (Etiqueta el cambio)
3.  `git push origin main` (Sube los cambios a la nube)

---

## 🔑 6. Gestión de Usuarios y Servidor (Backend)

Para tener control sobre quién se registra y ver las estadísticas reales, debes acceder al **Backend**:

### A. Acceso al Panel (EasyPanel)
- Si tu servidor usa **EasyPanel**, accede a través de la URL de administración que te proporcionó tu proveedor (habitualmente en el puerto `:port`).
- Desde allí puedes monitorizar si el servicio de la API está online o si hay errores de conexión.

### B. Base de Datos (MySQL/PostgreSQL)
- Los usuarios **NO** están en los archivos `.js` de la web.
- Debes entrar en el servicio de Base de Datos de tu panel para ver las tablas `users` y `attempts`.
- **Contraseñas:** Por seguridad, las contraseñas están "hasheadas" (encriptadas). No se pueden leer directamente, lo cual es el estándar profesional de seguridad.

### C. Depuración de la API
- Si los tests no se guardan o el login falla, el primer lugar donde mirar es `assets/js/api.js` para asegurar que la constante `API` apunta a la dirección correcta.

---

> [!TIP]
> Puedes imprimir este documento como **PDF** pulsando `Ctrl + P` en tu navegador o exportándolo desde tu editor de texto para tener una copia física de seguridad.
