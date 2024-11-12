FROM ubuntu:latest

RUN groupadd -r freeradius && useradd -r -g freeradius freeradius

RUN apt-get update && \
    apt-get install -y freeradius freeradius-utils freeradius-mysql winbind mysql-server libdbd-mysql-perl \
    libtalloc-dev build-essential git make gcc libssl-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN chmod 644 /etc/freeradius/3.0/mods-config/preprocess/huntgroups && \
    chown freeradius:freeradius /etc/freeradius/3.0/mods-config/preprocess/huntgroups

COPY ./configs/radiusd.conf /etc/freeradius/3.0/radiusd.conf
COPY ./configs/clients.conf /etc/freeradius/3.0/clients.conf
COPY ./configs/sql.conf /etc/freeradius/3.0/mods-available/sql
COPY ./configs/sites-enabled/default /etc/freeradius/3.0/sites-enabled/default
COPY ./configs/mschap /etc/freeradius/3.0/mods-available/mschap
COPY ./configs/ntlm_auth /etc/freeradius/3.0/mods-enabled/ntlm_auth
COPY ./configs/acct_unique /etc/freeradius/3.0/mods-available/acct_unique

COPY ./certs/server.crt /etc/freeradius/certs/server.crt
COPY ./certs/server.key /etc/freeradius/certs/server.key
RUN chmod 644 /etc/freeradius/certs/server.crt && \
    chmod 600 /etc/freeradius/certs/server.key

RUN rm -f /etc/freeradius/3.0/mods-enabled/sql && \
    rm -f /etc/freeradius/3.0/mods-enabled/mschap && \
    rm -f /etc/freeradius/3.0/mods-enabled/acct_unique && \
    ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/sql && \
    ln -s /etc/freeradius/3.0/mods-available/mschap /etc/freeradius/3.0/mods-enabled/mschap && \
    ln -s /etc/freeradius/3.0/mods-available/acct_unique /etc/freeradius/3.0/mods-enabled/acct_unique

COPY ./configs/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1812/udp 1813/udp 3306

ENTRYPOINT ["/entrypoint.sh"]
