#!/bin/bash

source $ARGO_HOME/lib/helper.sh
source $ARGO_HOME/config.sh

# -----------------------------------------------------------------------------
# Initiate runtime variables.
# -----------------------------------------------------------------------------
## Transcation ID with Timestamp.
RT_TX_ID=$(date +%Y%m%d-%H%M%S)
## Get the external IP address from OpenDNS
RT_WAN_IPv4_ADDR=`dig +short myip.opendns.com @${SYS_DNS_RESOLVER}`
## Get the target DNS IP address from OpenDNS
RT_TARGET_DNS_IP=`dig +short ${TARGET_FQDN} @${SYS_DNS_RESOLVER}`
## Craete the TX log
RT_LOGFILE_LOC="$ARGO_HOME/log/${RT_TX_ID}.access.log"
## File to store target DNS ip.
RT_TARGET_DNS_IP_FILE="$ARGO_HOME/log/${RT_TX_ID}.target.ip"
## Route53 command file.
RT_R53_CMD_FILE="$ARGO_HOME/log/$RT_TX_ID.awscli.json"
RT_R53_CMD_OUTPUT_FILE="$ARGO_HOME/log/$RT_TX_ID.awscli.log"


# -----------------------------------------------------------------------------
# Main Procedure
# -----------------------------------------------------------------------------
log_start "Start the procedure."
log_info "The transaction ID is ${RT_TX_ID}"
log_debug "PATH: [${PATH}]"

# Store target DNS IP address to file.
echo $RT_TARGET_DNS_IP > $RT_TARGET_DNS_IP_FILE

## Check IP Format
if ! valid_ip $RT_WAN_IPv4_ADDR; then
    log_info "WAN IP is Invalid, the value is [$RT_WAN_IPv4_ADDR]."
    log_info "Please update dig command or contact author."
    exit 1
fi

# log info.
log_info "Externl WAN IP: [$RT_WAN_IPv4_ADDR]"
log_info "TARGET DNS: [$TARGET_FQDN], IP: [$RT_TARGET_DNS_IP]"



if grep -Fxq "$RT_WAN_IPv4_ADDR" "$RT_TARGET_DNS_IP_FILE"; then
    log_info "Target DNS IP is the same as WAN IP, no action required."
    log_end "Exit the procedure."
    exit 0
else
    log_info "WAN IP has changed to [$RT_WAN_IPv4_ADDR]"
    log_info "Create a command file for Route53, stored in [$RT_R53_CMD_FILE]"

    cat > ${RT_R53_CMD_FILE} << EOF
    {
      "Comment":"$COMMENT",
      "Changes":[
        {
          "Action":"UPSERT",
          "ResourceRecordSet":{
            "ResourceRecords":[
              {
                "Value":"$RT_WAN_IPv4_ADDR"
              }
            ],
            "Name":"$TARGET_FQDN",
            "Type":"$TYPE",
            "TTL":$TTL
          }
        }
      ]
    }
EOF

    log_info "Execute the command to update DNS record."
    CMD="aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONEID \
        --change-batch file://"$RT_R53_CMD_FILE" \
        --output json"

    ## see: https://serverfault.com/questions/691319/why-cant-i-capture-aws-ec2-cli-output-in-bash/691327 
    eval "${CMD} >${RT_R53_CMD_OUTPUT_FILE} 2>&1"
    log_debug "AWS CLI: [$CMD]"
    log_debug "AWS CLI Stdout: [$RT_R53_CMD_OUTPUT_FILE]"
    
    log_info "The IP has changed in Route53."
    log_info "Check DNS with dig a few moment."
fi


log_end "Exit the procedure."