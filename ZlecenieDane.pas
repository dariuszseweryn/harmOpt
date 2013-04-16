unit ZlecenieDane;

interface

uses
  Data.Win.ADODB;

type
  TZlecenieDane = class

  public
    var
      ID_ZLECENIA : Integer;
      ID_ZLEC_TECHNOLOGIE : Integer;
      ILOSC_ZLECONA : Integer;

    procedure UstawDlaQueryZeZlecenia(query : TADOQuery);
  end;

implementation

  procedure TZlecenieDane.UstawDlaQueryZeZlecenia(query : TADOQuery);
  begin
    ID_ZLECENIA := query.FieldByName('ID_ZLECENIA').AsInteger;
    ID_ZLEC_TECHNOLOGIE := query.FieldByName('ID_ZLEC_TECHNOLOGIE').AsInteger;
    ILOSC_ZLECONA := query.FieldByName('ILOSC_ZLECONA').AsInteger;
  end;

end.
