FROM nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /etc/nginx/html/ 
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
