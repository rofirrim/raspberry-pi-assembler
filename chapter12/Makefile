EXES=mult64 mult64_2
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
