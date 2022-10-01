build:
	docker build -t fbuchmeier/rsync-server:2.0.0 .

publish: build
	docker push fbuchmeier/rsync-server:2.0.0

run: build
	docker run --rm -it fbuchmeier/rsync-server:2.0.0

