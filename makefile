CC_XSL		= xsltproc
CC_XQ		= zorba
TEMPLATE	= tvguide-template.xml
TEMPLATE_XQ	= tvguide.xq
OUT		= tvguide.xml
OUT_XQ		= tvguide-xq.html
OBJS		= tvguide xquery
E_C		= @echo "compiling " $@



all: $(OBJS)
	$(E_C)

tvguide:
	$(E_C)
	$(CC_XSL) $(TEMPLATE) > $(OUT)
xquery:
	$(E_C)
	$(CC_XQ) $(TEMPLATE_XQ) -i > $(OUT_XQ) 

clean: 
	rm $(OUT) 

