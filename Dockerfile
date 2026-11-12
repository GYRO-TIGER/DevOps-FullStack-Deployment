FROM node:18-alpine AS client-build
WORKDIR /app/client

COPY client/package*.json ./
RUN npm ci

COPY client/ ./
RUN npm run build

FROM node:18-alpine AS server-build
WORKDIR /app/server

COPY server/package*.json ./
RUN npm ci 

COPY server/ ./
RUN npm run build

FROM node-18:alpine AS production
WORKDIR /app

ENV NODE_ENV=production

WORKDIR /app/server
COPY server/package*.json ./
RUN npm ci --omit==dev

COPY --from=server-build /app/server/dist ./dist

COPY --from=client-build /app/client/build ./build

EXPOSE 3000

CMD ['node','dist/index.js']