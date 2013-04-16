unit ZlecenieEtap;

interface

uses
  Data.Win.ADODB, ZlecenieDane;

type
  TZlecenieEtap = class

  private
  public
  // info nt. konkretnego etapu
  NR_ETAPU : Integer;
  TPZ_M : Integer;
  TJ_M : Integer;
  ID_STANOWISKA : Integer;
  ID_RODZAJE_STANOWISK : Integer;
  // info nt. czasu zajecia stanowiska
  DATA_START : Integer;
  DATA_KONIEC : Integer;
  // info nt. kolejnosci dodania do wykresu Gantta
  ganttID : Integer;
  // poprzedni, nastepny etap, zlecenie
  poprzedniEtap : TZlecenieEtap;
  nastepnyEtap : TZlecenieEtap;
  daneZlecenia : TZlecenieDane;

  procedure UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);

  end;

implementation

  procedure TZlecenieEtap.UstawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  begin
    NR_ETAPU := query.FieldByName('NR_ETAPU').AsInteger;
    TPZ_M := query.FieldByName('TPZ_M').AsInteger;
    TJ_M := query.FieldByName('TJ_M').AsInteger;
    ID_STANOWISKA := query.FieldByName('ID_STANOWISKA').AsInteger;
    ID_RODZAJE_STANOWISK := query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;
  end;

end.
