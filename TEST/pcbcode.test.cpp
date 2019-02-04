// pcbcode.test.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <locale.h>
#include <windows.h>
#include "./..\..\cpp\pcbcode.h"

void ErrorExit(LPTSTR lpszFunction) 
{ 
	CHAR szBuf[80]={0}; 
	LPVOID lpMsgBuf;
	DWORD dw = GetLastError(); 
	DWORD ch_count = FormatMessage(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | 
		FORMAT_MESSAGE_FROM_HMODULE,
		GetModuleHandle("pcbcode.dll"),
		dw,
		MAKELANGID(LANG_RUSSIAN, SUBLANG_DEFAULT),
		(LPTSTR) &lpMsgBuf,
		0, NULL );
	if( ch_count == 0 )
	{
		FormatMessage(
				FORMAT_MESSAGE_ALLOCATE_BUFFER | 
				FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				dw,
				MAKELANGID(LANG_RUSSIAN, SUBLANG_DEFAULT),
				(LPTSTR) &lpMsgBuf,
				0, NULL );
	}
	sprintf(szBuf, 
		"%s failed with error %d: %s", 
		lpszFunction, dw, lpMsgBuf); 
	printf(szBuf);
	//MessageBox(NULL, szBuf, "Error", MB_OK); 
	LocalFree(lpMsgBuf);
	ExitProcess(dw); 
}

int _tmain(int argc, _TCHAR* argv[]) {
	//��������� ����������� �� ������� ����
	setlocale( LC_ALL, "Russian" );
	BYTE bar_code_data_V1[]  = 
	{
		0x01, 0x00, 0x16, 0xE9, 0x59, 0xAF, 0x0F, 0x3A, 
		0x6C, 0x53, 0xE6, 0x84, 0xD3, 0x77, 0x71, 0xCE, 
		0xEF, 0x39, 0xDF, 0x38, 0x71, 0x1D, 0xE4, 0xFC, 
		0xD2, 0x76, 0x85, 0xDF, 0x35, 0x41, 0x9C, 0x03, 
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
		0x00, 0x00, 0x00, 0x02, 0x71, 0xD3, 0x00, 0x00, 
		0x00, 0xEF, 0x4A, 0x04, 0xBD, 0xB8, 0x00, 0xF6, 
		0x18, 0x01, 0x7D, 0xDE, 0x3F, 0x6B, 0x9C, 0x4B, 
		0x45, 0x92, 0xFB, 0x28, 0xEB, 0x75, 0xEF, 0x1E, 
		0x0D, 0x22, 0x74, 0xBD, 0x0F, 0x57, 0x37, 0x72, 
		0x84, 0xF0, 0x24, 0x69, 0x69, 0x8A, 0x8C, 0xAC, 
		0x4A, 0x91, 0x2F, 0xE7, 0x4D, 0x77, 0x3A, 0xF6, 
		0xFC, 0x0C, 0x8D, 0x71, 0x51, 0x5C, 0xB8, 0x81, 
		0x76, 0xEC, 0x04, 0xA4, 0x14, 0xB1, 0x79, 0xAD, 
		0x00, 0xAC, 0x54, 0x82, 0x95, 0x03, 0x39, 0x72, 
		0xDC, 0x82 
	};
	//V2
	BYTE bar_code_data_V2[]  =  
  { 
		0x02, 0x00, 0x00, 0x00, 0x00, 0x36, 0x3D, 0x80, 
		0x4E, 0x9D, 0xB3, 0xA1, 0x75, 0x03, 0xBF, 0x84, 
		0xE8, 0x69, 0xB9, 0xC3, 0xBF, 0x39, 0xC3, 0xA1, 
		0x75, 0xAA, 0x53, 0x41, 0xC3, 0x80, 0x00, 0x00, 
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
		0x00, 0x00, 0x00, 0x00, 0x02, 0x83, 0xEB, 0x00, 
		0x00, 0x01, 0x5C, 0xEA, 0x68, 0x0D, 0x9C, 0xDD, 
		0xEF, 0x02, 0x09, 0xE9, 0xF9, 0x1F, 0xFE, 0xA6, 
		0x28, 0x32, 0x8C, 0xD1, 0x57, 0x14, 0x4B, 0x63, 
		0x42, 0x04, 0xBA, 0xC3, 0x0F, 0x57, 0x3F, 0xF2, 
		0xE1, 0x02, 0x1B, 0xDC, 0x2A, 0x28, 0xB2, 0xDD, 
		0x50, 0xA2, 0x76, 0x1E, 0x4C, 0xF7, 0x5F, 0xFC, 
		0xDB, 0xFB, 0xA7, 0x1E, 0xAF, 0xC5, 0x48, 0xAD, 
		0x07, 0xD3, 0x8D, 0xC8, 0x2A, 0x7D, 0x67, 0x4B, 
		0xD0, 0x9A
  };
	DWORD dwLength	= 130;
	BARCODE_T1 T1   = {0};
	DWORD dwError		= DecomposeBarcode(&bar_code_data_V1[0], dwLength, &T1);
	//����� �� �������
	printf("��� �����-����:         %d\r\n", T1.Header.BarcodeType);
	printf("����� ������ ���:       %016I64d\r\n", T1.Body.PolicyNumber);
	printf("�������:                %s\r\n", T1.Body.LastName);
	printf("���:                    %s\r\n", T1.Body.FirstName);
	printf("��������:               %s\r\n", T1.Body.Patronymic);
	printf("���� ��������:          %02d.%02d.%04d\r\n", T1.Body.BirthDate.wDay,T1.Body.BirthDate.wMonth,T1.Body.BirthDate.wYear);
	printf("���� �������� ������    %02d.%02d.%04d\r\n", T1.Body.ExpireDate.wDay,T1.Body.ExpireDate.wMonth,T1.Body.ExpireDate.wYear);
	printf("���                     %s\r\n", T1.Body.Sex == 1 ? "�������":"�������");
	if( dwError != 0 ) {
		ErrorExit("DecomposeBarcode");
	}
	BARCODE_T1 T2   = {0};
	printf("\r\n");
	dwError		= DecomposeBarcode(&bar_code_data_V2[0], dwLength, &T2);
	//����� �� �������
	printf("��� �����-����:         %d\r\n", T2.Header.BarcodeType);
	printf("����� ������ ���:       %016I64d\r\n", T2.Body.PolicyNumber);
	printf("�������:                %s\r\n", T2.Body.LastName);
	printf("���:                    %s\r\n", T2.Body.FirstName);
	printf("��������:               %s\r\n", T2.Body.Patronymic);
	printf("���� ��������:          %02d.%02d.%04d\r\n", T2.Body.BirthDate.wDay,T2.Body.BirthDate.wMonth,T2.Body.BirthDate.wYear);
	printf("���� �������� ������    %02d.%02d.%04d\r\n", T2.Body.ExpireDate.wDay,T2.Body.ExpireDate.wMonth,T2.Body.ExpireDate.wYear);
	printf("���                     %s\r\n", T2.Body.Sex == 1 ? "�������":"�������");
	if( dwError != 0 ) {
		ErrorExit("DecomposeBarcode");
	}
	return 0;
}

