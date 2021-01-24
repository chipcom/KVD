package main

import (
	"bytes"
	"encoding/xml"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"strings"

	"github.com/tadvi/dbf"
	"golang.org/x/text/encoding/charmap"
)

// type Transaction struct {
//     //...
//     DateEntered     customTime     `xml:"enterdate"` // use your own type that satisfies UnmarshalXML
//     //...
// }

// type customTime struct {
// 	time.Time
// }

// func (c *customTime) UnmarshalXML(d *xml.Decoder, start xml.StartElement) error {
// 	const shortForm = "20060102" // yyyymmdd date format
// 	var v string
// 	d.DecodeElement(&v, &start)
// 	parse, err := time.Parse(shortForm, v)
// 	if err != nil {
// 		return err
// 	}
// 	*c = customTime{parse}
// 	return nil
// }
type JurAddress struct {
	Index   string `xml:"index_j"`
	Address string `xml:"addr_j"`
}
type MedAdvice struct {
	YearWork string `xml:"YEAR_WORK"`
}

type MedCompany struct {
	XMLName   xml.Name    `xml:"medCompany"`
	TfOKATO   string      `xml:"tf_okato"`
	Mcod      string      `xml:"mcod"`
	NamMop    string      `xml:"nam_mop"`
	NamMok    string      `xml:"nam_mok"`
	INN       string      `xml:"inn"`
	KPP       string      `xml:"KPP"`
	OGRN      string      `xml:"ogrn"`
	Address   JurAddress  `xml:"jurAddress"`
	Medadvice []MedAdvice `xml:"medAdvice"`
}

type Packet struct {
	XMLName      xml.Name     `xml:"packet"`
	Version      string       `xml:"version,attr"`
	Date         string       `xml:"date,attr"`
	MedCompanies []MedCompany `xml:"medCompany"`
}

type FieldType int

const (
	None FieldType = iota
	Alpha
	Bool
	Int
	Float
)

type FieldName struct {
	name     string
	typ      FieldType
	length   int
	truncate bool // truncated fields longer than 254
}

func removeQuotes(s string) string {
	var b bytes.Buffer
	for _, r := range s {
		if r != '"' && r != '\'' && r != '«' && r != '»' {
			b.WriteRune(r)
		}
	}

	return b.String()
}

func utfTOcp886(s string) string {
	//Инициализируем декодирование с указанным типом CodePage866
	d := charmap.CodePage866.NewEncoder()
	//Обрабатываем вывод
	decodeOut, _ := d.String(s)
	//Говорим что это строка
	return string(decodeOut)
}

type ReplaceString struct {
	Full  string
	Short string
}

func manyRepl(arr []ReplaceString, s string) string {

	ret := s
	for _, elem := range arr {
		ret = strings.Replace(ret, elem.Full, elem.Short, -1)
	}
	return ret
}

