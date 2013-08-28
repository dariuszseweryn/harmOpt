unit Zlecenia;

interface

uses
  System.Generics.Collections, VCLTee.GanttCh, Zlecenie, ZlecenieEtap, Etapy;

type
  TZlecenia = class(TObjectList<TZlecenie>)
  public

    function Add(const zlecenie : TZlecenie) : Integer;
    procedure PolaczKolejneEtapyZlecenWSerii(seria : TGanttSeries);
    function ZnajdzEtapZleceniaZGanttId(ganttId : Integer) : TZlecenieEtap;
    function EtapyDoHarmonogramowania() : TEtapy;
    function WszystkieNierozpoczeteEtapy() : TEtapy;
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

  function TZlecenia.EtapyDoHarmonogramowania() : TEtapy;
  var
    etapyDoHarmonogramowania : TEtapy;
    zlecenie : TZlecenie;
    zlecenieEtap : TZlecenieEtap;
  begin
    etapyDoHarmonogramowania := TEtapy.Create(False);
    for zlecenie in self do
    begin
      zlecenieEtap := zlecenie.PierwszyNierozpoczetyEtap();
      if not (zlecenieEtap = nil) then
        etapyDoHarmonogramowania.Add(zlecenieEtap);
    end;
    Result := etapyDoHarmonogramowania;
  end;

  function TZlecenia.WszystkieNierozpoczeteEtapy() : TEtapy;
  var
    nierozpoczeteEtapy : TEtapy;
    zlecenie : TZlecenie;
    etapZlecenia : TZlecenieEtap;
  begin
    nierozpoczeteEtapy := TEtapy.Create(False);
    for zlecenie in self do
    begin
      for etapZlecenia in zlecenie do
         if not etapZlecenia.rozpoczety then
            nierozpoczeteEtapy.Add(etapZlecenia);
    end;
    Result := nierozpoczeteEtapy;
  end;

end.
