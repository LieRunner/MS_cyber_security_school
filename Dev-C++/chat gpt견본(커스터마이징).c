#include <stdio.h>

int main() {
    char ch;

    while (1) {   // ���� �ݺ�
        printf("���� �ϳ� �Է� (�����Ϸ��� # �Է�): ");
        char ch =getch();

        if (ch == '#') {   // ���� ����
            printf("���α׷��� �����մϴ�.\n");
            break;  // �ݺ��� Ż��
        }

        switch (ch) {
            // ���� ����
            case '0': case '1': case '2': case '3': case '4':
            case '5': case '6': case '7': case '8': case '9':
                printf("%c�� �����Դϴ�.\n",ch);
                break;

            default:
                if (ch >= 'a' && ch <= 'z') {
                    printf("%c�� �ҹ����Դϴ�.\n",ch);
                }
                else if (ch >= 'A' && ch <= 'Z') {
                    printf("%c�� �빮���Դϴ�.\n",ch);
                }
                else {
                    printf("%c�� Ư�������Դϴ�.\n",ch);
                }
                break;
        }
    }

    return 0;
}

