unit Harmonogramator;

interface

uses
  System.Generics.Collections, Stanowiska, Stanowisko, Zlecenia, Zlecenie, ZlecenieEtap;

type
  THarmonogramator = class
  private

  public
    procedure Harmonogramuj(zlecenia : TZlecenia; stanowiska : TStanowiska);
  end;

implementation

  // public

  procedure THarmonogramator.Harmonogramuj(zlecenia : TZlecenia; stanowiska : TStanowiska);
  var
    zlecenie : TZlecenie;
    etapZlecenia : TZlecenieEtap;
    stanowisko : TStanowisko;
  begin
    for zlecenie in zlecenia do
    begin
      for etapZlecenia in zlecenie do
      begin
        if etapZlecenia.poprzedniEtap = nil then
        begin
          // znajdz stanowiska na ktorych etap moze byc wykonany
          // sprawdz na ktorym stanowisku mozna wczesniej wykonac dany etap
          // zapisz w etapie info na ktorym stanowisku bedzie i w jakim czasie
          // dodaj etap do stanowiska
        end;

      end;

    end;

  end;

end.
