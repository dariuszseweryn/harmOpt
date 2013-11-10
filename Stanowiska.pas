unit Stanowiska;

interface

uses
  System.Generics.Collections, System.DateUtils, Stanowisko, ZlecenieEtap, Etapy;

type
  TStanowiska = class(TObjectList<TStanowisko>)
  public
    function StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia : TZlecenieEtap) : TStanowiska;
    function StanowiskaNieZajeteOCzasie(czas : TDateTime) : TStanowiska;
    function OperacjeKonczaceSiePoCzasie(czas : TDateTime) : TEtapy;
    function StanowiskaNieZnajdujaceSieW(stanowiska : TStanowiska) : TStanowiska;
    function StanowiskoDoKtoregoJestPrzydzielonyEtap(etapZlecenia : TZlecenieEtap) : TStanowisko;
    function CzasZakonczeniaNajwczesniejszejZOstatnichOperacji() : TDateTime;
    procedure Czysc;
  end;


implementation

  function TStanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia : TZlecenieEtap) : TStanowiska;
  var
    stanowisko : TStanowisko;
  begin
    Result := TStanowiska.Create(False);
    if not (etapZlecenia.ID_STANOWISKA = 0) then
      begin
        for stanowisko in self do
          if stanowisko.ID_STANOWISKA = etapZlecenia.ID_STANOWISKA then
            Result.Add(stanowisko);
      end
    else
      begin
        for stanowisko in self do
          if stanowisko.ID_RODZAJE_STANOWISK = etapZlecenia.ID_RODZAJE_STANOWISK then
            Result.Add(stanowisko);
      end;
  end;

  function TStanowiska.StanowiskaNieZajeteOCzasie(czas : TDateTime) : TStanowiska;
  var
    stanowisko : TStanowisko;
  begin
    Result := TStanowiska.Create(False);
    for stanowisko in self do
    begin
      if stanowisko.WolneOCzasie(czas) then Result.Add(stanowisko);
    end;
  end;

  function TStanowiska.OperacjeKonczaceSiePoCzasie(czas : TDateTime) : TEtapy;
  var
    stanowisko : TStanowisko;
  begin
    Result := TEtapy.Create(False);
    for stanowisko in self do
    begin
      Result.Add(stanowisko.EtapKonczacySiePoCzasie(czas));
    end;
  end;

  function TStanowiska.StanowiskaNieZnajdujaceSieW(stanowiska : TStanowiska) : TStanowiska;
  var
    stanowiskoTemp1, stanowiskoTemp2 : TStanowisko;
    nieJest : TList<Boolean>;
    i : Integer;
    b : Boolean;
  begin
    i := 0;
    nieJest := TList<Boolean>.Create();
    for stanowiskoTemp1 in self do
    begin
      nieJest.Add(True);
    end;
    for stanowiskoTemp1 in self do
    begin
      for stanowiskoTemp2 in stanowiska do
        if stanowiskoTemp1 = stanowiskoTemp2 then nieJest.Items[i] := False;
      i := i + 1;
    end;

    i := 0;
    Result := TStanowiska.Create(False);
    for b in nieJest do
    begin
      if b = True then Result.Add(self.Items[i]);
      i := i + 1;
    end;
    nieJest.Free;
  end;

  function TStanowiska.StanowiskoDoKtoregoJestPrzydzielonyEtap(etapZlecenia: TZlecenieEtap) : TStanowisko;
  var
    tempStanowisko : TStanowisko;
  begin
    for tempStanowisko in self do
    begin
      if tempStanowisko.listaEtapow.Contains(etapZlecenia) then
      begin
        Result := tempStanowisko;
        break;
      end;
    end;
  end;

  function TStanowiska.CzasZakonczeniaNajwczesniejszejZOstatnichOperacji;
  var
    tempStanowisko : TStanowisko;
    czasZakonczeniaEtapu : TDateTime;
  begin
    Result := EncodeDateTime(5000, 1, 1, 1, 1, 1, 1);
    for tempStanowisko in self do
    begin
      czasZakonczeniaEtapu := tempStanowisko.CzasZakonczeniaOstatniegoEtapu();
      if Result > czasZakonczeniaEtapu then
        Result := IncMinute(czasZakonczeniaEtapu,1);
    end;
  end;

  procedure TStanowiska.Czysc;
  var
    stanowisko : TStanowisko;
  begin
    for stanowisko in self do
      stanowisko.Czysc;
  end;

end.
