unit ZlecenieEtap;

interface

uses
  Data.Win.ADODB, System.Math, ZlecenieDane;

type
  TZlecenieEtap = class

  private
  public
  // info nt. konkretnego etapu
  NR_ETAPU : Integer;
  TPZ_M : Extended;
  TJ_M : Extended;
  ID_STANOWISKA : Integer;
  ID_RODZAJE_STANOWISK : Integer;
  // info nt. czasu zajecia stanowiska
  DATA_START : TDateTime;
  DATA_KONIEC : TDateTime;
  // info nt. kolejnosci dodania do wykresu Gantta
  ganttID : Integer;
  // poprzedni, nastepny etap, zlecenie
  poprzedniEtap : TZlecenieEtap;
  nastepnyEtap : TZlecenieEtap;
  daneZlecenia : TZlecenieDane;

  procedure UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  function CzasWykonaniaNetto : Integer;
  function PierwszyEtap : TZlecenieEtap;
  function OstatniEtap : TZlecenieEtap;

  end;

implementation

  procedure TZlecenieEtap.UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  begin
    NR_ETAPU := query.FieldByName('NR_ETAPU').AsInteger;
    TPZ_M := query.FieldByName('TPZ_M').AsExtended;
    TJ_M := query.FieldByName('TJ_M').AsExtended;
    ID_STANOWISKA := query.FieldByName('ID_STANOWISKA').AsInteger;
    ID_RODZAJE_STANOWISK := query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;
  end;

  function TZlecenieEtap.CzasWykonaniaNetto : Integer;
  var
    tmp : Extended;
  begin
    tmp := TPZ_M + TJ_M * daneZlecenia.ILOSC_ZLECONA;
    if frac(tmp) > 0 then tmp := tmp + 1;
    Result := Ceil(tmp);
  end;

  function TZlecenieEtap.PierwszyEtap;
  begin
    if poprzedniEtap = nil then Result := self
    else Result := poprzedniEtap.PierwszyEtap;
  end;

  function TZlecenieEtap.OstatniEtap;
  begin
    if nastepnyEtap = nil then Result := self
    else Result := nastepnyEtap.OstatniEtap;
  end;

end.
