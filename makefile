CC_XSL		= xsltproc
TEMPLATE	= tvguide-form.xml
OUT		= tvguide.xml
OBJS		= tvguide
E_C		= @echo "compiling " $@



all: $(OBJS)
	$(E_C)

tvguide:
	$(E_C)
	$(CC_XSL) $(TEMPLATE) > $(OUT)

clean: 
	rm $(OUT) 

