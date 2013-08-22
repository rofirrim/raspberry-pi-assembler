EXES=divideby14 division benchmark
OBJS=$(addsuffix .o, $(EXES))
all: $(EXES) $(OBJS)

%: %.o
	gcc -o $@ $+

% : %.s

%.o : %.s
	as -march=armv6 -mfpu=vfpv2 -o $@ $<

.PHONY: clean
clean:
	rm -vf $(EXES) *.o
