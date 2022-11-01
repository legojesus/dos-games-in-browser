FROM node:alpine
RUN mkdir /doom
WORKDIR /doom
COPY ./doom/package.json /doom
RUN npm install
COPY ./doom /doom
CMD npm start run
EXPOSE 8080

