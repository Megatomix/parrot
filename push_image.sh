#! /bin/sh

IMAGE=$1
TAG=`date +%d-%m%Hh%Mm`
URL='362338258830.dkr.ecr.us-east-1.amazonaws.com'

docker build -t $IMAGE:$TAG .
docker tag $IMAGE:$TAG $URL/$IMAGE:$TAG

aws ecr get-login --region us-east-1 --no-include-email | sh
docker push $URL/$IMAGE:$TAG
