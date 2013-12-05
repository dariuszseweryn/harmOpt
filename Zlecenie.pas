unit Zlecenie;

interface

uses
  System.Generics.Collections, Data.Win.ADODB, VCLTee.GanttCh, ZlecenieEtap, ZlecenieDane;

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
    procedure PolaczKolejneEtapyZleceniaWSerii(seria : TGanttSeries);
    procedure Czysc;
    function ZnajdzEtapZleceniaZGanttId(ganttId : Integer) : TZlecenieEtap;
    function PierwszyNierozpoczetyEtap() : TZlecenieEtap;
  end;

implementation

  constructor TZlecenie.Create(AOwnsObjects : Boolean = True);
  begin
    inherited Create(ownsObjects);
    poprzedniEtap := nil;
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

  procedure TZlecenie.PolaczKolejneEtapyZleceniaWSerii(seria : TGanttSeries);
  var
    etapZlecenia : TZlecenieEtap;
  begin
    for etapZlecenia in self do
      if not (etapZlecenia.poprzedniEtap = nil) and not (etapZlecenia.ganttID = 0) then
          seria.NextTask[etapZlecenia.poprzedniEtap.ganttID] := etapZlecenia.ganttID;
  end;

  procedure TZlecenie.Czysc;
  var
    etapZlecenia : TZlecenieEtap;
  begin
    for etapZlecenia in self do
      etapZlecenia.Czysc;
  end;

  function TZlecenie.ZnajdzEtapZleceniaZGanttId(ganttId: Integer) : TZlecenieEtap;
  var
    etapZlecenia : TZlecenieEtap;
  begin
    Result := nil;
    for etapZlecenia in self do
      if etapZlecenia.ganttID = ganttId then Result := etapZlecenia;
  end;

  function TZlecenie.PierwszyNierozpoczetyEtap() : TZlecenieEtap;
  var
    zlecenieEtapTemp : TZlecenieEtap;
  begin
    Result := nil;
    zlecenieEtapTemp := nil;
    for zlecenieEtapTemp in self do
    begin
      if not (zlecenieEtapTemp = nil) then
      begin
        if not zlecenieEtapTemp.rozpoczety then
        begin
          Result := zlecenieEtapTemp;
          break;
        end;
      end;
    end;
  end;

end.
