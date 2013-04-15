unit Harmonogramator;

interface

uses
  System.Generics.Collections, Stanowiska, Stanowisko, Zlecenia, Zlecenie, EtapZlecenia;

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
    etapZlecenia : TEtapZlecenia;
    stanowisko : TStanowisko;
  begin
    for zlecenie in zlecenia.listaZlecen do
    begin
      for etapZlecenia in zlecenie.listaEtapow do
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
