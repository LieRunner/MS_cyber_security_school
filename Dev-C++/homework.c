#include<stdio.h>
#include<conio.h>

int main()
{
	printf("�Է�\n");
	
	for(;;){
		char a =getch();
		
		switch(a)
		{
			case '1':printf(">%c  :  ����\n",a);
			break;
			case '2':printf(">%c  :  ����\n",a);
			break;
			case '3':printf(">%c  :  ����\n",a);
			break;
			case '4':printf(">%c  :  ����\n",a);
			break;
			case '5':printf(">%c  :  ����\n",a);
			break;
			case '6':printf(">%c  :  ����\n",a);
			break;
			case '7':printf(">%c  :  ����\n",a);
			break;
			case '8':printf(">%c  :  ����\n",a);
			break;
			case '9':printf(">%c  :  ����\n",a);
			break;
			case '0':printf(">%c  :  ����\n",a);
			break;
			default: a =3;break;
			case 'a':printf(">%c  :  �ҹ���\n",a);
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
		}
		if(a==3)break;
	}
}
