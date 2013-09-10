#!/bin/sh

OPT=/opt
ZIP=go_appengine_sdk_linux_amd64-1.8.3.zip
GAEPATH=${OPT}/go_appengine
GOPATH=${OPT}/gopath export GOPATH
GOREAD=github.com/mjibson/goread/goapp
GOREADDIR=${GOPATH}/src/${GOREAD}

mkdir -p $OPT
mkdir -p $GOPATH

apt-get -q -y install python mercurial git unzip

if [ ! -d $GAEPATH ];
then
	echo fetching $ZIP
	cd $OPT
	wget -nv http://googleappengine.googlecode.com/files/$ZIP
	unzip $ZIP
	chown -R vagrant:vagrant ${GAEPATH}
fi

PATH=${PATH}:${GAEPATH} export PATH

if [ ! -d $GOREADDIR ];
then
	echo downloading $GOREAD
	go get -d ${GOREAD} 2> /dev/null
fi

echo starting app engine
cd /goread
if [ ! -f app.yaml ];
then
	echo installing app.yaml
	cp app.sample.yaml app.yaml
fi
if [ ! -f goapp/settings.go ];
then
	echo install settings.go
	cp goapp/settings.go.dist goapp/settings.go
fi
dev_appserver.py --skip_sdk_update_check=yes app.yaml &
echo app engine started