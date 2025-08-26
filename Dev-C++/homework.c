#include<stdio.h>
#include<conio.h>

int main()
{
	printf("입력\n");
	
	for(;;){
		char a =getch();
		
		switch(a)
		{
			case '1':printf(">%c  :  숫자\n",a);
			break;
			case '2':printf(">%c  :  숫자\n",a);
			break;
			case '3':printf(">%c  :  숫자\n",a);
			break;
			case '4':printf(">%c  :  숫자\n",a);
			break;
			case '5':printf(">%c  :  숫자\n",a);
			break;
			case '6':printf(">%c  :  숫자\n",a);
			break;
			case '7':printf(">%c  :  숫자\n",a);
			break;
			case '8':printf(">%c  :  숫자\n",a);
			break;
			case '9':printf(">%c  :  숫자\n",a);
			break;
			case '0':printf(">%c  :  숫자\n",a);
			break;
			default: a =3;break;
			case 'a':printf(">%c  :  소문자\n",a);
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
		}
		if(a==3)break;
	}
}
