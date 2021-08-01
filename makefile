PASS = placeholder

dev: mysql mssql postgres jenkins

password:
	sh pass.sh

reset:
	cp makefile.bak makefile
	rm -rf makefile.bak

mysql:
	docker run --name mysql \
		-v mysqlvolume:/var/lib/mysql \
		-e MYSQL_ROOT_PASSWORD=$(PASS) \
		-p 3306:3306 \
		-d mysql:8.0.25

mssql:
	docker run --name mssql \
		-e ACCEPT_EULA=Y -e SA_PASSWORD=$(PASS) \
		-e MSSQL_PID=Developer -p 1433:1433 \
		-v mssqlvolume:/var/mssql_home \
		-d mcr.microsoft.com/mssql/server:2017-CU24-ubuntu-16.04

postgres:
	docker run --name postgres \
		-e POSTGRES_PASSWORD=$(PASS) \
		-e PGDATA=/var/lib/postgresql/data/pgdata \
		-v postgresvolume:/var/lib/postgresql/data \
		-p 5432:5432 \
		-d postgres:13.3

jenkins:
	docker run --name jenkins \
		-p 8080:8080 -p 50000:50000 \
		-e JAVA_OPTS=-Dhudson.footerURL=http://matthew.codes \
		-v jenkinsvolume:/var/jenkins_home \
		-d jenkins/jenkins:lts-jdk11

stop:
	docker ps -a -q | xargs docker stop

clean: stop
	docker ps -a -q | xargs docker rm
	docker images -q | xargs docker rmi
	docker volume ls -q | xargs docker volume rm -f