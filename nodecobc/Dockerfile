FROM ubuntu:18.04


RUN apt update
RUN apt -y install gcc make libgmp3-dev

RUN apt -y install curl 
RUN apt -y install wget

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