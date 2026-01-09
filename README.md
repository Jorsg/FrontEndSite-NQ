# Sitio Web Multilingüe - Natalia Quintero

## 📁 Estructura del Proyecto

```
website/
├── index.html          # Versión en español (raíz del sitio)
├── styles.css          # Estilos CSS compartidos
├── script.js           # JavaScript compartido
├── assets/             # Carpeta para imágenes y recursos
│   └── logo.png        # Tu logo aquí
├── en/                 # Versión en inglés
│   └── index.html
└── fr/                 # Versión en francés
    └── index.html
```

## 🌐 URLs del Sitio

- **Español** (por defecto): `https://tusitio.com/`
- **Inglés**: `https://tusitio.com/en/`
- **Francés**: `https://tusitio.com/fr/`

## ✅ Ventajas de esta Estructura

### 1. **SEO Optimizado**
- URLs únicas para cada idioma
- Etiquetas `hreflang` correctamente implementadas
- Google puede indexar cada versión por separado
- Mejores rankings en búsquedas locales

### 2. **URLs Compartibles**
- Cada idioma tiene su propia URL
- Los usuarios pueden compartir enlaces específicos
- Los marcadores funcionan correctamente

### 3. **Fácil de Mantener**
- Un archivo CSS compartido
- Un archivo JavaScript compartido
- Actualiza estilos una vez, aplica a todos los idiomas

### 4. **Profesional**
- Estructura estándar de la industria
- Compatible con cualquier hosting
- Fácil de expandir a más idiomas

## 🚀 Cómo Usar

### 1. Preparar tus Archivos

1. **Coloca tu logo:**
   - Crea una carpeta `assets/` en la raíz
   - Guarda tu logo como `logo.png`
   - O actualiza las rutas en los HTML

2. **Actualiza el dominio:**
   - Busca `https://tusitio.com` en todos los archivos HTML
   - Reemplázalo con tu dominio real

3. **Personaliza la información:**
   - Email: `contact@nataliaquintero.com`
   - Teléfono: `+1 (555) 123-4567`
   - Horarios
   - Links de redes sociales

### 2. Subir a tu Hosting

**Opción A: Hosting tradicional (cPanel, FTP)**
```
- Sube toda la carpeta website/ a tu servidor
- La estructura de carpetas debe mantenerse igual
- Asegúrate que index.html esté en la raíz
```

**Opción B: Netlify / Vercel (recomendado para principiantes)**
```
1. Crea cuenta en Netlify.com
2. Arrastra la carpeta website/
3. ¡Listo! Tu sitio está online
```

**Opción C: GitHub Pages**
```
1. Crea repositorio en GitHub
2. Sube los archivos
3. Activa GitHub Pages en Settings
```

### 3. Configurar el Dominio

En tu proveedor de hosting o DNS:
```
- Apunta tu dominio a tu servidor
- No necesitas subdominios
- Las carpetas /en/ y /fr/ funcionan automáticamente
```

## 🔧 Personalización

### Cambiar Colores

Edita `styles.css`, líneas 1-7:
```css
:root {
    --azul-profundo: #1F3B57;
    --verde-esmeralda: #2F5B4A;
    --blanco-marfil: #F9F7F1;
    --blanco-suave: #F2EFE8;
    --dorado-calido: #D1A741;
}
```

### Agregar más Secciones

1. Copia una sección existente en el HTML
2. Modifica el contenido
3. Repite en los 3 archivos (es, en, fr)

### Agregar más Idiomas

1. Crea nueva carpeta (ej: `/de/` para alemán)
2. Copia `en/index.html`
3. Traduce el contenido
4. Actualiza los botones de idioma en todos los archivos

## 📧 Formulario de Contacto

El formulario actualmente muestra un mensaje de alerta. Para hacerlo funcional:

**Opción 1: FormSubmit.co (Gratis, sin servidor)**
```html
<form action="https://formsubmit.co/tu@email.com" method="POST">
```

**Opción 2: Netlify Forms (si usas Netlify)**
```html
<form name="contact" method="POST" data-netlify="true">
```

**Opción 3: EmailJS (JavaScript)**
- Crea cuenta en EmailJS.com
- Sigue su guía de integración

## 🔍 SEO Checklist

- [ ] Actualiza todos los `<title>` con palabras clave relevantes
- [ ] Actualiza todas las meta descriptions
- [ ] Verifica que todas las URLs en hreflang sean correctas
- [ ] Agrega un archivo sitemap.xml
- [ ] Agrega Google Analytics
- [ ] Registra tu sitio en Google Search Console
- [ ] Crea un archivo robots.txt

## 📱 Testing

Antes de lanzar, verifica:

1. **Desktop**: Abre en Chrome, Firefox, Safari
2. **Mobile**: Prueba en tu teléfono
3. **Idiomas**: 
   - Click en ES/EN/FR funciona
   - Cada URL muestra el idioma correcto
4. **Formulario**: Envía un mensaje de prueba
5. **Links**: Verifica que todos los enlaces internos funcionan

## 🆘 Soporte

Si necesitas ayuda:

1. **Hosting**: Contacta a tu proveedor
2. **HTML/CSS**: W3Schools.com
3. **SEO**: Moz.com, Search Engine Journal
4. **Formularios**: Documentación de FormSubmit o Netlify

## 📈 Próximos Pasos Recomendados

1. **Analytics**: Instala Google Analytics
2. **Blog**: Agrega una sección de blog funcional
3. **CMS**: Considera migrar a WordPress o un CMS moderno
4. **Certificado SSL**: Asegúrate de tener HTTPS
5. **Velocidad**: Optimiza imágenes con TinyPNG
6. **Backup**: Haz copias de seguridad regulares

## 🎨 Recursos de Imágenes Recomendados

Como te mencioné antes:
- **Unsplash.com** - Fotos profesionales gratis
- **Pexels.com** - Gran variedad
- **Pixabay.com** - Millones de imágenes

Busca: "professional translation", "documents", "graduation", "travel"

---

**¡Éxito con tu sitio web profesional!** 🚀
