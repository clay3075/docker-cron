FROM ubuntu:22.04

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install -y \
    cron \
    curl \
    python3 \
    python3-pip \
    git \
    vim \
    # Remove package lists for smaller image sizes
    && rm -rf /var/lib/apt/lists/* \
    && which cron \
    && rm -rf /etc/cron.*/*

COPY crontab /hello-cron
COPY entrypoint.sh /entrypoint.sh

RUN crontab hello-cron
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# https://manpages.ubuntu.com/manpages/trusty/man8/cron.8.html
# -f | Stay in foreground mode, don't daemonize.
# -L loglevel | Tell  cron  what to log about jobs (errors are logged regardless of this value) as the sum of the following values:
CMD ["cron","-f", "-L", "2"]

WORKDIR /custom_apps

# Argument for the token
ARG GITHUB_TOKEN

# Clone the private repo
RUN git clone https://$GITHUB_TOKEN:x-oauth-basic@github.com/clay3075/zeus_crm_api.git
RUN pip3 install --no-cache-dir -r zeus_crm_api/requirements.txt
