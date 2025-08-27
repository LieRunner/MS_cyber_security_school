#include <stdio.h>

int main() {
    char ch;

    while (1) {   // 무한 반복
        printf("문자 하나 입력 (종료하려면 # 입력): ");
        char ch =getch();

        if (ch == '#') {   // 종료 조건
            printf("프로그램을 종료합니다.\n");
            break;  // 반복문 탈출
        }

        switch (ch) {
            // 숫자 구분
            case '0': case '1': case '2': case '3': case '4':
            case '5': case '6': case '7': case '8': case '9':
                printf("%c는 숫자입니다.\n",ch);
                break;

            default:
                if (ch >= 'a' && ch <= 'z') {
                    printf("%c는 소문자입니다.\n",ch);
                }
                else if (ch >= 'A' && ch <= 'Z') {
                    printf("%c는 대문자입니다.\n",ch);
                }
                else {
                    printf("%c는 특수문자입니다.\n",ch);
                }
                break;
        }
    }

    return 0;
}

