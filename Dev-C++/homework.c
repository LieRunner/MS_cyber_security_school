#include<stdio.h>
#include<conio.h> //window only

int main()
{
	printf("�Է�\n");
	
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
			printf(">%c  :  ����\n",a);
			break;

			default:
			if (a>='a' && a <='z')
			{printf(">%c  :  �ҹ���\n",a);
						}
			else if	(a>='A' && a <='Z')
			{printf(">%c  :  �빮��\n",a);
					}		
			else {
				printf(">%c  :  Ư������\n",a);
			}
			break;
			/*case 'a':printf(">%c  :  �ҹ���\n",a);
			break;
			
			case 'b':printf(">%c  :  �ҹ���\n",a);
			break;
			
			case 'c':printf(">%c  :  �ҹ���\n",a);
			break;
			
			case 'd':printf(">%c  :  �ҹ���\n",a);
			break;
			
			case 'A':printf(">%c  :  �빮��\n",a);
			break;
			
			case 'B':printf(">%c  :  �빮��\n",a);
			break;
			
			case 'C':printf(">%c  :  �빮��\n",a);
			break;
			
			case '@':printf(">%c  :  Ư������\n",a);
			break;
			
			default:a = 3; break;*/
		}
		//if(a==3)break;
	}
	return 0;
}
