# FROM alpine:latest

# RUN apk add --no-cache openssh-server 
# RUN mkdir /var/run/sshd 

# COPY ssh-user-auth.sh /usr/bin/ssh-user-auth.sh
# COPY entrypoint.sh /usr/bin/entrypoint.sh

# # WORKDIR /usr/bin/
# # COPY . /usr/bin/

# RUN ssh-keygen -A
# RUN echo "AuthorizedKeysCommand /usr/bin/ssh-user-auth.sh" >> /etc/ssh/sshd_config 
# RUN echo "AuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config 
# RUN echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config 
# RUN chmod 755 /usr/bin/ssh-user-auth.sh 
# RUN chmod 755 /usr/bin/entrypoint.sh

# EXPOSE 22

# ENTRYPOINT ["/usr/bin/entrypoint.sh"]
# # ENTRYPOINT ["sh"]



FROM debian:bullseye-slim

ENV TERM=xterm-256color

COPY ssh-user-auth.sh /usr/bin/ssh-user-auth.sh
COPY entrypoint.sh /usr/bin/entrypoint.sh
COPY motd /home/motd

RUN apt-get -q update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		openssh-server netcat telnet curl \
	&& mkdir /var/run/sshd \
	&& mkdir /etc/ssh/config \
	&& echo "AuthorizedKeysCommand /usr/bin/ssh-user-auth.sh" >> /etc/ssh/sshd_config \
  	&& echo "AuthorizedKeysCommandUser nobody" >> /etc/ssh/sshd_config \
	&& echo "AcceptEnv *" >> /etc/ssh/sshd_config \
	&& echo "Banner /etc/ssh/config/banner" >> /etc/ssh/sshd_config \
	&& apt-get clean autoclean \
  	&& apt-get autoremove --yes \
  	&& rm -rf /var/lib/{apt,dpkg,cache,log}/ \
	&& chmod 755 /usr/bin/ssh-user-auth.sh \
	&& chmod 755 /usr/bin/entrypoint.sh

RUN ssh-keygen -A

EXPOSE 22

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
