docker-compose -f docker/docker-compose.yml down
docker rmi filnk-rocketmq
docker build -t filnk-rocketmq .
