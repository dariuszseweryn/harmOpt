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
  rozpoczety : Boolean;
  // info nt. czasu zajecia stanowiska
  DATA_START : TDateTime;
  DATA_KONIEC : TDateTime;
  DATA_PROPONOWANA : TDateTime;
  // info nt. kolejnosci dodania do wykresu Gantta
  ganttID : Integer;
  // poprzedni, nastepny etap, zlecenie
  poprzedniEtap : TZlecenieEtap;
  nastepnyEtap : TZlecenieEtap;
  daneZlecenia : TZlecenieDane;

  procedure UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  function CzasWykonaniaNetto() : Integer;
  function PierwszyEtap() : TZlecenieEtap;
  function OstatniEtap() : TZlecenieEtap;
  function DataProponowana() : TDateTime;

  end;

implementation

  procedure TZlecenieEtap.UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  begin
    NR_ETAPU := query.FieldByName('NR_ETAPU').AsInteger;
    TPZ_M := query.FieldByName('TPZ_M').AsExtended;
    TJ_M := query.FieldByName('TJ_M').AsExtended;
    ID_STANOWISKA := query.FieldByName('ID_STANOWISKA').AsInteger;
    ID_RODZAJE_STANOWISK := query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;
    DATA_PROPONOWANA := 0;
    rozpoczety := False;
    poprzedniEtap := nil;
    nastepnyEtap := nil;
    daneZlecenia := nil;
  end;

  function TZlecenieEtap.CzasWykonaniaNetto : Integer;
  var
    tmp : Extended;
  begin
    tmp := TPZ_M + TJ_M * daneZlecenia.ILOSC_ZLECONA;
    if frac(tmp) > 0 then tmp := tmp + 1;
    Result := Ceil(tmp);
  end;

  function TZlecenieEtap.PierwszyEtap() : TZlecenieEtap;
  begin
    if poprzedniEtap = nil then Result := self
    else Result := poprzedniEtap.PierwszyEtap;
  end;

  function TZlecenieEtap.OstatniEtap() : TZlecenieEtap;
  begin
    if nastepnyEtap = nil then Result := self
    else Result := nastepnyEtap.OstatniEtap;
  end;

  function TZlecenieEtap.DataProponowana() : TDateTime;
  begin
    if self.DATA_PROPONOWANA > 0 then
    begin
      Result := DATA_PROPONOWANA;
    end
    else if not (poprzedniEtap = nil) then
    begin
      Result := poprzedniEtap.DATA_KONIEC;
    end
    else
    begin
      Result := daneZlecenia.PLAN_DATA_ROZPOCZECIA;
    end;
  end;

end.
