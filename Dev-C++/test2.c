#include <stdio.h>

int main()
{
	printf("합계  인덱스\n");
	int index = 1, val= 0;
	
	while(index<10){
		val= val+index;
		printf("%3d     %2d\n",val, index); //%(-)(n)d
		//index++;
		index = index + 2;
	}
}
