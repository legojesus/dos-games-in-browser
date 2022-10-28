FROM node:alpine
RUN mkdir /app
WORKDIR /app
COPY ./app/package.json /app
RUN npm install
COPY ./app /app
CMD ["npm", "start"]
EXPOSE 8080
