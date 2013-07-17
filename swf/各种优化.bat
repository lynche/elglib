@ECHO OFF

PATH D:\360data\重要数据\我的文档\appart\apparat;D:\360data\重要数据\我的文档\appart\scala-2.8.1\bin;D:\360data\重要数据\我的文档\appart\scala-2.8.1\lib;D:\360data\重要数据\我的文档\appart\7-Zip
::classpath  .;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;%JAVA_HOME%\lib\
::path    %ANT_HOME%/bin;%JAVA_HOME%\bin;%JAVA_HOME%\jre6\bin;%Scala_Home%/bin;%SevenZip_Home%/;.

@echo 先调用reduce减小了大小 %1
call reducer -i %1 -o %1 -q 0.7

@echo 再调用tdsi优化字节码
call tdsi -i %1 -o %1

::@echo 再再调用Stripper去除debug信息
::call Stripper -i %1 -o %1

@echo =====================================================
@echo ====================优化完毕=========================
@echo =====================================================
