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
	OGRN      string      `xml:"ogrn"`
	KPP       string      `xml:"KPP"`
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

// https://www2.arhofoms.ru/it/base/%D0%9F%D1%80%D0%B8%D0%BA%D0%B0%D0%B7%20%D0%A4%D0%9E%D0%9C%D0%A1%20%D0%BE%D1%82%2020110407%2079%20(%D1%80%D0%B5%D0%B4.%20%D0%BE%D1%82%2030.08.2019%20173)%20%D0%9E%D0%B1%20%D1%83%D1%82%D0%B2%D0%B5%D1%80%D0%B6%D0%B4%D0%B5%D0%BD%D0%B8%D0%B8%20%D0%BE%D0%B1%D1%89%D0%B8%D1%85%20%D0%BF%D1%80%D0%B8%D0%BD%D1%86%D0%B8%D0%BF%D0%BE%D0%B2%20(%D0%A4%D0%9E%D0%9C%D0%A1).pdf
func main() {

	dbffile := "f003.dbf"

	names := []FieldName{
		{name: "MCOD", typ: None, length: 6},
		{name: "NAMEMOK", typ: None, length: 50, truncate: true},
		{name: "NAMEMOP", typ: None, length: 250, truncate: true},
		{name: "YEAR", typ: Int, length: 4},
	}
	// names = append(names, FieldName{name: "MCOD", typ: None, length: 6})
	// names = append(names, FieldName{name: "NAMEMOK", typ: None, length: 100, truncate: true})
	// names = append(names, FieldName{name: "NAMEMOP", typ: None, length: 250, truncate: true})
	// names = append(names, FieldName{name: "YEAR", typ: Int, length: 4})

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

	var name string
	for _, company := range companies {
		for _, advice := range company.Medadvice {
			if year, err := strconv.Atoi(advice.YearWork); err != nil {
				continue
			} else {
				if year == 2021 {
					name = strings.Replace(company.NamMop, "ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГБУЗ", -1)
					name = strings.Replace(name, "ГОСУДАРСТВЕННОЕ ОБЛАСТНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГОБУЗ", -1)
					name = strings.Replace(name, "ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГАУЗ", -1)
					name = strings.Replace(name, "ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГАУЗ", -1)
					name = strings.Replace(name, "ОБЛАСТНОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ОАУЗ", -1)
					name = strings.Replace(name, "ОБЛАСТНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ОБУЗ", -1)
					name = strings.Replace(name, "АВТОНОМНАЯ НЕКОММЕРЧЕСКАЯ ОРГАНИЗАЦИЯ", "АНО", -1)
					name = strings.Replace(name, "МУНИЦИПАЛЬНОЕ УНИТАРНОЕ ПРЕДПРИЯТИЕ", "МУП", -1)
					name = strings.Replace(name, "ОБЩЕСТВО С ОГРАНИЧЕННОЙ ОТВЕТСТВЕННОСТЬЮ", "ООО", -1)
					name = strings.Replace(name, "ЗАКРЫТОЕ АКЦИОНЕРНОЕ ОБЩЕСТВО", "ЗАО", -1)
					name = strings.Replace(name, "АКЦИОНЕРНОЕ ОБЩЕСТВО", "АО", -1)
					name = strings.Replace(name, "ФЕДЕРАЛЬНОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ФБУЗ", -1)
					name = strings.Replace(name, "ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ", "ФГБУ", -1)
					name = strings.Replace(name, "ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ УЧРЕЖДЕНИЕ", "ФГАУ", -1)
					name = strings.Replace(name, "ФЕДЕРАЛЬНОЕ КАЗЕННОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ФКУЗ", -1)
					name = removeQuotes(name)

					nameMok := removeQuotes(company.NamMok)

					// writer.Write([]string{company.Mcod, nameMok, name, advice.YearWork})

					n := db.AddRecord()

					db.SetFieldValueByName(n, "MCOD", company.Mcod)
					db.SetFieldValueByName(n, "NAMEMOK", utfTOcp886(nameMok))
					db.SetFieldValueByName(n, "NAMEMOP", utfTOcp886(name))
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
