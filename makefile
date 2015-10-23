CC		= xsltproc
TEMPLATE	= tvguide-template.xml
OUTPUT		= tvguide.xml
OBJS		= tvguide
E_C		= @echo "compiling " $@



all: $(OBJS)
	$(E_C)

tvguide:
	$(E_C)
	$(CC) $(TEMPLATE) > $(OUTPUT)

clean: 
	rm $(OUTPUT) 

