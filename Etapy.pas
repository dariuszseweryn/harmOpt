unit Etapy;

interface

uses
  System.Generics.Collections, System.DateUtils, VCLTee.GanttCh, ZlecenieEtap;

type
  TEtapy = class(TObjectList<TZlecenieEtap>)
  public
    function NajwczesniejszyCzasProponowany(wPrzod : Boolean) : TDateTime;
    function OperacjeZCzasemProponowanym(czasProponowany : TDateTime) : TEtapy;
  end;

implementation

  function TEtapy.NajwczesniejszyCzasProponowany(wPrzod : Boolean) : TDateTime;
  var
    czas : TDateTime;
    zlecenieEtap : TZlecenieEtap;
  begin
    Result := EncodeDateTime(5000, 1, 1, 1, 1, 1, 1);
    for zlecenieEtap in self do
    begin
      czas := zlecenieEtap.DataProponowana();
      if czas < Result then Result := czas;
    end;
  end;

  function TEtapy.OperacjeZCzasemProponowanym(czasProponowany : TDateTime) : TEtapy;
  var
    zlecenieEtap : TZlecenieEtap;
  begin
    Result := TEtapy.Create(False);
    for zlecenieEtap in self do
    begin
      if zlecenieEtap.DataProponowana() = czasProponowany then Result.Add(zlecenieEtap);
    end;
  end;

end.
