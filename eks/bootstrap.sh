#!/bin/bash
/etc/eks/bootstrap.sh ${cluster_name} --b64-cluster-ca ${ca_data} --apiserver-endpoint ${endpoint}
