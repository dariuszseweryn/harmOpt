unit ZlecenieEtap;

interface

uses
  Data.Win.ADODB, System.SysUtils, System.Math, ZlecenieDane;

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
  ID_STANOWISKA_PRZYDZIELENIE : Integer;
  rozpoczety : Boolean;
  // info nt. czasu zajecia stanowiska
  DATA_ROZPOCZECIA : TDateTime;
  DATA_ZAKONCZENIA : TDateTime;
  DATA_PROPONOWANA : TDateTime;
  // info nt. kolejnosci dodania do wykresu Gantta
  ganttID : Integer;
  // poprzedni, nastepny etap, zlecenie
  poprzedniEtap : TZlecenieEtap;
  nastepnyEtap : TZlecenieEtap;
  daneZlecenia : TZlecenieDane;

  procedure UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  procedure ZapiszSie(query1 : TADOQuery);
  procedure Czysc;
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
    if not (query.FieldByName('ID_STANOWISKA_PRZYDZIELENIE').IsNull) then
      ID_STANOWISKA_PRZYDZIELENIE := query.FieldByName('ID_STANOWISKA_PRZYDZIELENIE').AsInteger;
    if not (query.FieldByName('DATA_ROZPOCZECIA').IsNull) then
      DATA_ROZPOCZECIA := query.FieldByName('DATA_ROZPOCZECIA').AsDateTime;
    if not (query.FieldByName('DATA_ZAKONCZENIA').IsNull) then
      DATA_ZAKONCZENIA := query.FieldByName('DATA_ZAKONCZENIA').AsDateTime;
    DATA_PROPONOWANA := 0;
    rozpoczety := False;
    poprzedniEtap := nil;
    nastepnyEtap := nil;
    daneZlecenia := nil;
  end;

  procedure TZlecenieEtap.ZapiszSie(query1 : TADOQuery);
  begin
    query1.SQL.Text := 'SELECT data_rozpoczecia, data_zakonczenia, id_stanowiska_przydzielenie '+
                       'FROM zlec_technologie_etapy '+
                       'WHERE id_zlec_technologie = '+ IntToStr(daneZlecenia.ID_ZLEC_TECHNOLOGIE) + ' ' +
                       'AND nr_etapu = ' + IntToStr(NR_ETAPU);
    query1.Open;
    query1.Edit;
    query1.Fields[0].AsDateTime := DATA_ROZPOCZECIA;
    query1.Fields[1].AsDateTime := DATA_ZAKONCZENIA;
    query1.Fields[2].AsInteger := ID_STANOWISKA_PRZYDZIELENIE;
    query1.Post;
    query1.Close
  end;

  procedure TZlecenieEtap.Czysc;
  begin
    DATA_ROZPOCZECIA := 0;
    DATA_ZAKONCZENIA := 0;
    DATA_PROPONOWANA := 0;
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
      Result := poprzedniEtap.DATA_ZAKONCZENIA;
    end
    else
    begin
      Result := daneZlecenia.PLAN_DATA_ROZPOCZECIA;
    end;
  end;

end.
