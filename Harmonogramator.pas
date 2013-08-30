unit Harmonogramator;

interface

uses
  System.SysUtils, System.Generics.Collections, DyspozytorskaRegulaHarmonogramowania, Math, Stanowiska, Stanowisko, Zlecenia, Zlecenie, ZlecenieEtap, CzasHelper, Etapy, ZlecenieDane;

type
  THarmonogramator = class
  private
    function ListyZawierajaTaSamaDateNaJednymIndeksie(lista1, lista2 : TList<TDateTime>) : Boolean;
    var
      CzasHelper : TCzasHelper;

  public
    constructor Create(czasHelperToUse : TCzasHelper);
    procedure Harmonogramuj(zlecenia : TZlecenia; stanowiska : TStanowiska; drh : TDyspozytorskaRegulaHarmonogramowania);
  end;

implementation

  // private

  function THarmonogramator.ListyZawierajaTaSamaDateNaJednymIndeksie(lista1, lista2 : TList<TDateTime>) : Boolean;
  var
    I : Integer;
  begin
    Result := False;
    for I := 0 to lista1.Count - 1 do
      if lista1.Items[I] = lista2.Items[I] then
      begin
        Result := True;
        Break;
      end;
  end;

  // public

  constructor THarmonogramator.Create(czasHelperToUse : TCzasHelper);
  begin
    CzasHelper := czasHelperToUse;
  end;

  procedure THarmonogramator.Harmonogramuj(zlecenia : TZlecenia; stanowiska : TStanowiska; drh : TDyspozytorskaRegulaHarmonogramowania);
  var
    stan : Int8;
    operacjeDoHarmonogramowania,
      wszystkieOperacje,
      najwczesniejszeOperacje,
      operacjeTrwajaceNaMaszynach : TEtapy;
    najwczesniejszyCzasProponowany, najwczesniejszyCzasZakonczenia : TDateTime;
    operacja, operacjaTemp : TZlecenieEtap;
    potencjalneMaszyny, niezajeteMaszyny, mozeNiezajeteMaszyny : TStanowiska;
    niezajetaMaszyna, maszynaDoOproznienia, mozeNiezajetaMaszyna : TStanowisko;
    moznaWydziedziczycOperacje : Boolean;

//    zlecenie : TZlecenie;
//    etapZlecenia : TZlecenieEtap;
//    stanowisko : TStanowisko;
//    dataCzasPoczatku, dataCzasKonca : TDateTime;
//    stanowiskaDlaEtapu : TStanowiska;
//    tmpDatyCzasyPoczatku, datyCzasyPoczatku, datyCzasyKonca : TList<TDateTime>;
//    I, J, czasTrwaniaEtapuMinuty : Integer;
  begin
    stan := 1;

    while not (stan = 16) do
    begin
      case stan of
        1:
        begin
          stan := 2;
        end;
        2:
        begin
          operacjeDoHarmonogramowania := zlecenia.EtapyDoHarmonogramowania(); // C
          for operacja in operacjeDoHarmonogramowania do
          begin
            operacja.DATA_PROPONOWANA := CzasHelper.DataCzasPracujacy(operacja.DataProponowana, true);
          end;

          wszystkieOperacje := zlecenia.WszystkieNierozpoczeteEtapy(); // C
          stan := 3;
        end;
        3:
        begin
          najwczesniejszyCzasProponowany := operacjeDoHarmonogramowania.NajwczesniejszyCzasProponowany(True);
          najwczesniejszeOperacje := operacjeDoHarmonogramowania.OperacjeZCzasemProponowanym(najwczesniejszyCzasProponowany); //C
          stan := 4;
        end;
        4:
        begin
          operacja := drh.WybierzZEtapy(najwczesniejszeOperacje);
          stan := 5;
        end;
        5:
        begin
          potencjalneMaszyny := stanowiska.StanowiskaPasujaceDlaEtapuZlecenia(operacja); // C
          niezajeteMaszyny := potencjalneMaszyny.StanowiskaNieZajeteOCzasie(najwczesniejszyCzasProponowany); // C
          stan := 6;
        end;
        6:
        begin
          if niezajeteMaszyny.Count > 0 then stan := 7
          else stan := 10;
        end;
        7:
        begin
          niezajetaMaszyna := niezajeteMaszyny.Items[0];
          niezajetaMaszyna.DodajEtap(operacja);
          operacjeDoHarmonogramowania.Remove(operacja);
          wszystkieOperacje.Remove(operacja);
          najwczesniejszeOperacje.Remove(operacja);
          operacja.DATA_START := najwczesniejszyCzasProponowany;
          operacja.DATA_KONIEC := CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(najwczesniejszyCzasProponowany, operacja.CzasWykonaniaNetto);
          potencjalneMaszyny.Free(); // D
          niezajeteMaszyny.Free(); // D
          stan := 8;
        end;
        8:
        begin
          if not (operacja.nastepnyEtap = nil) then stan := 9
          else stan := 14;
        end;
        9:
        begin
          operacjeDoHarmonogramowania.Add(operacja.nastepnyEtap);
          stan := 14;
        end;
        10:
        begin
          operacjeTrwajaceNaMaszynach := potencjalneMaszyny. // C
            OperacjeKonczaceSiePoCzasie(najwczesniejszyCzasProponowany);
          stan := 11;
        end;
        11:
        begin
          moznaWydziedziczycOperacje := False;
          for operacjaTemp in operacjeTrwajaceNaMaszynach do
          begin
            maszynaDoOproznienia := stanowiska.StanowiskoDoKtoregoJestPrzydzielonyEtap(operacjaTemp);
            mozeNiezajeteMaszyny := stanowiska. // C
              StanowiskaPasujaceDlaEtapuZlecenia(operacjaTemp).
              StanowiskaNieZnajdujaceSieW(potencjalneMaszyny);
            for mozeNiezajetaMaszyna in mozeNiezajeteMaszyny do
            begin
              if mozeNiezajetaMaszyna.WolneOCzasie(operacjaTemp.DATA_START) then
              begin
                moznaWydziedziczycOperacje := True;
                break;
              end;
            end;
            mozeNiezajeteMaszyny.Free(); // D
            if moznaWydziedziczycOperacje then break;
          end;
          operacjeTrwajaceNaMaszynach.Free(); // D
          if moznaWydziedziczycOperacje then stan := 12
          else stan := 13;
        end;
        12:
        begin
          mozeNiezajetaMaszyna.DodajEtap(operacjaTemp);
          maszynaDoOproznienia.UsunEtap(operacjaTemp);
          niezajeteMaszyny.Add(maszynaDoOproznienia);
          stan := 7;
        end;
        13:
        begin
          operacja.DATA_PROPONOWANA := potencjalneMaszyny.CzasZakonczeniaNajwczesniejszejZOstatnichOperacji();
          najwczesniejszeOperacje.Remove(operacja);
          stan := 14;
        end;
        14:
        begin
          if najwczesniejszeOperacje.Count > 0 then stan := 4
          else
          begin
            najwczesniejszeOperacje.Free; // D
            stan := 15;
          end;
        end;
        15:
        begin
          if wszystkieOperacje.Count > 0 then stan := 3
          else
          begin
            wszystkieOperacje.Free(); // D
            operacjeDoHarmonogramowania.Free(); // D
            stan := 16;
          end;
        end;
      end;
    end;

