#!/bin/bash

# Check if required arguments are provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <client_id> <org_id1> [org_id2] [org_id3] ..."
  echo "Example: $0 SWAU_CLIENT1052 2846 2847 2848"
  exit 1
fi

# Get client ID from first argument
CLIENT_ID=$1
shift

# Iterate through remaining arguments (org IDs)
for ORG_ID in "$@"; do
  CONTAINER_NAME="etl_${CLIENT_ID}_${ORG_ID}"
  
  echo "Starting container: $CONTAINER_NAME"
  
  # Launch container in detached mode
  docker run -d \
    --name "$CONTAINER_NAME" \
    -e JOB_ID=0 \
    -e JOB_RUN_ID=0 \
    -e TRIGGER_TYPE="MANUAL" \
    -e EtaniClientID="$CLIENT_ID" \
    -e EtaniOrganisationID="$ORG_ID" \
    -e XeroTenantID="" \
    etani-etl-python:latest python -u "XEROBLUE - UPSERT.py"
    
  echo "Container $CONTAINER_NAME launched!"
  echo "-----------------------------------"
done

echo "All containers have been launched successfully!"