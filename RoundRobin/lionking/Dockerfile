FROM node:alpine
RUN mkdir /lionking
WORKDIR /lionking
COPY ./lionking/package.json /lionking
RUN npm install
COPY ./lionking /lionking
CMD npm start run
EXPOSE 8080

