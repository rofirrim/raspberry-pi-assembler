EXES=hello01 printf01 printf02
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
