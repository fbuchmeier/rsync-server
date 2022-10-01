build:
	docker build -t fbuchmeier/rsync-server:${VERSION} .

publish: build
	docker push fbuchmeier/rsync-server:${VERSION}

run: build
	docker run --rm -it fbuchmeier/rsync-server:${VERSION}

