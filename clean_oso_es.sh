#!/bin/bash
# clean ES indices using curator_cli, only keep 7 days

source ~/.bashrc
clean_days_ago=3

# login to OpenShift namespace "caas"
oc login -u=xxxxx -p=xxxxx --insecure-skip-tls-verify https://openshift.xxx.xxx.com:8443 -n caas

# get ES podIP
podIP=`oc get pods -n caas --template='{{range .items}}PodName: {{.metadata.name}} PodIP: {{.status.podIP}}{{"\n"}}{{end}}' | grep 'elasticsearch' | awk -F'PodIP: ' '{print $2}'`

# clean es indices
curator_cli --host ${podIP} delete_indices --filter_list '[{"filtertype":"age","source":"creation_date","direction":"older","unit":"days","unit_count":'"${clean_days_ago}"'},{"filtertype":"pattern","kind":"prefix","value":"logstash"}]'
