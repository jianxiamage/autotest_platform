obj-m := testmod.o 
CROSS_COMPILE = 
CC = gcc 
KERNELDIR ?= /usr/src/linux-headers-$(shell uname -r) 
PWD := $(shell pwd) 

all: modules 
modules: 
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules 

#clean: rm -rf *.o *~core .depend *.symvers .*.cmd *.ko *.mod.c .tmp_versions $(TARGET)
clean: 
	rm -rf *.o *~core .depend *.symvers .*.cmd *.mod.c modules.order .tmp_versions $(TARGET)

