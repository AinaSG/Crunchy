ASSET_FILES = $(shell find ./assets/ -type f -name '*')

all: love

love: *.lua $(ASSET_FILES)
	rm -f  *.love
	zip kawaii-roach *.lua assets/*
	mv kawaii-roach.zip kawaii-roach.love
	make launch
launch:
	love kawaii-roach.love &
