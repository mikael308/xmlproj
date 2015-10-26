CC_XSLT				= xsltproc
CC_XQ					= zorba
TEMPLATE_XSLT	= tvguide-form.xml
TEMPLATE_XQ		= tvguide.xq
OUT_XSLT			= tvguide.xml
OUT_XQ				= tvguide-xq.html
OBJS					= tvguide xquery
E_C						= @echo "compiling " $@



all: $(OBJS)
	$(E_C)

tvguide:
	$(E_C)
	$(CC_XSLT) $(TEMPLATE_XSLT) > $(OUT_XSLT)
xquery:
	$(E_C)
	$(CC_XQ) $(TEMPLATE_XQ) -i > $(OUT_XQ) 

clean: 
	rm $(OUT) 

