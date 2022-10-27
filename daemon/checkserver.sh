count=`ps aux|grep -v grep |grep (程序ps aux的唯一进程名称) |wc -l`
if [  $count -eq 0 ] ; then
	echo  未运行，尝试启动 
	# 程序启动命令
else
	echo  正常运行  
fi

