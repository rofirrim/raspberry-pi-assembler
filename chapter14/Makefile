EXES=matmul benchmark
OBJS=$(addsuffix .o, $(EXES))
all: $(EXES) $(OBJS)

%: %.o
	gcc -o $@ $+

% : %.s

%.o : %.s
	as -mfpu=vfpv2 -o $@ $<

.PHONY: clean
clean:
	rm -vf $(EXES) *.o
