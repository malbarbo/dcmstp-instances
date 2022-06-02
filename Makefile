INSTANCES := target/instances
SOLVERS := target/solvers

all: instances solvers

instances: download-var-instances download-shrd-instances download-ieee-instances

# Originally from http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/
download-var-instances: $(INSTANCES)/variable/ANDINST/tb1ct100_1.txt
$(INSTANCES)/variable/ANDINST/tb1ct100_1.txt:
	@echo Downloading variable instances
	mkdir -p $(INSTANCES)/variable/ANDINST
	curl -L https://malbarbo.pro.br/datasets/dcmstp-allinstances.tar.gz |\
		tar xzf - --strip-components 1 -C $(INSTANCES)/variable/

# Originally from https://turing.cs.hbg.psu.edu/txn131/spanning_tree.html
download-shrd-instances: $(INSTANCES)/fixed/shrd150
$(INSTANCES)/fixed/shrd150:
	@echo Downloading shrd instances
	mkdir -p $(INSTANCES)/fixed/
	curl -L https://malbarbo.pro.br/datasets/SHRD-Graphs.tar.gz |\
		tar xzf - --strip-components 1 -C $(INSTANCES)/fixed/

# Originally from https://turing.cs.hbg.psu.edu/txn131/spanning_tree.html
download-ieee-instances: $(INSTANCES)/fixed/m050n1
$(INSTANCES)/fixed/m050n1:
	@echo Downloading ieee instances
	mkdir -p $(INSTANCES)/fixed/
	curl -L https://malbarbo.pro.br/datasets/IEEE-Graphs.tar.gz |\
		tar xzf - --strip-components 1 -C $(INSTANCES)/fixed/


solvers: download-concorde download-lkh download-choco download-cgbc download-bcp download-bcp-bc

# http://www.math.uwaterloo.ca/tsp/concorde/index.html
download-concorde: $(SOLVERS)/concorde
$(SOLVERS)/concorde:
	@echo Downloading concorde
	mkdir -p $(SOLVERS)
	curl -L http://www.math.uwaterloo.ca/tsp/concorde/downloads/codes/linux24/concorde.gz |\
	    gunzip -c > $(SOLVERS)/concorde
	chmod +x $(SOLVERS)/concorde

# http://www.akira.ruc.dk/~keld/research/LKH/
download-lkh: $(SOLVERS)/LKH/LKH
$(SOLVERS)/LKH/LKH:
	@echo Downloading lkh
	mkdir -p $(SOLVERS)/LKH/
	curl -L http://www.akira.ruc.dk/~keld/research/LKH/LKH-2.0.7.tgz |\
		tar xzf - --strip-components 1 -C $(SOLVERS)/LKH/
	@echo Compiling lkh
	cd $(SOLVERS)/LKH/ && make

download-choco: $(SOLVERS)/dcmstp-choco/target/dcmstp-choco-4.1.1-shaded.jar
$(SOLVERS)/dcmstp-choco/target/dcmstp-choco-4.1.1-shaded.jar:
	@echo Downloading dcmstp-choco
	if [ ! -d $(SOLVERS)/dcmstp-choco/.git ]; then \
		git clone https://github.com/malbarbo/dcmstp-choco $(SOLVERS)/dcmstp-choco; \
	fi
	@echo Compiling dcmstp-choco
	mvn -f $(SOLVERS)/dcmstp-choco/pom.xml package

download-cgbc: $(SOLVERS)/cgbc
$(SOLVERS)/cgbc:
	ln -sr broken $(SOLVERS)/cgbc
	#curl -L http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/CGBC.tar |\
	#	tar xzf - -C $(SOLVERS)/ cgbc

download-bcp: $(SOLVERS)/bcp
$(SOLVERS)/bcp:
	ln -sr broken $(SOLVERS)/bcp
	#curl -L http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/BCP.tar |\
	#	tar xzf - -C $(SOLVERS)/ bcp

download-bcp-bc: $(SOLVERS)/bcp_bc
$(SOLVERS)/bcp_bc:
	ln -sr broken $(SOLVERS)/bcp_bc
	#curl -L http://homepages.dcc.ufmg.br/~luishbicalho/dcmst/BCP_BC.tar |\
	#	tar xzf - -C $(SOLVERS)/ bcp_bc

# TODO: add ndrc-bc
# TODO: add checksum for the download binaries

.PHONY: all \
	instances download-var-instances download-shrd-instances download-ieee-instances \
	solvers download-concorde download-choco download-cgbc download-bcp download-bcp-bc \
	download-lkh
