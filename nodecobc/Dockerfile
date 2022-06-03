FROM fedora 

RUN yum -y update
RUN yum -y upgrade
RUN yum -y install nodejs
RUN yum -y install automake autoconf make 
RUN yum -y install gcc g++ git
RUN yum -y install libpq-devel
RUN yum -y install libtool
RUN yum -y install gnucobol

WORKDIR /tmp

RUN git clone https://github.com/opensourcecobol/Open-COBOL-ESQL.git
WORKDIR /tmp/Open-COBOL-ESQL
RUN export CPPFLAGS="-I/usr/include"
RUN export LDFLAGS="-L/usr/lib"
RUN autoreconf -f -i
RUN ./configure
RUN make 
RUN make install 


WORKDIR /usr/src/app
EXPOSE 8080

RUN mv /tmp/Open-COBOL-ESQL/copy/ /usr/src/ocesql-copy
RUN echo 'export CPPFLAGS="-I/usr/include"' >> ~/.bashrc
RUN echo 'export LDFLAGS="-L/usr/lib"' >> ~/.bashrc
RUN echo "export COBCPY=/usr/src/ocesql-copy" >> ~/.bashrc

ENTRYPOINT ["tail", "-f", "/dev/null"]
