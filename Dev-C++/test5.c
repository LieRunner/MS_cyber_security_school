#include <stdio.h>
#include <conio.h> 
//콘솔함수를 사용하기위한 규칙 

int main()
{
	int v1, v2;
	printf("value 1 ? "); scanf("%d", &v1);
	printf("value 2 ? "); scanf("%d",&v2);
	
	for(;;) //while과 같은 무한루프  [while(1)]
	{
	
	char k =getch(); //콘솔함수 
	
	switch(k)          //정수만들어감 
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
	if(k==3) break; //다른 키를 입력하면 종료 (3은 입력할수 없는 수 이기에)
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
	// %f 실수로 만들어라  (double):실수로 만들어라. 필요한 부분마다 삽입 
	}
	else break; //다른 키가 눌리면 종료 */
	
}
