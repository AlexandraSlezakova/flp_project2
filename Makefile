all:
	@swipl -q -g main -o flp20-log -c flp20-log.pl
	
time: all
	@cd tests && ./tester.sh -t
	
tests: all
	@cd tests && ./tester.sh
	
pack:
	zip flp-log-xsleza20 Makefile flp20-log.pl README.md -r tests/*

clean:
	@rm -rf flp20-log xsleza20.zip
