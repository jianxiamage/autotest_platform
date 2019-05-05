#!/bin/bash
# File Name: sum_code_row.sh
# Author: Liwqiang
# mail: shrekee@qq.com
# Created Time: Sun 05 Aug 2018 06:43:19 PM CST
# Desc: 统计某个目录下的代码总量（以递归的方式遍历目录查询）、注释总量、空行总量等，并输出有意思的内容。。
 
#统计一个文件夹中的所有代码的之和
#即：统计下自己在coding学习中总共付出多少汗水？
#最后计算下，有效代码的数量=代码总量的75%
 
##定义函数，用递归的方式遍历目录，以查询代码总量，代码脚本的时间戳，以及注释行和空行的总量等。
function auto_sum() {
			for i in `ls $1`;do
				#如果是目录，则自动保存在数组中,然后递归
				if [ -d "$1/$i" ]; then
					dir_array[j]="$1/$i"   #把子目录中的目录保存在数组中
					let j++
#测试用				echo "$1/$i"
					auto_sum "$1/$i"
				#如果是文件或者是有效的符号链接则统计代码行数
				elif [ -f "$1/$i" -o -L "$1/$i" -a -e "$1/$i" ]; then
					##记录每个文件的修改（modify）的时间戳，保存在数组timestamp[]中				
					timestamp[m]=$(stat "$1/$i"| awk -F'[ .]+' '/^Modify/{cmd="date +%s -d"$2;system(cmd)}')
					let m++
					let valid_num+=`sed -r '/^$|^#/d' $1/$i |wc -l`   #统计有用的代码行
					let null_num+=`sed  '/^$/!d' $1/$i |wc -l`		#统计空行
				#统计注释行（每行的开头是//,#,/*,",，则为注释行）
					let comment_num+=`sed -r '/^#|^\/\/|^\"|^\/\*/!d' $1/$i |wc -l`	
				#既不是文件，也不是目录的，则放在else_array数组中
				else
					else_array[k]="$1/$i"
					let k++
				fi
			done
}
##定义主函数
function main(){
		echo '````````````````````````````````````````````````````````````````````'
		echo '````````````````````````````````````````````````````````````````````'
		echo '此脚本用来统计某个目录下的脚本的有效代码行数(递归的方式)，步骤如下：'
		echo -e "第一步： 分别统计所有以#开头的注释行\t空行\t代码行"
		echo -e "然后分别输出:  注释行\t空行\t代码行"
		echo '````````````````````````````````````````````````````````````````````'
		echo '````````````````````````````````````````````````````````````````````'
 
		read -p'请输入您想统计目录的路径，默认为统计当前目录'  path
		#处理下用户输入的路径，如果末尾带‘/’，则自动删除最后的‘/’
		path=`echo $path |sed -r 's/(.+)\/$/\1/g'`  
		echo '结果统计中....请耐心等待..........`'
		auto_sum $path
		echo '统计结果如下'
		echo '``````````````````````````````````````````'
	##把用户的文档的修改时间排序，取最小值
		#first_time=`echo ${timestamp[@]}|tr ' ' '\n' | sort -n |head -1`
	##把用户的文档的修改时间排序，取最大值
		#last_time=`echo ${timestamp[@]} |tr ' ' '\n' | sort -n |tail -1`
	##把时间戳，换算成标准的yyyy-mm--dd格式的日期
		#change_first_time=`date -d @${first_time} +%F`
	##把时间戳，换算成标准的yyyy-mm--dd格式的日期
		#change_last_time=`date -d @$last_time +%F`
		echo -e "总共有效文档数:\t${#timestamp[@]}"
		#echo -e "最早的的修改时间:\t$change_first_time"
		#echo -e "最后的修改时间为：\t$change_last_time"
	##计算时间跨度，即最晚的时间减去最早的时间的差值
		#let cross=($last_time-$first_time)/86400
		#echo -e "时间跨度:\t$cross  天"
		#echo '``````````````````````````````````````````'
		echo '``````````````````````````````````````````'
		echo "其中包含${#dir_array[@]}个子目录" ##还有${#else_array[@]}个非普通文件"
		echo -e "其中目录:\t${dir_array[@]}"
		echo -e "其他文件:\t${else_array[@]}"
		echo '``````````````````````````````````````````'
		echo '``````````````````````````````````````````'
	##计算有效代码行，其公式为：代码总行的75%
		#let valid_code_row=$valid_num*75/100
		let mix_code_comment_num=$comment_num+$valid_num
		echo "关于代码行数量的统计如下..."
		echo '``````````````````````````````````````````'
		echo -e "空行.......总量:\t${null_num}"
		echo -e "注释行.....总量:\t$comment_num"
		echo -e "注释行+代码总量:\t$mix_code_comment_num"
		echo -e "代码.......总量:\t$valid_num"
		#echo -e "有效代码...总量:\t$valid_code_row"
		echo '``````````````````````````````````````````'
	##计算总的空行量/总的代码量，用来衡量整体的结构，条例性等。毕竟：适当的空行会让代码更清晰易懂。
		#let beauty=${null_num}*100/$valid_num
		#let easy_reading=$comment_num*100/$valid_num
		#if [ $beauty -ge 14 -a $beauty -le 20 ]; then
		#	is_beauty='尚可，，空行是不是可以精简一点点呢？'
		#elif [ $beauty -ge 8 -a $beauty -lt 14 ]; then
		#	is_beauty='完美，适当的空行令您的代码清晰易懂'
		#elif [ $beauty -ge 20 -a $beauty -le 30 ]; then
		#	is_beauty='一般，空行有点多了。。'
		#elif [ $beauty -ge 0 -a $beauty -lt 8 ]; then
		#	is_beauty='很一般，空行太少了。。适当的加一些空行，有助于提高可读性。。'
		#else
		#	is_beauty='没有美感,,空行实在太多了，已经超过了代码量的30%，，兄弟！！！'
		#fi
		#if [ $easy_reading -ge 15 -a $easy_reading -le 25 ]; then
		#	is_easy_reading='还行吧，注释量在10%左右。。'
		#elif [ $easy_reading -ge 8 -a $easy_reading -lt 15 ]; then
		#	is_easy_reading='不好读，注释太少了。。。'
		#elif [ $easy_reading -gt 25 ]; then
		#	is_easy_reading='太高了，兄弟您这确定您是在写代码，而不是在写注释？'
		#else
		#	is_easy_reading='没有可读性'
		#fi
		#echo "关于代码行美感与可读性的统计如下..."
		#echo '``````````````````````````````````````````'
		#echo -e "代码的美感为：\t$is_beauty"
		#echo -e "代码的可读性为：\t$is_easy_reading"
		#echo '``````````````````````````````````````````'
	}	
 
##调用主函数
	main

