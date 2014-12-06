ASSET_FILES = $(shell find ./assets/ -type f -name '*')

all: love

love: *.lua $(ASSET_FILES)
	rm -f  *.love
	zip kr *.lua assets/*
	mv kr.zip kr.love
	make launch
launch:
	love kr.love &
