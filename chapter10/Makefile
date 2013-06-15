EXES=factorial01 factorial02 factorial03
OBJS=$(addsuffix .o, $(EXES))
all: $(EXES) $(OBJS)

%: %.o
	gcc -o $@ $+

% : %.s

%.o : %.s
	as -march=armv6 -o $@ $<

.PHONY: clean
clean:
	rm -vf $(EXES) *.o
