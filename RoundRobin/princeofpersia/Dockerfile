FROM node:alpine
RUN mkdir /princeofpersia
WORKDIR /princeofpersia
COPY ./princeofpersia/package.json /princeofpersia
RUN npm install
COPY ./princeofpersia /princeofpersia
CMD npm start run
EXPOSE 8080

