unit Zlecenie;

interface

uses
  System.Generics.Collections, EtapZlecenia;

type
  TZlecenie = class

    public
    var
      listaEtapow : TObjectList<TEtapZlecenia>;

    constructor Create;
    destructor Free;

    procedure DodajEtap(etapZlecenia : TEtapZlecenia);
  end;

implementation

  constructor TZlecenie.Create;
  begin
    listaEtapow := TObjectList<TEtapZlecenia>.Create(True);
  end;

  destructor TZlecenie.Free;
  begin
    listaEtapow.Free;
  end;

  procedure TZlecenie.DodajEtap(etapZlecenia : TEtapZlecenia);
  begin
    listaEtapow.Add(etapZlecenia);
  end;

end.