//    tmpDatyCzasyPoczatku := TList<TDateTime>.Create;
//    datyCzasyPoczatku := TList<TDateTime>.Create;
//    datyCzasyKonca := TList<TDateTime>.Create;
//
//    if not VerifyZlecenia(zlecenia) then
//    begin
//      zlecenia := zlecenia;
//    end;
//
//
//    for zlecenie in zlecenia do
//    begin
//      dataCzasPoczatku := CzasHelper.DataCzasPracujacy(zlecenie.daneZlecenia.PLAN_DATA_ROZPOCZECIA, True);
//      dataCzasKonca := 0; // dowolna inna wartosc niz dataCzasPoczatku
//
//      for etapZlecenia in zlecenie do
//      begin
//        stanowiskaDlaEtapu := stanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia);
//        czasTrwaniaEtapuMinuty := etapZlecenia.CzasWykonaniaNetto;
//
//         //inicjalizacja list pomocniczych
//        for stanowisko in stanowiskaDlaEtapu do
//        begin
//          tmpDatyCzasyPoczatku.Add(dataCzasKonca);
//          datyCzasyPoczatku.Add(dataCzasPoczatku);
//          datyCzasyKonca.Add(dataCzasKonca);
//        end;
//
//         //jesli zawieraja tzn. ze ktores ze stanowisk znalazlo czas na wykonanie etapu
//        while not ListyZawierajaTaSamaDateNaJednymIndeksie(tmpDatyCzasyPoczatku, datyCzasyPoczatku) do
//        begin
//          I := 0;
//          for stanowisko in stanowiskaDlaEtapu do
//          begin
//            dataCzasPoczatku := datyCzasyPoczatku.Items[I];
//            dataCzasKonca := CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(dataCzasPoczatku, czasTrwaniaEtapuMinuty);
//
//            tmpDatyCzasyPoczatku.Items[I] := dataCzasPoczatku;
//            datyCzasyPoczatku.Items[I] := stanowisko.PotencjalnaDataCzasRozpoczeciaEtapu(dataCzasPoczatku, dataCzasKonca);
//            datyCzasyKonca.Items[I] := dataCzasKonca;
//
//            I := I + 1;
//          end;
//        end;
//
//        I := 0;
//        dataCzasPoczatku := EncodeDate(3000,1,1); // duza data
//
//         //szukamy najwczesniejszej mozliwej daty zaczecia i indeks dla dat oraz stanowiska
//        for stanowisko in stanowiskaDlaEtapu do
//        begin
//          if (tmpDatyCzasyPoczatku.Items[I] = datyCzasyPoczatku.Items[I]) and
//            (dataCzasPoczatku > datyCzasyPoczatku.Items[I]) then J := I;
//
//          I := I + 1;
//        end;
//
//         //mamy date poczatku, konca i stanowisko
//        stanowisko := stanowiskaDlaEtapu.Items[J];
//        dataCzasPoczatku := datyCzasyPoczatku.Items[J];
//        dataCzasKonca := datyCzasyKonca.Items[J];
//
//         //ustawiamy dane dla etapu i stanowiska
//        etapZlecenia.DATA_START := dataCzasPoczatku;
//        etapZlecenia.DATA_KONIEC := dataCzasKonca;
//        stanowisko.listaEtapow.Add(etapZlecenia);
//
//        stanowiskaDlaEtapu.Free;
//        tmpDatyCzasyPoczatku.Clear;
//        datyCzasyPoczatku.Clear;
//        datyCzasyKonca.Clear;
//
//        dataCzasPoczatku := CzasHelper.DataCzasPracujacy(dataCzasKonca, True);
//        dataCzasKonca := 0;
//      end;
//
//    end;

  end;
end.

