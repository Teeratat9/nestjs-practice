# 1. Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# copy package files first
COPY package*.json ./

# install dependencies
RUN npm install -g @nestjs/cli
RUN npm install --legacy-peer-deps

# copy source code (ไม่รวม node_modules เพราะ .dockerignore กันไว้แล้ว)
COPY . .

# build NestJS project
RUN npm run build

# 2. Run stage
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
COPY --from=builder /app/dist ./dist

RUN npm install -g @nestjs/cli
RUN npm install --only=production --legacy-peer-deps

EXPOSE 3000

CMD ["node", "dist/main"]

