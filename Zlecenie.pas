unit Zlecenie;

interface

uses
  System.Generics.Collections, Data.Win.ADODB, ZlecenieEtap, ZlecenieDane;

type
  TZlecenie = class(TObjectList<TZlecenieEtap>)

    private
    var
      poprzedniEtap : TZlecenieEtap;

    public
    var
      daneZlecenia : TZlecenieDane;

    constructor Create(AOwnsObjects : Boolean = True);
    destructor Free;

    function Add(etapZlecenia : TZlecenieEtap) : Integer;
  end;

implementation

  constructor TZlecenie.Create(AOwnsObjects : Boolean = True);
  begin
    inherited Create(ownsObjects);
    daneZlecenia := TZlecenieDane.Create;
  end;

  destructor TZlecenie.Free;
  begin
    daneZlecenia.Free;
    inherited Free;
  end;

  function TZlecenie.Add(etapZlecenia : TZlecenieEtap) : Integer;
  begin
    if not (poprzedniEtap = nil) then
    begin
      etapZlecenia.poprzedniEtap := poprzedniEtap;
      poprzedniEtap.nastepnyEtap := etapZlecenia;
    end;
    poprzedniEtap := etapZlecenia;

    etapZlecenia.daneZlecenia := daneZlecenia;

    Result := inherited Add(etapZlecenia);
  end;



end.
