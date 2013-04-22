unit Stanowiska;

interface

uses
  System.Generics.Collections, Stanowisko, ZlecenieEtap;

type
  TStanowiska = class(TObjectList<TStanowisko>)
  public

//    constructor Create;
//    destructor Free;

//    procedure DodajStanowisko(stanowisko : TStanowisko);
    function StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia : TZlecenieEtap) : TStanowiska;
  end;


implementation

//  constructor TStanowiska.Create;
//  begin
//    listaStanowisk := TObjectList<TStanowisko>.Create(True);
//  end;
//
//  destructor TStanowiska.Free;
//  begin
//    listaStanowisk.Free;
//  end;
//
//  procedure TStanowiska.DodajStanowisko(stanowisko : TStanowisko);
//  begin
//    listaStanowisk.Add(stanowisko);
//  end;

  function TStanowiska.StanowiskaPasujaceDlaEtapuZlecenia(etapZlecenia : TZlecenieEtap) : TStanowiska;
  var
    stanowisko : TStanowisko;
  begin
    Result := TStanowiska.Create(False);
    if not etapZlecenia.ID_STANOWISKA = 0 then
      begin
        for stanowisko in self do
          if stanowisko.ID_STANOWISKA = etapZlecenia.ID_STANOWISKA then
            Result.Add(stanowisko);
      end
    else
      begin
        for stanowisko in self do
          if stanowisko.ID_RODZAJE_STANOWISK = etapZlecenia.ID_RODZAJE_STANOWISK then
            Result.Add(stanowisko);
      end;
  end;

end.
