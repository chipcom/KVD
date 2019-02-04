// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the PCBCODE_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// PCBCODE_API functions as being imported from a DLL, whereas this DLL sees symbols
// defined with this macro as being exported.

#ifdef PCBCODE_EXPORTS
#define PCBCODE_API __declspec(dllexport)
#else
#define PCBCODE_API __declspec(dllimport)
#endif

#pragma pack(push, 1)

#include <basetsd.h>

//extern "C"
//{
typedef unsigned char BYTE;
typedef char CHAR;
typedef unsigned long DWORD;
typedef unsigned short WORD;
typedef unsigned __int64 DWORD64;

typedef struct _SYSTEMTIME {
  WORD wYear;
  WORD wMonth;
  WORD wDayOfWeek;
  WORD wDay;
  WORD wHour;
  WORD wMinute;
  WORD wSecond;
  WORD wMilliseconds;
} SYSTEMTIME, *PSYSTEMTIME, *LPSYSTEMTIME;
//Данная структура описывает заголовок штрих-кода
typedef struct
{
	//Код типа штрих-кода
	BYTE BarcodeType;			/*0*/
} BARCODE_HEADER, *PBARCODE_HEADER;

typedef struct
{
	//Номер полиса
	DWORD64				 PolicyNumber;		/*1*/
	//Фамилия
	CHAR					 FirstName[32];		/*9*/
	//Имя
	CHAR					 LastName[32];		/*41*/
	//Отчество
	CHAR					 Patronymic[32];	/*73*/
	//Пол
	BYTE					 Sex;							/*105*/
	//Дата рождения
	SYSTEMTIME		 BirthDate;				/*106*/
	//Срок действия полиса ОМС
	SYSTEMTIME		 ExpireDate;			/*122*/
	//Номер полиса в строковом представлении
	CHAR				   PolicyNumberString[17]; /*138*/
}BARCODE_BODY, *PBARCODE_BODY;

//Данная структура описывает формат штрих-кода: Тип #1
typedef struct
{
	/*L203*/
	union {	BARCODE_HEADER	Header; };
	union { BARCODE_BODY		Body;		};
	BYTE										EDS[65];	/*155*/
} BARCODE_T1, *PBARCODE_T1;

//Преобразование бинарных данных штрих-кода к структуре штрих-кода
PCBCODE_API int DecomposeBarcode(BYTE * pbRawData, DWORD dwLength, void * pvBarcode);
//};

#pragma pack(pop)