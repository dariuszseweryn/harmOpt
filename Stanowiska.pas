unit Stanowiska;

interface

uses
  System.Generics.Collections, Stanowisko;

type
  TStanowiska = class
  public
    var
      listaStanowisk : TObjectList<TStanowisko>;

    constructor Create;
    destructor Free;

    procedure DodajStanowisko(stanowisko : TStanowisko);
  end;


implementation

  constructor TStanowiska.Create;
  begin
    listaStanowisk := TObjectList<TStanowisko>.Create(True);
  end;

  destructor TStanowiska.Free;
  begin
    listaStanowisk.Free;
  end;

  procedure TStanowiska.DodajStanowisko(stanowisko : TStanowisko);
  begin
    listaStanowisk.Add(stanowisko);
  end;

end.
