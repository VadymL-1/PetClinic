#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y openjdk-8-jdk git netcat-openbsd

id appuser &>/dev/null || useradd -m -s /bin/bash appuser
APP_DIR=/home/appuser
PROJECT_DIR=$APP_DIR/project

cat > /etc/profile.d/petclinic.sh <<EOF
export DB_HOST=${DB_HOST}
export DB_PORT=${DB_PORT}
export DB_NAME=${DB_NAME}
export DB_USER=${DB_USER}
export DB_PASS='${DB_PASS}'
EOF
chmod 644 /etc/profile.d/petclinic.sh

sudo -u appuser -H bash <<EOF
set -e
rm -rf ${PROJECT_DIR}
git clone ${REPO_URL} ${PROJECT_DIR}
cd ${PROJECT_DIR}/PetClinic
chmod +x mvnw
./mvnw clean package
cp target/*.jar ${APP_DIR}/petclinic.jar
EOF

for i in $(seq 1 30); do nc -z ${DB_HOST} ${DB_PORT} && break; sleep 2; done

sudo -u appuser -H bash -c "source /etc/profile.d/petclinic.sh && \
  nohup java -jar ${APP_DIR}/petclinic.jar --spring.profiles.active=mysql \
  > ${APP_DIR}/petclinic.log 2>&1 &"