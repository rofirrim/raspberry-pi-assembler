EXES=addf
OBJS=$(addsuffix .o, $(EXES))
all: $(EXES) $(OBJS)

%: %.o
	gcc -o $@ $+

% : %.s

%.o : %.s
	as -mcpu=arm1176jzf-s -mfpu=vfpv2 -o $@ $<

.PHONY: clean
clean:
	rm -vf $(EXES) *.o
