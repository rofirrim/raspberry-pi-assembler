EXES=sum01 sum02
all: $(EXES)

%: %.o
	gcc -o $@ $+

% : %.s

%.o : %.s
	as -o $@ $<

.PHONY: clean
clean:
	rm -vf $(EXES) *.o
