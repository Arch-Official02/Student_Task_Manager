# Use an official Node.js runtime as a parent image
FROM node:18-alpine

WORKDIR /app

COPY app/package*.json ./

RUN npm install

COPY app/ .

EXPOSE 5000

CMD ["npm", "start"]