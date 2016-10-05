FROM ubuntu:14.04

RUN apt-get update && apt-get install -y wget fontconfig pkgconf libatk1.0-dev libpango1.0-dev libglib2.0-dev libgtk2.0-dev m4

RUN mkdir /usr/local/Tina6
WORKDIR /usr/local/Tina6
RUN wget http://www.tina-vision.net/tarballs/tina-tools-6.0rcbuild010.tar.gz
RUN wget http://www.tina-vision.net/tarballs/tina-libs-6.0rcbuild010.tar.gz
RUN wget http://www.tina-vision.net/tarballs/manual_landmark_tool/volpack-1.0c7-2.tar.gz
RUN wget http://www.tina-vision.net/tarballs/manual_landmark_tool/max_planck_toolkit-2.0.tar.gz

RUN tar xzfv tina-libs-6.0rcbuild010.tar.gz
RUN tar xzfv tina-tools-6.0rcbuild010.tar.gz
RUN tar xzfv volpack-1.0c7-2.tar.gz
RUN tar xzfv max_planck_toolkit-2.0.tar.gz

WORKDIR /usr/local/Tina6/tina-libs-6.0rcbuild010
RUN ./configure && make && make install
WORKDIR /usr/local/Tina6/tina-tools-6.0rcbuild010
RUN ./configure && make && make install
WORKDIR /usr/local/Tina6/volpack-1.0c7-2
RUN ./configure && make && make install
RUN ldconfig
WORKDIR /usr/local/Tina6/max_planck_toolkit-2.0
RUN ./configure \
    --with-tina-includes=/usr/local/Tina6/tina-libs-6.0rcbuild010 \
    --with-tina-libraries=/usr/local/Tina6/tina-libs-6.0rcbuild010/lib \
    --with-tinatool-includes=/usr/local/Tina6/tina-tools-6.0rcbuild010 \
    --with-tinatool-libraries=/usr/local/Tina6/tina-tools-6.0rcbuild010/lib \
    --with-volpack-library=/usr/local/lib \
    --with-volpack-include=/usr/local/include
RUN make && make install
RUN ln -s /usr/local/Tina6/max_planck_toolkit-2.0/src/tinaTool /usr/bin/tinaTool

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
               mkdir -p /home/developer && \
               echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
               echo "developer:x:${uid}:" >> /etc/group && \
               echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
               chmod 0440 /etc/sudoers.d/developer && \
               chown ${uid}:${gid} -R /home/developer

USER developer
ENV HOME /home/developer
CMD /usr/bin/tinaTool
