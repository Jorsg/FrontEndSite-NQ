FROM node:20-alpine

RUN apk update && apk add --no-cache build-base gcc autoconf automake zlib-dev libpng-dev vips-dev

WORKDIR /srv/app

# Copiar archivos de configuración
COPY package.json ./

# Instalar dependencias
RUN npm install

# Copiar el resto del proyecto
COPY . .

# Crear directorio temporal
RUN mkdir -p .tmp

EXPOSE 1337

CMD ["npm", "run", "develop"]
