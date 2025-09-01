#include<stdio.h>
#include<string.h>
#include<stdlib.h>

char *title[] = {"번호","이름","국어","영어","수학"};
char *name[] = {"이승빈","박정석", "박시혜", "김준혁","박재은"};
int kor[]={10,20,30,40,80};
int eng[]={60,70,80,90,70};
int mat[]={70,60,50,40,30};

void swap(int i, int j); //swap prototype
//
//  t13[번호]
//    번호에 해당하는 학생의 이름과 성적을 화면에 출력
//    <default> ALL

int main(int n, char *s[])
{
    int start = 0, end = 5; //end=5는 사실 필요없음
    if( n > 1 )       //"1"  "2"  "--help"
    { 
      if(strcmp(s[1], "--help")==0)  //strcmp 표준함수 어디서든 쓸수있음
        {
          printf("  \n\n t12[번호] [--help]\n");
          printf("  번호에 해당하는 학생의 이름과 성적을 화면에 출력합니다.\n");
          printf("  <default> ALL  \n\n\n");
          exit(1);
        }
      start = atoi(s[1])-1;  //문자 '1'을 숫자 '1' 1로 변경해주는 것
      end = start + 1;
    }

    
    for (int i = start; i < end ; i++){
      if(i==start) //title line 출력
      {
        for (int j =0; j<5; j++)
        {
          printf("%s\t",title[j]);

        
      }printf("\n");
      
      }        printf("%2d\t%s\t%3d\t%3d\t  %3d\t\n",i+1, name[i], kor[i],eng[i],mat[i]);
   }} 
/*int i = 10,j = 20, k;
printf("(before)i : %d    j: %d\n",i, j);
k=i; i=j ; j=k;
swap(i,j);
printf("(after)i : %d   j: %d\n",i,j);
}

void swap (int i, int j)
{
int k;
printf("   (before)i : %d    j: %d\n",i, j);
k=i; i=j ; j=k;
printf("   (after)i :  %d    j: %d\n",i,j);


}*/
