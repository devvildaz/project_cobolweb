FROM fedora 

RUN yum -y update
RUN yum -y upgrade
RUN yum -y install nodejs
RUN yum -y install automake autoconf make 
RUN yum -y install gcc g++ git
RUN yum -y install libpq-devel
RUN yum -y install libtool
RUN yum -y install libdb libdb-devel gmp-devel openssl

WORKDIR /tmp

RUN curl https://ufpr.dl.sourceforge.net/project/gnucobol/gnucobol/3.1/gnucobol-3.1.2.tar.gz -o gnucobol
RUN tar -xvf gnucobol

WORKDIR /tmp/gnucobol-3.1.2/
RUN ./configure
RUN make 
RUN sudo make install 
RUN sudo ldconfig
RUN export PATH=$PATH:/usr/local/bin/
RUN export LD_LIBRARY_PATH=/usr/local/lib
RUN echo 'export PATH=$PATH:/usr/local/bin/' >> ~/.bashrc
WORKDIR /tmp

RUN git clone https://github.com/opensourcecobol/Open-COBOL-ESQL.git
WORKDIR /tmp/Open-COBOL-ESQL
RUN export CPPFLAGS="-I/usr/include"
RUN export LDFLAGS="-L/usr/lib"
RUN export COBCPY=/usr/src/ocesql-copy
RUN autoreconf -f -i
RUN ./configure
RUN make 
RUN make install 


WORKDIR /usr/src/app
EXPOSE 8080

RUN echo "export COBCPY=/usr/src/ocesql-copy"
RUN mv /tmp/Open-COBOL-ESQL/copy/ /usr/src/ocesql-copy
RUN echo 'export CPPFLAGS="-I/usr/include"' >> ~/.bashrc
RUN echo 'export LDFLAGS=-L/usr/lib' >> ~/.bashrc
RUN echo "export COBCPY=/usr/src/ocesql-copy" >> ~/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/lib' >> ~/.bashrc

ENTRYPOINT ["tail", "-f", "/dev/null"]
