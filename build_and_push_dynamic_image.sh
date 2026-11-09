#!/bin/bash

##############################################################################
# Build and Push Dynamic Integration ETL Docker Image to AWS ECR
##############################################################################

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Configuration
AWS_REGION="ap-southeast-2"
AWS_ACCOUNT_ID="870551425938"
ECR_REPOSITORY="etl-dynamic-worker"
IMAGE_TAG="latest"
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"

echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}Building DYNAMIC INTEGRATION ETL Docker Image${NC}"
echo -e "${GREEN}=============================================${NC}"

# Script should be run from the etl-packages directory
# If running from elsewhere, cd to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo -e "\n${YELLOW}Step 1: Authenticating with ECR...${NC}"
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
echo -e "${GREEN}✓ Authenticated with ECR${NC}"

echo -e "\n${YELLOW}Step 2: Checking if ECR repository exists...${NC}"
if ! aws ecr describe-repositories --region ${AWS_REGION} --repository-names ${ECR_REPOSITORY} &>/dev/null; then
    echo -e "${YELLOW}Repository does not exist. Creating ${ECR_REPOSITORY}...${NC}"
    aws ecr create-repository --region ${AWS_REGION} --repository-name ${ECR_REPOSITORY}
    echo -e "${GREEN}✓ Repository created successfully${NC}"
else
    echo -e "${GREEN}✓ Repository already exists${NC}"
fi

echo -e "\n${YELLOW}Step 3: Building Docker Dynamic Integration image...${NC}"
docker build -f Dockerfile_dynamic -t ${ECR_REPOSITORY}:${IMAGE_TAG} .
echo -e "${GREEN}✓ Docker Dynamic Integration image built successfully${NC}"

echo -e "\n${YELLOW}Step 4: Tagging Dynamic Integration image for ECR...${NC}"
docker tag ${ECR_REPOSITORY}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
echo -e "${GREEN}✓ Dynamic Integration Image tagged: ${ECR_URI}:${IMAGE_TAG}${NC}"

echo -e "\n${YELLOW}Step 5: Pushing Dynamic Integration image to ECR...${NC}"
docker push ${ECR_URI}:${IMAGE_TAG}
echo -e "${GREEN}✓ Dynamic Integration Image pushed successfully${NC}"

echo -e "\n${GREEN}=============================================${NC}"
echo -e "${GREEN}Docker Image Ready!${NC}"
echo -e "${GREEN}=============================================${NC}"
echo -e "${YELLOW}Image URI: ${ECR_URI}:${IMAGE_TAG}${NC}"
echo ""
