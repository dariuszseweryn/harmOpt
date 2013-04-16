unit Zlecenia;

interface

uses
  System.Generics.Collections, Zlecenie;

type
  TZlecenia = class(TObjectList<TZlecenie>)
  public

    function Add(const zlecenie : TZlecenie) : Integer;
  end;


implementation

  function TZlecenia.Add(const zlecenie : TZlecenie) : Integer;
  begin
    Result := inherited Add(zlecenie);
  end;

end.
