FROM node:alpine
RUN mkdir /app
WORKDIR /app
COPY ./app/package.json /app
RUN npm install
COPY ./app /app
CMD npm start run
EXPOSE 8080

