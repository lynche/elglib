@ECHO OFF

PATH D:\360data\��Ҫ����\�ҵ��ĵ�\appart\apparat;D:\360data\��Ҫ����\�ҵ��ĵ�\appart\scala-2.8.1\bin;D:\360data\��Ҫ����\�ҵ��ĵ�\appart\scala-2.8.1\lib;D:\360data\��Ҫ����\�ҵ��ĵ�\appart\7-Zip
::classpath  .;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;%JAVA_HOME%\lib\
::path    %ANT_HOME%/bin;%JAVA_HOME%\bin;%JAVA_HOME%\jre6\bin;%Scala_Home%/bin;%SevenZip_Home%/;.

@echo �ȵ���reduce��С�˴�С %1
call reducer -i %1 -o %1 -q 0.7

@echo �ٵ���tdsi�Ż��ֽ���
call tdsi -i %1 -o %1

::@echo ���ٵ���Stripperȥ��debug��Ϣ
::call Stripper -i %1 -o %1

@echo =====================================================
@echo ====================�Ż����=========================
@echo =====================================================
