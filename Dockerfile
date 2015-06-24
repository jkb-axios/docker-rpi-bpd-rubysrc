# Pull base image
FROM kipp/rpi-buildpack-deps:v2
MAINTAINER Kipp Bowen <kipp.bowen@axiosengineering.com>

ADD ./ruby-1.9.3-p551.tar.gz /data/src/
RUN ls -l /data && ls -l /data/src
RUN cd /data/src/ruby-1.9.3-p551 && ./configure && make #install

RUN gem update \
    && gem install rubygems-update \
            bundler \
            json \
            awscli
#RUN /bin/bash -l -c "gem install rubygems-update bundler json awscli"

# pull soca git repo and apply patch, build, install
RUN mkdir -p /data/repos \
    && cd /data/repos \
    && git clone https://github.com/quirkey/soca.git soca \
    && cd /data/repos/soca \
    && git checkout v0.3.3
ADD ./fix_file_read.patch2 /data/repos/soca/fix_file_read.patch2
RUN cd /data/repos/soca && patch -p1 < fix_file_read.patch2
RUN cd /data/repos/soca && gem build soca.gemspec
RUN cd /data/repos/soca && gem install soca-*.gem

