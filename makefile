INFILE := Testbench.bsv
OUTFILE := TestExec

#Simulate
MODULE := mkTestbench

simulate: $(INFILE)
	mkdir -p exec
	cp *.bsv exec/
	cd exec/
	bsc -sim -g $(MODULE) -u $(INFILE)
	bsc -sim -e $(MODULE) -o $(OUTFILE)
	./$(OUTFILE)
