EXES=loop01 loop02 collatz
OBJS=$(addsuffix .o, $(EXES))
all: $(EXES) $(OBJS)

%: %.o
	gcc -o $@ $+

% : %.s

%.o : %.s
	as -o $@ $<

.PHONY: clean
clean:
	rm -vf $(EXES) *.o
