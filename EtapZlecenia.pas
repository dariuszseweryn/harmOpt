unit EtapZlecenia;

interface

uses
  Data.Win.ADODB;

type
  TEtapZlecenia = class

  private
  public
  // info ze zlecenia
  ID_ZLECENIA : Integer;
  ID_ZLEC_TECHNOLOGIE : Integer;
  ILOSC_ZLECONA : Integer;
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
  GanttID : Integer;

  procedure ustawDlaQueryZeZlecenia(query : TADOQuery);
  procedure ustawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);

  end;

var
  EtapZlecenia1 : TEtapZlecenia;

implementation

  procedure TEtapZlecenia.ustawDlaQueryZeZlecenia(query : TADOQuery);
  begin
    ID_ZLECENIA := query.FieldByName('ID_ZLECENIA').AsInteger;
    ID_ZLEC_TECHNOLOGIE := query.FieldByName('ID_ZLEC_TECHNOLOGIE').AsInteger;
    ILOSC_ZLECONA := query.FieldByName('ILOSC_ZLECONA').AsInteger;
  end;

  procedure TEtapZlecenia.ustawDlaQueryZeZlecTechnologieEtapy(query : TADOQuery);
  begin
    NR_ETAPU := query.FieldByName('NR_ETAPU').AsInteger;
    TPZ_M := query.FieldByName('TPZ_M').AsInteger;
    TJ_M := query.FieldByName('TJ_M').AsInteger;
    ID_STANOWISKA := query.FieldByName('ID_STANOWISKA').AsInteger;
    ID_RODZAJE_STANOWISK := query.FieldByName('ID_RODZAJE_STANOWISK').AsInteger;
  end;

end.
