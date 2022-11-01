FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY nodejs-basic.conf /etc/nginx/conf.d 
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
