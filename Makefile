# No spaces in STACK_NAME
export STACK_NAME := GT-SITE
export AWS_DEFAULT_REGION := us-east-1

# Docker image of benchmarking service
TAG := $(shell git rev-parse --short HEAD)
export SERVICE_IMG := quay.io/geotrellis/gtsite-service
export STATIC_IMG := quay.io/geotrellis/gtsite-nginx

clean:
	rm -rf service/srv/target
	rm -rf ./build
	docker-compose down
	sudo rm -rf nginx/_site/

assets:
	cd static/ && docker build -t gtsite-assets .
	docker run --rm \
		-v ${PWD}/static:/build \
		-v ${PWD}/nginx:/handoff \
		gtsite-assets:latest

assembly:
	cd service/srv/data/hillshade/ && unzip -o hills.zip
	cd service && ./sbt assembly

build:
	docker-compose build
	docker tag ${SERVICE_IMG} ${SERVICE_IMG}:${TAG}
	docker tag ${STATIC_IMG} ${STATIC_IMG}:${TAG}
	touch ./build

start: build
	docker-compose up

stop:
	docker-compose down

publish: build
	docker push ${SERVICE_IMG}:${TAG}
	docker push ${STATIC_IMG}:${TAG}

deploy: publish
	terraform remote config \
		-backend="s3" \
		-backend-config="region=us-east-1" \
		-backend-config="bucket=aws-state" \
		-backend-config="key=geotrellis-site/GT-SITE.tfstate" \
		-backend-config="encrypt=true"
	terraform apply \
		-var 'stack_name=${STACK_NAME}' \
		-var 'service_image=${SERVICE_IMG}:${TAG}' \
		-var 'static_image=${STATIC_IMG}:${TAG}' \
		./deployment
	terraform remote push

destroy:
	terraform remote config \
		-backend="s3" \
		-backend-config="region=us-east-1" \
		-backend-config="bucket=aws-state" \
		-backend-config="key=geotrellis-site/GT-SITE.tfstate \
		-backend-config="encrypt=true"
	terraform destroy -force \
		-var 'stack_name=${STACK_NAME}' \
		-var 'service_image=NA' \
		-var 'static_image=NA' \
		./deployment
	terraform remote push
