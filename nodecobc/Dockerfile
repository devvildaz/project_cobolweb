FROM ubuntu:20.04


RUN apt-get update -y && apt-get upgrade -y && \
 apt-get -y install gcc 
RUN apt-get -y install make 
RUN apt-get -y install libgmp3-dev
RUN apt-get -y install curl 
RUN apt-get -y install wget

WORKDIR /tmp

RUN  wget --no-check-certificate https://ufpr.dl.sourceforge.net/project/gnucobol/gnucobol/3.1/gnucobol-3.1.2.tar.gz
RUN tar xvf gnucobol-3.1.2.tar.gz

WORKDIR /tmp/gnucobol-3.1.2
RUN ./configure --without-db

RUN make 
RUN make install
RUN ldconfig 

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt -y install nodejs

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080
CMD ["npm", "run", "dev"]