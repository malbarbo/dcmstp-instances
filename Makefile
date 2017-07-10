INSTANCES := target/instances
SOLVERS := target/solvers

all: instances solvers

instances: download-var-instances download-shrd-instances download-ieee-instances

# http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/
download-var-instances: $(INSTANCES)/variable/ANDINST/tb1ct100_1.txt
$(INSTANCES)/variable/ANDINST/tb1ct100_1.txt:
	@echo Downloading variable instances
	mkdir -p $(INSTANCES)/variable/ANDINST
	curl -L http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/allinstances.tar |\
		tar xzf - --strip-components 1 -C $(INSTANCES)/variable/

# https://turing.cs.hbg.psu.edu/txn131/spanning_tree.html
download-shrd-instances: $(INSTANCES)/fixed/shrd150
$(INSTANCES)/fixed/shrd150:
	@echo Downloading shrd instances
	mkdir -p $(INSTANCES)/fixed/
	curl -L https://turing.cs.hbg.psu.edu/txn131/file_instances/spanning_tree/SHRD-Graphs.tar.gz |\
		tar xzf - --strip-components 1 -C $(INSTANCES)/fixed/

# https://turing.cs.hbg.psu.edu/txn131/spanning_tree.html
download-ieee-instances: $(INSTANCES)/fixed/m050n1
$(INSTANCES)/fixed/m050n1:
	@echo Downloading ieee instances
	mkdir -p $(INSTANCES)/fixed/
	curl -L https://turing.cs.hbg.psu.edu/txn131/file_instances/spanning_tree/IEEE-Graphs.tar.gz |\
		tar xzf - --strip-components 1 -C $(INSTANCES)/fixed/

solvers: download-concorde

# http://www.math.uwaterloo.ca/tsp/concorde/index.html
download-concorde: $(SOLVERS)/concorde
$(SOLVERS)/bin/concorde:
	@echo Downloading concorde
	mkdir -p $(SOLVERS)
	curl -L http://www.math.uwaterloo.ca/tsp/concorde/downloads/codes/linux24/concorde.gz |\
	    gunzip -c > $(SOLVERS)/concorde
	chmod +x $(SOLVERS)/concorde

.PHONY: all \
	instances download-var-instances download-shrd-instances download-ieee-instances \
	solvers download-concorde