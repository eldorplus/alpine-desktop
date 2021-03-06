FROM alpine:latest

ENV LC_ALL C.UTF-8
ENV LANG fr_US.UTF-8
ENV LANGUAGE fr_US.UTF-8
ENV DISPLAY :1

# firefox --user-data-dir ~/.firefox
# add packages
#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update --no-cache add xrdp xvfb alpine-desktop xfce4 xfce4-session xfce4-terminal thunar-volman xfce4-power-manager \
faenza-icon-theme paper-gtk-theme paper-icon-theme slim xf86-input-synaptics xf86-input-mouse xf86-input-keyboard \
setxkbmap openssh util-linux dbus ttf-freefont xauth supervisor x11vnc firefox-esr \
util-linux dbus ttf-freefont xauth xf86-input-keyboard sudo \
&& rm -rf /tmp/* /var/cache/apk/*

# add scripts/config
ADD etc /etc
ADD docker-entrypoint.sh /bin

# prepare user alpine
RUN addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers
ADD alpine /home/alpine
RUN chown -R alpine:alpine /home/alpine

# prepare xrdp key
RUN xrdp-keygen xrdp auto

EXPOSE 3389 22
VOLUME [ "/home" ]
WORKDIR /home
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
