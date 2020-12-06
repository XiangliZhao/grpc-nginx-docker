VERSION := $(shell git rev-parse HEAD)
BUILD_DATE := $(shell date -R)
VCS_URL := $(shell basename `git rev-parse --show-toplevel`)
VCS_REF := $(shell git log -1 --pretty=%h)
NAME := $(shell basename `git rev-parse --show-toplevel`)
VENDOR := $(shell whoami)

stub:
	find . -name "*.proto" -exec \
	protoc -I/usr/local/include -I. \
	-I${GOPATH}/src \
	-I${GOPATH}/src/github.com/grpc-ecosystem/grpc-gateway/third_party/googleapis \
	--gofast_out=plugins=grpc:. \
	--proto_path=. "{}" \;

nginx-cert:
	openssl req -x509 -newkey rsa:4096 -sha256 -utf8 -days 365 -nodes -config ./san.cfg  -subj '/CN=nginx'   -keyout ./cert/nginx.key -out ./cert/nginx.cert

print:
	@echo VERSION=${VERSION} 
	@echo BUILD_DATE=${BUILD_DATE}
	@echo VCS_URL=${VCS_URL}
	@echo VCS_REF=${VCS_REF}
	@echo NAME=${NAME}
	@echo VENDOR=${VENDOR}

build-server:
	cd server && docker build -t xiangli/grpc-server --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" .

build-client:
	cd client && docker build -t xiangli/grpc-client --build-arg VERSION="${VERSION}" \
	--build-arg BUILD_DATE="${BUILD_DATE}" \
	--build-arg VCS_URL="${VCS_URL}" \
	--build-arg VCS_REF="${VCS_REF}" \
	--build-arg NAME="${NAME}" \
	--build-arg VENDOR="${VENDOR}" .

run:
	@docker run xiangli/hello-go

label:
	@docker inspect --format='{{range $k, $v := .Config.Labels}}{{$k}}={{$v}}{{println}}{{end}}' xiangli/hello-go

up:
	@docker-compose up -d

down:
	@docker-compose down

test-client:
	@docker-compose up client