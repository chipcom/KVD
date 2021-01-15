package main

import (
	"bytes"
	"encoding/csv"
	"encoding/xml"
	"fmt"
	"io"
	"log"
	"os"
	"strconv"
	"strings"

	"golang.org/x/text/encoding/charmap"
)

// type JurAddress struct {
// 	IndexJ string `xml:"index_j"`
// 	AddrJ  string `xml:"addr_j"`
// }

// type AddrFsp struct {
// 	AddrCode string `xml:"addr_code"`
// 	AddrFspo string `xml:"addr_fspo"`
// }

// type Mpstruct struct {
// 	Mpvid string   `xml:"mpvid"`
// 	Mprof []string `xml:"mprof"`
// }

// type AddrMp struct {
// 	MpCodsL string     `xml:"mpcods_L"`
// 	Mp      []Mpstruct `xml:"mp"`
// }

// type Podr struct {
// 	Mpcod    string `xml:"mpcod"`
// 	NamMosp  string `xml:"nam_mosp"`
// 	NamMosk  string `xml:"nam_mosk"`
// 	FamRukSp string `xml:"fam_ruk_sp"`
// 	ImRukSp  string `xml:"im_ruk_sp"`
// 	OtRukSp  string `xml:"ot_ruk_sp"`
// 	PhoneSp  string `xml:"phone_sp"`
// 	AddrFsp  AddrFsp
// }

// type Doc struct {
// 	NDoc   string   `xml:"n_doc"`
// 	DStart string   `xml:"d_start"`
// 	DateE  string   `xml:"date_e"`
// 	DTerm  string   `xml:"d_term"`
// 	Addrmp []AddrMp `xml:"addr_mp"`
// }

// type MedInclude struct {
// 	Dbegin string `xml:"d_begin"`
// 	Dend   string `xml:"d_end"`
// 	NameE  string `xml:"name_e"`
// }

// type MedCompany1 struct {
// 	TfOKATO          string     `xml:"tf_okato"`
// 	Mcod             string     `xml:"mcod"`
// 	NamMop           string     `xml:"nam_mop"`
// 	NamMok           string     `xml:"nam_mok"`
// 	INN              string     `xml:"inn"`
// 	OGRN             string     `xml:"ogrn"`
// 	KPP              string     `xml:"KPP"`
// 	JuridicalAddress JurAddress `xml:"jur_address"`
// 	OKOPF            string     `xml:"okopf"`
// 	OKFS             string     `xml:"okfs"`
// 	VedPri           string     `xml:"vedpri"`
// 	Org              string     `xml:"org"`
// 	FamRuk           string     `xml:"fam_ruk"`
// 	ImRuk            string     `xml:"im_ruk"`
// 	OtRuk            string     `xml:"ot_ruk"`
// 	Phone            string     `xml:"phone"`
// 	Fax              string     `xml:"fax"`
// 	EMail            string     `xml:"e_mail"`
// 	Podr             []Podr     `xml:"podr"`
// 	Document         []Doc      `xml:"doc"`
// 	Web              string     `xml:"www"`
// 	Medinclude       MedInclude `xml:"medInclude"`
// 	Medadvice        MedAdvice  `xml:"medAdvice"`
// 	DateEdit         string     `xml:"d_edit"`
// }

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
	// Duved    string `xml:"DUVED"`
	// Duved customTime `xml:"DUVED"`
	// Dmp   []int      `xml:"d_mp"`
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

// func (s MedCompany) String() string {
// 	return fmt.Sprintf("\tmcod : %s - Name : %s - Дата уведомления : %s\n", s.Mcod, strings.Replace(s.NamMok, "ГОСУДАРСТВЕННОЕ БЮДЖЕТНОЕ УЧРЕЖДЕНИЕ ЗДРАВООХРАНЕНИЯ", "ГБУЗ", -1), s.Medadvice.Duved)
// }

func removeQuotes(s string) string {
	var b bytes.Buffer
	for _, r := range s {
		if r != '"' && r != '\'' {
			b.WriteRune(r)
		}
	}

	return b.String()
}

// https://www2.arhofoms.ru/it/base/%D0%9F%D1%80%D0%B8%D0%BA%D0%B0%D0%B7%20%D0%A4%D0%9E%D0%9C%D0%A1%20%D0%BE%D1%82%2020110407%2079%20(%D1%80%D0%B5%D0%B4.%20%D0%BE%D1%82%2030.08.2019%20173)%20%D0%9E%D0%B1%20%D1%83%D1%82%D0%B2%D0%B5%D1%80%D0%B6%D0%B4%D0%B5%D0%BD%D0%B8%D0%B8%20%D0%BE%D0%B1%D1%89%D0%B8%D1%85%20%D0%BF%D1%80%D0%B8%D0%BD%D1%86%D0%B8%D0%BF%D0%BE%D0%B2%20(%D0%A4%D0%9E%D0%9C%D0%A1).pdf
func main() {
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
	file, err := os.Create("f003.txt")
	if err != nil {
		return
	}
	defer file.Close()

	fmt.Fprintf(file, "%+v", companies)

	outfile, err := os.Create("f003.csv")
	if err != nil {
		log.Fatal("Unable to open output")
	}
	defer outfile.Close()

	writer := csv.NewWriter(outfile)
	defer writer.Flush()

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

					// writer.Write([]string{company.Mcod, company.NamMok, name, advice.YearWork})
					writer.Write([]string{company.Mcod, nameMok, name, advice.YearWork})
				}
			}

		}

		// writer.Write([]string{company.Mcod, company.NamMok, name, company.Medadvice.Duved, company.Medadvice.YearWork})

	}

	fmt.Println("That's all")
}
