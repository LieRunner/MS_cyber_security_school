#include<stdio.h>

int main()
{
	int nu;
	printf("숫자를 입력하세요:"); scanf("%d",&nu);
	
		
	if(nu ==1){
			printf("%d  :  one\n",nu);
		}
		else if(nu ==2){
			printf("%d  :  two\n",nu);
		}
		else if(nu ==3){
			printf("%d  :  three\n",nu);
		}
		else if(nu ==4){
			printf("%d  :  four\n",nu);
		}
		else if(nu ==5){
			printf("%d  :  five\n",nu);
		}
		else{
			printf("1~5사이에 숫자만 입력하세요.\n");
		}
 } 
