#include<stdio.h>

int main()
{
	int index, val, end;	
	//int index=1, val=0, end;
	printf("�ε����� ���۰���?:"); scanf("%d",&index);
	printf("�ε����� �� ����?:"); scanf("%d",&end);

	printf("�հ�    �ε���\n");
	for(/*index=index*/; index<end; index+=2 )//index=index+2 ��� 
	{
	val= index+val; //val���� ��� ������. 
	printf("%-4d    %-4d\n",val,index);
	
	}
	/*	while(index<end)
	{
	val= index+val; //val���� ��� ������. 
	printf("%-4d    %-4d\n",val,index);
	index= index+2;
	}*/
}
