#include<stdio.h>

int main()
{
	int index, val, end;	
	//int index=1, val=0, end;
	printf("인덱스의 시작값은?:"); scanf("%d",&index);
	printf("인덱스의 끝 값은?:"); scanf("%d",&end);

	printf("합계    인덱스\n");
	for(/*index=index*/; index<end; index+=2 )//index=index+2 축소 
	{
	val= index+val; //val값은 계속 증가함. 
	printf("%-4d    %-4d\n",val,index);
	
	}
	/*	while(index<end)
	{
	val= index+val; //val값은 계속 증가함. 
	printf("%-4d    %-4d\n",val,index);
	index= index+2;
	}*/
}
