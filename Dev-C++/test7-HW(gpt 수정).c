#include<stdio.h>
#include<conio.h>

int func1(char c); //function prototype

int main()
{
	int k;
	char c;
	int m = 1;
	while(m){
	
	printf("(ESC����)>"); c=getch();
	if(c == 27)  // ESC Ű �Է½� ����
        {
            printf("\n���α׷� ����!\n");
            break;
        }
	k = func1(c);
	
	switch(func1(c))
	{
		case 1: printf("%c : �빮��\n",c);   break;
		case 2: printf("%c : �ҹ���\n",c);   break;
		case 3: printf("%c : ����\n",c);     break;
		case 4: printf("%c : Ư������\n",c); break;
		default: break;
		
	}
}
    return 0;
}
int func1(char c)
{
	int k;
	if ((c>='A') && (c<='Z'))       k=1;
	else if ((c >='a')&&(c <='z'))  k=2;
	else if ((c >='0')&&(c <='9'))  k=3;
	else                            k=4;
	
	return k;

}