// https://www2.arhofoms.ru/it/base/%D0%9F%D1%80%D0%B8%D0%BA%D0%B0%D0%B7%20%D0%A4%D0%9E%D0%9C%D0%A1%20%D0%BE%D1%82%2020110407%2079%20(%D1%80%D0%B5%D0%B4.%20%D0%BE%D1%82%2030.08.2019%20173)%20%D0%9E%D0%B1%20%D1%83%D1%82%D0%B2%D0%B5%D1%80%D0%B6%D0%B4%D0%B5%D0%BD%D0%B8%D0%B8%20%D0%BE%D0%B1%D1%89%D0%B8%D1%85%20%D0%BF%D1%80%D0%B8%D0%BD%D1%86%D0%B8%D0%BF%D0%BE%D0%B2%20(%D0%A4%D0%9E%D0%9C%D0%A1).pdf
func main() {

	arrRepl := []ReplaceString{
		{"ГОСУДАРСТВЕННОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГУЗ"},
		{"ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГБУЗ"},
		{"ГОСУДАРСТВЕННОЕ ОБЛАСТНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГОБУЗ"},
		{"ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГАУЗ"},
		// {"ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГАУЗ"},
		{"ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВОХРАНЕНИЯ", "ГАУЗ"},
		{"ОБЛАСТНОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ОАУЗ"},
		{"ОБЛАСТНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ОБУЗ"},
		{"ОБЛАСТНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДОРАВООХРАНЕНИЯ", "ОБУЗ"},
		{"АВТОНОМНАЯ НЕКОММЕРЧЕСКАЯ ОРГАНИЗАЦИЯ", "АНО"},
		{"МУНИЦИПАЛЬНОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ", "МУП"},
		{"ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ", "ООО"},
		{"ЗАКРЫТОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО", "ЗАО"},
		{"АКЦИОНЕРНОЕ ОБЩЕСТВО", "АО"},
		{"ФЕДЕРАЛЬНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ФБУЗ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ НАУКИ", "ФГБУН"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ", "ФГБУ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ", "ФГАУ"},
		{"ФЕДЕРАЛЬНОЕ КАЗЕННОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ФКУЗ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ КАЗЕННОЕ УЧРЕЖДЕНИЕ", "ФГКУ"},
		{"НАУЧНО-ИССЛЕДОВАТЕЛЬСКИЙ ИНСТИТУТ", "НИИ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ НАУЧНОЕ УЧРЕЖДЕНИЕ", "ФГБНУ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ", "ФГБОУВО"},
		{"ФЕДЕРАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ ЦЕНТР", "ФИЦ"},
		{"МЕДИКО-САНИТАРНАЯ ЧАСТЬ", "МСЧ"},
		{"МИНИСТЕРСТВА ТРУДА И СОЦИАЛЬНОЙ ЗАЩИТЫ РОССИЙСКОЙ ФЕДЕРАЦИИ", "МИНТРУДА РОССИИ"},
		{"МИНИСТЕРСТВА ВНУТРЕННИХ ДЕЛ РОССИИ", "МВД РФ"},
		{"МИНИСТЕРСТВА ВНУТРЕННИХ ДЕЛ РОССИЙСКОЙ ФЕДЕРАЦИИ", "МВД РФ"},
		{"НАЦИОНАЛЬНЫЙ МЕДИЦИНСКИЙ ИССЛЕДОВАТЕЛЬСКИЙ ЦЕНТР", "НМИЦ"},
		{"РОССИЙСКИЙ НАУЧНЫЙ ЦЕНТР", "РНЦ"},
		{"МИНИСТЕРСТВА ОБОРОНЫ РОССИЙСКОЙ ФЕДЕРАЦИИ", "МИНОБОРОНЫ РОССИИ"},
		{"МИНИСТЕРСТВА ЗДРАВООХРАНЕНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ", "МИНЗДРАВА РОССИИ"},
		{"МИНИСТЕРСТВА ЗДРАВООХРАНЕНИЯ", "МИНЗДРАВА"},
		{"ФЕДЕРАЛЬНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ НАУКИ", "ФБУН"},
		{"ФЕДЕРАЛЬНЫЙ НАУЧНЫЙ ЦЕНТР", "ФНЦ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ", "ФГУП"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ ВОЕННОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ", "ФГБВОУВО"},
		{"ФЕДЕРАЛЬНОЙ СЛУЖБЫ ПО НАДЗОРУ В СФЕРЕ ЗАЩИТЫ ПРАВ ПОТРЕБИТЕЛЕЙ И БЛАГОПОЛУЧИЯ ЧЕЛОВЕКА", "РОСПОТРЕБНАДЗОРА"},
		{"МЕЖОТРАСЛЕВОЙ НАУЧНО-ТЕХНИЧЕСКИЙ КОМПЛЕКС", "МНТК"},
		{"ФЕДЕРАЛЬНОГО МЕДИКО-БИОЛОГИЧЕСКОГО АГЕНТСТВА", "ФМБА"},
		{"ФЕДЕРАЛЬНОГО МЕДИКО-БИОЛОГИЧЕСКОГО АГЕНСТВА", "ФМБА"},
		{"ГОСУДАРСТВЕННОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ", "ГУП"},
		{"МОСКОВСКОЙ ОБЛАСТИ", "МО"},
		{"ЦЕНТРАЛЬНАЯ РАЙОННАЯ БОЛЬНИЦА", "ЦРБ"},
		{"МОСКОВСКОЙ ОБЛАСТИ", "МО"},
		{"ЧАСТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ЧУЗ"},
		{"ЦЕНТРАЛЬНАЯ ГОРОДСКАЯ БОЛЬНИЦА", "ЦГБ"},
		{"ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ", "ГБУ"},
		{"ЛЕЧЕБНО-ДИАГНОСТИЧЕСКИЙ ЦЕНТР", "ЛДЦ"},
		{"ОБШЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ", "ООО"},
		{"ОБЩЕСТВА С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ", "ООО"},
		{"ЧАСТНОЕ УЧРЕЖДЕНИЕ ДОПОЛНИТЕЛЬНОГО ПРОФЕССИОНАЛЬНОГО ОБРАЗОВАНИЯ", "ЧУДПО"},
		{"АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "АУЗ"},
		{"ФЕДЕРАЛЬНОГО ГОСУДАРСТВЕННОГО АВТОНОМНОГО УЧРЕЖДЕНИЯ", "ФГАУ"},
		{"МУНИЦИПАЛЬНОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "МАУЗ"},
		{"ФЕДЕРАЛЬНОГО ГОСУДАРСТВЕННОГО БЮДЖЕТНОГО УЧРЕЖДЕНИЯ", "ФГБУ"},
		{"ФЕДЕРАЛЬНЫЙ КЛИНИЧЕСКИЙ ЦЕНТР", "ФКЦ"},
		{"ОБЛАСТНОЕ ГОСУДАРСТВЕННОЕ КЛИНИЧЕСКОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ОГКБУЗ"},
		{"ОБЛАСТНОЕ ГБУЗ", "ОГБУЗ"},
		{"МЕДИКО-СОЦИАЛЬНОЙ ЭКСПЕРТИЗЫ", "МСЭ"},
		{"РЕАБИЛИТАЦИИ ИНВАЛИДОВ", "РИ"},
		{"НАУЧНО-ПРАКТИЧЕСКИЙ ЦЕНТР", "НПЦ"},
		{"ФЕДЕРАЛЬНОГО ГОСУДАРСТВЕННОГО КАЗЕННОГО УЧРЕЖДЕНИЯ", "ФГКУ"},
		{"НАУЧНЫЙ ЦЕНТР", "НЦ"},
		{"ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ СОЦИАЛЬНО-ОЗДОРОВИТЕЛЬНОЕ УЧРЕЖДЕНИЕ", "ГБСОУ"},
		{"ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ", "ФГАОУ"},
		{"ВЫСШЕГО ОБРАЗОВАНИЯ", "ВО"},
		{"МЕЖДУНАРОДНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ И ДОПОЛНИТЕЛЬНОГО ОБРАЗОВАНИЯ", "МУЗ ДО"},
		{"ОБЛАСТНОЕ ГОСУДАРСТВЕННОЕ КАЗЕННОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ОГКУЗ"},
		{"ФЕДЕРАЛЬНОГО ГОСУДАРСТВЕННОГО БЮДЖЕТНОГО ОБРАЗОВАТЕЛЬНОГО УЧРЕЖДЕНИЯ ДОПОЛНИТЕЛЬНОГО ПРОФЕССИОНАЛЬНОГО ОБРАЗОВАНИЯ", "ФГБОУДПО"},
		{"ФЕДЕРАЛЬНОЕ КАЗЕННОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНИЕНИЯ", "ФКУЗ"},
		{"БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "БУЗ"},
		{"ФЕДЕРАЛЬНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ", "ФБУ"},
		{"ФОНДА СОЦИАЛЬНОГО СТРАХОВАНИЯ РОССИЙСКОЙ ФЕДЕРАЦИИ", "ФСС РФ"},
		{"ФЕДЕРАЛЬНОГО ГОСУДАРСТВЕННОГО УНИТАРНОГО ПРЕДПРИЯТИЯ", "ФГУП"},
		{"ОТКРЫТОГО АКЦИОНЕРНОГО ОБЩЕСТВА", "ОАО"},
		{"РОССИЙСКИЕ ЖЕЛЕЗНЫЕ ДОРОГИ", "РЖД"},
	}

	dbffile := "f003.dbf"

	names := []FieldName{
		{name: "MCOD", typ: None, length: 6},
		{name: "NAMEMOK", typ: None, length: 50, truncate: true},
		{name: "NAMEMOP", typ: None, length: 150, truncate: true},
		{name: "ADDRESS", typ: None, length: 250, truncate: true},
		{name: "YEAR", typ: Int, length: 4},
	}

	db := dbf.New()
	log.Println("Creating table:")
	log.Println("------------------------")

	for _, f := range names {
		switch f.typ {
		case None, Alpha:
			db.AddTextField(f.name, uint8(f.length))
			log.Println("Text field:", f.name, "size:", f.length)
		case Bool:
			db.AddBoolField(f.name)
			log.Println("Bool field:", f.name)
		case Int:
			db.AddIntField(f.name)
			log.Println("Int field:", f.name)
		case Float:
			db.AddFloatField(f.name)
			log.Println("Float field:", f.name)
		}
	}
	log.Println("------------------------")

	xmlFile, err := os.Open("f003.xml")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer xmlFile.Close()

	d := xml.NewDecoder(xmlFile)
	d.CharsetReader = func(charset string, input io.Reader) (io.Reader, error) {
		switch charset {
		case "Windows-1251":
			return charmap.Windows1251.NewDecoder().Reader(input), nil
		default:
			return nil, fmt.Errorf("unknown charset: %s", charset)
		}
	}
	packet := Packet{}
	err = d.Decode(&packet)
	if err != nil {
		log.Fatalf("decode: %v", err)
	}

	companies := packet.MedCompanies

	// outfile, err := os.Create("f003.csv")
	// if err != nil {
	// 	log.Fatal("Unable to open output")
	// }
	// defer outfile.Close()

	// writer := csv.NewWriter(outfile)
	// defer writer.Flush()

	for _, company := range companies {
		for _, advice := range company.Medadvice {
			if year, err := strconv.Atoi(advice.YearWork); err != nil {
				continue
			} else {
				if year == 2021 {
					name := manyRepl(arrRepl, company.NamMop)
					nameMok := manyRepl(arrRepl, company.NamMok)

					name = removeQuotes(name)
					nameMok = removeQuotes(nameMok)

					// writer.Write([]string{company.Mcod, nameMok, name, advice.YearWork})

					n := db.AddRecord()

					db.SetFieldValueByName(n, "MCOD", company.Mcod)
					db.SetFieldValueByName(n, "NAMEMOK", utfTOcp886(nameMok))
					db.SetFieldValueByName(n, "NAMEMOP", utfTOcp886(name))
					db.SetFieldValueByName(n, "ADDRESS", utfTOcp886(company.Address.Address))
					db.SetFieldValueByName(n, "YEAR", advice.YearWork)

				}
			}

		}

	}
	if err := db.SaveFile(dbffile); err != nil {
		log.Fatal(err)
	}

	fmt.Println("That's all")
}
