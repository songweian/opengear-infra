# ./infra-docker-compose.sh mysql up -d
# ./infra-docker-compose.sh nacos down
# ./infra-docker-compose.sh mongodb up -d
# ./infra-docker-compose.sh redis up -d
# ./infra-docker-compose.sh nexus up -d
# ./infra-docker-compose.sh gitlib up -d
# ./infra-docker-compose.sh jenkins up -d
# ./infra-docker-compose.sh sonarqube up -d
# ./infra-docker-compose.sh minio up -d
# ./infra-docker-compose.sh kafka up -d
# ./infra-docker-compose.sh rocketmq up -d
# ./infra-docker-compose.sh rabbitmq up -d
# ./infra-docker-compose.sh zookeeper up -d
# ./infra-docker-compose.sh elasticsearch up -d
# ./infra-docker-compose.sh kibana up -d
# ./infra-docker-compose.sh logstash up -d
# ./infra-docker-compose.sh grafana up -d
# ./infra-docker-compose.sh prometheus up -d
# ./infra-docker-compose.sh alertmanager up -d
# ./infra-docker-compose.sh node-exporter up -d
# ./infra-docker-compose.sh cadvisor up -d
# ./infra-docker-compose.sh ceph up -d
# ./infra-docker-compose.sh ceph-mgr up -d
# ./infra-docker-compose.sh ceph-mon up -d
# ./infra-docker-compose.sh ceph-osd up -d
# ./infra-docker-compose.sh ceph-rgw up -d
# ./infra-docker-compose.sh ceph-mds up -d
# ./infra-docker-compose.sh ceph-dashboard up -d
# ./infra-docker-compose.sh ceph-prometheus up -d
# ./infra-docker-compose.sh ceph-node-exporter up -d
# ./infra-docker-compose.sh ceph-alertmanager up -d
# ./infra-docker-compose.sh ceph-grafana up -d
# ./infra-docker-compose.sh ceph-rbd-mirror up -d
# ./infra-docker-compose.sh ceph-rbd-nbd up -d
# ./infra-docker-compose.sh ceph-rbd-nbd-client up -d
# if mysql/.env not exits then create 
# data_dir; if data dir not exits create it
if [ ! -d ./data ]; then
    mkdir -p ./data
    chmod 777 -R data
fi

# network; if docker-compose infra_network not extis then create
export infra_network="infra_network"
if [ ! "$(docker network ls | grep $infra_network)" ]; then
    docker network create $infra_network
fi
# env; 
if [ ! -f ./mysql/.env ]; then
    touch ./mysql/.env
fi
if [ ! -f ./nacos/.env ]; then
    touch ./nacos/.env
fi
if [ ! -f ./postgres/.env ]; then
    touch ./postgres/.env
fi

# create_service $1 $2
# $1 service type
# $2 docker-compose project name
create_service() {
    service_name="$1"
    project_name="$2"
    case "$service_name" in
        mysql)
            if [ -z "$project_name" ]; then
                project_name="mysql"
            fi
            docker-compose --project-name $project_name -f "./mysql/docker-compose.yml" up -d 
            ;;
        nacos)
            if [ -z "$project_name" ]; then
                project_name="nacos"
            fi
            docker-compose --project-name $project_name -f "./nacos/docker-compose.yml" up -d
            ;;
        postgres)
            if [ -z "$project_name" ]; then
                project_name="postgres"
            fi
            docker-compose --project-name $project_name -f "./postgres/docker-compose.yml" up -d
            ;;
        *)
            echo "Usage: $0 {mysql|nacos|postgres} [project_name]"
            exit 1
            ;;
    esac
}
# delete_service $1
# $1 docker-compose project name
delete_service() {
    project_name="$1"
    docker-compose --project-name $project_name down 
}

# ./infra create mysql mysql-nas
# ./infra delete mysql-nas
# ./infra ls
command="$1"
case "$command" in
    create)
        create_service $2 $3
        ;;
    delete)
        delete_service $2
        ;;
    ls)
        docker-compose ls
        ;;
    info)
        docker inspect -f '{{ index .Config.Labels "com.docker.compose.project" }}' $2
        ;;
    mkdir)
        mkdir -p $2
        chmod 777 -R $2
        ;;
    *)
        echo "Usage: $0 {create|delete|ls} {mysql|nacos|postgres} [project_name]"
        exit 1
        ;;
esac