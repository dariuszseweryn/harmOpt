unit Zlecenia;

interface

uses
  System.Generics.Collections, Zlecenie;

type
  TZlecenia = class
  public
    var
      listaZlecen : TObjectList<TZlecenie>;

    constructor Create;
    destructor Free;

    procedure DodajZlecenie(zlecenie : TZlecenie);
  end;


implementation

  constructor TZlecenia.Create;
  begin
    listaZlecen := TObjectList<TZlecenie>.Create(True);
  end;

  destructor TZlecenia.Free;
  begin
    listaZlecen.Free;
  end;

  procedure TZlecenia.DodajZlecenie(zlecenie : TZlecenie);
  begin
    listaZlecen.Add(zlecenie);
  end;

end.
