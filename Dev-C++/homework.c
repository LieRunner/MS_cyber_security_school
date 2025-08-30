#include<stdio.h>
#include<conio.h> //window only

int main()
{
	printf("입력\n");
	
	for(;;){
		char a =getch();
		if(a=='#')
		{printf("Program CLOSE.\n");
		break;
		}
		switch(a)
		{
			case '1': case '2':	case '3': case '4': case '5':
			case '6': case '7': case '8': case '9': case '0':	
			printf(">%c  :  숫자\n",a);
			break;

			default:
			if (a>='a' && a <='z')
			{printf(">%c  :  소문자\n",a);
						}
			else if	(a>='A' && a <='Z')
			{printf(">%c  :  대문자\n",a);
					}		
			else {
				printf(">%c  :  특수문자\n",a);
			}
			break;
			/*case 'a':printf(">%c  :  소문자\n",a);
			break;
			
			case 'b':printf(">%c  :  소문자\n",a);
			break;
			
			case 'c':printf(">%c  :  소문자\n",a);
			break;
			
			case 'd':printf(">%c  :  소문자\n",a);
			break;
			
			case 'A':printf(">%c  :  대문자\n",a);
			break;
			
			case 'B':printf(">%c  :  대문자\n",a);
			break;
			
			case 'C':printf(">%c  :  대문자\n",a);
			break;
			
			case '@':printf(">%c  :  특수문자\n",a);
			break;
			
			default:a = 3; break;*/
		}
		//if(a==3)break;
	}
	return 0;
}
