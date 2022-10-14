# from base image node
FROM ubuntu:20.04

LABEL "about"="the label was set using dockfile label instruction"

RUN apt update && apt install -y nginx

WORKDIR /project

ADD index.html .

RUN cat index.html > /var/www/html/index.nginx-debian.html

CMD ["bash"]

EXPOSE 8081
