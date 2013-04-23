unit Zlecenia;

interface

uses
  System.Generics.Collections, VCLTee.GanttCh, Zlecenie;

type
  TZlecenia = class(TObjectList<TZlecenie>)
  public

    function Add(const zlecenie : TZlecenie) : Integer;
    procedure PolaczKolejneEtapyZlecenWSerii(seria : TGanttSeries);
  end;


implementation

  function TZlecenia.Add(const zlecenie : TZlecenie) : Integer;
  begin
    Result := inherited Add(zlecenie);
  end;

  procedure TZlecenia.PolaczKolejneEtapyZlecenWSerii(seria: TGanttSeries);
  var
    zlecenie : TZlecenie;
  begin
    for zlecenie in self do
    begin
      zlecenie.PolaczKolejneEtapyZleceniaWSerii(seria);
    end;
  end;

end.
