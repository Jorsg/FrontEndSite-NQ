FROM node:20-alpine

RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev

WORKDIR /srv/app

# Copiar archivos de configuración
COPY package.json ./

# Instalar dependencias (omitir paquetes opcionales para acelerar)
RUN npm install --prefer-offline

# Copiar el resto del proyecto
COPY . .

# Crear directorio temporal
RUN mkdir -p .tmp

# Build del admin UI (se hace en el build de la imagen, no en runtime)
ENV NODE_ENV=production
RUN npm run build

EXPOSE 1337

CMD ["npm", "run", "start"]
