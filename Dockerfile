FROM opensuse:leap
MAINTAINER Jan-Simon Moeller <dl9pf@gmx.de>

# Install packages
RUN zypper ref && zypper --non-interactive -v dup
RUN sudo zypper --non-interactive -y install python gcc gcc-c++ git chrpath make wget python-xml \
     diffstat makeinfo python-curses patch socat libSDL-devel xterm mc cpio file
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config


ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV AUTHORIZED_KEYS **None**

# Set user jenkins to the image
RUN adduser --quiet jenkins && echo "jenkins:jenkinspass" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

#EXPOSE 22
#CMD ["bash"]
