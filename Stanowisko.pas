unit Stanowisko;

interface

uses
  System.Generics.Collections, Data.Win.ADODB, ZlecenieEtap;

type
  TStanowisko = class
    private

    public
    var
      NAZ_STANOWISKA : String;
      KOD_STANOWISKA : String;
      ID_STANOWISKA : Integer;

      NAZ_R_STANOWISKA : String;
      RODZ_STANOWISKA : String;
      ID_RODZAJE_STANOWISK : Integer;

      listaEtapow : TObjectList<TZlecenieEtap>;

    constructor Create;
    destructor Free;

    procedure DodajEtap(etapZlecenia : TZlecenieEtap);
    procedure UsunEtap(etapZlecenia : TZlecenieEtap);
    procedure UstawDlaQueryZRodzajeStanowisk(query : TADOQuery);
    procedure UstawDlaQueryZeStanowiska(query : TADOQuery);

    function WolneOCzasie(czas : TDateTime) : Boolean;
    function EtapKonczacySiePoCzasie(czas : TDateTime) : TZlecenieEtap;
    function CzasZakonczeniaOstatniegoEtapu() : TDateTime;

    function PotencjalnaDataCzasRozpoczeciaEtapu(potencjalnyStart,
      potencjalnyKoniec : TDateTime) : TDateTime;
  end;

implementation

  constructor TStanowisko.Create;
  begin
    listaEtapow := TObjectList<TZlecenieEtap>.Create(False);
  end;

  destructor TStanowisko.Free;
  begin
    listaEtapow.Free;
  end;

  procedure TStanowisko.DodajEtap(etapZlecenia : TZlecenieEtap);
  begin
    listaEtapow.Add(etapZlecenia);
  end;

  procedure TStanowisko.UsunEtap(etapZlecenia: TZlecenieEtap);
  begin
    listaEtapow.Remove(etapZlecenia);
  end;

  procedure TStanowisko.UstawDlaQueryZRodzajeStanowisk(query : TADOQuery);
  begin
    NAZ_R_STANOWISKA := query.FieldByName('NAZ_R_STANOWISKA').AsString;
    RODZ_STANOWISKA := query.FieldByName('RODZ_STANOWISKA').AsString;
    ID_RODZAJE_STANOWISK := query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;
  end;

  procedure TStanowisko.UstawDlaQueryZeStanowiska(query : TADOQuery);
  begin
    NAZ_STANOWISKA := query.FieldByName('NAZ_STANOWISKA').AsString;
    KOD_STANOWISKA := query.FieldByName('KOD_STANOWISKA').AsString;
    ID_STANOWISKA := query.FieldByName('ID_STANOWISKA').AsInteger;
  end;

  // zwraca ta sama date jesli wolne w szukanym okresie czasu.
  // jesli zajete w tym czasie, zwraca potencjalna date kiedy moze byc wolne.
  function TStanowisko.PotencjalnaDataCzasRozpoczeciaEtapu(potencjalnyStart,
    potencjalnyKoniec : TDateTime) : TDateTime;
  var
    listaEtapowPomiedzy : TObjectList<TZlecenieEtap>;
    etapZlecenia : TZlecenieEtap;
  begin
    listaEtapowPomiedzy := TObjectList<TZlecenieEtap>.Create(False);

    for etapZlecenia in listaEtapow do
    begin
      if ((etapZlecenia.DATA_START >= potencjalnyStart) and (etapZlecenia.DATA_START <= potencjalnyKoniec)) or
        ((etapZlecenia.DATA_KONIEC >= potencjalnyStart) and (etapZlecenia.DATA_KONIEC <= potencjalnyKoniec)) or
        ((etapZlecenia.DATA_START <= potencjalnyStart) and (etapZlecenia.DATA_KONIEC >= potencjalnyKoniec)) then
          listaEtapowPomiedzy.Add(etapZlecenia);
    end;

    Result := potencjalnyStart;

    for etapZlecenia in listaEtapowPomiedzy do
    begin
      if etapZlecenia.DATA_KONIEC > Result then Result := etapZlecenia.DATA_KONIEC;
    end;

  end;

  function TStanowisko.WolneOCzasie(czas: TDateTime) : Boolean;
  var
    zlecenieEtap : TZlecenieEtap;
  begin
    Result := True;
    for zlecenieEtap in listaEtapow do
    begin
      if (zlecenieEtap.DATA_START <= czas)
        and (zlecenieEtap.DATA_KONIEC >= czas)
          then Result := False;
    end;
  end;

  function TStanowisko.EtapKonczacySiePoCzasie(czas : TDateTime) : TZlecenieEtap;
  var
    zlecenieEtap : TZlecenieEtap;
  begin
    Result := nil;
    for zlecenieEtap in listaEtapow do
    begin
      if (zlecenieEtap.DATA_START <= czas)
        and (zlecenieEtap.DATA_KONIEC >= czas)
          then Result := zlecenieEtap;
    end;
  end;

  function TStanowisko.CzasZakonczeniaOstatniegoEtapu() : TDateTime;
  var
    zlecenieEtap : TZlecenieEtap;
  begin
    Result := 0;
    for zlecenieEtap in listaEtapow do
    begin
      if Result < zlecenieEtap.DATA_KONIEC then
        Result := zlecenieEtap.DATA_KONIEC;
    end;
  end;

end.
