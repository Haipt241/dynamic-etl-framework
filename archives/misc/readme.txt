How To build and run docker
first change the current directory where the UPSERT py file is located
#run this in the terminal
docker build -t etani-etl-python:latest -f ./Dockerfile_api .

#to test and run the docker

docker run -e DB_Destination="DW" \
           -e JOB_ID=0 \
           -e JOB_RUN_ID=0 \
           -e TRIGGER_TYPE="MANUAL" \
           -e EtaniClientID="BIGOLESHOECOMPANY_CLIENT1518" \
           -e EtaniOrganisationID="5393" \
           -e XeroTenantID="865512af-e7d8-4d42-8568-73084279eb43" \
           etani-etl-python:latest python "XEROBLUE - UPSERT.py"

#testing aws insert and upsert
USE_AWS_DB=True    DB_Destination="DW" JOB_ID=0 JOB_RUN_ID=0 TRIGGER_TYPE="MANUAL"  EtaniClientID="TIGERS_CLIENT6910"  EtaniOrganisationID="1755241431"  XeroTenantID="865512af-e7d8-4d42-8568-73084279eb43" python -u "XEROBLUE - INSERT.py"