CC		= xsltproc
TEMPLATE	= tvguide-template.xml
OUTPUT		= tvguide.xml
OBJS		= tvguide
E_C		= @echo "compiling " $@



all: $(OBJS)
	$(E_C)

tvguide:
	$(CC) $(TEMPLATE) > $(OUTPUT)

clean: 
	rm $(OUTPUT) 

