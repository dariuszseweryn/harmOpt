unit Zlecenia;

interface

uses
  System.Generics.Collections, VCLTee.GanttCh, Zlecenie, ZlecenieEtap;

type
  TZlecenia = class(TObjectList<TZlecenie>)
  public

    function Add(const zlecenie : TZlecenie) : Integer;
    procedure PolaczKolejneEtapyZlecenWSerii(seria : TGanttSeries);
    function ZnajdzEtapZleceniaZGanttId(ganttId : Integer) : TZlecenieEtap;
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

  function TZlecenia.ZnajdzEtapZleceniaZGanttId(ganttId: Integer) : TZlecenieEtap;
  var
    zlecenie : TZlecenie;
  begin
    Result := nil;
    for zlecenie in self do
    begin
      Result := zlecenie.ZnajdzEtapZleceniaZGanttId(ganttId);
      if not (Result = nil) then break;
    end;
  end;

end.
