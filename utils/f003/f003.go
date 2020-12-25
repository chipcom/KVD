package main

import (
	"encoding/csv"
	"encoding/xml"
	"fmt"
	"io"
	"log"
	"os"

	"golang.org/x/text/encoding/charmap"
)

type JurAddress struct {
	IndexJ string `xml:"index_j"`
	AddrJ  string `xml:"addr_j"`
}

type AddrFsp struct {
	AddrCode string `xml:"addr_code"`
	AddrFspo string `xml:"addr_fspo"`
}

type Mpstruct struct {
	Mpvid string   `xml:"mpvid"`
	Mprof []string `xml:"mprof"`
}

type AddrMp struct {
	MpCodsL string     `xml:"mpcods_L"`
	Mp      []Mpstruct `xml:"mp"`
}

type Podr struct {
	Mpcod    string `xml:"mpcod"`
	NamMosp  string `xml:"nam_mosp"`
	NamMosk  string `xml:"nam_mosk"`
	FamRukSp string `xml:"fam_ruk_sp"`
	ImRukSp  string `xml:"im_ruk_sp"`
	OtRukSp  string `xml:"ot_ruk_sp"`
	PhoneSp  string `xml:"phone_sp"`
	AddrFsp  AddrFsp
}

type Doc struct {
	NDoc   string   `xml:"n_doc"`
	DStart string   `xml:"d_start"`
	DateE  string   `xml:"date_e"`
	DTerm  string   `xml:"d_term"`
	Addrmp []AddrMp `xml:"addr_mp"`
}

type MedInclude struct {
	Dbegin string `xml:"d_begin"`
	Dend   string `xml:"d_end"`
	NameE  string `xml:"name_e"`
}

type MedAdvice struct {
	YearWork string   `xml:"YEAR_WORK"`
	Duved    string   `xml:"DUVED"`
	Dmp      []string `xml:"d_mp"`
}

type MedCompany1 struct {
	TfOKATO          string     `xml:"tf_okato"`
	Mcod             string     `xml:"mcod"`
	NamMop           string     `xml:"nam_mop"`
	NamMok           string     `xml:"nam_mok"`
	INN              string     `xml:"inn"`
	OGRN             string     `xml:"ogrn"`
	KPP              string     `xml:"KPP"`
	JuridicalAddress JurAddress `xml:"jur_address"`
	OKOPF            string     `xml:"okopf"`
	OKFS             string     `xml:"okfs"`
	VedPri           string     `xml:"vedpri"`
	Org              string     `xml:"org"`
	FamRuk           string     `xml:"fam_ruk"`
	ImRuk            string     `xml:"im_ruk"`
	OtRuk            string     `xml:"ot_ruk"`
	Phone            string     `xml:"phone"`
	Fax              string     `xml:"fax"`
	EMail            string     `xml:"e_mail"`
	Podr             []Podr     `xml:"podr"`
	Document         []Doc      `xml:"doc"`
	Web              string     `xml:"www"`
	Medinclude       MedInclude `xml:"medInclude"`
	Medadvice        MedAdvice  `xml:"medAdvice"`
	DateEdit         string     `xml:"d_edit"`
}

type MedCompany struct {
	XMLName xml.Name `xml:"medCompany"`
	TfOKATO string   `xml:"tf_okato"`
	Mcod    string   `xml:"mcod"`
	NamMop  string   `xml:"nam_mop"`
	NamMok  string   `xml:"nam_mok"`
	INN     string   `xml:"inn"`
	OGRN    string   `xml:"ogrn"`
	KPP     string   `xml:"KPP"`
}

type Packet struct {
	XMLName      xml.Name     `xml:"packet"`
	Version      string       `xml:"version,attr"`
	Date         string       `xml:"date,attr"`
	MedCompanies []MedCompany `xml:"medCompany"`
}

func (s MedCompany) String() string {
	return fmt.Sprintf("\tmcod : %s - Name : %s\n", s.Mcod, s.NamMok)
}

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
	// file.WriteString( "test" )

	fmt.Fprintf(file, "%+v", companies)
	// log.Printf("%+v", companies)

	outfile, err := os.Create("f003.csv")
	if err != nil {
		log.Fatal("Unable to open output")
	}
	defer outfile.Close()

	writer := csv.NewWriter(outfile)
	defer writer.Flush()

	for _, company := range companies {

		writer.Write([]string{company.Mcod, company.NamMok, company.NamMop})

	}

	fmt.Println("That's all")
}
