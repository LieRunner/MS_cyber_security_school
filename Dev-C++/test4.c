#include <stdio.h>

int main()
{
	printf("�հ�  �ε���\n");
	int index = 1, val= 0;
	    //����� 
	while(index<10){
		    //�賡 
		val= val+index;
		printf("%-3d     %03d\n",val, index); //%(- or 0)(n)d ���ĵ� 
		//index++;
		index = index + 2;
	}
	
	
	printf("�ε��� ���۰��� %d�̴�\n",index) 
}
