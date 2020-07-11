#!/bin/bash

# -----------------------------------------------------------------------------
# USER SETTINGS.
# -----------------------------------------------------------------------------

# (optional) You might need to set your PATH variable at the top here
# depending on how you run this script
# ARGO_HOME=

# Hosted Zone ID e.g. BJBK35SKMM9OE
ZONEID="<<UPDATE_YOUR_ZONEID>>"

# The CNAME you want to update e.g. hello.example.com
TARGET_FQDN="<<UPDATE_YOUR_CNAME>>"

# More advanced options below
# The Time-To-Live of this TARGET_FQDN
TTL=300
# Change this if you want
COMMENT="Auto updating @ `date`"
# Change to AAAA if using an IPv6 address
TYPE="A"



# -----------------------------------------------------------------------------
# SYSTEM SETTINGS, DON'T MODIFY.
# -----------------------------------------------------------------------------
SYS_DNS_RESOLVER="resolver1.opendns.com"