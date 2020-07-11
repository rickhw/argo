

Code Name: `Argo`

# Purpose

- Update DNS to Route53 for PPPoE Dynamic IP


# Prerequisite

* AWS CLI
* An IAM user who allows to update Route53.

---
# Setup

1. Config
1. Test
1. Apply

## Config

1. git clone 
1. Copy `config.sample.sh` as `config.sh`
    1. Modify the `ZONEID`, `TARGET_FQDN`, `TYPE` for fit your AWS route53.


## Test

```bash

export ARGO_HOME="$HOME/argo"
cd ${ARGO_HOME}

./main.sh


## check the log
```bash
$ ~/argo/log$ ls -ls

total 16
4 -rw-rw-r-- 1 ubuntu ubuntu 1079 Jul 11 10:22 20200711-102201.access.log
4 -rw-rw-r-- 1 ubuntu ubuntu  402 Jul 11 10:22 20200711-102201.awscli.json
4 -rw-rw-r-- 1 ubuntu ubuntu  231 Jul 11 10:22 20200711-102201.awscli.log
4 -rw-rw-r-- 1 ubuntu ubuntu    1 Jul 11 10:22 20200711-102201.target.ip
0 -rw-rw-r-- 1 ubuntu ubuntu    0 Jul 11 09:33 EMPTY

```


## Apply

Run with crontab:

```bash
ARGO_HOME=/home/ubuntu/argo
1 * * * * ${ARGO_HOME}/main.sh >/dev/null 2>&1
```



---

## Troubleshoting

1. Cannot find aws command: `/home/ubuntu/argo/main.sh: line 81: aws: command not found`

Add following to crontab:

```
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

```

---

# TODO

- Support multiple DNS records.
- Notify when IP is change.

