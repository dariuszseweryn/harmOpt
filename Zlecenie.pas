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

  procedure TZlecenie.PolaczKolejneEtapyZleceniaWSerii(seria : TGanttSeries);
  var
    etapZlecenia : TZlecenieEtap;
  begin
    for etapZlecenia in self do
      if not (etapZlecenia.poprzedniEtap = nil) then
          seria.NextTask[etapZlecenia.poprzedniEtap.ganttID] := etapZlecenia.ganttID;
  end;

end.
