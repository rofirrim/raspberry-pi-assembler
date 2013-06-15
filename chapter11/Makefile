EXES=collatz02 collatz03
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
