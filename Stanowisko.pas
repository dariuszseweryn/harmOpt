unit Stanowisko;

interface

uses
  System.Generics.Collections, Data.Win.ADODB, EtapZlecenia;

type
  TStanowisko = class

    public
    var
      NAZ_STANOWISKA : String;
      KOD_STANOWISKA : String;
      ID_STANOWISKA : Integer;

      NAZ_R_STANOWISKA : String;
      RODZ_STANOWISKA : String;
      ID_RODZAJE_STANOWISK : Integer;

      listaEtapow : TObjectList<TEtapZlecenia>;

    constructor Create;
    destructor Free;

    procedure DodajEtap(etapZlecenia : TEtapZlecenia);
    procedure UstawDlaQueryZRodzajeStanowisk(query : TADOQuery);
    procedure UstawDlaQueryZeStanowiska(query : TADOQuery);
  end;

implementation

  constructor TStanowisko.Create;
  begin
    listaEtapow := TObjectList<TEtapZlecenia>.Create(False);
  end;

  destructor TStanowisko.Free;
  begin
    listaEtapow.Free;
  end;

  procedure TStanowisko.DodajEtap(etapZlecenia : TEtapZlecenia);
  begin
    listaEtapow.Add(etapZlecenia);
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

end.
