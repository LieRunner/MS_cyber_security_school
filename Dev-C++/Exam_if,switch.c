#include<stdio.h>
#include<conio.h>

int main()
{
	
	printf("숫자를 입력하세요:\n");
	
	for(;;){
		char nu =getch();
		switch(nu)
		{
			case '1':printf(">%c  :  one\n",nu);
			break;
			case '2':printf(">%c  :  two\n",nu);
			break;
			case '3':printf(">%c  :  three\n",nu);
			break;
			case '4':printf(">%c  :  four\n",nu);
			break;
			case '5':printf(">%c  :  five\n",nu);
			break;
			case '6':printf(">%c  :  six\n",nu);
			break;
			case '7':printf(">%c  :  seven\n",nu);
			break;
			case '8':printf(">%c  :  eight\n",nu);
			break;
			case '9':printf(">%c  :  nine\n",nu);
			break;
			default: nu = 3; break;
			
		}
	if(nu==3)break;
	/*if(nu =='1'){
			printf("%c  :  one\n",nu);
		}
		else if(nu =='2'){
			printf("%c  :  two\n",nu);
		}
		else if(nu =='3'){
			printf("%c  :  three\n",nu);
		}
		else if(nu =='4'){
			printf("%c  :  four\n",nu);
		}
		else if(nu =='5'){
			printf("%c  :  five\n",nu);
		}
		else if(nu =='6'){
			printf("%c  :  six\n",nu);
		}
		else if(nu =='7'){
			printf("%c  :  seven\n",nu);
		}
		else if(nu =='8'){
			printf("%c  :  eight\n",nu);
		}
		else if(nu =='9'){
			printf("%c  :  nine\n",nu);
		}
		else if(nu =='0'){
			printf("%c  :  zero\n",nu);
		}
		else break;*/
		
		
		}
 } 
