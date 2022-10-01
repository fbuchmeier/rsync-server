## rsync-server

A `rsyncd` server in Docker. You know, for moving files.


### quickstart

Start a server (both `sshd` and `rsyncd` are supported)

```
$ docker run \
    --name rsync-server \ # Name it
    -p 8000:8873 \ # rsyncd port
    -e USERNAME=user \ # rsync username
    -e PASSWORD=pass \ # rsync/ssh password
    fbuchmeier/rsync-server
```

**Warning** If you are exposing services to the internet be sure to change the default password from `pass` by settings the environmental variable `PASSWORD`.

#### `rsyncd`

Please note that `/volume` is the `rsync` volume pointing to `/data`. The data
will be at `/data` in the container. Use the `VOLUME` parameter to change the
destination path in the container. Even when changing `VOLUME`, you will still
`rsync` to `/volume`. **It is recommended that you always change the default password of `pass` by setting the `PASSWORD` environmental variable, even if you are using key authentication.**

```
$ rsync -av /your/folder/ rsync://user@localhost:8000/volume
Password: pass
sending incremental file list
./
foo/
foo/bar/
foo/bar/hi.txt

sent 166 bytes  received 39 bytes  136.67 bytes/sec
total size is 0  speedup is 0.00
```


### Usage

Variable options (on run)

* `USERNAME` - the `rsync` username. defaults to `user`
* `PASSWORD` - the `rsync` password. defaults to `pass`
* `VOLUME`   - the path for `rsync`. defaults to `/data`
* `ALLOW`    - space separated list of allowed sources. defaults to `192.168.0.0/16 172.16.0.0/12`.


##### Simple server on port 8873

```
$ docker run -p 8873:8873 axiom/rsync-server
```


##### Use a volume for the default `/data`

```
$ docker run -p 8873:8873 -v /your/folder:/data fbuchmeier/rsync-server
```

##### Set a username and password

```
$ docker run \
    -p 8873:8873 \
    -v /your/folder:/data \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    fbuchmeier/rsync-server
```

##### Run on a custom port

```
$ docker run \
    -p 9999:8873 \
    -v /your/folder:/data \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    fbuchmeier/rsync-server
```

```
$ rsync rsync://admin@localhost:9999
volume            /data directory
```


##### Modify the default volume location

```
$ docker run \
    -p 9999:8873 \
    -v /your/folder:/myvolume \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    -e VOLUME=/myvolume \
    fbuchmeier/rsync-server
```

```
$ rsync rsync://admin@localhost:9999
volume            /myvolume directory
```

##### Allow additional client IPs

```
$ docker run \
    -p 9999:8873 \
    -v /your/folder:/myvolume \
    -e USERNAME=admin \
    -e PASSWORD=mysecret \
    -e VOLUME=/myvolume \
    -e ALLOW=192.168.8.0/24 192.168.24.0/24 172.16.0.0/12 127.0.0.1/32 \
    fbuchmeier/rsync-server
```