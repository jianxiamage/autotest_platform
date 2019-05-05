/*
 * * for insmod rmmod Test
 * *
 * * - based on loongnix vm, by tyh
 * * This program is used for loongnix kvm guest kernel to test insmod or rmmod.
 * */

#include <linux/module.h>
#include <linux/kernel.h>
int init_test_module(void)
{
        printk("***************Start insmod***************\n");
        printk("Hello! only a test for insmod module on kvm-guest-kernel!\n");
        printk("***************End insmod***************\n");
        return 0;
}
void exit_test_module(void)
{
        printk("***************Start rmmod***************\n");
        printk("Hello! only a test for rmmod module on kvm-guest-kernel!\n");
        printk("***************End rmmod***************\n");
}

MODULE_LICENSE("Dual BSD/GPL");
module_init(init_test_module);
module_exit(exit_test_module);
