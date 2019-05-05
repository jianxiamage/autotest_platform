#!/bin/bash

srcDir='/home/loongson'

echo "performance Test:[scp大文件] Begin-----------------------------------------------"

cd $srcDir/loongnix-testsuite/shell
./scp-test.sh

echo "performance Test:[scp大文件] End-----------------------------------------------"
