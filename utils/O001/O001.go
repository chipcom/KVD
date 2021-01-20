package main

import (
	"encoding/csv"
	"encoding/xml"
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	"github.com/tadvi/dbf"
	"golang.org/x/text/encoding/charmap"
)

type ZglvType struct {
	Type    string `xml:"type"`
	Version string `xml:"version"`
	Date    string `xml:"date"`
}

type ZapType struct {
	Kod    string `xml:"KOD"`
	Name11 string `xml:"NAME11"`
	Name12 string `xml:"NAME12"`
	Alfa2  string `xml:"ALFA2"`
	Alfa3  string `xml:"ALFA3"`
}

type Packet struct {
	XMLName xml.Name  `xml:"packet"`
	Zglv    ZglvType  `xml:"zglv"`
	Zap     []ZapType `xml:"zap"`
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

	dbffile := "o001.dbf"

	names := []FieldName{
		{name: "KOD", typ: None, length: 3},
		{name: "NAME11", typ: None, length: 60, truncate: true},
		{name: "NAME12", typ: None, length: 60, truncate: true},
		{name: "ALFA2", typ: None, length: 2, truncate: true},
		{name: "ALFA3", typ: None, length: 3, truncate: true},
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

	xmlFile, err := os.Open("O001.xml")
	if err != nil {
		fmt.Println("Error opening file:", err)
		return
	}
	defer xmlFile.Close()

	d := xml.NewDecoder(xmlFile)
	d.CharsetReader = func(charset string, input io.Reader) (io.Reader, error) {
		switch charset {
		case "windows-1251":
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

	zaps := packet.Zap

	outfile, err := os.Create("o001.csv")
	if err != nil {
		log.Fatal("Unable to open output")
	}
	defer outfile.Close()

	writer := csv.NewWriter(outfile)
	defer writer.Flush()

	var nameCountry []string

	for _, zap := range zaps {

		writer.Write([]string{zap.Kod, zap.Name11, zap.Name12, zap.Alfa2, zap.Alfa3})

		n := db.AddRecord()

		nameCountry = strings.Split(zap.Name11, "^")
		db.SetFieldValueByName(n, "KOD", zap.Kod)
		db.SetFieldValueByName(n, "NAME11", utfTOcp886(nameCountry[0]))
		if len(nameCountry) > 1 {
			db.SetFieldValueByName(n, "NAME12", utfTOcp886(nameCountry[1]))
		} else {
			db.SetFieldValueByName(n, "NAME12", utfTOcp886(""))
		}
		db.SetFieldValueByName(n, "ALFA2", zap.Alfa2)
		db.SetFieldValueByName(n, "ALFA3", zap.Alfa3)

	}
	if err := db.SaveFile(dbffile); err != nil {
		log.Fatal(err)
	}

	fmt.Println("That's all")
}
