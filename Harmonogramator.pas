unit Harmonogramator;

interface

uses
  System.SysUtils, System.Generics.Collections, Stanowiska, Stanowisko, Zlecenia, Zlecenie, ZlecenieEtap, CzasHelper;

type
  THarmonogramator = class
  private
    function ListyZawierajaTaSamaDateNaJednymIndeksie(lista1, lista2 : TList<TDateTime>) : Boolean;
    var
      CzasHelper : TCzasHelper;

  public
    constructor Create;
    destructor Free;
    procedure Harmonogramuj(zlecenia : TZlecenia; stanowiska : TStanowiska);
    procedure HarmonogramujWstecz(zlecenia : TZlecenia; stanowiska : TStanowiska);
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

  constructor THarmonogramator.Create;
  begin
    CzasHelper := TCzasHelper.Create(EncodeTime(8,0,0,0), EncodeTime(16,0,0,0));
  end;

  destructor THarmonogramator.Free;
  begin
    CzasHelper.Free;
  end;

  procedure THarmonogramator.Harmonogramuj(zlecenia : TZlecenia; stanowiska : TStanowiska);
  var
    zlecenie : TZlecenie;
    etapZlecenia : TZlecenieEtap;
    stanowisko : TStanowisko;
    dataCzasPoczatku, dataCzasKonca : TDateTime;
    stanowiskaDlaEtapu : TStanowiska;
    tmpDatyCzasyPoczatku, datyCzasyPoczatku, datyCzasyKonca : TList<TDateTime>;
    I, J, czasTrwaniaEtapuMinuty : Integer;
  begin
    tmpDatyCzasyPoczatku := TList<TDateTime>.Create;
    datyCzasyPoczatku := TList<TDateTime>.Create;
    datyCzasyKonca := TList<TDateTime>.Create;

    for zlecenie in zlecenia do
    begin
      dataCzasPoczatku := CzasHelper.DataCzasPracujacy(zlecenie.daneZlecenia.PLAN_DATA_ROZPOCZECIA, True);
      dataCzasKonca := 0; // dowolna inna wartosc niz dataCzasPoczatku

      for etapZlecenia in zlecenie do
      begin
        stanowiskaDlaEtapu := stanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia);
        czasTrwaniaEtapuMinuty := etapZlecenia.CzasWykonaniaNetto;

        // inicjalizacja list pomocniczych
        for stanowisko in stanowiskaDlaEtapu do
        begin
          tmpDatyCzasyPoczatku.Add(dataCzasKonca);
          datyCzasyPoczatku.Add(dataCzasPoczatku);
          datyCzasyKonca.Add(dataCzasKonca);
        end;

        // jesli zawieraja tzn. ze ktores ze stanowisk znalazlo czas na wykonanie etapu
        while not ListyZawierajaTaSamaDateNaJednymIndeksie(tmpDatyCzasyPoczatku, datyCzasyPoczatku) do
        begin
          I := 0;
          for stanowisko in stanowiskaDlaEtapu do
          begin
            dataCzasPoczatku := datyCzasyPoczatku.Items[I];
            dataCzasKonca := CzasHelper.DataCzasZakonczeniaDlaDatyCzasuStartuICzasuTrwania(dataCzasPoczatku, czasTrwaniaEtapuMinuty);

            tmpDatyCzasyPoczatku.Items[I] := dataCzasPoczatku;
            datyCzasyPoczatku.Items[I] := stanowisko.PotencjalnaDataCzasRozpoczeciaEtapu(dataCzasPoczatku, dataCzasKonca);
            datyCzasyKonca.Items[I] := dataCzasKonca;

            I := I + 1;
          end;
        end;

        I := 0;
        dataCzasPoczatku := EncodeDate(3000,1,1); // duza data

        // szukamy najwczesniejszej mozliwej daty zaczecia i indeks dla dat oraz stanowiska
        for stanowisko in stanowiskaDlaEtapu do
        begin
          if (tmpDatyCzasyPoczatku.Items[I] = datyCzasyPoczatku.Items[I]) and
            (dataCzasPoczatku > datyCzasyPoczatku.Items[I]) then J := I;

          I := I + 1;
        end;

        // mamy date poczatku, konca i stanowisko
        stanowisko := stanowiskaDlaEtapu.Items[J];
        dataCzasPoczatku := datyCzasyPoczatku.Items[J];
        dataCzasKonca := datyCzasyKonca.Items[J];

        // ustawiamy dane dla etapu i stanowiska
        etapZlecenia.DATA_START := dataCzasPoczatku;
        etapZlecenia.DATA_KONIEC := dataCzasKonca;
        stanowisko.listaEtapow.Add(etapZlecenia);

        stanowiskaDlaEtapu.Free;
        tmpDatyCzasyPoczatku.Clear;
        datyCzasyPoczatku.Clear;
        datyCzasyKonca.Clear;

        dataCzasPoczatku := CzasHelper.DataCzasPracujacy(dataCzasKonca, True);
        dataCzasKonca := 0;
      end;
    end;
  end;

  procedure THarmonogramator.HarmonogramujWstecz(zlecenia : TZlecenia; stanowiska : TStanowiska);
  var
    zlecenie : TZlecenie;
    etapZlecenia : TZlecenieEtap;
    stanowisko : TStanowisko;
    dataCzasPoczatku, dataCzasKonca : TDateTime;
    stanowiskaDlaEtapu : TStanowiska;
    tmpDatyCzasyKonca, datyCzasyPoczatku, datyCzasyKonca : TList<TDateTime>;
    I, J, czasTrwaniaEtapuMinuty : Integer;
  begin
    tmpDatyCzasyKonca := TList<TDateTime>.Create;
    datyCzasyPoczatku := TList<TDateTime>.Create;
    datyCzasyKonca := TList<TDateTime>.Create;

    for zlecenie in zlecenia do
    begin
      dataCzasPoczatku := 0; // dowolna inna wartosc niz dataCzasKonca
      dataCzasKonca := CzasHelper.DataCzasPracujacy(zlecenie.daneZlecenia.PLAN_TERMIN_REALIZACJI, False);

      for etapZlecenia in zlecenie do
      begin
        stanowiskaDlaEtapu := stanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia);
        czasTrwaniaEtapuMinuty := etapZlecenia.CzasWykonaniaNetto;

        // inicjalizacja list pomocniczych
        for stanowisko in stanowiskaDlaEtapu do
        begin
          tmpDatyCzasyKonca.Add(dataCzasPoczatku);
          datyCzasyPoczatku.Add(dataCzasPoczatku);
          datyCzasyKonca.Add(dataCzasKonca);
        end;

        // jesli zawieraja tzn. ze ktores ze stanowisk znalazlo czas na wykonanie etapu
        while not ListyZawierajaTaSamaDateNaJednymIndeksie(tmpDatyCzasyKonca, datyCzasyKonca) do
        begin
          I := 0;
          for stanowisko in stanowiskaDlaEtapu do
          begin
            dataCzasKonca := datyCzasyKonca.Items[I];
            dataCzasPoczatku := CzasHelper.DataCzasRozpoczeciaDlaDatyCzasuZakonczeniaICzasuTrwania(dataCzasKonca, czasTrwaniaEtapuMinuty);

            tmpDatyCzasyKonca.Items[I] := dataCzasKonca;
            datyCzasyKonca.Items[I] := stanowisko.PotencjalnaDataCzasZakonczeniaEtapu(dataCzasPoczatku, dataCzasKonca);
            datyCzasyPoczatku.Items[I] := dataCzasPoczatku;

            I := I + 1;
          end;
        end;

        I := 0;
        dataCzasKonca := EncodeDate(1900,1,1); // mala data

        // szukamy najpozniejszej mozliwej daty zakonczenia i indeks dla dat oraz stanowiska
        for stanowisko in stanowiskaDlaEtapu do
        begin
          if (tmpDatyCzasyKonca.Items[I] = datyCzasyKonca.Items[I]) and
            (dataCzasKonca < datyCzasyKonca.Items[I]) then J := I;

          I := I + 1;
        end;

        // mamy date poczatku, konca i stanowisko
        stanowisko := stanowiskaDlaEtapu.Items[J];
        dataCzasPoczatku := datyCzasyPoczatku.Items[J];
        dataCzasKonca := datyCzasyKonca.Items[J];

        // ustawiamy dane dla etapu i stanowiska
        etapZlecenia.DATA_START := dataCzasPoczatku;
        etapZlecenia.DATA_KONIEC := dataCzasKonca;
        stanowisko.listaEtapow.Add(etapZlecenia);

        stanowiskaDlaEtapu.Free;
        tmpDatyCzasyKonca.Clear;
        datyCzasyPoczatku.Clear;
        datyCzasyKonca.Clear;

        dataCzasKonca := CzasHelper.DataCzasPracujacy(dataCzasPoczatku, False);
        dataCzasPoczatku := 0;
      end;
    end;
  end;

end.
