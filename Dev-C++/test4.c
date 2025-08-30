#include <stdio.h>

int main()
{
	printf("합계  인덱스\n");
	int index = 1, val= 0;
	    //↑시작 
	while(index<10){
		    //↑끝 
		val= val+index;
		printf("%-3d     %03d\n",val, index); //%(- or 0)(n)d 정렬됨 
		//index++;
		index = index + 2;
	}
	
	
	printf("인덱스 시작값은 %d이다\n",index) 
}
