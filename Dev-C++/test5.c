#include <stdio.h>
#include <conio.h> 
//�ܼ��Լ��� ����ϱ����� ��Ģ 

int main()
{
	int v1, v2;
	printf("value 1 ? "); scanf("%d", &v1);
	printf("value 2 ? "); scanf("%d",&v2);
	
	for(;;) //while�� ���� ���ѷ���  [while(1)]
	{
	
	char k =getch(); //�ܼ��Լ� 
	
	switch(k)          //�������� 
	{
		case '+':printf("%d %c %d = %d\n", v1, k, v2, v1+v2); 
		break;
	
		case '-':printf("%d %c %d = %d\n", v1, k, v2, v1-v2); 
		break;
	
		case '*':printf("%d %c %d = %d\n", v1, k, v2, v1*v2); 
		break;
	
		case '/':printf("%d %c %d = %f\n", v1, k, v2, (double)v1/(double)v2); 
		break;
		default: k = 3; break;
	}
	if(k==3) break; //�ٸ� Ű�� �Է��ϸ� ���� (3�� �Է��Ҽ� ���� �� �̱⿡)
}
	

	  
 
	
	
	/*
	if(k == '+' ){
	printf("%d %c %d = %d\n", v1, k, v2, v1+v2);   
	}
	else if(k == '-' )  
	{
		printf("%d %c %d = %d\n", v1, k, v2, v1-v2);   
	}
	else if(k == '*' )  
	{
		printf("%d %c %d = %d\n", v1, k, v2, v1*v2);   
	}
	
	else if(k == '/' )
	{
		printf("%d %c %d = %f\n", v1, k, v2, ((double)v1/(double)v2));   
	// %f �Ǽ��� ������  (double):�Ǽ��� ������. �ʿ��� �κи��� ���� 
	}
	else break; //�ٸ� Ű�� ������ ���� */
	
}
